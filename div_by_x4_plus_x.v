module div_by_x4_plus_x #(parameter N=4460) (
    input clk, rst,
    input  wire [N-1:0] p,
    output reg [N-1:0] q,
    output reg done
);

    reg [15:0] count;
    reg [15:0] cycles;

    always @(posedge clk) begin
        if(done) begin
            done <= 0;
        end

        // $display(count);
        if(rst) begin
            count <= 0;
            done <= 0;
            q<=0;
            cycles <= 0;

        end
        else begin
            if(count >= N) begin
                count <= count;
                q <= q<<1;
                done <= 1;
                // $display("Total cycles in division: %d", cycles);

            end
            else begin
                q <= q ^ (p>>count);
                count <= count + 3;
                cycles <= cycles + 1;
            end

        end


    end

endmodule