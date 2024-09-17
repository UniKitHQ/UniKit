/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2023, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __UNIKIT_ESSENTIALS_H__
#define __UNIKIT_ESSENTIALS_H__

#undef NULL
#define NULL ((void *)0)

#undef __packed
#define __packed __attribute__((packed))

#undef __section
#define __section(_section_name) __attribute__((section(_section_name)))

#undef __align
#define __align(_n) __attribute__((aligned(_n)))

#undef __used
#define __used __attribute__((used))

#undef likely
#define likely(x)   (__builtin_expect((!!(x)), 1))

#undef unlikely
#define unlikely(x) (__builtin_expect((!!(x)), 0))

#undef STRINGFY
#define __STRINGIFY(x) #x
#define STRINGIFY(x) __STRINGIFY(x)

#undef CONCAT
#define __CONCAT(x, y) x##y
#define CONCAT(x, y) __CONCAT(x, y)

#ifndef __ASSEMBLY__

typedef signed   char  i8;
typedef unsigned char  u8;

typedef signed   short i16;
typedef unsigned short u16;

typedef signed   int   i32;
typedef unsigned int   u32;

typedef signed   long  i64;
typedef unsigned long  u64;

typedef u64 sz;

#endif

#endif /* __UNIKIT_ESSENTIALS_H__ */
