/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __UNIKIT_PLAT_NOSTD_H__
#define __UNIKIT_PLAT_NOSTD_H__

#include <unikit/essentials.h>

void *memcpy(void *dst, const void *src, sz len);
void *memmove(void *dst, const void *src, sz len);
void *memset(void *dst, int value, sz len);
int memcmp(const void *s1, const void *s2, sz len);

#endif /* __UNIKIT_PLAT_NOSTD_H__ */
