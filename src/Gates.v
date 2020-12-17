`ifndef GATES_V
`define GATES_V

// 12 input, 1 bit Or gate for arithmatic mux select bits
module Or12By1 (input A,B,C,D,E,F,G,H,I,J,K,L,output result);
  	assign result = A|B|C|D|E|F|G|H|I|J|K|L;
endmodule //Or12

// 7 input, 1 bit Or gate for arithmatic mux select bits
module Or7By1 (input A,B,C,D,E,F,G,output result);
  	assign result = A|B|C|D|E|F|G;
endmodule //Or7

// 4 input, 1 bit Or gate for arithmatic mux select bits
module Or4By1 (input A,B,C,D,output result);
  	assign result = A|B|C|D;
endmodule //Or4

// 3 input, 1 bit Or gate for logic mux select bit
module Or3By1 (input A,B,C,output result);
  	assign result = A|B|C;
endmodule //Or3

// 2 input, 1 bit Or gate for logic mux select bits
module Or2By1 (input A,B,output result);
  assign result = A|B;
endmodule //Or2

// 2 BY 16-BIT AND----------------------------------------------------
module And2By16 (A,B,result);
	input [15:0] A;
	input [15:0] B;
	output reg [15:0] result;

  	integer i;
  	always @(A,B) begin
  	  	for (i = 0; i < 16; i=i+1)
		    result[i] = A[i]&B[i];
  end
endmodule
//----------------------------------------------------------------------

// 2 BY 16-BIT OR-----------------------------------------------------
module Or2By16 (A,B,result);
  	input [15:0] A;
  	input [15:0] B;
	output reg [15:0] result;

  	integer i;
  	always @(A,B) begin
  	  	for (i = 0; i < 16; i=i+1)
  	  	  	result[i] = A[i]|B[i];
  	end
endmodule
//----------------------------------------------------------------------

// 2 BY 16-BIT XOR-----------------------------------------------------
module XOr2By16 (A,B,result);
	input [15:0] A;
	input [15:0] B;
	output reg [15:0] result;

  	integer i;
  	always @(A,B) begin
  	    for (i = 0; i < 16; i=i+1)
  	    	result[i] = A[i]^B[i];
    end
endmodule
//----------------------------------------------------------------------

// 2 BY 16-BIT NOT-----------------------------------------------------
module Not2By16 (A,result);
	input [15:0] A;
	output reg [15:0] result;

  	integer i;
  	always @(A) begin
  	  	for (i = 0; i < 16; i=i+1)
		    result[i] = !A[i];
    end
endmodule
//----------------------------------------------------------------------

// 2 BY 16-BIT NAND----------------------------------------------------
module NAnd2By16 (A,B,result);
	input [15:0] A;
	input [15:0] B;
	output reg [15:0] result;

  	integer i;
  	always @(A,B) begin
  	  	for (i = 0; i < 16; i=i+1)
		    result[i] = !(A[i]&B[i]);
  	end
endmodule
//----------------------------------------------------------------------

// 2 BY 16-BIT NOR-----------------------------------------------------
module NOr2By16 (A,B,result);
	input [15:0] A;
	input [15:0] B;
	output reg [15:0] result;

  	integer i;
  	always @(A,B) begin
  	  	for (i = 0; i < 16; i=i+1)
		    result[i] = !(A[i]|B[i]);
  	end
endmodule
//----------------------------------------------------------------------

// 2 BY 16-BIT XNOR-----------------------------------------------------
module XNor2By16 (A,B,result);
	input [15:0] A;
	input [15:0] B;
	output reg [15:0] result;

  	integer i;
  	always @(A,B) begin
  		for (i = 0; i < 16; i=i+1)
		    result[i] = (A[i]~^B[i]);
  	end
endmodule
// END OF GATES// BEGIN MATH MODULES
//----------------------------------------------------------------------
`endif
