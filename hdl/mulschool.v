module gf2_schoolbook_mult #(parameter N = 256) (
    input  [0:N-1] a,
    input  [0:N-1] b,
    output [0:2*N-1] c
);

    integer i, j;
    reg [0:2*N-2] result;

    always @(*) begin
        result = 0;
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                result[i+j] = result[i+j] ^ (a[i] & b[j]);
            end
        end
    end

    assign c = {result, 1'b0};

endmodule
