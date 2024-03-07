/* SPDX-License-Identifier: MPL-2.0 */
/* Copyright (c) 2023, Pribess (Heewon Cho).
 * Licensed under the MPL-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <usft/essentials.h>
#include <usft/nolibc/string.h>
#include <common/x86/serial.h>
#include <kvm/lxboot.h>

void copy_boot_params() {
	memcpy(&boot_params.hdr, &hdr, sizeof(struct lxboot_setup_header));
}

void setup() {

	copy_boot_params();

	serial_init();

}