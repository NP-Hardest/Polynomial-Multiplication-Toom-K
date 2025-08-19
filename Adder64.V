module adder64(in1, in2, out);
    input [63:0] in1, in2;
    output [64:0] out;

    assign out = in1 ^ in2;

endmodule