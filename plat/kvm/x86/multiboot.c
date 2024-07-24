/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include "unikit/arch/x86/serial.h"
#include <unikit/essentials.h>
#include <unikit/plat/kvm/multiboot.h>
#include <unikit/plat/bootinfo.h>

#define MULTIBOOT_PAGE_ALIGN 0x00000001
#define MULTIBOOT_MEMORY_INFO 0x00000002

struct multiboot_header hdr __section(".data.boot") __aligned(4) __used = {
	.magic = MULTIBOOT_HEADER_MAGIC,
	.flags = MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO,
	.checksum = -(MULTIBOOT_HEADER_MAGIC + (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO)),
};

void multiboot_entry(struct multiboot_info *mi) {
	struct unikit_bootinfo bi = {
		.magic = BOOTINFO_MAGIC
	};

	if (mi->flags & MULTIBOOT_INFO_CMDLINE) {
		if (mi->cmdline) {
			bi.cmdline = (u8 *)(u64)mi->cmdline;
		}
	}

	set_bootinfo(bi);
}
