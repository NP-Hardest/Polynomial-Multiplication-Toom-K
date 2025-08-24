`timescale 1ns/1ps

module tb_divide_1;

    parameter N = 128;  // keep small for test (2 words = 64 bits)

    reg clk, rst;
    reg [N-1:0] in;
    wire [N-1:0] out;
    wire done;

    // DUT
    divide_2 #(.N(N)) dut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out),
        .done(done)
    );

    // clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 100 MHz clock

    initial begin
        // init
        rst = 1;
        in  = {32'h00000001, 32'h40000000,64'b0};  // example polynomial
        #20 rst = 0;                  // release reset

        // wait until done
        wait(done);

        // display results
        $display("Input  = %b", in);
        $display("Output = %b", out);

        #20 $finish;
    end

endmodule
