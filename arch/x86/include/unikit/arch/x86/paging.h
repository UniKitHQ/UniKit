#ifndef __PAGING_H__
#define __PAGING_H__

#include <unikit/essentials.h>

struct x86_pml5e {
	u64 present               : 1;
	u64 read_write            : 1;
	u64 user_supervisor       : 1;
	u64 page_write_through    : 1;
	u64 page_cache_disable    : 1;
	u64 accessed              : 1;
	u64                       : 5;
	u64 hlat_ignore           : 1;
	u64 pml4_address          : 40;
	u64                       : 11;
	u64 no_execute            : 1;
};

struct x86_pml4e {
	u64 present              : 1;
	u64 read_write           : 1;
	u64 user_supervisor      : 1;
	u64 page_write_through   : 1;
	u64 page_cache_disable   : 1;
	u64 accessed             : 1;
	u64                      : 5;
	u64 hlat_ignore          : 1;
	u64 pdpte_address        : 40;
	u64                      : 11;
	u64 no_execute           : 1;
};

struct x86_pdpte {
	u64 present              : 1;
	u64 read_write           : 1;
	u64 user_supervisor      : 1;
	u64 page_write_through   : 1;
	u64 page_cache_disable   : 1;
	u64 accessed             : 1;
	u64                      : 1;
	u64 page_size            : 1; /* must be 0 */
	u64                      : 3;
	u64 hlat_ignore          : 1;
	u64 pd_address           : 40;
	u64                      : 11;
	u64 no_execute           : 1;
};

struct x86_pdpte_1gb {
	u64 present              : 1;
	u64 read_write           : 1;
	u64 user_supervisor      : 1;
	u64 page_write_through   : 1;
	u64 page_cache_disable   : 1;
	u64 accessed             : 1;
	u64 dirty                : 1;
	u64 page_size            : 1; /* must be 1 */
	u64 global               : 1;
	u64                      : 2;
	u64 hlat_ignore          : 1;
	u64 page_attribute_table : 1;
	u64                      : 17;
	u64 address              : 22;
	u64                      : 7;
	u64 protection_key       : 4;
	u64 no_execute           : 1;
};

struct x86_pde {
	u64 present              : 1;
	u64 read_write           : 1;
	u64 user_supervisor      : 1;
	u64 page_write_through   : 1;
	u64 page_cache_disable   : 1;
	u64 accessed             : 1;
	u64                      : 1;
	u64 page_size            : 1; /* must be 0 */
	u64                      : 3;
	u64 hlat_ignore          : 1;
	u64 pte_address          : 40;
	u64                      : 11;
	u64 no_execute           : 1;
};

struct x86_pde_2mb {
	u64 present              : 1;
	u64 read_write           : 1;
	u64 user_supervisor      : 1;
	u64 page_write_through   : 1;
	u64 page_cache_disable   : 1;
	u64 accessed             : 1;
	u64 dirty                : 1;
	u64 page_size            : 1; /* must be 1 */
	u64 global               : 1;
	u64                      : 2;
	u64 hlat_ignore		     : 1;
	u64 page_attribute_table : 1;
	u64                      : 8;
	u64 address              : 31;
	u64                      : 7;
	u64 protection_key       : 4;
	u64 no_execute           : 1;
};

struct x86_pte_4kb {
	u64 present               : 1;
	u64 read_write            : 1;
	u64 user_supervisor       : 1;
	u64 page_write_through    : 1;
	u64 page_cache_disable    : 1;
	u64 accessed              : 1;
	u64 dirty                 : 1;
	u64 page_attribute_table  : 1;
	u64 global                : 1;
	u64                       : 2;
	u64 hlat_ignore           : 1;
	u64 address               : 40;
	u64                       : 7;
	u64 protection_key        : 4;
	u64 no_execute            : 1;
};

#endif /* __PAGING_H__ */