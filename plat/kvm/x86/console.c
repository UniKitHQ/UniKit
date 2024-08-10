/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/plat/console.h>
#include <unikit/arch/x86/serial.h>

int kvm_console_init() {
	serial_init();
	return 0;
}

int unikit_puts(const char *str, sz len) {
	for (int i = 0; i < len; i++) {
		serial_putc(str[i]);
	}
	return len;
}

int unikit_gets(char *buf, sz len) {
	for (int i = 0; i < len; i++) {
			buf[i] = serial_getc();
	}
	return len;
}
