`include "ks75.v"

`include "SeqMul_1116.v"
`include "Break4464.v"

module SeqMul_4460(clk, reset, U0, U1, U2, U3, V0, V1, V2, V3, W, done);
    input clk, reset;
    input [4459:0] U0, U1, U2, U3;
    input [4459:0] V0, V1, V2, V3;
    output [35679:0] W;
    output reg done;

    reg [35679:0] final;

    assign W=final;


    reg [8940:0] W0, W1, W2, W3, W4, W5, W6;


    reg [7:0]  state;


    reg [4463:0] mult_1_in_1, mult_1_in_2;
    reg [4463:0] mult_2_in_1, mult_2_in_2;

    wire [1115:0] mult_1_in_1_a, mult_1_in_1_b, mult_1_in_1_c, mult_1_in_1_d;
    wire [1115:0] mult_1_in_2_a, mult_1_in_2_b, mult_1_in_2_c, mult_1_in_2_d;
    wire [1115:0] mult_2_in_1_a, mult_2_in_1_b, mult_2_in_1_c, mult_2_in_1_d;
    wire [1115:0] mult_2_in_2_a, mult_2_in_2_b, mult_2_in_2_c, mult_2_in_2_d;

    wire [8927:0] mult_1_out, mult_2_out;

    wire [8940:0] mult_1_out_ext = {mult_1_out, 13'b0};
    wire [8940:0] mult_2_out_ext = {mult_2_out, 13'b0};

    reg seq1116_reset_1;
    reg seq1116_reset_2;

    wire seq1116done_1;
    wire seq1116done_2;


    Break4464 dut1(mult_1_in_1, mult_1_in_1_a, mult_1_in_1_b, mult_1_in_1_c, mult_1_in_1_d);
    Break4464 dut2(mult_1_in_2, mult_1_in_2_a, mult_1_in_2_b, mult_1_in_2_c, mult_1_in_2_d);
    Break4464 dut3(mult_2_in_1, mult_2_in_1_a, mult_2_in_1_b, mult_2_in_1_c, mult_2_in_1_d);
    Break4464 dut4(mult_2_in_2, mult_2_in_2_a, mult_2_in_2_b, mult_2_in_2_c, mult_2_in_2_d);




    SeqMul_1116 mult_1(
        .clk(clk),
        .reset(seq1116_reset_1),
        .U0(mult_1_in_1_a), .U1(mult_1_in_1_b), .U2(mult_1_in_1_c), .U3(mult_1_in_1_d),
        .V0(mult_1_in_2_a), .V1(mult_1_in_2_b), .V2(mult_1_in_2_c), .V3(mult_1_in_2_d),
        .W(mult_1_out),
        .done(seq1116done_1)
    );

    SeqMul_1116 mult_2(
        .clk(clk),
        .reset(seq1116_reset_2),
        .U0(mult_2_in_1_a), .U1(mult_2_in_1_b), .U2(mult_2_in_1_c), .U3(mult_2_in_1_d),
        .V0(mult_2_in_2_a), .V1(mult_2_in_2_b), .V2(mult_2_in_2_c), .V3(mult_2_in_2_d),
        .W(mult_2_out),
        .done(seq1116done_2)
    );

    reg [8940:0] dividend_1, dividend_2;
    wire [8940:0] quotient_1, quotient_2;

    reg div_1_rst, div_2_rst;
    wire div_1_done, div_2_done;

    div_by_x4_plus_x #(8941) div1 (
    .clk(clk), 
    .rst(div_1_rst),
    .p(dividend_1),
    .q(quotient_1),
    .done(div_1_done)
    );

    div_by_x4_plus_x2 #(8941) div8 (
    .clk(clk), 
    .rst(div_2_rst),
    .p(dividend_2),
    .q(quotient_2),
    .done(div_2_done)
    );

    reg [8940:0] adder_in_1, adder_in_2, adder_in_3, adder_in_4, adder_in_5, adder_in_6;
    wire [8940:0] adder_out;

    SixInputAdder #(8941) adder3(
        .in1(adder_in_1),
        .in2(adder_in_2),
        .in3(adder_in_3),
        .in4(adder_in_4),
        .in5(adder_in_5),
        .in6(adder_in_6),
        .out(adder_out)
    );


    always @(posedge clk) begin
        if(reset) begin
            state <= 0;
            done <= 0;
            seq1116_reset_1 <= 1;
            seq1116_reset_2 <= 1;
        end else begin
            case(state)
                0: begin
                    W0 <= 8941'b0;
                    W1 <= 8941'b0;
                    W2 <= 8941'b0;
                    W3 <= 8941'b0;
                    W4 <= 8941'b0;
                    W5 <= 8941'b0;
                    W6 <= 8941'b0;

                    adder_in_1 <= 8941'b0;
                    adder_in_2 <= 8941'b0;
                    adder_in_3 <= 8941'b0;
                    adder_in_4 <= 8941'b0;
                    adder_in_5 <= 8941'b0;
                    adder_in_6 <= 8941'b0;

                    mult_1_in_1 <= 4464'b0;
                    mult_1_in_2 <= 4464'b0;
                    mult_2_in_1 <= 4464'b0;
                    mult_2_in_2 <= 4464'b0;
                    seq1116_reset_1 <= 1;
                    seq1116_reset_2 <= 1;
                    state <= 1;
                    $display(state);
                end
                1: begin
                    adder_in_1[8940:4477] <= {U0, 4'b0};
                    adder_in_2[8940:4477] <= {U1, 4'b0};
                    adder_in_3[8940:4477]<= {U2, 4'b0};
                    adder_in_4[8940:4477] <= {U3, 4'b0};
                    adder_in_1[4463:0] <= {V0, 4'b0};
                    adder_in_2[4463:0] <= {V1, 4'b0};
                    adder_in_3[4463:0] <= {V2, 4'b0};
                    adder_in_4[4463:0] <= {V3, 4'b0};
                    state <= 101;
                    $display(state);
                end

                101:begin
                    W1[8940:4477] <= adder_out[8940:4477];
                    W2[8940:4477] <= adder_out[4463:0];
                    state <= 2;
                    $display(state);
                
                end


                2: begin
                    mult_1_in_1 <= W1[8940:4477];
                    mult_1_in_2 <= W2[8940:4477];
                    seq1116_reset_1 <= 0;
                    state <= 3;
                    $display(state);
                end
                3: begin
                    if(seq1116done_1) begin
                        W3 <= mult_1_out_ext;
                        adder_in_1[8940:4477] <= {U1, 4'b0};
                        adder_in_2[8940:4477] <= {1'b0, U2, 3'b0};
                        adder_in_3[8940:4477] <= {2'b0, U3, 2'b0};
                        adder_in_4[8940:4477] <= 4464'b0;
                        adder_in_1[4463:0] <= {V1, 4'b0};
                        adder_in_2[4463:0] <= {1'b0, V2, 3'b0};
                        adder_in_3[4463:0] <= {2'b0, V3, 2'b0};
                        adder_in_4[4463:0] <= 4464'b0;
                        seq1116_reset_1 <= 1;
                        state <= 104;
                    $display(state);
                    end
                    else begin
                        state <= 3;
                    end
                end

                104: begin
                    W0[8940:4477] <= adder_out[8940:4477];
                    W6[8940:4477] <= adder_out[4463:0];
                    state <= 4;
                    $display(state);
                end
                4: begin
                    adder_in_1[8940:4477] <= {1'b0, W0[8940:4478]};
                    adder_in_2[8940:4477] <= {2'b0, U3, 2'b0};
                    adder_in_3[8940:4477] <= {1'b0, U3, 3'b0};
                    adder_in_4[8940:4477] <= W1[8940:4477];
                    adder_in_1[4463:0] <= {1'b0, W6[8940:4478]};
                    adder_in_2[4463:0] <= {1'b0, V3, 3'b0};
                    adder_in_3[4463:0] <= {2'b0, V3, 2'b0};
                    adder_in_4[4463:0] <= {W2[8940:4477]};
                    state <= 5;
                    $display(state);
                end

                5: begin
                    W4[8940:4477] <= adder_out[8940:4477];
                    W5[8940:4477] <= adder_out[4463:0];
                    adder_in_1[8940:4477] <= {1'b0, W0[8940:4478]};
                    adder_in_2[8940:4477] <= {U0, 4'b0};
                    adder_in_3[8940:4477] <= 4464'b0;
                    adder_in_4[8940:4477] <= 4464'b0;
                    adder_in_5[8940:4477] <= 4464'b0;
                    adder_in_1[4463:0] <= {1'b0, W6[8940:4478]};
                    adder_in_2[4463:0] <= {V0, 4'b0};
                    adder_in_3[4463:0] <= 4464'b0;
                    adder_in_4[4463:0] <= 4464'b0;
                    adder_in_5[4463:0] <= 4464'b0;
                    state <= 106;
                    $display(state);
                end
                106: begin
                    W0[8940:4477] <= adder_out[8940:4477];
                    W6[8940:4477] <= adder_out[4463:0];
                    state <= 6;
                    $display(state);

                end
                6: begin
                    mult_1_in_1 <= W5[8940:4477];
                    mult_1_in_2 <= W4[8940:4477];
                    mult_2_in_1 <= W0[8940:4477];
                    mult_2_in_2 <= W6[8940:4477];
                    seq1116_reset_1 <= 0;
                    seq1116_reset_2 <= 0;
                    state <= 7; 
                    $display(state);
                end
                7: begin
                    if(seq1116done_1 && seq1116done_2) begin
                        seq1116_reset_1 <= 1;
                        seq1116_reset_2 <= 1;
                        W5 <= mult_1_out_ext;
                        W4 <= mult_2_out_ext;
                        adder_in_1[8940:4477] <= {3'b0, U0, 1'b0};
                        adder_in_2[8940:4477] <= {2'b0, U1, 2'b0};
                        adder_in_3[8940:4477] <= {1'b0, U2, 3'b0};
                        adder_in_4[8940:4477] <= 4464'b0;
                        adder_in_5[8940:4477] <= 4464'b0;
                        adder_in_1[4463:0] <= {3'b0, V0, 1'b0};
                        adder_in_2[4463:0] <= {2'b0, V1, 2'b0};
                        adder_in_3[4463:0] <= {1'b0, V2, 3'b0};
                        adder_in_4[4463:0] <= 4464'b0;
                        adder_in_5[4463:0] <= 4464'b0;
                        state <= 108;
                    $display(state);
                    end
                    else begin
                        state <= 7;
                    end
                end

                108: begin
                    W0[8940:4477] <= adder_out[8940:4477];
                    W6[8940:4477] <= adder_out[4463:0];
                    state <= 8;
                    $display(state);
                end


                8: begin
                    adder_in_1[8940:4477] <= W1[8940:4477];
                    adder_in_2[8940:4477] <= W0[8940:4477];
                    adder_in_3[8940:4477] <= {2'b0, U0, 2'b0};
                    adder_in_4[8940:4477] <= {1'b0, U0, 3'b0};
                    adder_in_5[8940:4477] <= 4464'b0;
                    adder_in_1[4463:0] <= W2[8940:4477];
                    adder_in_2[4463:0] <= W6[8940:4477];
                    adder_in_3[4463:0] <= {2'b0, V0, 2'b0};
                    adder_in_4[4463:0] <= {1'b0, V0, 3'b0};
                    adder_in_5[4463:0] <= 4464'b0;
                    state <= 9;
                    $display(state);
                end

                9 : begin
                    W1[8940:4477] <= adder_out[8940:4477];
                    W2[8940:4477] <= adder_out[4463:0];
                    adder_in_1[8940:4477] <= {W0[8940:4477]};
                    adder_in_2[8940:4477] <= {U3, 4'b0};
                    adder_in_3[8940:4477] <= 4464'b0;
                    adder_in_4[8940:4477] <= 4464'b0;
                    adder_in_5[8940:4477] <= 4464'b0;
                    adder_in_1[4463:0] <= W6[8940:4477];
                    adder_in_2[4463:0] <= {V3, 4'b0};   
                    adder_in_3[4463:0] <= 4464'b0;
                    adder_in_4[4463:0] <= 4464'b0;
                    adder_in_5[4463:0] <= 4464'b0;
                    state <= 110;
                    $display(state);
                end

                110: begin
                    W0[8940:4477] <= adder_out[8940:4477];
                    W6[8940:4477] <= adder_out[4463:0];
                    state <= 10;
                    $display(state);

                end

                10: begin
                    mult_1_in_1 <= W1[8940:4477];
                    mult_1_in_2 <= W2[8940:4477];
                    mult_2_in_1 <= W0[8940:4477];
                    mult_2_in_2 <= W6[8940:4477];
                    seq1116_reset_1 <= 0;
                    seq1116_reset_2 <= 0;
                    state <= 11;
                end

                            
                           
                11: begin
                    if(seq1116done_1 && seq1116done_2) begin
                        seq1116_reset_1 <= 1;
                        seq1116_reset_2 <= 1;
                        W1 <= mult_1_out_ext;
                        W2 <= mult_2_out_ext;
                        mult_1_in_1 <= {U3, 4'b0};
                        mult_1_in_2 <= {V3, 4'b0};
                        mult_2_in_1 <= {U0, 4'b0};
                        mult_2_in_2 <= {V0, 4'b0};

                    $display(state);
                        state <= 32;
                    end
            
                    else begin
                        state <= 11;
                    end
                end

                32: begin 
                    seq1116_reset_1 <= 0;
                    seq1116_reset_2 <= 0;
                    state <= 72;
                    $display(state);
                end
                72: begin
                    if(seq1116done_1 && seq1116done_2) begin
                        seq1116_reset_1 <= 1;
                        seq1116_reset_2 <= 1;
                        W6 <= mult_1_out_ext;
                        W0 <= mult_2_out_ext;
                        state <= 12;
                    $display(state);
                    end
                    else begin
                        state <= 72;
                    end
                end
                 // #interpolation
                12: begin
                    adder_in_1 <= W1;
                    adder_in_2 <= W2;
                    adder_in_3 <= W0;
                    adder_in_4 <= {2'b0, W0[8940:2]};
                    adder_in_5 <= {4'b0, W0[8940:4]};
                    adder_in_6 <= 8941'b0;

                    state <= 73;
                    $display(state);
                end

                73: begin
                    W1 <= adder_out;
                    state <= 13;
                    $display(state);
                end

                13: begin /////////////////////////
                    adder_in_1 <= W5;
                    adder_in_2 <= W4;
                    adder_in_3 <= {4'b0, W6[8940:4]};
                    adder_in_4 <= {2'b0, W6[8940:2]};
                    adder_in_5 <= W6;
                    adder_in_6 <= W1;
                    state <= 14;
                    div_1_rst <= 1;
                    $display(state);
                end
                
                14: begin
                    // $display("%b", adder_out);
                    dividend_1 <= adder_out;
                    div_1_rst <= 0;
                    adder_in_1 <= W2;
                    adder_in_2 <= W6;
                    adder_in_3 <= {6'b0, W0[8940:6]};
                    adder_in_4 <= 8941'b0;
                    adder_in_5 <= 8941'b0;
                    adder_in_6 <= 8941'b0;
                    state <= 75;
                    $display(state);
                end

                75: begin
                    if(div_1_done) begin
                        W5 <= quotient_1;
                        W2 <= adder_out;
                    $display(state);
                        state <= 15;
                    end
                    else begin
                        state <= 75;
                    end
                
                end


                15: begin
                    adder_in_1 <= W4;
                    adder_in_2 <= W2;
                    adder_in_3 <= {6'b0, W6[8940:6]};
                    adder_in_4 <= W0;
                    adder_in_5 <= {5'b0, W5[8940:5]}; //W5
                    adder_in_6 <= {1'b0, W5[8940:1]};
                    div_2_rst <= 1;
                    state <= 16;
                    $display(state);
                end

                16: begin
                    dividend_2 <= adder_out;
                    div_2_rst <= 0;
                    state <= 17;
                    $display(state);
                end

                17: begin //////////////////////

                    if(div_2_done) begin
                        W4 <= quotient_2;
                        adder_in_1 <= W3;
                        adder_in_2 <= W0;
                        adder_in_3 <= W6;
                        adder_in_4 <= 8941'b0;
                        adder_in_5 <= 8941'b0;
                        adder_in_6 <= 8941'b0;
                        state <= 78;
                    $display(state);
                    end
                    
                    else begin
                        state <= 17;
                    end

                end

                78: begin
                    W3 <= adder_out;
                    state <= 18;
                    $display(state);
                end


                18: begin
                    adder_in_1 <= W1;
                    adder_in_2 <= W3;
                    adder_in_3 <= 8941'b0;
                    adder_in_4 <= 8941'b0;
                    adder_in_5 <= 8941'b0;
                    adder_in_6 <= 8941'b0;
                    state <= 79;
                    $display(state);
                end

                79: begin
                    W1 <= adder_out;
                    state <= 19;
                    $display(state);
                end

                19: begin
                    adder_in_1 <= W2;
                    adder_in_2 <= {1'b0, W1[8940:1]};
                    adder_in_3 <= {2'b0, W3[8940:2]};
                    adder_in_4 <= 8941'b0;
                    adder_in_5 <= 8941'b0;
                    adder_in_6 <= 8941'b0;
                    state <= 20;
                    $display(state);
                end

                20: begin
                    W2 <= adder_out;
                    adder_in_1 <= W3;
                    adder_in_2 <= W4;
                    adder_in_3 <= W5;
                    adder_in_4 <= 8941'b0;
                    adder_in_5 <= 8941'b0;
                    adder_in_6 <= 8941'b0;
                    state <= 81;
                    $display(state);
                end

                81: begin
                    W3 <= adder_out;
                    state <= 21;
                    $display(state);
                end

                21: begin
                    adder_in_1 <= W1;
                    adder_in_2 <= {2'b0, W3[8940:2]};    
                    adder_in_3 <= {1'b0, W3[8940:1]};    
                    div_1_rst <= 1;
                    state <= 22;
                    $display(state);
                end

                22: begin
                    dividend_1 <= adder_out;
                    div_1_rst <= 0;
                    state <= 83;
                    $display(state);
                end

                83: begin
                    if(div_1_done) begin
                        W1 <= quotient_1;
                        state <= 23;
                    $display(state);
                    end
                    else begin
                        state <=83;
                    end
                    
                end

                23: begin
                    adder_in_1 <= W5;
                    adder_in_2 <= W1;
                    adder_in_3 <= 8941'b0;
                    adder_in_4 <= 8941'b0;
                    adder_in_5 <= 8941'b0;
                    adder_in_6 <= 8941'b0;

                    $display(state);
                    state <= 84;
                end

                84: begin
                    W5 <= adder_out;
                    state <= 24;    
                    $display(state);
                end    

                24: begin
                    adder_in_1 <= W2;
                    adder_in_2 <= {2'b0, W5[8940:2]};    
                    adder_in_3 <= {1'b0, W5[8940:1]};    
                    div_2_rst <= 1;
                    $display(state);
                    state <= 25;
                end

                25: begin
                    dividend_2 <= adder_out;
                    div_2_rst <= 0;
                    state <= 86;
                    $display(state);
                end

                86: begin
                    if(div_2_done) begin
                        W2 <= quotient_2;
                        state <= 26;
                    $display(state);
                    end
                    else begin
                        state <=86;
                    end
                end

                26: begin
                    adder_in_1 <= W4;
                    adder_in_2 <= W2;
                    adder_in_3 <= 8941'b0;
                    adder_in_4 <= 8941'b0;
                    adder_in_5 <= 8941'b0;      
                    adder_in_6 <= 8941'b0;
                    state <= 27;
                    $display(state);
                end

                27: begin
                    W4 <= adder_out;
                    state <= 28;
                    $display(state);
                end

                28: begin
                    final <= {W0, 26739'b0} ^ {4460'b0, W1, 22279'b0} ^ {8920'b0, W2, 17819'b0} ^ {13380'b0, W3, 13359'b0} ^ {17840'b0, W4, 8899'b0} ^ {22300'b0, W5, 4439'b0} ^ {26760'b0, W6[8940:21]} ;
                    done <= 1;
                    state <= 28;
                    $display(state);
                end

            endcase
        end
    end


endmodule

