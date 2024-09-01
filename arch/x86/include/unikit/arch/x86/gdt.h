/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __UNIKIT_ARCH_X86_GDT_H__
#define __UNIKIT_ARCH_X86_GDT_H__

#include <unikit/essentials.h>

/* Segment Limit                    : 0xFFFF
 * Base                             : 0x00000000
 * Type                             : 0x1010b (code/execute/read/accessed)
 * Code or Data Segment (S)         : 0x1 (true)
 * Descriptor Privilege Level (DPL) : 0x0 (kernel)
 * Segment Present (P)              : 0x1 (true)
 * Default Operation Size (D)       : 0x1 (32-bit)
 * Granularity (G)                  : 0x1 (4KB)
 */
#define GDT_SEGMENT_CODE32 0x00CF9B000000FFFF

/* Segment Limit                    : 0xFFFF
 * Base                             : 0x00000000
 * Type                             : 0x0011b (data/read/write/accessed)
 * Code or Data Segment (S)         : 0x1 (true)
 * Descriptor Privilege Level (DPL) : 0x0 (kernel)
 * Segment Present (P)              : 0x1 (true)
 * Granularity (G)                  : 0x1 (4KB)
 */
#define GDT_SEGMENT_DATA32 0x00CF93000000FFFF

/* Segment Limit                    : 0xFFFF
 * Base                             : 0x00000000
 * Type                             : 0x1011b (code/execute/read/accessed)
 * Code or Data Segment (S)         : 0x1 (true)
 * Descriptor Privilege Level (DPL) : 0x0 (kernel)
 * Segment Present (P)              : 0x1 (true)
 * 64-bit Code Segment (L)          : 0x1 (true)
 * Granularity (G)                  : 0x1 (4KB)
 */
#define GDT_SEGMENT_CODE64 0x00AF9B000000FFFF
#define GDT_SEGMENT_DATA64 GDT_SEGMENT_DATA32

#ifndef __ASSEMBLY__

struct x86_gdt {
    u64 limit_low  : 16; /* low 16 bit of limit value */
    u64 base_low   : 24; /* low 24 bit of base address */
    u64 type       : 4;  /* segment type */
    u64 s          : 1;  /* descriptor type */
    u64 dpl        : 2;  /* descriptor privilege level */
    u64 p          : 1;  /* present */
    u64 limit_high : 4;  /* high 4 bit of limit value */
    u64 avl        : 1;  /* available for use */
    u64 l          : 1;  /* 64-bit code segment */
    u64 db         : 1;  /* default operation size (0 = 64-bit, 1 = 32-bit segment) */
    u64 g          : 1;  /* granularity (0 = limit, 1 = limit * 4KB) */
    u64 base_high  : 8;  /* high 8 bit of base address */
};

static inline void gdtr(u64 gdtr) {
    asm volatile("lgdt %0" : : "m" (gdtr));
}

#endif

#endif /* __UNIKIT_ARCH_X86_GDT_H__ */
