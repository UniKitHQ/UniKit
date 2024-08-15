/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __PLAT_MEMORY_H__
#define __PLAT_MEMORY_H__

#include <unikit/essentials.h>
#include <stddef.h>

#define UNIKIT_MEMORY_DESCRIPTOR_MAX_COUNT 64

struct unikit_memory_desc {
	/** Physical base address */
	u64 base;
	/** Length in bytes */
	sz len;
	/** Memory type */
	u16 type;
	/** Memory flags */
	u16 flags;
};

struct unikit_memory_map {
	/** Maximum descriptors in the map */
	u32 capacity;
	/** Current number of descriptors in the map */
	u32 cnt;
	/** Array of memory descriptors */
	struct unikit_memory_desc *mds;
};

void unikit_memory_map_insert(struct unikit_memory_desc md);

#endif /* __PLAT_MEMORY_H__ */
