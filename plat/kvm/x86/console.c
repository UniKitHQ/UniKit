/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/arch/x86/serial.h>

int kvm_console_init() {
	serial_init();
	return 0;
}

int plat_console_putc(char i) {
	serial_putc(i);
	return i;
}

int plat_console_getc() {
	return serial_getc();
}