/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/plat/bootinfo.h>

#include <unikit/essentials.h>

static struct unikit_memory_desc mds[UNIKIT_MEMORY_DESCRIPTOR_MAX_COUNT];

static struct unikit_bootinfo bi = {
	.magic = BOOTINFO_MAGIC,
	.mmap = {
		.capacity = sizeof(mds) / sizeof(struct unikit_memory_desc),
		.cnt = 0,
		.mds = mds
	}
};

const struct unikit_bootinfo *unikit_get_bootinfo() {
	if (unlikely(bi.magic != BOOTINFO_MAGIC)) return NULL;
	return &bi;
}

