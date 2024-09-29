/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

.equ TRAP_STUB_SIZE, 0x10

.section .text.traps
.global trap_stub
trap_stub:
.set i, 0
.rept 256

.align TRAP_STUB_SIZE

.if !(i == 0x08              || \
      0x0A <= i && i <= 0x0E || \
      i == 0x11 || i == 0x15 || \
      0x1D <= i && i <= 0x1E)
/* Trap without error code */
push 0x00
.endif

push i
jmp trap_stub_common

.align TRAP_STUB_SIZE

.set i, i + 1
.endr

trap_stub_common:
/*
 * Current stack
 *      ┌──────────────────┐
 *  48  │        SS        │ ◄─┐
 *      ├──────────────────┤   ├ Valid only after privilege escalation
 *  40  │       RSP        │ ◄─┘
 *      ├──────────────────┤
 *  32  │      RFLAGS      │
 *      ├──────────────────┤
 *  24  │        CS        │
 *      ├──────────────────┤
 *  16  │       RIP        │
 *      ├──────────────────┤
 *   8  │    Error code    │
 *      ├──────────────────┤
 *   0  │    Trap vector   │ ◄─ RSP
 *      └──────────────────┘
 */

xchg rdi, [rsp]
push rsi
push rbp
push r15
push r14
push r13
push r12
push r11
push r10
push r9
push r8
push rdx
push rcx
push rbx
push rax

mov rsi, rsp

call trap_handler

pop rax
pop rbx
pop rcx
pop rdx
pop r8
pop r9
pop r10
pop r11
pop r12
pop r13
pop r14
pop r15
pop rbp
pop rsi
pop rdi

add rsp, 0x8 /* error code */

iretq
