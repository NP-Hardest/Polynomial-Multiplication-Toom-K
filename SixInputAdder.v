module SixInputAdder #(parameter N=64)(in1, in2, in3, in4, in5, in6, out);
    input [N-1:0] in1, in2, in3, in4, in5, in6;
    output [N-1:0] out;

    assign out = in1 ^ in2 ^ in3 ^ in4 ^ in5 ^ in6;

endmodule