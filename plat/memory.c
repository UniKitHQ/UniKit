/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/essentials.h>
#include <unikit/plat/memory.h>

static struct unikit_memory_desc mds[UNIKIT_MEMORY_DESCRIPTOR_MAX_COUNT];

static struct unikit_memory_map mmap = {
	.capacity = 0,
	.cnt = 0,
	.mds = mds
};
