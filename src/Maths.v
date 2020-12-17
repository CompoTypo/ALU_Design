`ifndef MATHS_V
`define MATHS_V

// 16 bit multiplier module
module Mul (A,B,Cout,result);
   	//---------------------------------------
   	input [15:0] A;
   	input [15:0] B;
   	//---------------------------------------
   	output[15:0] Cout;
   	output[15:0] result;
   	reg   [15:0] Cout;
   	reg   [15:0] result;
   	//---------------------------------------
	always @(A,B) begin
   		result = A * B;
	end
endmodule //Mul

// 16 bit division module
module Div (A,B,mod,res);
   	//---------------------------------------
   	input [15:0] A;
   	input [15:0] B;
   	wire  [15:0] A;
   	wire  [15:0] B;
   	//---------------------------------------
   	output[15:0] res;
   	output[15:0] mod;
   	reg   [15:0] res;
   	reg   [15:0] mod;
   	//---------------------------------------
   	always @(A,B) begin
   		res = A / B;
   		mod = A % B;
   	end
endmodule //Div

// 16 bit adder
module Add (A,B,Cin,carry,sum);
	input [15:0] A; 
	input [15:0] B;
	input 		 Cin;
	output[15:0] sum;
	output       carry;
	wire  [15:0] Sum;
   	wire         carry;

	assign {carry,sum} = A+B+Cin;
endmodule
// END MATH MODULES


`endif
