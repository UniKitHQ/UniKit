/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/arch/x86/gdt.h>

#include <unikit/arch/x86/asm.h>
#include <unikit/arch/x86/paging.h>

static __align(8)
struct x86_gdt_desc gdt[GDT_ENTRIES];

void gdt_init() {
    gdt[GDT_CODE].raw = GDT_SEGMENT_CODE64;
    gdt[GDT_DATA].raw = GDT_SEGMENT_DATA64;

    struct x86_gdtr gdtr = {
        .limit = sizeof(gdt) - 1,
        .base = (u64)gdt
    };

    lgdt((u64)&gdtr);

    set_cs(GDT_OFFSET(GDT_CODE));

    set_ds(GDT_OFFSET(GDT_DATA));
    set_ss(GDT_OFFSET(GDT_DATA));
    set_es(GDT_OFFSET(GDT_DATA));
}

static __align(8)
struct x86_tss tss;

static __align(8)
u8 ist1[PAGE_SIZE]; /* Interrupt Stack */

static __align(8)
u8 ist2[PAGE_SIZE]; /* Trap Stack */

static __align(8)
u8 ist3[PAGE_SIZE]; /* Critical Stack */

void tss_init() {
    tss.iopb = sizeof(tss);
    
    tss.ist[0] = (u64)ist1;
    tss.ist[1] = (u64)ist2;
    tss.ist[2] = (u64)ist3;

    struct x86_gdt_desc *tssd;

    tssd = &gdt[GDT_TSS_LOW];
    tssd->base_low  = (u64)&tss;
    tssd->base_high = (u64)&tss >> 24;
    tssd->limit_low = sizeof(tss) - 1;
    tssd->type      = GDT_TYPE_TSS_AVAIL;
    tssd->p         = 1;

    tssd = &gdt[GDT_TSS_HIGH];
    tssd->limit_low = (u64)&tss >> 32;
    tssd->base_low = ((u64)&tss >> 48) & 0xFFFF;

    ltr(GDT_OFFSET(GDT_TSS_LOW));
}
