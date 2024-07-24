/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __PLAT_BOOTINFO_H__
#define __PLAT_BOOTINFO_H__

#include <unikit/essentials.h>

struct unikit_bootinfo {
	/* Boot info magic */
	#define BOOTINFO_MAGIC 0xB0071EF0
	u32 magic;

	/* Boot environment identifier */
	u8 *bootloader;
	u8 *protocol;

	/* Null-terminated kernel command line */
	u8 *cmdline;
};


struct unikit_bootinfo *get_bootinfo();
void set_bootinfo(struct unikit_bootinfo new_bi);

#endif /* __PLAT_BOOTINFO_H__ */
