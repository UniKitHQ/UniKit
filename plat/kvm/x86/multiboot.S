/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

/*
 * ┌───────────────────────┐   ┌─────────────────┐
 * │   multiboot.S         │   │   boot.S        │
 * │   _multiboot_entry:   ├──►│   boot32:       │
 * └───────────────────────┘   │   boot64:       │
 *                             └────────┬────────┘
 *                                      │
 *      ┌────────────────────────────┐  │
 *      │   multiboot.c              │◄─┘
 *      │   void multiboot_entry()   │
 *      └────────────────────────────┘
 */

#include <unikit/plat/kvm/multiboot.h>

.section .bss
.space 4096
boot_stack:

/*
 * 32-bit multiboot entry function
 * EAX = multiboot bootloader magic
 * EBX = 32-bit physical address of multiboot info structure
 * GDT with descriptor for 4GB flat CS and DS segments
 * Interrupts are disabled
 * DS = ES = FS = GS = SS = 0x10
 */

.section .text.boot
.code32
.globl _multiboot_entry
_multiboot_entry:
    cmp    eax, MULTIBOOT_BOOTLOADER_MAGIC

    jne magic_mismatch

    mov edi, offset multiboot_entry /* Boot function address */
    mov esi, offset boot_stack      /* Boot stack address */
    mov edx, ebx                    /* Multiboot information structure */
    call boot32

magic_mismatch:
    cli
    hlt
