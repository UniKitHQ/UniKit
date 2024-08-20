/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/essentials.h>
#include <unikit/plat/kvm/multiboot.h>
#include <unikit/plat/bootinfo.h>

struct multiboot_header hdr __section(".data.boot") __aligned(4) __used = {
	.magic = MULTIBOOT_HEADER_MAGIC,
	.flags = MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO,
	.checksum = -(MULTIBOOT_HEADER_MAGIC + (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO)),
};

void multiboot_entry(struct multiboot_info *mi) {
	struct unikit_bootinfo *bi = (struct unikit_bootinfo *)unikit_get_bootinfo();

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

}
