module SeqMul_70(clk, reset, U0, U1, U2, U3, V0, V1, V2, V3, W, done);
    input clk, reset;
    input [70:0] U0, U1, U2, U3;
    input [70:0] V0, V1, V2, V3;
    output [567:0] W;
    output reg done;

    reg [567:0] final;

    assign W=final;


    reg [161:0] W0, W1, W2, W3, W4, W5, W6;


    reg [5:0]  state;

    reg [74:0] mult_1_in_1, mult_1_in_2;

    wire [148:0] mult_1_out;

    wire [161:0] mult_1_out_ext = {mult_1_out, 13'b0};


    ks75 mult_1(
        .a(mult_1_in_1),
        .b(mult_1_in_2),
        .d(mult_1_out)
    );


    reg [161:0] dividend_1, dividend_2;
    wire [191:0] quotient_1, quotient_2;

    reg div_1_rst, div_2_rst;
    wire div_1_done, div_2_done;

    // div_by_x4_plus_x #(162) div1 (
    // .clk(clk), 
    // .rst(div_1_rst),
    // .p(dividend_1),
    // .q(quotient_1),
    // .done(div_1_done)
    // );
    divide_1 #(192) div1 (
    .clk(clk), 
    .rst(div_1_rst),
    .in({dividend_1, 30'b0}),
    .out(quotient_1),
    .done(div_1_done)
    );

    divide_2 #(192) div2 (
    .clk(clk), 
    .rst(div_2_rst),
    .in({dividend_2, 30'b0}),
    .out(quotient_2),
    .done(div_2_done)
    );

    // div_by_x4_plus_x2 #(162) div8 (
    // .clk(clk), 
    // .rst(div_2_rst),
    // .p(dividend_2),
    // .q(quotient_2),
    // .done(div_2_done)
    // );

    reg [161:0] adder_in_1, adder_in_2, adder_in_3, adder_in_4, adder_in_5, adder_in_6;
    wire [161:0] adder_out;

    SixInputAdder #(162) adder3(
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
        end else begin
            case(state)
                0: begin
                    W0 <= 162'b0;
                    W1 <= 162'b0;
                    W2 <= 162'b0;
                    W3 <= 162'b0;
                    W4 <= 162'b0;
                    W5 <= 162'b0;
                    W6 <= 162'b0;

                    adder_in_1 <= 162'b0;
                    adder_in_2 <= 162'b0;
                    adder_in_3 <= 162'b0;
                    adder_in_4 <= 162'b0;
                    adder_in_5 <= 162'b0;
                    adder_in_6 <= 162'b0;

                    mult_1_in_1 <= 75'b0;
                    mult_1_in_2 <= 75'b0;
                    state <= 1;
                end
                1: begin
                    adder_in_1[161:87] <= {U0, 4'b0};
                    adder_in_2[161:87] <= {U1, 4'b0};
                    adder_in_3[161:87]<= {U2, 4'b0};
                    adder_in_4[161:87] <= {U3, 4'b0};
                    adder_in_1[74:0] <= {V0, 4'b0};
                    adder_in_2[74:0] <= {V1, 4'b0};
                    adder_in_3[74:0] <= {V2, 4'b0};
                    adder_in_4[74:0] <= {V3, 4'b0};
                    state <= 2;
                end

                2:begin
                    W1[161:87] <= adder_out[161:87];
                    W2[161:87] <= adder_out[74:0];
                    state <= 3;
                
                end


                3: begin
                    mult_1_in_1 <= W1[161:87];
                    mult_1_in_2 <= W2[161:87];
                    state <= 4;
                end
                4: begin
                    W3 <= mult_1_out_ext;
                    adder_in_1[161:87] <= {U1, 4'b0};
                    adder_in_2[161:87] <= {1'b0, U2, 3'b0};
                    adder_in_3[161:87] <= {2'b0, U3, 2'b0};
                    adder_in_4[161:87] <= 75'b0;
                    adder_in_1[74:0] <= {V1, 4'b0};
                    adder_in_2[74:0] <= {1'b0, V2, 3'b0};
                    adder_in_3[74:0] <= {2'b0, V3, 2'b0};
                    adder_in_4[74:0] <= 75'b0;
                    state <= 5;
                end

                5: begin
                    W0[161:87] <= adder_out[161:87];
                    W6[161:87] <= adder_out[74:0];
                    state <= 6;
                end
                6: begin
                    adder_in_1[161:87] <= {1'b0, W0[161:88]};
                    adder_in_2[161:87] <= {2'b0, U3, 2'b0};
                    adder_in_3[161:87] <= {1'b0, U3, 3'b0};
                    adder_in_4[161:87] <= W1[161:87];
                    adder_in_1[74:0] <= {1'b0, W6[161:88]};
                    adder_in_2[74:0] <= {1'b0, V3, 3'b0};
                    adder_in_3[74:0] <= {2'b0, V3, 2'b0};
                    adder_in_4[74:0] <= {W2[161:87]};
                    state <= 7;
                end

                7: begin
                    W4[161:87] <= adder_out[161:87];
                    W5[161:87] <= adder_out[74:0];
                    adder_in_1[161:87] <= {1'b0, W0[161:88]};
                    adder_in_2[161:87] <= {U0, 4'b0};
                    adder_in_3[161:87] <= 75'b0;
                    adder_in_4[161:87] <= 75'b0;
                    adder_in_5[161:87] <= 75'b0;
                    adder_in_1[74:0] <= {1'b0, W6[161:88]};
                    adder_in_2[74:0] <= {V0, 4'b0};
                    adder_in_3[74:0] <= 75'b0;
                    adder_in_4[74:0] <= 75'b0;
                    adder_in_5[74:0] <= 75'b0;
                    state <= 8;
                end
                8: begin
                    W0[161:87] <= adder_out[161:87];
                    W6[161:87] <= adder_out[74:0];
                    state <= 9;

                end
                9: begin
                    mult_1_in_1 <= W5[161:87];
                    mult_1_in_2 <= W4[161:87];
                    state <= 10; 
                end

                10: begin
                    W5 <= mult_1_out_ext;
                    mult_1_in_1 <= W0[161:87];
                    mult_1_in_2 <= W6[161:87];
                    state <= 11;

                end
                11: begin
                    // W5 <= mult_1_out_ext;
                    W4 <= mult_1_out_ext;
                    adder_in_1[161:87] <= {3'b0, U0, 1'b0};
                    adder_in_2[161:87] <= {2'b0, U1, 2'b0};
                    adder_in_3[161:87] <= {1'b0, U2, 3'b0};
                    adder_in_4[161:87] <= 75'b0;
                    adder_in_5[161:87] <= 75'b0;
                    adder_in_1[74:0] <= {3'b0, V0, 1'b0};
                    adder_in_2[74:0] <= {2'b0, V1, 2'b0};
                    adder_in_3[74:0] <= {1'b0, V2, 3'b0};
                    adder_in_4[74:0] <= 75'b0;
                    adder_in_5[74:0] <= 75'b0;
                    state <= 12;
                end

                12: begin
                    W0[161:87] <= adder_out[161:87];
                    W6[161:87] <= adder_out[74:0];
                    state <= 13;
                end


                13: begin
                    adder_in_1[161:87] <= W1[161:87];
                    adder_in_2[161:87] <= W0[161:87];
                    adder_in_3[161:87] <= {2'b0, U0, 2'b0};
                    adder_in_4[161:87] <= {1'b0, U0, 3'b0};
                    adder_in_5[161:87] <= 75'b0;
                    adder_in_1[74:0] <= W2[161:87];
                    adder_in_2[74:0] <= W6[161:87];
                    adder_in_3[74:0] <= {2'b0, V0, 2'b0};
                    adder_in_4[74:0] <= {1'b0, V0, 3'b0};
                    adder_in_5[74:0] <= 75'b0;
                    state <= 14;
                end

                14 : begin
                    W1[161:87] <= adder_out[161:87];
                    W2[161:87] <= adder_out[74:0];
                    adder_in_1[161:87] <= {W0[161:87]};
                    adder_in_2[161:87] <= {U3, 4'b0};
                    adder_in_3[161:87] <= 75'b0;
                    adder_in_4[161:87] <= 75'b0;
                    adder_in_5[161:87] <= 75'b0;
                    adder_in_1[74:0] <= W6[161:87];
                    adder_in_2[74:0] <= {V3, 4'b0};   
                    adder_in_3[74:0] <= 75'b0;
                    adder_in_4[74:0] <= 75'b0;
                    adder_in_5[74:0] <= 75'b0;
                    state <= 15;
                end

                15: begin
                    W0[161:87] <= adder_out[161:87];
                    W6[161:87] <= adder_out[74:0];
                    state <= 16;

                end

                16: begin
                    mult_1_in_1 <= W1[161:87];
                    mult_1_in_2 <= W2[161:87];
                    state <= 17;
                end

                17: begin
                    W1 <= mult_1_out_ext;
                    mult_1_in_1 <= W0[161:87];
                    mult_1_in_2 <= W6[161:87];
                    state <= 18;
                end

                18: begin

                    W2 <= mult_1_out_ext;
                    mult_1_in_1 <= {U3, 4'b0};
                    mult_1_in_2 <= {V3, 4'b0};

                    state <= 19;
                end
                19: begin
                    W6 <= mult_1_out_ext;
                    mult_1_in_1 <= {U0, 4'b0};
                    mult_1_in_2 <= {V0, 4'b0};
                    state <= 20;
                end


                20: begin
                    W0 <= mult_1_out_ext;
                    state <= 21;
                end
                 // #interpolation
                21: begin
                    adder_in_1 <= W1;
                    adder_in_2 <= W2;
                    adder_in_3 <= W0;
                    adder_in_4 <= {2'b0, W0[161:2]};
                    adder_in_5 <= {4'b0, W0[161:4]};
                    adder_in_6 <= 162'b0;

                    state <= 22;
                end

                22: begin
                    W1 <= adder_out;
                    state <= 23;
                end

                23: begin /////////////////////////
                    adder_in_1 <= W5;
                    adder_in_2 <= W4;
                    adder_in_3 <= {4'b0, W6[161:4]};
                    adder_in_4 <= {2'b0, W6[161:2]};
                    adder_in_5 <= W6;
                    adder_in_6 <= W1;
                    div_1_rst <= 1;
                    state <= 24;
                end
                
                24: begin
                    dividend_1 <= adder_out;
                    div_1_rst <= 0;
                    adder_in_1 <= W2;
                    adder_in_2 <= W6;
                    adder_in_3 <= {6'b0, W0[161:6]};
                    adder_in_4 <= 162'b0;
                    adder_in_5 <= 162'b0;
                    adder_in_6 <= 162'b0;
                    state <= 25;
                    
                end

                25: begin
                    if(div_1_done) begin
                        W5 <= quotient_1[191:30];
                        W2 <= adder_out;
                        state <= 26;
                    end
                    else begin
                        state <= 25;
                    end
                
                end


                26: begin

                    adder_in_1 <= W4;
                    adder_in_2 <= W2;
                    adder_in_3 <= {6'b0, W6[161:6]};
                    adder_in_4 <= W0;
                    adder_in_5 <= {5'b0, W5[161:5]}; //W5
                    adder_in_6 <= {1'b0, W5[161:1]};
                    div_2_rst <= 1;
                    state <= 27;
                end

                27: begin
                    dividend_2 <= adder_out;
                    div_2_rst <= 0;
                    state <= 28;
                end

                28: begin //////////////////////

                    if(div_2_done) begin
                        W4 <= quotient_2[191:30];
                        adder_in_1 <= W3;
                        adder_in_2 <= W0;
                        adder_in_3 <= W6;
                        adder_in_4 <= 162'b0;
                        adder_in_5 <= 162'b0;
                        adder_in_6 <= 162'b0;
                        state <= 29;
                    end
                    
                    else begin
                        state <= 28;
                    end

                end

                29: begin
                    W3 <= adder_out;
                    state <= 30;
                end


                30: begin
                    adder_in_1 <= W1;
                    adder_in_2 <= W3;
                    adder_in_3 <= 162'b0;
                    adder_in_4 <= 162'b0;
                    adder_in_5 <= 162'b0;
                    adder_in_6 <= 162'b0;
                    state <= 31;
                end

                31: begin
                    W1 <= adder_out;
                    state <= 32;
                end

                32: begin
                    adder_in_1 <= W2;
                    adder_in_2 <= {1'b0, W1[161:1]};
                    adder_in_3 <= {2'b0, W3[161:2]};
                    adder_in_4 <= 162'b0;
                    adder_in_5 <= 162'b0;
                    adder_in_6 <= 162'b0;
                    state <= 33;
                end

                33: begin
                    W2 <= adder_out;
                    adder_in_1 <= W3;
                    adder_in_2 <= W4;
                    adder_in_3 <= W5;
                    adder_in_4 <= 162'b0;
                    adder_in_5 <= 162'b0;
                    adder_in_6 <= 162'b0;
                    state <= 34;
                end

                34: begin
                    W3 <= adder_out;
                    state <= 35;
                end

                35: begin
                    adder_in_1 <= W1;
                    adder_in_2 <= {2'b0, W3[161:2]};    
                    adder_in_3 <= {1'b0, W3[161:1]};    
                    div_1_rst <= 1;
                    state <= 36;
                end

                36: begin
                    dividend_1 <= adder_out;
                    div_1_rst <= 0;
                    state <= 37;
                end

                37: begin
                    if(div_1_done) begin
                        W1 <= quotient_1[191:30];
                        state <= 38;
                    end
                    else begin
                        state <=37;
                    end
                    
                end

                38: begin
                    adder_in_1 <= W5;
                    adder_in_2 <= W1;
                    adder_in_3 <= 162'b0;
                    adder_in_4 <= 162'b0;
                    adder_in_5 <= 162'b0;
                    adder_in_6 <= 162'b0;

                    state <= 39;
                end

                39: begin
                    W5 <= adder_out;
                    state <= 40;    
                end    

                40: begin
                    adder_in_1 <= W2;
                    adder_in_2 <= {2'b0, W5[161:2]};    
                    adder_in_3 <= {1'b0, W5[161:1]};    
                    div_2_rst <= 1;
                    state <= 41;
                end

                41: begin
                    dividend_2 <= adder_out;
                    div_2_rst <= 0;
                    state <= 42;
                end

                42: begin

                    if(div_2_done) begin
                        W2 <= quotient_2[191:30];
                        state <= 43;
                    end
                    else begin
                        state <=42;
                    end
                end

                43: begin
                    
                    adder_in_1 <= W4;
                    adder_in_2 <= W2;
                    adder_in_3 <= 162'b0;
                    adder_in_4 <= 162'b0;
                    adder_in_5 <= 162'b0;      
                    adder_in_6 <= 162'b0;
                    state <= 44;
                end

                44: begin

                    W4 <= adder_out;
                    state <= 45;
                end

                45: begin

                    final <= {W0, 406'b0} ^ {71'b0, W1, 335'b0} ^ {142'b0, W2, 264'b0} ^ {213'b0, W3, 193'b0} ^ {284'b0, W4, 122'b0} ^ {355'b0, W5, 51'b0} ^ {426'b0, W6[161:20]} ;
                    done <= 1;
                    state <= 45;
                end

            endcase
        end
    end


endmodule

