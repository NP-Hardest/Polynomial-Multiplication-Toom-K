module Break1120(in, out1, out2, out3, out4);
    input [1119:0] in;
    output [279:0] out1, out2, out3, out4;

    assign out1 = in[1119:840];
    assign out2 = in[839:560];
    assign out3 = in[559:280];
    assign out4 = in[279:0];


endmodule
