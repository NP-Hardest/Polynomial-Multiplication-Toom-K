module Break280(in, out1, out2, out3, out4);
    input [279:0] in
    output [69:0] out1, out2, out3, out4;

    assign out1 = a[279:209];
    assign out2 = a[209:139];
    assign out3 = a[139:69];
    assign out4 = a[69:0];


endmodule
