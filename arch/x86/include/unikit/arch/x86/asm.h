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

static inline void lgdt(u64 gdtr) {
    asm volatile("lgdt [%0]" : : "r"(gdtr));
}

static inline void lidt(u64 idtr) {
    asm volatile("lidt [%0]" : : "r"(idtr));
}

static inline void ltr(u16 ss) {
    asm volatile("ltr %0" : : "r"(ss));
}

static inline void set_cs(u16 ss) {
    asm volatile(
        "push %0;"
        "push offset wrap_up;"
        "retfq;"
        "wrap_up:;"
        : : "m"(ss) :
    );
};

static inline void set_ds(u16 ss) {
    asm volatile("mov ds, %0" : : "r"(ss));
};

static inline void set_ss(u16 ss) {
    asm volatile("mov ss, %0" : : "r"(ss));
};

static inline void set_es(u16 ss) {
    asm volatile("mov es, %0" : : "r"(ss));
}

#endif /* __UNIKIT_ARCH_X86_ASM_H__ */
