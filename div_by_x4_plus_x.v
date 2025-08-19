module div_by_x4_plus_x #(parameter N=64) (
    input  wire [N-1:0] p,
    output wire [N-1:0] q
);
    genvar i;
    generate
        for (i=0; i<N; i=i+1) begin : gen_div
            if (i > N-4) begin
                assign q[i] = p[i-1];
            end else if(i <= N-4 && i >= 1) begin
                assign q[i] = p[i-1] ^ q[i+3];
            end else begin
                assign q[i] = 0;   
            end
        end
    endgenerate
endmodule
