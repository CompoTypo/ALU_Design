`ifndef DFF_V
`define DFF_V

//16 bit FLip Flop
module DFF(clk,rst,in,out);
	input clk; input  rst;
	input      [15:0] in;
	output reg [15:0] out;

	always @(clk,rst) begin
		if (clk) begin
			out = rst ? 16'b0000000000000000 : in;
		end
	end
endmodule
`endif
