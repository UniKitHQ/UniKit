/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __ARCH_X86_PAGING_H__
#define __ARCH_X86_PAGING_H__

#include <unikit/essentials.h>

struct x86_pml5e {
	u64 p             : 1;  /* present */
	u64 rw            : 1;  /* read / write */
	u64 us            : 1;  /* user / supervisor */
	u64 pwt           : 1;  /* page-level write-through */
	u64 pcd           : 1;  /* page-level cache disable */
	u64 a             : 1;  /* accessed */
	u64               : 5;
	u64 r             : 1;  /* hlat ignore */
	u64 pml4_address  : 40;
	u64               : 11;
	u64 xd            : 1;  /* execute disable */
};

struct x86_pml4e {
	u64 p             : 1;
	u64 rw            : 1;
	u64 us            : 1;
	u64 pwt           : 1;
	u64 pcd           : 1;
	u64 a             : 1;
	u64               : 5;
	u64 r             : 1;
	u64 pdpt_address : 40;
	u64               : 11;
	u64 xd            : 1;
};

struct x86_pdpte {
	u64 p             : 1;
	u64 rw            : 1;
	u64 us            : 1;
	u64 pwt           : 1;
	u64 pcd           : 1;
	u64 a             : 1;
	u64               : 1;
	u64 ps            : 1; /* page size */ /* must be 0 */
	u64               : 3;
	u64 r             : 1;
	u64 pd_address    : 40;
	u64               : 11;
	u64 xd            : 1;
};

struct x86_pdpte_1gb {
	u64 p             : 1;
	u64 rw            : 1;
	u64 us            : 1;
	u64 pwt           : 1;
	u64 pcd           : 1;
	u64 a             : 1;
	u64 d             : 1;
	u64 ps            : 1;  /* must be 1 */
	u64 g             : 1;
	u64               : 2;
	u64 r             : 1;
	u64 pat           : 1;  /* must be 0 */
	u64               : 17;
	u64 address       : 22;
	u64               : 7;
	u64 pk            : 4;  /* protection key */
	u64 xd            : 1;
};

struct x86_pde {
	u64 p             : 1;
	u64 rw            : 1;
	u64 us            : 1;
	u64 pwt           : 1;
	u64 pcd           : 1;
	u64 a             : 1;
	u64               : 1;
	u64 ps            : 1;  /* must be 0 */
	u64               : 3;
	u64 r             : 1;
	u64 pt_address   : 40;
	u64               : 11;
	u64 xd            : 1;
};

struct x86_pde_2mb {
	u64 p             : 1;
	u64 rw            : 1;
	u64 us            : 1;
	u64 pwt           : 1;
	u64 pcd           : 1;
	u64 a             : 1;
	u64 d             : 1;
	u64 ps            : 1;  /* must be 1 */
	u64 g             : 1;
	u64               : 2;
	u64 r		      : 1;
	u64 pat           : 1;
	u64               : 8;
	u64 address       : 31;
	u64               : 7;
	u64 pk            : 4;
	u64 xd            : 1;
};

struct x86_pte_4kb {
	u64 p             : 1;
	u64 rw            : 1;
	u64 us            : 1;
	u64 pwt           : 1;
	u64 pcd           : 1;
	u64 a             : 1;
	u64 d             : 1;
	u64 pat           : 1;
	u64 g             : 1;
	u64               : 2;
	u64 r             : 1;
	u64 address       : 40;
	u64               : 7;
	u64 pk            : 4;
	u64 xd            : 1;
};

#endif /* __ARCH_X86_PAGING_H__ */