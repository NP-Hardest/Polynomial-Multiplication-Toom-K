/*******************************************************
* File Name     : hdl/ks3.v
* Module Name   : Karatsuba Multiplier
* Author        : Chester Rebeiro
* Institute     : Indian Institute of Technology, Madras
* Creation Time : 

* Comment       : Automatically generated from ks.c
********************************************************/
`ifndef __KS_3_V__
`define __KS_3_V__
// `include "ks2.v"
module ks3(a, b, d);

input wire [2:0] a;
input wire [2:0] b;
output wire [4:0] d;

wire [0:0] m1;
wire [2:0] m2;
wire [2:0] m3;
wire [1:0] ahl;
wire [1:0] bhl;

ks2 ksm1(a[1:0], b[1:0], m2);
ks1 ksm2(a[2:2], b[2:2], m1);
assign ahl[0:0] = a[2:2] ^ a[0:0];
assign ahl[1] = a[1];
assign bhl[0:0] = b[2:2] ^ b[0:0];
assign bhl[1] = b[1];
ks2 ksm3(ahl, bhl, m3);

assign  d[00] = m2[00];   
assign  d[01] = m2[01];   
assign  d[02] = m2[02] ^ m1[00] ^ m2[00] ^ m3[00];   
assign  d[03] = m2[01] ^ m3[01];   
assign  d[04] = m2[02] ^ m3[02] ^ m1[00];   
endmodule
`endif
