`include "ks75.v"
// `include "SixInputAdder.v"
// `include "div_by_x4_plus_x2.v"
// `include "div_by_x4_plus_x.v"
`include "SeqMul_70.v"

module SeqMul_280(clk, reset, U0, U1, U2, U3, V0, V1, V2, V3, W, done);
    input clk, reset;
    input [279:0] U0, U1, U2, U3;
    input [279:0] V0, V1, V2, V3;
    output [2239:0] W;
    output reg done;

    reg [2239:0] final;

    assign W=final;


    reg [580:0] W0, W1, W2, W3, W4, W5, W6;


    reg [7:0]  state;


    reg [283:0] mult_1_in_1, mult_1_in_2;
    reg [283:0] mult_2_in_1, mult_2_in_2;

    wire [567:0] mult_1_out, mult_2_out;

    wire [580:0] mult_1_out_ext = {mult_1_out, 13'b0};
    wire [580:0] mult_2_out_ext = {mult_2_out, 13'b0};

    reg seq70_reset_1;
    reg seq70_reset_2;

    wire seq70done_1;
    wire seq70done_2;



    SeqMul_70 mult_1(
        .clk(clk),
        .reset(seq70_reset_1),
        .U0(mult_1_in_1[283:213]), .U1(mult_1_in_1[212:142]), .U2(mult_1_in_1[141:71]), .U3(mult_1_in_1[70:0]),
        .V0(mult_1_in_2[283:213]), .V1(mult_1_in_2[212:142]), .V2(mult_1_in_2[141:71]), .V3(mult_1_in_2[70:0]),
        .W(mult_1_out),
        .done(seq70done_1)
    );

    SeqMul_70 mult_2(
        .clk(clk),
        .reset(seq70_reset_2),
        .U0(mult_2_in_1[283:213]), .U1(mult_2_in_1[212:142]), .U2(mult_2_in_1[141:71]), .U3(mult_2_in_1[70:0]),
        .V0(mult_2_in_2[283:213]), .V1(mult_2_in_2[212:142]), .V2(mult_2_in_2[141:71]), .V3(mult_2_in_2[70:0]),
        .W(mult_2_out),
        .done(seq70done_2)
    );

    reg [580:0] dividend_1, dividend_2;
    wire [580:0] quotient_1, quotient_2;

    reg div_1_rst, div_2_rst;
    wire div_1_done, div_2_done;

    div_by_x4_plus_x #(581) div1 (
    .clk(clk), 
    .rst(div_1_rst),
    .p(dividend_1),
    .q(quotient_1),
    .done(div_1_done)
    );

    div_by_x4_plus_x2 #(581) div8 (
    .clk(clk), 
    .rst(div_2_rst),
    .p(dividend_2),
    .q(quotient_2),
    .done(div_2_done)
    );

    reg [580:0] adder_in_1, adder_in_2, adder_in_3, adder_in_4, adder_in_5, adder_in_6;
    wire [580:0] adder_out;

    SixInputAdder #(581) adder3(
        .in1(adder_in_1),
        .in2(adder_in_2),
        .in3(adder_in_3),
        .in4(adder_in_4),
        .in5(adder_in_5),
        .in6(adder_in_6),
        .out(adder_out)
    );


    always @(posedge clk) begin
        // $display(state);
        if(reset) begin
            state <= 0;
            done <= 0;
            seq70_reset_1 <= 1;
            seq70_reset_2 <= 1;
        end else begin
            case(state)
                0: begin
                    W0 <= 581'b0;
                    W1 <= 581'b0;
                    W2 <= 581'b0;
                    W3 <= 581'b0;
                    W4 <= 581'b0;
                    W5 <= 581'b0;
                    W6 <= 581'b0;

                    adder_in_1 <= 581'b0;
                    adder_in_2 <= 581'b0;
                    adder_in_3 <= 581'b0;
                    adder_in_4 <= 581'b0;
                    adder_in_5 <= 581'b0;
                    adder_in_6 <= 581'b0;

                    mult_1_in_1 <= 284'b0;
                    mult_1_in_2 <= 284'b0;
                    mult_2_in_1 <= 284'b0;
                    mult_2_in_2 <= 284'b0;
                    seq70_reset_1 <= 1;
                    seq70_reset_2 <= 1;
                    state <= 1;
                end
                1: begin
                    adder_in_1[580:297] <= {U0, 4'b0};
                    adder_in_2[580:297] <= {U1, 4'b0};
                    adder_in_3[580:297]<= {U2, 4'b0};
                    adder_in_4[580:297] <= {U3, 4'b0};
                    adder_in_1[283:0] <= {V0, 4'b0};
                    adder_in_2[283:0] <= {V1, 4'b0};
                    adder_in_3[283:0] <= {V2, 4'b0};
                    adder_in_4[283:0] <= {V3, 4'b0};
                    state <= 101;
                end

                101:begin
                    W1[580:297] <= adder_out[580:297];
                    W2[580:297] <= adder_out[283:0];
                    state <= 2;
                
                end


                2: begin
                    mult_1_in_1 <= W1[580:297];
                    mult_1_in_2 <= W2[580:297];
                    seq70_reset_1 <= 0;
                    state <= 3;
                end
                3: begin
                    if(seq70done_1) begin
                        W3 <= mult_1_out_ext;
                        adder_in_1[580:297] <= {U1, 4'b0};
                        adder_in_2[580:297] <= {1'b0, U2, 3'b0};
                        adder_in_3[580:297] <= {2'b0, U3, 2'b0};
                        adder_in_4[580:297] <= 284'b0;
                        adder_in_1[283:0] <= {V1, 4'b0};
                        adder_in_2[283:0] <= {1'b0, V2, 3'b0};
                        adder_in_3[283:0] <= {2'b0, V3, 2'b0};
                        adder_in_4[283:0] <= 284'b0;
                        seq70_reset_1 <= 1;
                        state <= 104;
                    end
                    else begin
                        state <= 3;
                    end
                end

                104: begin
                    W0[580:297] <= adder_out[580:297];
                    W6[580:297] <= adder_out[283:0];
                    state <= 4;
                end
                4: begin
                    adder_in_1[580:297] <= {1'b0, W0[580:298]};
                    adder_in_2[580:297] <= {2'b0, U3, 2'b0};
                    adder_in_3[580:297] <= {1'b0, U3, 3'b0};
                    adder_in_4[580:297] <= W1[580:297];
                    adder_in_1[283:0] <= {1'b0, W6[580:298]};
                    adder_in_2[283:0] <= {1'b0, V3, 3'b0};
                    adder_in_3[283:0] <= {2'b0, V3, 2'b0};
                    adder_in_4[283:0] <= {W2[580:297]};
                    state <= 5;
                end

                5: begin
                    W4[580:297] <= adder_out[580:297];
                    W5[580:297] <= adder_out[283:0];
                    adder_in_1[580:297] <= {1'b0, W0[580:298]};
                    adder_in_2[580:297] <= {U0, 4'b0};
                    adder_in_3[580:297] <= 284'b0;
                    adder_in_4[580:297] <= 284'b0;
                    adder_in_5[580:297] <= 284'b0;
                    adder_in_1[283:0] <= {1'b0, W6[580:298]};
                    adder_in_2[283:0] <= {V0, 4'b0};
                    adder_in_3[283:0] <= 284'b0;
                    adder_in_4[283:0] <= 284'b0;
                    adder_in_5[283:0] <= 284'b0;
                    state <= 106;
                end
                106: begin
                    W0[580:297] <= adder_out[580:297];
                    W6[580:297] <= adder_out[283:0];
                    state <= 6;

                end
                6: begin
                    mult_1_in_1 <= W5[580:297];
                    mult_1_in_2 <= W4[580:297];
                    mult_2_in_1 <= W0[580:297];
                    mult_2_in_2 <= W6[580:297];
                    seq70_reset_1 <= 0;
                    seq70_reset_2 <= 0;
                    state <= 7; 
                end
                7: begin
                    if(seq70done_1 && seq70done_2) begin
                        seq70_reset_1 <= 1;
                        seq70_reset_2 <= 1;
                        W5 <= mult_1_out_ext;
                        W4 <= mult_2_out_ext;
                        adder_in_1[580:297] <= {3'b0, U0, 1'b0};
                        adder_in_2[580:297] <= {2'b0, U1, 2'b0};
                        adder_in_3[580:297] <= {1'b0, U2, 3'b0};
                        adder_in_4[580:297] <= 284'b0;
                        adder_in_5[580:297] <= 284'b0;
                        adder_in_1[283:0] <= {3'b0, V0, 1'b0};
                        adder_in_2[283:0] <= {2'b0, V1, 2'b0};
                        adder_in_3[283:0] <= {1'b0, V2, 3'b0};
                        adder_in_4[283:0] <= 284'b0;
                        adder_in_5[283:0] <= 284'b0;
                        state <= 108;
                    end
                    else begin
                        state <= 7;
                    end
                end

                108: begin
                    W0[580:297] <= adder_out[580:297];
                    W6[580:297] <= adder_out[283:0];
                    state <= 8;
                end


                8: begin
                    adder_in_1[580:297] <= W1[580:297];
                    adder_in_2[580:297] <= W0[580:297];
                    adder_in_3[580:297] <= {2'b0, U0, 2'b0};
                    adder_in_4[580:297] <= {1'b0, U0, 3'b0};
                    adder_in_5[580:297] <= 284'b0;
                    adder_in_1[283:0] <= W2[580:297];
                    adder_in_2[283:0] <= W6[580:297];
                    adder_in_3[283:0] <= {2'b0, V0, 2'b0};
                    adder_in_4[283:0] <= {1'b0, V0, 3'b0};
                    adder_in_5[283:0] <= 284'b0;
                    state <= 9;
                end

                9 : begin
                    W1[580:297] <= adder_out[580:297];
                    W2[580:297] <= adder_out[283:0];
                    adder_in_1[580:297] <= {W0[580:297]};
                    adder_in_2[580:297] <= {U3, 4'b0};
                    adder_in_3[580:297] <= 284'b0;
                    adder_in_4[580:297] <= 284'b0;
                    adder_in_5[580:297] <= 284'b0;
                    adder_in_1[283:0] <= W6[580:297];
                    adder_in_2[283:0] <= {V3, 4'b0};   
                    adder_in_3[283:0] <= 284'b0;
                    adder_in_4[283:0] <= 284'b0;
                    adder_in_5[283:0] <= 284'b0;
                    state <= 110;
                end

                110: begin
                    W0[580:297] <= adder_out[580:297];
                    W6[580:297] <= adder_out[283:0];
                    state <= 10;

                end

                10: begin
                    mult_1_in_1 <= W1[580:297];
                    mult_1_in_2 <= W2[580:297];
                    mult_2_in_1 <= W0[580:297];
                    mult_2_in_2 <= W6[580:297];
                    seq70_reset_1 <= 0;
                    seq70_reset_2 <= 0;
                    state <= 11;
                end

                            
                           
                11: begin
                    if(seq70done_1 && seq70done_2) begin
                        seq70_reset_1 <= 1;
                        seq70_reset_2 <= 1;
                        W1 <= mult_1_out_ext;
                        W2 <= mult_2_out_ext;
                        mult_1_in_1 <= {U3, 4'b0};
                        mult_1_in_2 <= {V3, 4'b0};
                        mult_2_in_1 <= {U0, 4'b0};
                        mult_2_in_2 <= {V0, 4'b0};

                        state <= 32;
                    end
            
                    else begin
                        state <= 11;
                    end
                end

                32: begin 
                    seq70_reset_1 <= 0;
                    seq70_reset_2 <= 0;
                    state <= 72;
                end
                72: begin
                    if(seq70done_1 && seq70done_2) begin
                        seq70_reset_1 <= 1;
                        seq70_reset_2 <= 1;
                        W6 <= mult_1_out_ext;
                        W0 <= mult_2_out_ext;
                        state <= 12;
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
                    adder_in_4 <= {2'b0, W0[580:2]};
                    adder_in_5 <= {4'b0, W0[580:4]};
                    adder_in_6 <= 581'b0;

                    state <= 73;
                end

                73: begin
                    W1 <= adder_out;
                    state <= 13;
                end

                13: begin /////////////////////////
                    adder_in_1 <= W5;
                    adder_in_2 <= W4;
                    adder_in_3 <= {4'b0, W6[580:4]};
                    adder_in_4 <= {2'b0, W6[580:2]};
                    adder_in_5 <= W6;
                    adder_in_6 <= W1;
                    state <= 14;
                    div_1_rst <= 1;
                end
                
                14: begin
                    // $display("%b", adder_out);
                    dividend_1 <= adder_out;
                    div_1_rst <= 0;
                    adder_in_1 <= W2;
                    adder_in_2 <= W6;
                    adder_in_3 <= {6'b0, W0[580:6]};
                    adder_in_4 <= 581'b0;
                    adder_in_5 <= 581'b0;
                    adder_in_6 <= 581'b0;
                    state <= 75;
                end

                75: begin
                    if(div_1_done) begin
                        W5 <= quotient_1;
                        W2 <= adder_out;
                        state <= 15;
                    end
                    else begin
                        state <= 75;
                    end
                
                end


                15: begin
                    adder_in_1 <= W4;
                    adder_in_2 <= W2;
                    adder_in_3 <= {6'b0, W6[580:6]};
                    adder_in_4 <= W0;
                    adder_in_5 <= {5'b0, W5[580:5]}; //W5
                    adder_in_6 <= {1'b0, W5[580:1]};
                    div_2_rst <= 1;
                    state <= 16;
                end

                16: begin
                    dividend_2 <= adder_out;
                    div_2_rst <= 0;
                    state <= 17;
                end

                17: begin //////////////////////

                    if(div_2_done) begin
                        W4 <= quotient_2;
                        adder_in_1 <= W3;
                        adder_in_2 <= W0;
                        adder_in_3 <= W6;
                        adder_in_4 <= 581'b0;
                        adder_in_5 <= 581'b0;
                        adder_in_6 <= 581'b0;
                        state <= 78;
                    end
                    
                    else begin
                        state <= 17;
                    end

                end

                78: begin
                    W3 <= adder_out;
                    state <= 18;
                end


                18: begin
                    adder_in_1 <= W1;
                    adder_in_2 <= W3;
                    adder_in_3 <= 581'b0;
                    adder_in_4 <= 581'b0;
                    adder_in_5 <= 581'b0;
                    adder_in_6 <= 581'b0;
                    state <= 79;
                end

                79: begin
                    W1 <= adder_out;
                    state <= 19;
                end

                19: begin
                    adder_in_1 <= W2;
                    adder_in_2 <= {1'b0, W1[580:1]};
                    adder_in_3 <= {2'b0, W3[580:2]};
                    adder_in_4 <= 581'b0;
                    adder_in_5 <= 581'b0;
                    adder_in_6 <= 581'b0;
                    state <= 20;
                end

                20: begin
                    W2 <= adder_out;
                    adder_in_1 <= W3;
                    adder_in_2 <= W4;
                    adder_in_3 <= W5;
                    adder_in_4 <= 581'b0;
                    adder_in_5 <= 581'b0;
                    adder_in_6 <= 581'b0;
                    state <= 81;
                end

                81: begin
                    W3 <= adder_out;
                    state <= 21;
                end

                21: begin
                    adder_in_1 <= W1;
                    adder_in_2 <= {2'b0, W3[580:2]};    
                    adder_in_3 <= {1'b0, W3[580:1]};    
                    div_1_rst <= 1;
                    state <= 22;
                end

                22: begin
                    dividend_1 <= adder_out;
                    div_1_rst <= 0;
                    state <= 83;
                end

                83: begin
                    if(div_1_done) begin
                        W1 <= quotient_1;
                        state <= 23;
                    end
                    else begin
                        state <=83;
                    end
                    
                end

                23: begin
                    adder_in_1 <= W5;
                    adder_in_2 <= W1;
                    adder_in_3 <= 581'b0;
                    adder_in_4 <= 581'b0;
                    adder_in_5 <= 581'b0;
                    adder_in_6 <= 581'b0;

                    state <= 84;
                end

                84: begin
                    W5 <= adder_out;
                    state <= 24;    
                end    

                24: begin
                    adder_in_1 <= W2;
                    adder_in_2 <= {2'b0, W5[580:2]};    
                    adder_in_3 <= {1'b0, W5[580:1]};    
                    div_2_rst <= 1;
                    state <= 25;
                end

                25: begin
                    dividend_2 <= adder_out;
                    div_2_rst <= 0;
                    state <= 86;
                end

                86: begin
                    if(div_2_done) begin
                        W2 <= quotient_2;
                        state <= 26;
                    end
                    else begin
                        state <=86;
                    end
                end

                26: begin
                    adder_in_1 <= W4;
                    adder_in_2 <= W2;
                    adder_in_3 <= 581'b0;
                    adder_in_4 <= 581'b0;
                    adder_in_5 <= 581'b0;      
                    adder_in_6 <= 581'b0;
                    state <= 27;
                end

                27: begin
                    W4 <= adder_out;
                    state <= 28;
                end

                28: begin
                    final <= {W0, 1659'b0} ^ {280'b0, W1, 1379'b0} ^ {560'b0, W2, 1099'b0} ^ {840'b0, W3, 819'b0} ^ {1120'b0, W4, 539'b0} ^ {1400'b0, W5, 259'b0} ^ {1680'b0, W6[580:21]} ;
                    done <= 1;
                    state <= 28;
                end

            endcase
        end
    end


endmodule

