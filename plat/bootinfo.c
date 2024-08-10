/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/essentials.h>
#include <unikit/plat/bootinfo.h>

static struct unikit_bootinfo bi;

struct unikit_bootinfo *unikit_get_bootinfo() {
	if (unlikely(bi.magic != BOOTINFO_MAGIC)) return NULL;
	return &bi;
}

void unikit_set_bootinfo(struct unikit_bootinfo new_bi) {
	bi = new_bi;
}
