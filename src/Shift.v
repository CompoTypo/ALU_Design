`ifndef SHIFT_V
`define SHIFT_V

// BEGIN SHIFTING MODULES
// Shift one bit to the left
module LSHIFT(in,sft,out);
    input [15:0] in;
	input 		 sft;
    output reg [15:0] out;

    // Chop off greatest bit and concat 0 as least bit 
	always @(in,sft,out) begin
    	out <= in << sft;
	end
endmodule // LSHIFT

// Shift one bit to the right
module RSHIFT(in,sft,out);
    input [15:0] in;
	input 		 sft;
    output reg [15:0] out;

    // Chop off least bit and concat 0 as greatest bit 
	always @(in,sft,out) begin
  		out <= in >> sft;
	end
endmodule // RSHIFT
// END SHIFT MODULES

`endif