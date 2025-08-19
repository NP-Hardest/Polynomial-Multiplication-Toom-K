module Break17672(in, out1, out2, out3, out4);
    input [17671:0] in
    output [4417:0] out1, out2, out3, out4;

    assign out1 = a[17671:13253];
    assign out2 = a[13253:8835];
    assign out3 = a[8835:4417];
    assign out4 = a[4417:0];


endmodule
