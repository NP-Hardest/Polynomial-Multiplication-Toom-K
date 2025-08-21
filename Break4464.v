module Break4464(in, out1, out2, out3, out4);
    input [4463:0] in;
    output [1115:0] out1, out2, out3, out4;

    assign out1 = in[4463:3348];
    assign out2 = in[3347:2232];
    assign out3 = in[2231:1116];
    assign out4 = in[1115:0];


endmodule
