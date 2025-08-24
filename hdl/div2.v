module divide_2 #(parameter N = 4460)(
    input clk, rst,
    input [N-1:0] in,   
    output reg  [N-1:0] out,   
    output reg done
);

    reg [31:0] t;
    reg [15:0] i;
    reg running;

    reg [N-1:0] store_in;
    reg [N-1:0] store_out;

    wire [31:0] temp1, temp2, temp3, temp4, temp5;

    assign temp1 = t ^ store_in[N-1:N-32];
    assign temp2 = temp1 ^ (temp1 >> 2);
    assign temp3 = temp2 ^ (temp2 >> 4);
    assign temp4 = temp3 ^ (temp3 >> 8);
    assign temp5 = temp4 ^ (temp4 >> 16);


    always @(posedge clk) begin
        if (rst) begin
            t <= 32'b0;
            i <= 15'd0;
            done <= 0;
            running <= 0;              
            store_in <= {N{1'b0}};     
            out <= {N{1'b0}}; 
        end 
        else if (!running) begin
            store_in <= in;           
            running <= 1;             
        end
        else if (i == N) begin
            out <= out << 2;
            done <= 1;    
            i <= i + 32;
        end
        else if (i > N) begin
            i <= i;
        end
        else begin
            t <= (temp5 << 30);
            i <= i + 32;
            store_in <= store_in << 32;
            out <= {out[N-33:0], temp5};
        end
    end


endmodule
