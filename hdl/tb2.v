`timescale 1ns/1ps


module gf2_schoolbook_mult #(parameter N = 256) (
    input  [0:N-1] a,
    input  [0:N-1] b,
    output reg [0:2*N-1] c
);
    integer i;
    reg [2*N-1:0] tmp;
    reg [2*N-1:0] res;

    always @(*) begin
        tmp = {a, {N{1'b0}}};
        res = {2*N{1'b0}};
        for (i = 0; i < N; i = i + 1) begin
            if (b[i]) begin
                res = res ^ (tmp >> i);
            end
        end
        c = res; // direct assignment, no extra shift
    end
endmodule

module tb_seqmul70;

    reg clk, reset;
    reg [70:0] U0, U1, U2, U3;
    reg [70:0] V0, V1, V2, V3;
    wire [567:0] W_seq;
    wire done;

    // Flatten inputs for schoolbook
    wire [283:0] A = {U0, U1, U2, U3};
    wire [283:0] B = {V0, V1, V2, V3};

    wire [567:0] W_schoolbook;

    // DUT
    SeqMul_70 dut (
        .clk(clk),
        .reset(reset),
        .U0(U0), .U1(U1), .U2(U2), .U3(U3),
        .V0(V0), .V1(V1), .V2(V2), .V3(V3),
        .W(W_seq),
        .done(done)
    );

    // Schoolbook multiplier
    gf2_schoolbook_mult #(284) sb (
        .a(A),
        .b(B),
        .c(W_schoolbook)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        U0 = 0; U1 = 0; U2 = 0; U3 = 0;
        V0 = 0; V1 = 0; V2 = 0; V3 = 0;

        #20 reset = 0;

        // Test 1: small numbers
        U0 = 71'h1; U1 = 71'h0; U2 = 71'h0; U3 = 71'h0;
        V0 = 71'h3; V1 = 71'h0; V2 = 71'h0; V3 = 71'h0;

        wait(done);
        #10;
        $display("Test 1 Result:");
        $display("SeqMul     = %b", W_seq);
        $display("Schoolbook = %b", W_schoolbook);
        if (W_seq == W_schoolbook) $display("PASS");
        else $display("FAIL");

        // Test 2: random
        reset = 1; #10 reset = 0;
        U0 = $random; U1 = $random; U2 = $random; U3 = $random;
        V0 = $random; V1 = $random; V2 = $random; V3 = $random;

        wait(done);
        #10;
        $display("Test 2 Result:");
        $display("SeqMul     = %b", W_seq);
        $display("Schoolbook = %b", W_schoolbook);
        if (W_seq == W_schoolbook) $display("PASS");
        else $display("FAIL");

        $finish;
    end

endmodule
