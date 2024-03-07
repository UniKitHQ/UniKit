/* SPDX-License-Identifier: MPL-2.0 */
/* Copyright (c) 2023, Pribess (Heewon Cho).
 * Licensed under the MPL-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <usft/essentials.h>

#include <kvm/lxboot.h>

struct lxboot_params boot_params __aligned(16);

struct lxboot_setup_header hdr __section(".data.lxboot.header") = {
	.setup_sects = 4,
	.root_flags = ROOT_RDONLY,		/* deprecated */
	.syssize = 0,					/* deperecated */
	.ram_size = 0,					/* obsolute */
	.vid_mode = ASK_VGA,
	.root_dev = 0,					/* deprecated */
	.boot_flag = 0xAA55,
	/* short jump (0xEB) + relative start (.lxboot_start) offset */
	.jump = 0xEB + ((sizeof(struct lxboot_setup_header) - 0x11) << 8),
	.header = 0x53726448, /* "HdrS" */
	.version = 0x020C, /* protocol version 2.12 */
	.realmode_swtch = 0,
	.start_sys_seg = 0,				/* obsolute */
	.kernel_version = 0,
	.type_of_loader = 0xFF,
	.loadflags = LOADED_HIGH,
	.setup_move_size = 0,
	.code32_start = 0x10000,
	.ramdisk_image = 0,
	.ramdisk_size = 0,
	.bootsect_kludge = 0,			/* obsolute */
	.heap_end_ptr = 0x2000 - 0x200,	
	.ext_loader_ver = 0,
	.ext_loader_type = 0,
	.cmd_line_ptr = 0,
	.initrd_addr_max = 0,
	.kernel_alignment = 0,
	.relocatable_kernel = 0,
	.min_alignment = 0,
	.xloadflags = XLF_KERNEL_64,
	.cmd_line_size = 1024,
	.hardware_subarch = 0,
	.hardware_subarch_data = 0,
	.payload_offset = 0,
	.payload_length = 0,
	.setup_data = 0,
	.pref_address = 0,
	.init_size = 0,
	.handover_offset = 0,
	.kernel_info_offset = 0,
};


