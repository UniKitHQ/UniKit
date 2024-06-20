/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/essentials.h>
#include <unikit/plat/kvm/multiboot.h>

#define MULTIBOOT_PAGE_ALIGN 0x00000001
#define MULTIBOOT_MEMORY_INFO 0x00000002

struct multiboot_header hdr __section(".data.boot") __aligned(4) __used = {
	.magic = MULTIBOOT_HEADER_MAGIC,
	.flags = MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO,
	.checksum = -(MULTIBOOT_HEADER_MAGIC + (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO)),
};
