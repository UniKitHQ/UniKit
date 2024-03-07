/* SPDX-License-Identifier: MPL-2.0 */
/* Copyright (c) 2023, Pribess (Heewon Cho).
 * Licensed under the MPL-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <kvm/lxboot.h>

.code16
.section .text.head, "a"
head:
	.att_syntax
	ljmp $0x07C0, $start
	.intel_syntax noprefix

start:
	cld

	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ss, ax

	lea si, [msg]
	mov ah, 0x0E

msg_loop:
	lodsb

	cmp al, 0x00
	je reboot

	int 0x10

	jmp msg_loop

reboot:
	/* allow user press any key, then reboot */
	xor ax, ax
	int 0x16
	int 0x19

	/*
	 * int 0x19 should never return.
	 * in case it does anyway, invoke BIOS reset code
	 */
	ljmp 0xF000, 0xFFF0


.section .text.boot, "a"
	/*
	 * cs = ds + 0x20 at this point
	 * make cs on par with the other segment registers
	 */
	push ds
	.att_syntax
	pushw $0f
	lretw
	.intel_syntax noprefix
	0:

	mov di, _bss_start
	mov cx, _bss_end
	sub cx, di
	shr cx, 2
	xor eax, eax
	rep stosw

	call setup
	
	stop:
	jmp stop

.section .data.head, "a"
msg:
	.ascii "Booting kernel directly using MBR is unsupported.\r\n"
	.ascii "\n"
	.ascii "Press any key to reboot...\r\n"
	.byte 0x00

.section .padding, "a"
	.fill 0x1000, 1, 0x00