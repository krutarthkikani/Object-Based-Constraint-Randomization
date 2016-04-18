`include "uvm_macros.svh"
import ahb_pkg::*;
import address_map_pkg::*;
import uvm_pkg::*;
module top();

initial
begin
find_next f = new;
ahb_item ai = new( "ahb_item" );
     constr_region register = new( 0, 16'h0FFF,0 );
     constr_region ram      = new( 16'h1000, 16'h7FFF,0 );
     constr_region rom      = new( 16'h8000, 16'hFFFF,1 );
     bit [15:0] addr;
     repeat (10) begin
         void'(f.next( register,ai));
     end
     repeat (10) begin
        void'(f.next( ram,ai));
     end
     repeat (10) begin
        void'(f.next( rom,ai));
     end

end

endmodule:top
