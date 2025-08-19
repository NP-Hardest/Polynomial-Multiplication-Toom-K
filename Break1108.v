module Break1104(in, out1, out2, out3, out4);
    input [1107:0] in
    output [276:0] out1, out2, out3, out4;

    assign out1 = a[1107:830];
    assign out2 = a[830:553];
    assign out3 = a[553:276];
    assign out4 = a[276:0];


endmodule
