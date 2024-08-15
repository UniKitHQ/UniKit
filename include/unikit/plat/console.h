/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __UNIKIT_PLAT_CONSOLE_H__
#define __UNIKIT_PLAT_CONSOLE_H__

#include <unikit/essentials.h>

/**
 * Outputs a string to console
 * @param str Buffer with string
 * @param len Length of string buffer (if < 0 ignored),
 * @return Number of printed characters, errno on < 0
 */
int unikit_puts(const char *str, sz len);

/**
 * Reads a string from console
 * @param buf Buffer to store string
 * @param len Length of string buffer (if < 0 ignored),
 * @return Number of printed characters, errno on < 0
 */
int unikit_gets(char *buf, sz len);

#endif /* __UNIKIT_PLAT_CONSOLE_H__ */
