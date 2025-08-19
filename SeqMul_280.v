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


    reg [283:0] W0, W1, W2, W4, W5, W6; 
    reg [580:0] W0_ext, W1_ext, W2_ext, W3, W4_ext, W5_ext, W6_ext;


    reg [7:0]  state;

    reg [283:0] adder_1_in_1, adder_1_in_2, adder_1_in_3, adder_1_in_4, adder_1_in_5, adder_1_in_6;
    reg [283:0] adder_2_in_1, adder_2_in_2, adder_2_in_3, adder_2_in_4, adder_2_in_5, adder_2_in_6;
    wire [283:0] adder_1_out, adder_2_out;

    SixInputAdder #(284) adder5(
        .in1(adder_1_in_1),
        .in2(adder_1_in_2),
        .in3(adder_1_in_3),
        .in4(adder_1_in_4),
        .in5(adder_1_in_5),
        .in6(adder_1_in_6),
        .out(adder_1_out)
    );

    SixInputAdder #(284) adder4(
        .in1(adder_2_in_1),
        .in2(adder_2_in_2),
        .in3(adder_2_in_3),
        .in4(adder_2_in_4),
        .in5(adder_2_in_5),
        .in6(adder_2_in_6),
        .out(adder_2_out)
    );


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

    div_by_x4_plus_x #(581) div3 (
    .p(dividend_1),
    .q(quotient_1)
    );

    div_by_x4_plus_x2 #(581) div4(
    .p(dividend_2),
    .q(quotient_2)
    );

    reg [580:0] adder_3_in_1, adder_3_in_2, adder_3_in_3, adder_3_in_4, adder_3_in_5, adder_3_in_6;
    wire [580:0] adder_3_out;

    SixInputAdder #(581) adder3(
        .in1(adder_3_in_1),
        .in2(adder_3_in_2),
        .in3(adder_3_in_3),
        .in4(adder_3_in_4),
        .in5(adder_3_in_5),
        .in6(adder_3_in_6),
        .out(adder_3_out)
    );


    always @(posedge clk) begin
        $display(state);
        if(reset) begin
            state <= 0;
            done <= 0;
            seq70_reset_1 <= 1;
            seq70_reset_2 <= 1;
        end else begin
            case(state)
                0: begin
                    W0 <= 284'b0;
                    W1 <= 284'b0;
                    W2 <= 284'b0;
                    W3 <= 581'b0;
                    W4 <= 284'b0;
                    W5 <= 284'b0;
                    W6 <= 284'b0;
                    adder_1_in_1 <= 284'b0;
                    adder_1_in_2 <= 284'b0;
                    adder_1_in_3 <= 284'b0;
                    adder_1_in_4 <= 284'b0;
                    adder_1_in_5 <= 284'b0;
                    adder_1_in_6 <= 284'b0;
                    adder_2_in_1 <= 284'b0;
                    adder_2_in_2 <= 284'b0;
                    adder_2_in_3 <= 284'b0;
                    adder_2_in_4 <= 284'b0;
                    adder_2_in_5 <= 284'b0;
                    adder_2_in_6 <= 284'b0;

                    mult_1_in_1 <= 284'b0;
                    mult_1_in_2 <= 284'b0;
                    mult_2_in_1 <= 284'b0;
                    mult_2_in_2 <= 284'b0;
                    state <= 1;
                    seq70_reset_1 <= 1;
                    seq70_reset_2 <= 1;
                end
                1: begin
                    adder_1_in_1 <= {U0, 4'b0};
                    adder_1_in_2 <= {U1, 4'b0};
                    adder_1_in_3 <= {U2, 4'b0};
                    adder_1_in_4 <= {U3, 4'b0};
                    adder_1_in_5 <= 284'b0;
                    adder_2_in_1 <= {V0, 4'b0};
                    adder_2_in_2 <= {V1, 4'b0};
                    adder_2_in_3 <= {V2, 4'b0};
                    adder_2_in_4 <= {V3, 4'b0};
                    adder_2_in_5 <= 284'b0;
                    state <= 2;
                end

                2: begin

                    mult_1_in_1 <= adder_1_out;
                    mult_1_in_2 <= adder_2_out;
                    seq70_reset_1 <= 0;
                    W1 <= adder_1_out;
                    W2 <= adder_2_out;
                    state <= 3;
                end
                3: begin
                    if(seq70done_1) begin

                        // $display("%b", adder_2_out);
                        // $display("\n");
                        W3 <= mult_1_out_ext;
                        adder_1_in_1 <= {U1, 4'b0};
                        adder_1_in_2 <= {1'b0, U2, 3'b0};
                        adder_1_in_3 <= {2'b0, U3, 2'b0};
                        adder_1_in_4 <= 284'b0;
                        adder_1_in_5 <= 284'b0;
                        adder_2_in_1 <= {V1, 4'b0};
                        adder_2_in_2 <= {1'b0, V2, 3'b0};
                        adder_2_in_3 <= {2'b0, V3, 2'b0};
                        adder_2_in_4 <= 284'b0;
                        adder_2_in_5 <= 284'b0;
                        seq70_reset_1 <= 1;
                        state <= 4;
                    end
                    else begin
                        state <= 3;
                    end
                end


                4: begin
                    
                    W0 <= adder_1_out;
                    W6 <= adder_2_out;
                    adder_1_in_1 <= {adder_1_out>>1};
                    adder_1_in_2 <= {2'b0, U3, 2'b0};
                    adder_1_in_3 <= {1'b0, U3, 3'b0};
                    adder_1_in_4 <= {W1};
                    adder_1_in_5 <= 284'b0;
                    adder_2_in_1 <= {adder_2_out>>1};
                    adder_2_in_2 <= {1'b0, V3, 3'b0};
                    adder_2_in_3 <= {2'b0, V3, 2'b0};
                    adder_2_in_4 <= {W2};
                    adder_2_in_5 <= 284'b0;
                    state <= 5;
                end

                5: begin
                    W4 <= adder_1_out;
                    W5 <= adder_2_out;
                    adder_1_in_1 <= W0>>1;
                    adder_1_in_2 <= {U0, 4'b0};
                    adder_1_in_3 <= 284'b0;
                    adder_1_in_4 <= 284'b0;
                    adder_1_in_5 <= 284'b0;
                    adder_2_in_1 <= W6>>1;
                    adder_2_in_2 <= {V0, 4'b0};
                    adder_2_in_3 <= 284'b0;
                    adder_2_in_4 <= 284'b0;
                    adder_2_in_5 <= 284'b0;
                    state <= 6;
                end

                6: begin
                    W0 <= adder_1_out;
                    W6 <= adder_2_out;
                    mult_1_in_1 <= W5;
                    mult_1_in_2 <= W4;
                    mult_2_in_1 <= adder_1_out;
                    mult_2_in_2 <= adder_2_out;
                    seq70_reset_1 <= 0;
                    seq70_reset_2 <= 0;
                    state <= 7; 
                end
                7: begin
                    if(seq70done_1 && seq70done_2) begin
                        // $display("%b", mult_1_out_ext);
                        // $display("%b", mult_2_out_ext);

                        // $display("%b", adder_2_out);
                        // $display("%b", adder_1_out);
                        W5_ext <= mult_1_out_ext;
                        W4_ext <= mult_2_out_ext;
                        adder_1_in_1 <= {3'b0, U0, 1'b0};
                        adder_1_in_2 <= {2'b0, U1, 2'b0};
                        adder_1_in_3 <= {1'b0, U2, 3'b0};
                        adder_1_in_4 <= 284'b0;
                        adder_1_in_5 <= 284'b0;
                        adder_2_in_1 <= {3'b0, V0, 1'b0};
                        adder_2_in_2 <= {2'b0, V1, 2'b0};
                        adder_2_in_3 <= {1'b0, V2, 3'b0};
                        adder_2_in_4 <= 284'b0;
                        adder_2_in_5 <= 284'b0;
                        seq70_reset_1 <= 1;
                        seq70_reset_2 <= 1;
                        state <= 8;

                    end
                    else begin
                        state <= 7;
                    end

                end


                8: begin
                    W0 <= adder_1_out;
                    W6 <= adder_2_out;
                    adder_1_in_1 <= W1;
                    adder_1_in_2 <= adder_1_out;
                    adder_1_in_3 <= {2'b0, U0, 2'b0};
                    adder_1_in_4 <= {1'b0, U0, 3'b0};
                    adder_1_in_5 <= 284'b0;
                    adder_2_in_1 <= W2;
                    adder_2_in_2 <= adder_2_out;
                    adder_2_in_3 <= {2'b0, V0, 2'b0};
                    adder_2_in_4 <= {1'b0, V0, 3'b0};
                    adder_2_in_5 <= 284'b0;
                    state <= 9;
                end

                9 : begin

                    W1 <= adder_1_out;
                    W2 <= adder_2_out;
                    adder_1_in_1 <= W0;
                    adder_1_in_2 <= {U3, 4'b0};
                    adder_1_in_3 <= 284'b0;
                    adder_1_in_4 <= 284'b0;
                    adder_1_in_5 <= 284'b0;
                    adder_2_in_1 <= W6;
                    adder_2_in_2 <= {V3, 4'b0};   
                    adder_2_in_3 <= 284'b0;
                    adder_2_in_4 <= 284'b0;
                    adder_2_in_5 <= 284'b0;
                    state <= 10;
                end

                10: begin
                    W0 <= adder_1_out;
                    W6 <= adder_2_out;
                    mult_1_in_1 <= W1;
                    mult_1_in_2 <= W2;
                    mult_2_in_1 <= adder_1_out;
                    mult_2_in_2 <= adder_2_out;
                    seq70_reset_1 <= 0;
                    seq70_reset_2 <= 0;
                    state <= 11;
                end                            
                           
                11: begin
                    if(seq70done_1 && seq70done_2) begin
                        // $display("%b", mult_1_out_ext);
                        // $display("%b", mult_2_out_ext);
                        W1_ext <= mult_1_out_ext;
                        W2_ext <= mult_2_out_ext;
                        mult_1_in_1 <= {U3, 4'b0};
                        mult_1_in_2 <= {V3, 4'b0};
                        mult_2_in_1 <= {U0, 4'b0};
                        mult_2_in_2 <= {V0, 4'b0};
                        seq70_reset_1 <= 1;
                        seq70_reset_2 <= 1;
                        state <= 113;
                    end

                    else begin
                        state <= 11;
                    end

                end

                113: begin
                    seq70_reset_1 <= 0;
                    seq70_reset_2 <= 0;
                    state <=12;

                end

                 // #interpolation
                12: begin
                    if(seq70done_1 && seq70done_2) begin
                        W6_ext <= mult_1_out_ext;
                        W0_ext <= mult_2_out_ext;
                        adder_3_in_1 <= W1_ext;
                        adder_3_in_2 <= W2_ext;
                        adder_3_in_3 <= mult_2_out_ext;
                        adder_3_in_4 <= mult_2_out_ext>>2;
                        adder_3_in_5 <= mult_2_out_ext>>4;
                        adder_3_in_6 <= 581'b0;
                        seq70_reset_1 <= 1;
                        seq70_reset_2 <= 1;
                        state <= 13;
                    end
                    else begin
                        state <= 12;
                    end

                end
                13: begin /////////////////////////
                    W1_ext <= adder_3_out;
                    adder_3_in_1 <= W5_ext;
                    adder_3_in_2 <= W4_ext;
                    adder_3_in_3 <= W6_ext>>4;
                    adder_3_in_4 <= W6_ext>>2;
                    adder_3_in_5 <= W6_ext;
                    adder_3_in_6 <= adder_3_out;
                    state <= 14;
                end
                
                14: begin
                    // $display("%b", adder_3_out);
                    dividend_1 <= adder_3_out;
                    adder_3_in_1 <= W2_ext;
                    adder_3_in_2 <= W6_ext;
                    adder_3_in_3 <= W0_ext>>6;
                    adder_3_in_4 <= 581'b0;
                    adder_3_in_5 <= 581'b0;
                    adder_3_in_6 <= 581'b0;
                    state <= 15;
                end

                15: begin
                    W5_ext <= quotient_1;
                    W2_ext <= adder_3_out;
                    adder_3_in_1 <= W4_ext;
                    adder_3_in_2 <= adder_3_out;
                    adder_3_in_3 <= W6_ext>>6;
                    adder_3_in_4 <= W0_ext;
                    adder_3_in_5 <= quotient_1>>5; //W5_ext
                    adder_3_in_6 <= quotient_1>>1;
                    state <= 16;
                end

                16: begin
                    dividend_2 <= adder_3_out;
                    state <= 17;
                end

                17: begin //////////////////////
                    W4_ext <= quotient_2;
                    adder_3_in_1 <= W3;
                    adder_3_in_2 <= W0_ext;
                    adder_3_in_3 <= W6_ext;
                    adder_3_in_4 <= 581'b0;
                    adder_3_in_5 <= 581'b0;
                    adder_3_in_6 <= 581'b0;
                    state <= 18;
                end

                18: begin
                    W3 <= adder_3_out;
                    adder_3_in_1 <= W1_ext;
                    adder_3_in_2 <= adder_3_out;
                    adder_3_in_3 <= 581'b0;
                    adder_3_in_4 <= 581'b0;
                    adder_3_in_5 <= 581'b0;
                    adder_3_in_6 <= 581'b0;
                    state <= 19;
                end

                19: begin
                    W1_ext <= adder_3_out;
                    adder_3_in_1 <= W2_ext;
                    adder_3_in_2 <= adder_3_out>>1;
                    adder_3_in_3 <= W3>>2;
                    adder_3_in_4 <= 581'b0;
                    adder_3_in_5 <= 581'b0;
                    adder_3_in_6 <= 581'b0;
                    state <= 20;
                end

                20: begin
                    W2_ext <= adder_3_out;
                    adder_3_in_1 <= W3;
                    adder_3_in_2 <= W4_ext;
                    adder_3_in_3 <= W5_ext;
                    adder_3_in_4 <= 581'b0;
                    adder_3_in_5 <= 581'b0;
                    adder_3_in_6 <= 581'b0;
                    state <= 21;
                end

                21: begin
                    W3 <= adder_3_out;
                    adder_3_in_1 <= W1_ext;
                    adder_3_in_2 <= adder_3_out>>2;    
                    adder_3_in_3 <= adder_3_out>>1;    
                    state <= 22;
                end

                22: begin
                    dividend_1 <= adder_3_out;
                    state <= 23;
                end

                23: begin
                    W1_ext <= quotient_1;
                    adder_3_in_1 <= W5_ext;
                    adder_3_in_2 <= quotient_1;
                    adder_3_in_3 <= 581'b0;
                    adder_3_in_4 <= 581'b0;
                    adder_3_in_5 <= 581'b0;
                    adder_3_in_6 <= 581'b0;

                    state <= 24;
                end

                24: begin
                    W5_ext <= adder_3_out;
                    adder_3_in_1 <= W2_ext;
                    adder_3_in_2 <= adder_3_out>>2;    
                    adder_3_in_3 <= adder_3_out>>1;    
                    state <= 25;
                end

                25: begin
                    dividend_2 <= adder_3_out;
                    state <= 26;
                end

                26: begin
                    W2_ext <= quotient_2;
                    adder_3_in_1 <= W4_ext;
                    adder_3_in_2 <= quotient_2;
                    adder_3_in_3 <= 581'b0;
                    adder_3_in_4 <= 581'b0;
                    adder_3_in_5 <= 581'b0;      
                    adder_3_in_6 <= 581'b0;
                    state <= 27;
                end

                27: begin
                    // $display("W0 %b\n", W0_ext);
                    // $display("W1 %b\n", W1_ext);
                    // $display("W2 %b\n", W2_ext);
                    // $display("W3 %b\n", W3);
                    // $display("W4 %b\n", adder_3_out);
                    // $display("W5 %b\n", W5_ext);
                    // $display("W6 %b\n\n", W6_ext);
                    W4_ext <= adder_3_out;
                    final <= {W0_ext, 1659'b0} ^ {280'b0, W1_ext, 1379'b0} ^ {560'b0, W2_ext, 1099'b0} ^ {840'b0, W3, 819'b0} ^ {1120'b0, adder_3_out, 539'b0} ^ {1400'b0, W5_ext, 259'b0} ^ {1680'b0, W6_ext[580:21]} ;
                    state <= 28;
                end

                28: begin
                    done <= 1;
                    state <= 28;
                end

            endcase
        end
    end


endmodule

