module Break17840(in, out1, out2, out3, out4);
    input [17839:0] in;
    output [4459:0] out1, out2, out3, out4;

    assign out1 = in[17839:13380];
    assign out2 = in[13379:8920];
    assign out3 = in[8919:4460];
    assign out4 = in[4459:0];


endmodule
