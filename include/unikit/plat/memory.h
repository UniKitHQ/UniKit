/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __UNIKIT_PLAT_MEMORY_H__
#define __UNIKIT_PLAT_MEMORY_H__

#include <unikit/essentials.h>

#define UNIKIT_MEMORY_DESCRIPTOR_MAX_COUNT 64
 
#define UNIKIT_MEMORY_TYPE_FREE          0x00
#define UNIKIT_MEMORY_TYPE_RESERVED      0x01

#define UNIKIT_MEMORY_PERMISSION_READ    0x01
#define UNIKIT_MEMORY_PERMISSION_WRITE   0x02
#define UNIKIT_MEMORY_PERMISSION_EXECUTE 0x04

struct unikit_memory_desc {
    /** Physical base address */
    u64 base;
    /** Length in bytes */
    sz len;
    /** Memory type */
    u8 type;
    /** Memory flags */
    u8 flags;
};

struct unikit_memory_map {
    /** Maximum descriptors in the map */
    u32 capacity;
    /** Current number of descriptors in the map */
    u32 cnt;
    /** Pointer to array of memory descriptors */
    struct unikit_memory_desc *mds;
};

int unikit_memory_map_insert(struct unikit_memory_map *mmap, struct unikit_memory_desc *md);

#endif /* __UNIKIT_PLAT_MEMORY_H__ */
