#ifndef __PAGING_H__
#define __PAGING_H__

#include <unikit/essentials.h>

struct x86_pml5e {
    u32 present               : 1;
    u32 read_write            : 1;
    u32 user_supervisor       : 1;
    u32 page_write_through    : 1;
    u32 page_cache_disable    : 1;
    u32 accessed              : 1;
    u32                       : 5;
    u32 hlat_ignore           : 1;
    u32 pml4_address          : 40;
    u32                       : 11;
    u32 no_execute            : 1;
};

struct x86_pml4e {
    u32 present              : 1;
    u32 read_write           : 1;
    u32 user_supervisor      : 1;
    u32 page_write_through   : 1;
    u32 page_cache_disable   : 1;
    u32 accessed             : 1;
    u32                      : 5;
    u32 hlat_ignore          : 1;
    u32 pdpte_address        : 40;
    u32                      : 11;
    u32 no_execute           : 1;
};

struct x86_pdpte {
    u32 present              : 1;
    u32 read_write           : 1;
    u32 user_supervisor      : 1;
    u32 page_write_through   : 1;
    u32 page_cache_disable   : 1;
    u32 accessed             : 1;
    u32                      : 1;
    u32 page_size            : 1; /* must be 0 */
    u32                      : 3;
    u32 hlat_ignore          : 1;
    u32 pd_address           : 40;
    u32                      : 11;
    u32 no_execute           : 1;
};

struct x86_pdpte_1gb {
	u32 present              : 1;
	u32 read_write           : 1;
	u32 user_supervisor      : 1;
	u32 page_write_through   : 1;
	u32 page_cache_disable   : 1;
	u32 accessed             : 1;
	u32 dirty                : 1;
	u32 page_size            : 1; /* must be 1 */
	u32 global               : 1;
	u32                      : 2;
	u32 hlat_ignore          : 1;
	u32 page_attribute_table : 1;
	u32                      : 17;
	u32 address              : 22;
	u32                      : 7;
	u32 protection_key       : 4;
	u32 no_execute           : 1;
};

struct x86_pde {
    u32 present              : 1;
    u32 read_write           : 1;
    u32 user_supervisor      : 1;
    u32 page_write_through   : 1;
    u32 page_cache_disable   : 1;
    u32 accessed             : 1;
    u32                      : 1;
    u32 page_size            : 1; /* must be 0 */
    u32                      : 3;
    u32 hlat_ignore          : 1;
    u32 pte_address          : 40;
    u32                      : 11;
    u32 no_execute           : 1;
};

struct x86_pde_2mb {
    u32 present              : 1;
    u32 read_write           : 1;
    u32 user_supervisor      : 1;
    u32 page_write_through   : 1;
    u32 page_cache_disable   : 1;
    u32 accessed             : 1;
    u32 dirty                : 1;
    u32 page_size            : 1; /* must be 1 */
    u32 global               : 1;
    u32                      : 2;
	u32 hlat_ignore		     : 1;
    u32 page_attribute_table : 1;
	u32                      : 8;
    u32 address              : 31;
	u32                      : 7;
	u32 protection_key       : 4;
    u32 no_execute           : 1;
};

struct x86_pte_4kb {
    u32 present               : 1;
    u32 read_write            : 1;
    u32 user_supervisor       : 1;
    u32 page_write_through    : 1;
    u32 page_cache_disable    : 1;
    u32 accessed              : 1;
    u32 dirty                 : 1;
    u32 page_attribute_table  : 1;
    u32 global                : 1;
    u32                       : 2;
    u32 hlat_ignore           : 1;
    u32 address               : 40;
    u32                       : 7;
    u32 protection_key        : 4;
    u32 no_execute            : 1;
};

#endif /* __PAGING_H__ */