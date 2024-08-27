/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/essentials.h>

void *memcpy(void *dst, const void *src, sz len) {
	sz i = 0;
	for (; len--; i++)
		((u8 *)dst)[i] = ((u8 *)src)[i];

	return dst;
}

void *memmove(void *dst, const void *src, sz len) {
	void *d = dst;
	const void *s = src;

	if (dst == src) return dst;
	else if (src > dst) {
		while (len-- > 0)
			*(u8 *)(d++) = *((u8 *)s++);
	} else if (src < dst) {
		s += len - 1;
		d += len - 1;

		while (len--)
			*((u8 *)d--) = *((u8 *)s--);
	}

	return dst;
}

void *memset(void *dst, int value, sz len) {
	void *ptr = dst;

	while (len--)
		*((u8 *)ptr++) = (u8)value;

	return dst;
}

int memcmp(const void *s1, const void *s2, sz len) {
	const void *p1 = s1;
	const void *p2 = s2;

	for (; len--; p1++, p2++)
		if (*((u8 *)p1) != *((u8 *)p2))
			return *((u8 *)p1) - *((u8 *)p2);

	return 0;
}
