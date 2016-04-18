package address_map_pkg;

import ahb_pkg::*;

 class constr_base;
    rand ahb_item ahb_container;
    function void apply_to( ahb_item c );
      ahb_container = c;
    endfunction
 endclass : constr_base

  class constr_region extends constr_base;
    bit [15:0] m_lo, m_hi;
    bit m_read_only; // Set it to "1" by passing 1 as argument at time of new for Read Only Region
    function new( bit[15:0] lo, bit[15:0] hi, bit read_only = 0 );
       m_lo = lo; m_hi = hi;
       m_read_only = read_only;
    endfunction
    constraint c_region_addr { ahb_container.m_haddr >= m_lo &&
                               ahb_container.m_haddr < m_hi; }
    constraint read_only_reg { m_read_only -> ahb_container.m_hwrite == 1'b0; }
  endclass:constr_region

  class find_next;
    function void next( constr_region ab = null,ahb_item ahb = null );
      if ( ab )
        ab.apply_to( ahb );
        ab.randomize();
     
    endfunction:next
  endclass:find_next

endpackage:address_map_pkg


