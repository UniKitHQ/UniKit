/* SPDX-License-Identifier: MPL-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the MPL-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __SERIAL_H__
#define __SERIAL_H__

void serial_init();

void serial_putc(char i);
int serial_getc();

#endif /* __SERIAL_H__ */