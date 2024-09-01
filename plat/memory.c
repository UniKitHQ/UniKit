/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/plat/memory.h>

#include <unikit/essentials.h>
#include <unikit/errno.h>
#include <unikit/plat/nostd.h>

int unikit_memory_map_insert(struct unikit_memory_map *mmap, struct unikit_memory_desc *md) {
    if (unlikely(!md->len))
        return -EINVAL;

    if (unlikely(mmap->cnt >= mmap->capacity))
        return -ENOMEM;

    int i;
    for (i = mmap->cnt; i > 0; i--) {
        if (mmap->mds[i].base + mmap->mds[i].len <= md->base) break;
    }

    memmove(mmap->mds + i + 1, mmap->mds + i, sizeof(struct unikit_memory_desc) * i);

    mmap->mds[i] = *md;
    mmap->cnt++;
    return i;
}
