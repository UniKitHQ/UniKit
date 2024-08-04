/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2023, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __ASSERT_H__
#define __ASSERT_H__

#include <unikit/essentials.h>
#include <unikit/plat/console.h>

#undef ASSERT
#define ASSERT(x)                                  \
	do {                                           \
		if (unlikely(!(x))) {                      \
			plat_puts("Assertion failed: ",        \
			 sizeof("Assertion failed: ") - 1);    \
			plat_puts(STRINGIFY(x),                \
			 sizeof(STRINGIFY(x)) - 1);            \
			/* TODO: stacktrace and termination */ \
		}                                          \
	} while (0)

#define WARNIF(x)                                \
	do {                                         \
		if (unlikely(x)) {                       \
			plat_puts("Condition warning: ",     \
			 sizeof("Condition warning: ") - 1); \
			plat_puts(STRINGIFY(x),              \
			 sizeof(STRINGIFY(x)) - 1);          \
			/* TODO: stacktrace */               \
		}                                        \
	} while (0)


#endif /* __ASSERT_H__ */
