/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/plat/kvm/multiboot.h>

.section .data.boot, "a"
.globl boot_entry
boot_entry:
	.quad multiboot_entry

.section .text.boot, "a"
.code32
.globl _multiboot_entry
_multiboot_entry:
	cmp	eax, MULTIBOOT_BOOTLOADER_MAGIC

	jne magic_mismatch

	call boot_32

magic_mismatch:
	cli
1:
	hlt
	jmp	1b