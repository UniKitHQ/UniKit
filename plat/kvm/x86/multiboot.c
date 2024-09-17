/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/essentials.h>
#include <unikit/plat/kvm/multiboot.h>
#include <unikit/plat/bootinfo.h>

extern void boot_entry(struct unikit_bootinfo *bi);

struct multiboot_header hdr __section(".data.boot") __align(4) __used = {
    .magic    = MULTIBOOT_HEADER_MAGIC,
    .flags    = MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO,
    .checksum = -(MULTIBOOT_HEADER_MAGIC + (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO)),
};

void multiboot_entry(struct multiboot_info *mi) {
    struct unikit_bootinfo *const bi = unikit_get_bootinfo();

    bi->protocol = (u8 *)"multiboot";

    if (mi->flags & MULTIBOOT_INFO_BOOT_LOADER_NAME) {
        if (mi->boot_loader_name) {
            bi->bootloader = (u8 *)(u64)mi->boot_loader_name;
        }
    }

    if (mi->flags & MULTIBOOT_INFO_CMDLINE) {
        if (mi->cmdline) {
            bi->cmdline = (u8 *)(u64)mi->cmdline;
        }
    }

    if (mi->flags & MULTIBOOT_INFO_MEM_MAP) {
        multiboot_memory_map_t *m;
        for (sz i = 0; i < mi->mmap_length; i += m->size + sizeof(m->size)) {
            m = (multiboot_memory_map_t *)(mi->mmap_addr + i);

            struct unikit_memory_desc md = {
                .base  = m->addr,
                .len   = m->len,
                .type  = m->type == MULTIBOOT_MEMORY_AVAILABLE ? UNIKIT_MEMORY_TYPE_FREE : UNIKIT_MEMORY_TYPE_RESERVED,
                .flags = m->type == MULTIBOOT_MEMORY_AVAILABLE ? UNIKIT_MEMORY_PERMISSION_READ | UNIKIT_MEMORY_PERMISSION_WRITE : 0x00,
            };

            unikit_memory_map_insert(&bi->mmap, &md);
        }
    }

    boot_entry(bi);
}
