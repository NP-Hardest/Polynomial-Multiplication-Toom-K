module Break284(in, out1, out2, out3, out4);
    input [283:0] in;
    output [70:0] out1, out2, out3, out4;


    assign out1 = in[283:213];
    assign out2 = in[212:142];
    assign out3 = in[141:71];
    assign out4 = in[70:0];


endmodule
