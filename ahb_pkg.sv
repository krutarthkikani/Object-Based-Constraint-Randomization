package ahb_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum bit[2:0] { HBURST_SINGLE =3'b000, HBURST_INCR   =3'b001, HBURST_WRAP4  =3'b010, HBURST_INCR4  =3'b011, HBURST_WRAP8  =3'b100, HBURST_INCR8  =3'b101,
HBURST_WRAP16 =3'b110, HBURST_INCR16 =3'b111 } hburst_type;

class ahb_item extends uvm_object;
  rand bit         m_hwrite;
  rand bit  [15:0] m_haddr;
  rand hburst_type m_hburst;
  rand bit   [2:0] m_hsize;
  rand bit   [7:0] m_hdata[];
  constraint hsize_limit { m_hsize < 3'b100; }
  constraint illigal_hburst { !(m_hburst inside {HBURST_INCR,HBURST_INCR4,HBURST_INCR8,HBURST_INCR16});}
  constraint addr_allign {(m_haddr >> m_hsize << m_hsize) == m_haddr;}
  constraint write_data_q { (m_hburst != 3'b110 & m_hwrite) -> (m_hdata.size() == ( m_hburst << (m_hsize + 1'b1)));
                            (m_hburst == 3'b110 & m_hwrite) -> (m_hdata.size() == ( 4'b1000 << (m_hsize + 1'b1)));
                            (!m_hwrite) -> (m_hdata.size() == 0);}
  constraint order  {solve m_hsize before m_hdata;}
  constraint order1  {solve m_hburst before m_hdata;}

  // ====== Payload Randomization Function==============
  function void payload_randomize();
     `uvm_info("PAYLOAD","===== PAYLOAD========",UVM_HIGH);
    foreach (m_hdata[i])
    begin
     m_hdata[i] = $random;
     `uvm_info("PAYLOAD",$sformatf("%0d",m_hdata[i]),UVM_HIGH);
    end
     `uvm_info("PAYLOAD","=====================",UVM_HIGH);
  endfunction:payload_randomize
  // ====================================================
    
  function new(string name);
      super.new(name);
  endfunction
  
  function void post_randomize;
    int len;
    len = m_hdata.size();
    if(len == 0)  begin
      `uvm_info("TEST",convert2string(),UVM_MEDIUM);  
    end
    else begin
      m_hdata = new[len];
      `uvm_info("TEST",convert2string(),UVM_MEDIUM);  
      payload_randomize();
    end
  endfunction:post_randomize
  
  virtual function string convert2string();
  string command = ( m_hwrite ) ? "Write" : "Read"; return $sformatf( "%s @%4h, hsize=%2d, hburst=%s data_len=%0d", command, m_haddr, m_hsize, m_hburst.name,m_hdata.size() ); 
  endfunction : convert2string  
  
endclass:ahb_item

endpackage:ahb_pkg
