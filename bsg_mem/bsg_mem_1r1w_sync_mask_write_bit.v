// MBT 7/7/2016
//
// 1 read-port, 1 write-port ram
//
// reads are synchronous

module bsg_mem_1r1w_sync_mask_write_bit #(parameter width_p=-1
                                        , parameter els_p=-1
                                        , parameter read_write_same_addr_p=0
                                        , parameter addr_width_lp=`BSG_SAFE_CLOG2(els_p)
                                        , parameter harden_p=0
                                        )
   (input   clk_i
    , input reset_i

    , input                     w_v_i
    , input [width_p-1:0]       w_mask_i
    , input [addr_width_lp-1:0] w_addr_i
    , input [width_p-1:0]       w_data_i

    , input                      r_v_i
    , input [addr_width_lp-1:0]  r_addr_i

    , output logic [width_p-1:0] r_data_o
    );

   bsg_mem_1r1w_sync_mask_write_bit_synth
     #(.width_p(width_p)
       ,.els_p (els_p  )
       ,.read_write_same_addr_p(read_write_same_addr_p)
       ,.harden_p(harden_p)
       ) synth
       (.*);

   //synopsys translate_off

/*
   always_ff @(negedge clk_i)
     begin
        if (reset_i!==1'b1 & (r_v_i | w_v_i))
          $display("@@ w=%b w_addr=%x w_data=%x w_mask=%x r=%b r_addr=%x (%m)",w_v_i,w_addr_i,w_data_i,w_mask_i,r_v_i,r_addr_i);
     end
 */

   always_ff @(posedge clk_i)
     if (w_v_i)
       begin
          assert (w_addr_i < els_p)
            else $error("Invalid address %x to %m of size %x\n", w_addr_i, els_p);

          assert (~(r_addr_i == w_addr_i && w_v_i && r_v_i && !read_write_same_addr_p))
            else
              begin
                 $error("%m: Attempt to read and write same address (reset_i %b, %x <= %x (mask %x) old_val %x",reset_i, w_addr_i,w_data_i,w_mask_i,mem[r_addr_i]);
                 //$finish();
              end
       end

   initial
     begin
        $display("## %L: instantiating width_p=%d, els_p=%d, read_write_same_addr_p=%d harden_p=%d (%m)",width_p,els_p,read_write_same_addr_p, harden_p);
     end

   //synopsys translate_on

   
endmodule
