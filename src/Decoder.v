`ifndef DECODER_V
`define DECODER_V

// 4TO16 BIT DECODER
module Decoder(opcode,out);
	input  	   [ 3:0] opcode;
	output reg [15:0] out;

	always @(opcode,out) begin
    	out = 1 << opcode;
	end
endmodule
`endif
