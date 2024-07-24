/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2023, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __ESSENTIALS_H__
#define __ESSENTIALS_H__

#undef NULL
#define NULL ((void *)0)

#undef __packed
#define __packed __attribute__((packed))

#undef __section
#define __section(_section_name) __attribute__((section(_section_name)))

#undef __aligned
#define __aligned(_n) __attribute__((aligned(_n)))

#undef __used
#define __used __attribute__((used))

#undef likely
#define likely(x)   (__builtin_expect((!!(x)), 1))

#undef unlikely
#define unlikely(x) (__builtin_expect((!!(x)), 0))

#ifndef __ASSEMBLY__

typedef signed   char	s8;
typedef unsigned char	u8;

typedef signed   short	s16;
typedef unsigned short	u16;

typedef signed   int	s32;
typedef unsigned int	u32;

typedef signed   long	s64;
typedef unsigned long	u64;

#endif

#endif /* __ESSENTIALS_H__ */
