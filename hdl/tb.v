`timescale 1ns/1ps

// Reference GF(2) schoolbook multiplier
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


// Testbench
module tb_SeqMul_64;
    reg clk, reset;
    reg [17668:0] U;
    reg [17668:0] V;
    wire [35337:0] W;
    
    // reg [17839:0] U;
    // reg [17839:0] V;
    // wire [35679:0] W;

    // reg [4463:0] U;
    // reg [4463:0] V;
    // wire [8927:0] W;


    wire done;

    integer cycle_count;

    // DUT
    // SeqMul_1116 dut(
    //     .clk(clk),
    //     .reset(reset),
    //     .U0(U[4463:3348]), .U1(U[3347:2232]), .U2(U[2231:1116]), .U3(U[1115:0]),
    //     .V0(V[4463:3348]), .V1(V[3347:2232]), .V2(V[2231:1116]), .V3(V[1115:0]),
    //     .W(W),
    //     .done(done)
    // );
    // SeqMul_4460 dut(
    //     .clk(clk),
    //     .reset(reset),
    //     .U0(U[17839:13380]), .U1(U[13379:8920]), .U2(U[8919:4460]), .U3(U[4459:0]),
    //     .V0(V[17839:13380]), .V1(V[13379:8920]), .V2(V[8919:4460]), .V3(V[4459:0]),
    //     .W(W),
    //     .done(done)
    // );

    CompleteMultiplier dut(clk, reset, U, V, W, done);

    // Reference (schoolbook)
    wire [17668:0] A = U;
    wire [17668:0] B = V;
    wire [35337:0] W_ref;

    // wire [17839:0] A = U;
    // wire [17839:0] B = V;
    // wire [35679:0] W_ref;

    // wire [4463:0] A = U;
    // wire [4463:0] B = V;
    // wire [8927:0] W_ref;

    gf2_schoolbook_mult #(17669) ref(
        .a(A),
        .b(B),
        .c(W_ref)
    );

    // Clock
    always #5 clk = ~clk;

    // Cycle counter
    always @(posedge clk) begin
        if (reset) begin
            cycle_count <= 0;
        end else if (!done) begin
            cycle_count <= cycle_count + 1;
        end
    end

    initial begin
        clk = 0;
        reset = 1;
        // U0 = 0; U1 = 0; U2 = 0; U3 = 0;
        // V0 = 0; V1 = 0; V2 = 0; V3 = 0;

        #10 reset = 0;

        // ==============================
        // Test 1: small numbers
        // ==============================
        reset = 1; #10 reset = 0;
        cycle_count = 0;

        // U0=0; U1=0; U2=0; U3=4460'd1;
        // V0=0; V1=0; V2=0; V3=4460'd1;

        // U = {3'b101, 17666'd7827828728728};
        // V = {3'b110, 17666'd7827872878728};

        U = 4892378128957813477589134;
        V = 2398457699321345184592348;
        // U = 17669'd8492384982347;
        // U = 17669'd2394938349583;
        // U = 4464'd8492384982347;
        // U = 4464'd2394938349583;
        wait(done);
        $display("Test1: DUT=%b, REF=%b", W, W_ref);
        $display("Test1 took %0d cycles", cycle_count);
        if (W === W_ref) $display("PASS");
        else $display("FAIL");

        // ==============================
        // Test 2: random
        // ==============================
        // reset = 1; #30 reset = 0;
        // cycle_count = 0;

        // U0 = 4460'd84223452834; U1 = 4460'd149234563414; U2 = 4460'd8134325213; U3 = 4460'd9945245;
        // V0 = 4460'd134513814232; V1 = 4460'd457378842834; V2 = 4460'd975347148123; V3 = 4460'd745714283424;

        // wait(done);
        // // $display("Test2: DUT=%b, REF=%b", W, W_ref);
        // $display("Test2 took %0d cycles", cycle_count);
        // if (W === W_ref) $display("PASS");
        // else $display("FAIL");

        // // ==============================
        // // Test 3: fixed numbers
        // // ==============================
        // reset = 1; #30 reset = 0;
        // cycle_count = 0;

        // // U0 = 4460'd842834; U1 = 4460'd149214; U2 = 4460'd813413; U3 = 4460'd9945245;
        // // V0 = 4460'd8814232; V1 = 4460'd8842834; V2 = 4460'd9148123; V3 = 4460'd14283424;

        // wait(done);
        // // $display("Test3: DUT=%h, REF=%h", W, W_ref);
        // $display("Test3 took %0d cycles", cycle_count);
        // if (W === W_ref) $display("PASS");
        // else $display("FAIL");

        $finish;
    end
endmodule
