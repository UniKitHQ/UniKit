/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __UNIKIT_ARCH_X86_ASM_H__
#define __UNIKIT_ARCH_X86_ASM_H__

#include <unikit/essentials.h>

static inline void outb(u16 PORT, u8 value) {
    asm volatile(
        "out %0, %1;"
        : : "dN"(PORT), "a"(value)
    );
}

static inline u8 inb(u16 PORT) {
    u8 value;
    asm volatile("in %0,%1" : "=a"(value) : "dN"(PORT));
    return value;
}

#endif /* __UNIKIT_ARCH_X86_ASM_H__ */
