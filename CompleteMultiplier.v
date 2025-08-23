`include "SeqMul_4460.v"
`include "Break17840.v"
`include "ks1.v"
`include "ks2.v"
`include "ks3.v"
`include "ks4.v"
`include "ks8.v"
`include "ks11.v"
`include "ks16.v"
`include "ks32.v"
`include "ks64.v"
`include "ks75.v"
`include "SixInputAdder.v"
`include "div.v"
`include "div2.v"
`include "SeqMul_70.v"
`include "SeqMul_280.v"
`include "Break1120.v"
`include "SeqMul_1116.v"
`include "Break4464.v"
`include "Break284.v"

module CompleteMultiplier(clk, reset, U, V, W, done);

    input clk, reset;
    input [17668:0] U;
    input [17668:0] V;
    output [35337:0] W;
    output done;

    wire [35679:0] multiplier_out;

    wire [17839:0] U_extended = {U, 171'b0};
    wire [17839:0] V_extended = {V, 171'b0};

    wire [4459:0] U0, U1, U2, U3;
    wire [4459:0] V0, V1, V2, V3;

    Break17840 dut1(U_extended, U0, U1, U2, U3);
    Break17840 dut2(V_extended, V0, V1, V2, V3);

    SeqMul_4460 multiplier(clk, reset, U0, U1, U2, U3, V0, V1, V2, V3, multiplier_out, done);

    assign W = multiplier_out[35679:342];


endmodule


