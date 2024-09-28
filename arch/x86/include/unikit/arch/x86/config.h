/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __UNIKIT_ARCH_X86_CONFIG_H__
#define __UNIKIT_ARCH_X86_CONFIG_H__

#include <unikit/arch/x86/paging.h>

#ifndef UNIKIT_CONFIG_STACK_SIZE
#define UNIKIT_CONFIG_STACK_SIZE 0
#endif

#define CONFIG_STACK_SIZE (PAGE_SIZE << UNIKIT_CONFIG_STACK_SIZE)

#endif /* __UNIKIT_ARCH_X86_CONFIG_H__ */
