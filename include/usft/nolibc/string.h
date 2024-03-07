/* SPDX-License-Identifier: MPL-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the MPL-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __STRING_H__
#define __STRING_H__

typedef unsigned int size_t;

#define NULL ((void *)0)

static inline void *memcpy(void *dest, const void *src, size_t n) {
    char *d = dest;
    const char *s = src;
    while (n--) *d++ = *s++;
    return dest;
}

#endif /* __STRING_H__ */