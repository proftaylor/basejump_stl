/**
 *  bsg_mux_interleave.v
 *
 *  @author tommy
 *
 *  example:
 *  For input  =  {b3,b2,b1,b0}
 *  ---------------------------
 *  sel_i = 00 => {b3,b2,b1,b0}
 *  sel_i = 01 => {b2,b3,b0,b1}
 *  sel_i = 10 => {b1,b0,b3,b2}
 *  sel_i = 11 => {b0,b1,b2,b3}
 *  ---------------------------
 */


module bsg_mux_interleave
  #(parameter width_p="inv"
    , parameter els_p="inv"
    , localparam lg_els_lp=`BSG_SAFE_CLOG2(els_p)
  )
  (
    input [els_p-1:0][width_p-1:0] data_i
    , input [lg_els_lp-1:0] sel_i
    , output logic [els_p-1:0][width_p-1:0] data_o
  );

  logic [lg_els_lp:0][(els_p*width_p)-1:0] data_stage;

  assign data_stage[0] = data_i;

  for (genvar i = 0; i < lg_els_lp; i++) begin: mux_stage
    for (genvar j = 0; j < els_p/(2**(i+1)); j++) begin: mux_swap

      bsg_swap #(
        .width_p(width_p*(2**i))
      ) swap_inst (
        .data_i(data_stage[i][2*width_p*(2**i)*j+:2*width_p*(2**i)])
        ,.swap_i(sel_i[i])
        ,.data_o(data_stage[i+1][2*width_p*(2**i)*j+:2*width_p*(2**i)])
      );

    end 
  end

  assign data_o = data_stage[lg_els_lp];

endmodule
