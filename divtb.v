module tb_div_by_x4_plus_x;

    parameter N = 1120;

    reg clk;
    reg reset;
    reg [N-1:0] p;
    wire [N-1:0] q;
    wire done;

    div_by_x4_plus_x2 #(N) dut (
        .clk(clk),
        .rst(reset),
        .p(p),
        .q(q),
        .done(done)
    );

    // Clock generator: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Init
        reset = 1;
        p = 0;

        // Apply reset for a couple of cycles
        #20;
        reset = 0;

        // Example input polynomial
        p = {9'b000111100, 1111'b0};

        // Wait until done
        wait(done);

        // Display result
        $display("Input p = %b", p);
        $display("Output q = %b", q);

        // Finish simulation
        #20;
        $finish;
    end

endmodule
