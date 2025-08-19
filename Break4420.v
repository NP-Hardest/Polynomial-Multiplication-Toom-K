module Break4420(in, out1, out2, out3, out4);
    input [4419:0] in
    output [1104:0] out1, out2, out3, out4;

    assign out1 = a[4419:3314];
    assign out2 = a[3314:2209];
    assign out3 = a[2209:1104];
    assign out4 = a[1104:0];


endmodule
