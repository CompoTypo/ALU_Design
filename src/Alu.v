/***************************************************************************************
*    Title: ALU Project 
*    Author: Andrew Jensen
*    Date: Nov/8/2020 
*
*************************************************************************************/
`include "Decoder.v"
`include "DFF.v"
`include "Gates.v"
`include "Maths.v"
`include "Mux.v"
`include "Shift.v"

//Breadboard
module breadboard(clk,A,opcode);
	input clk; 			wire clk;
	input [15:0] A;  	wire [15:0] A;
	input [15:0] B;  	wire [15:0] B;
	input [3:0]  opcode;wire [3:0] opcode;
	
	//----------------------------------
	wire [15:0] onehot; // decoder output
	wire [15:0] b;
	reg  [1:0]  Error;

	// Shifting input wires
	wire [15:0] LSFT;
	wire [15:0] RSFT;

	// Arithmetic output wires
	wire [15:0] ADDSUB,MUL,MULCARRY,DIV,MOD;
	wire        ADDSUBCARRY;

	// Gate output wires
	wire [15:0] AND,OR,XOR,NOT,NAND,NOR,XNOR;

	// Shift Mux output
	wire [15:0] SMOut;

	// Aritmatic multiplexer select and output wires
	wire MMSel0,MMSel1,MMSel2;
	wire [15:0] MMOut;

	// Logic Multiplexer select and output wires
	wire LMSel0,LMSel1,LMSel2;
	wire [15:0] LMOut;

	// Output Multiplexer select and output wires
	wire OMSel0,OMSel1;
  
	reg  [15:0] regA;
	reg  [15:0] regB;

	reg  [15:0] next;
	wire [15:0] cur;

	// Use decoder to generate out onehot
	Decoder dec(opcode,onehot);

	// setup and use Math Mux
	Or3By1 MMSelect0(onehot[1],onehot[2],onehot[7],MMSel0);	
	Or2By1 MMSelect1(onehot[2],onehot[3],MMSel1);
	Or2By1 MMSelect2(onehot[6],onehot[7],MMSel2);
	Mux3 MathMux({16'd0,16'd0,MOD,DIV,MUL,ADDSUB,ADDSUB,cur},{MMSel2,MMSel1,MMSel0},MMOut);

	// define operational arithmatic modules	
	//INTERFACES
	wire [15:0] XR;
	wire [15:0] MS;

	//Link the wires between the Adders
	assign MS = {opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1],opcode[1]};
	XOr2By16 SU(MS,regB,XR);
	// Arithmatic module usage
	Add add(regA,XR,opcode[1],ADDSUBCARRY,ADDSUB);
	Mul mul(regA,regB,MULCARRY,MUL);
	Div div(regA,regB,MOD,DIV);

	// Setup and use Logic Mux
	Or4By1 LMSelect0(onehot[5],onehot[12],onehot[15],onehot[10],LMSel0);
	Or4By1 LMSelect1(onehot[4],onehot[12],onehot[10],onehot[14],LMSel1);
	Or4By1 LMSelect2(onehot[13],onehot[15],onehot[14],onehot[10],LMSel2);
	Mux3 LogicMux({XNOR,NOR,NAND,NOT,XOR,OR,AND,cur},{LMSel2,LMSel1,LMSel0},LMOut);

	// define operational gates
	And2By16 a(regA,regB,AND);
	Or2By16 o(regA,regB,OR);
	XOr2By16 xo(regA,regB,XOR);
	Not2By16 n(regA,NOT);
	NAnd2By16 na(regA,regB,NAND);
	NOr2By16 no(regA,regB,NOR);
	XNor2By16 xno(regA,regB,XNOR);

	// Shift mux
	Mux2 ShiftMux({16'd0,RSFT,LSFT,cur},{onehot[9],onehot[11]},SMOut);

	// define shifting modules
	LSHIFT LSft(regA,opcode[3],LSFT);
	RSHIFT RSft(regA,opcode[3],RSFT);

	// final output Mux setup and usage
	Or7By1 OMSelect0(onehot[1],onehot[2],onehot[3],onehot[6],onehot[7],onehot[9],onehot[11],OMSel0);
	Or12By1 OMSelect1(onehot[1],onehot[2],onehot[3],onehot[4],onehot[5],onehot[6],onehot[7],onehot[10],onehot[12],onehot[13],onehot[14],onehot[15],OMSel1);
	Mux2 OutMux({MMOut,LMOut,SMOut,cur},{OMSel1,OMSel0},b);

	// 16 bit register
	DFF ACC(clk,onehot[8],next,cur);

	always @(A,cur,b)
	begin
		// Handle errors programatically, trust me this was more accurate than what i was able to do in logisim. Everything else should be properly accounted for
		if ((A == 0 && opcode[1] && (opcode == 7 || opcode == 6))) 
			Error = 2'b10;
 		else if ((ADDSUBCARRY > 0 && (opcode == 1 || opcode == 3)) || (MULCARRY > 0 && opcode == 3)) begin
		 	Error = 2'b01;
		end else begin
			Error = 2'b00;
		end
		regA=A;
		regB=cur;

		assign next=b;
	end
endmodule


//TEST BENCH
module testbench();

	//Local Variables
   	reg clk;
   	reg  [15:0] inputA;
   	reg  [3:0] opcode;
   	reg  [15:0] count;

	// create breadboard
	breadboard bb8(clk,inputA,opcode);

   	//CLOCK
    initial begin //Start Clock Thread
        forever //While TRUE
        begin //Do Clock Procedural
          clk=0; //square wave is low
          #5; //half a wave is 5 time units
          clk=1;//square wave is high
          #5; //half a wave is 5 time units
        end
    end

    initial begin //Start Output Thread
	forever
        begin
		$display("(ACC:%16b)(OPCODE:%4b)(IN:%16b)(OUT:%16b)(ERR:%2b)",bb8.cur,opcode,inputA,bb8.b,bb8.Error);
		//$display("(ADDSUB:%3b)(MUL:%3b)(DIV:%16b)(MOD:%16b)(AND:%16b)(OR:%16b)(XOR:%16b)",bb8.ADDSUB,bb8.MUL,bb8.DIV,bb8.MOD,bb8.AND,bb8.OR,bb8.XOR);
		//$display("(MM:%16b)(LM:%16b)(SM:%16b)",bb8.MMOut,bb8.LMOut,bb8.SMOut);
		#10;
		end
	end

//STIMULOUS
	initial begin//Start Stimulous Thread
	#6;	
	//---------------------------------
	inputA=16'b0000000000000000;
	opcode=4'b0000;//NO-OP
	#10; 
	//---------------------------------
	inputA=16'b0000000000000000;
	opcode=4'b1000;//NO-OP
	#10; 
	//---------------------------------
	inputA=16'b0000000000001001;
	opcode=4'b0001;//ADD
	#10; 
	//---------------------------------
	inputA=16'b0000000000001110;
	opcode=4'b0011;//ADD
	#10;
	//---------------------------------	
	inputA=16'b0000000000000010;
	opcode=4'b0010;//MULT
	#10;
	//---------------------------------	
	inputA=16'b0000000000011111;
	opcode=4'b0110;//DIV
	#10;
	//---------------------------------
	inputA=16'b0000000000000010;
	opcode=4'b0111;//MOD
	#10;
	//---------------------------------	
	inputA=16'b0000000000000010;
	opcode=4'b0101;//AND
	#10
	//---------------------------------	
	inputA=16'b0101100101010010;
	opcode=4'b0100;//OR
	#10;
	//---------------------------------	
	inputA=16'b1100001011010110;
	opcode=4'b1100;//XOR
	#10
	//---------------------------------	
	inputA=16'b0000000000101000;
	opcode=4'b1101;//NOT
	#10;
	//---------------------------------	
	inputA=16'b0011010101100101;
	opcode=4'b1111;//NAND
	#10;
	//---------------------------------	
	inputA=16'b0000010100101000;
	opcode=4'b1110;//NOR
	#10;
	//---------------------------------	
	inputA=16'b1100010101010101;
	opcode=4'b1010;//XNOR
	#10
	//---------------------------------	
	inputA=16'b0011010110101011;
	opcode=4'b1011;//LSHIFT
	#10;
	//---------------------------------	
	inputA=16'b1000101000101010;
	opcode=4'b1001;//RSHIFT
	#10;
	//---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b1000;//RESET
	#10;
	//---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b0000;//NOOP
	#10
	
	$finish;
	end
endmodule