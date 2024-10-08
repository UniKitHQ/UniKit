/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __UNIKIT_ARCH_X86_SERIAL_H__
#define __UNIKIT_ARCH_X86_SERIAL_H__

void serial_init();

void serial_putc(char i);
int serial_getc();

#endif /* __UNIKIT_ARCH_X86_SERIAL_H__ */
