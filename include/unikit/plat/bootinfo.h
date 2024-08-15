/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __PLAT_BOOTINFO_H__
#define __PLAT_BOOTINFO_H__

#include <unikit/essentials.h>
#include <unikit/plat/memory.h>

struct unikit_bootinfo {
	/** Boot info magic */
	#define BOOTINFO_MAGIC 0xB0071EF0
	u32 magic;

	/** Boot loader identifier */
	u8 *bootloader;
	/** Boot protocol identifier */
	u8 *protocol;

	/** Boot command line */
	u8 *cmdline;

	/** Memory map */
	struct unikit_memory_map mmap;
};

/**
 * Gets the boot information structure
 * @return Address of boot information structure
 */
struct unikit_bootinfo *unikit_get_bootinfo();

/**
 * Sets the boot information structure
 * @param new_bi Boot information structure to set
 */
void unikit_set_bootinfo(struct unikit_bootinfo new_bi);

#endif /* __PLAT_BOOTINFO_H__ */
