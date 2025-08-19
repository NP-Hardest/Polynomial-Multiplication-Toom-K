`timescale 1ns/1ps

// `include "SeqMul_64.v"

// a[0] is coeff of x^0 (LSB). b[0] is coeff of x^0.
// c[2*N-1:0], c[k] is coeff of x^k.
// Keeps the [0:N-1] indexing: a[0] is coeff of x^0 (leftmost in your textual form).
module gf2_schoolbook_mult #(parameter N = 256) (
    input  [0:N-1] a,
    input  [0:N-1] b,
    output reg [0:2*N-1] c
);
    integer i, j;
    reg [2*N-1:0] tmp;
    reg [2*N-1:0] res;

    always @(*) begin
        tmp = {a, 1120'b0};
        res = {2240'b0};
        for (i = 0; i < N; i = i + 1) begin
            if(b[i]) begin
                res = res ^ tmp>>i;
            end
        end
        c = res;                // direct assignment, no extra shift
    end
endmodule



module tb_SeqMul_64;
    reg clk, reset;
    reg [279:0] U0, U1, U2, U3;
    reg [279:0] V0, V1, V2, V3;
    wire [2239:0] W;
    wire done;

    // DUT
    SeqMul_280 dut(
        .clk(clk),
        .reset(reset),
        .U0(U0), .U1(U1), .U2(U2), .U3(U3),
        .V0(V0), .V1(V1), .V2(V2), .V3(V3),
        .W(W),
        .done(done)
    );

    // Reference (schoolbook)
    wire [1119:0] A = {U0,U1,U2,U3};
    wire [1119:0] B = {V0,V1,V2,V3};
    wire [2239:0] W_ref;

    gf2_schoolbook_mult #(1120) ref(
        .a(A),
        .b(B),
        .c(W_ref)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        U0 = 0; U1 = 0; U2 = 0; U3 = 0;
        V0 = 0; V1 = 0; V2 = 0; V3 = 0;

        #10 reset = 0;

        // Test 1: small numbers
        U0= 0; U1=0;
        U2 = 0; U3 = 280'd1;
        V0= 0; V1=0;
        V2 = 0; V3 = 280'd1;
        // U0 = {4'd5, 60'd0}; U1 = 64'h0; U2 = 64'h0; U3 = 64'h0;
        // V0 = {4'd13, 60'd328}; V1 = 64'h0; V2 = 64'h0; V3 = 64'h0;

        wait(done);
        #50;
        // $display("%b", W);
        $display("Test1: DUT=%b, \nREF=%b", W, W_ref);
        // $display("Xor = %b", W^W_ref);
        if(W === W_ref) $display("PASS");
        else $display("FAIL");

        // Test 2: random
        reset = 1; #10 reset = 0;
        U0 = $random; U1 = $random; U2 = $random; U3 = $random;
        V0 = $random; V1 = $random; V2 = $random; V3 = $random;

        wait(done);
        #20;
        $display("Test2: DUT=%h, REF=%h", W, W_ref);
        // $display("Xor = %b", W^W_ref);
        if(W === W_ref) $display("PASS");
        else $display("FAIL");

        // Test 3: all ones
        reset = 1; #10 reset = 0;
        U0 = 280'd842834; U1 = 280'd149214; U2 = 280'd813413; U3 = 280'd9945245;
        V0 = 280'd8814232; V1 = 280'd8842834; V2 = 280'd9148123; V3 = 280'd14283424;

        wait(done);
        #2;
        $display("Test3: DUT=%h, REF=%h", W, W_ref);
        // $display("Xor = %b", W^W_ref);
        if(W === W_ref) $display("PASS");
        else $display("FAIL");

        $finish;
    end
endmodule
