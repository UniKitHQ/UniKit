/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2023, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __UNIKIT_ASSERT_H__
#define __UNIKIT_ASSERT_H__

#include <unikit/essentials.h>
#include <unikit/plat/console.h>

#define PRINT(x) unikit_puts(x, sizeof(x) - 1)

/* TODO: termination */
#undef ASSERT
#define ASSERT(x)                                              \
    do {                                                       \
        if (unlikely(!(x))) {                                  \
            PRINT(__FILE__ ":");                               \
            PRINT(STRINGIFY(__LINE__) ": ");                   \
            PRINT("assertion \"" STRINGIFY(x) "\" failed.\n"); \
            PRINT("in function \"");                           \
            PRINT(__PRETTY_FUNCTION__);                        \
            PRINT("\"\n");                                     \
        }                                                      \
    } while (0)

#endif /* __UNIKIT_ASSERT_H__ */
