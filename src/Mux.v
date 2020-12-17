`ifndef MUX_V
`define MUX_V

// 3 SELECT BIT 16-BIT MULTIPLEXOR
module Mux3(chs,sel,result);
    input [7:0][15:0] chs;
    input [2:0] sel;
    output [15:0] result;
    wire [7:0][15:0] chs;
    reg [15:0] result;

    always @ (chs,sel,result)
    begin
        result = chs[sel];
    end
endmodule


// 2 SELECT BIT 16-BIT MULTIPLEXOR
module Mux2(chs,sel,result);
    input [3:0][15:0] chs;
    input [1:0] sel;
    output [15:0] result;
    wire [3:0][15:0] chs;
    reg [15:0] result;
    
    always @ (chs,sel,result)
    begin
        result = chs[sel];
    end
endmodule
`endif
