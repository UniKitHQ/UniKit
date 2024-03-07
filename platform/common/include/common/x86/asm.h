/* SPDX-License-Identifier: MPL-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the MPL-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __ASM_H__
#define __ASM_H__

#include <usft/essentials.h>

static inline void outb(u16 PORT, u8 value) {
	asm volatile(
		"out %0, %1;"
		: : "dN"(PORT), "a"(value)
	);
}

static inline u8 inb(u16 PORT) {
	u8 value;
	asm volatile("in %0,%1" : "=a"(value) : "dN"(PORT));
	return value;
}

#endif /* __ASM_H__ */