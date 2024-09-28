/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/essentials.h>
#include <unikit/plat/bootinfo.h>
#include <unikit/plat/kvm/console.h>
#include <unikit/arch/x86/gdt.h>
#include <unikit/arch/x86/traps.h>

void boot_entry(struct unikit_bootinfo *bi) {
    console_init();

    gdt_init();
    tss_init();

    idt_init();
}
