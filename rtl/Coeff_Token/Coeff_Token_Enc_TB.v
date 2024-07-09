`timescale 1ns / 1ps

module Coeff_Token_Enc_TB;

    // Parameters
    parameter aWIDTH = 6;
    parameter vcWIDTH = 8;
    parameter vc3WIDTH = 8;

    // Testbench signals
    reg clk;
    reg rst;
    reg [3:0] nC;
    reg [1:0] T1;
    reg [4:0] NZQs;
    reg start_coeff_token;
    wire finish_coeff_token;
    wire coeffTokenC3Flag;
    wire fifo_push;
    wire fifo_data;

    // Instantiate the DUT (Device Under Test)
    coeffTokenEnc #(aWIDTH, vcWIDTH, vc3WIDTH) uut (
        .clk(clk),
        .rst(rst),
        .nC(nC),
        .T1(T1),
        .NZQs(NZQs),
        .start_coeff_token(start_coeff_token),
        .finish_coeff_token(finish_coeff_token),
        .coeffTokenC3Flag(coeffTokenC3Flag),
        .fifo_push(fifo_push),
        .fifo_data(fifo_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    // Test procedure
    initial begin
        // Initialize signals
        rst = 1;
        nC = 0;
        T1 = 0;
        NZQs = 0;
        start_coeff_token = 0;

        // Reset the DUT
        #10 rst = 0;
        #10 rst = 1;

        // Test Case 1: Encode with nC = 0, T1 = 2'b01, NZQs = 5'b00101
        #10;
        nC = 4'd0;
        T1 = 2'b01;
        NZQs = 5'b00101;
        start_coeff_token = 1;
        #20;
        start_coeff_token = 0;

        // Wait for encoding to finish
        wait(finish_coeff_token == 1);
        #10;

        // Test Case 2: Encode with nC = 3, T1 = 2'b10, NZQs = 5'b01010
        #10;
        nC = 4'd3;
        T1 = 2'b10;
        NZQs = 5'b01010;
        start_coeff_token = 1;
        #20;
        start_coeff_token = 0;

        // Wait for encoding to finish
        wait(finish_coeff_token == 1);
        #10;

        // Test Case 3: Encode with nC = 7, T1 = 2'b11, NZQs = 5'b11111
        #10;
        nC = 4'd7;
        T1 = 2'b11;
        NZQs = 5'b11111;
        start_coeff_token = 1;
        #20;
        start_coeff_token = 0;

        // Wait for encoding to finish
        wait(finish_coeff_token == 1);
        #10;

        // Test Case 4: Encode with nC = 8, T1 = 2'b00, NZQs = 5'b00001 (Fixed length case)
        #10;
        nC = 4'd8;
        T1 = 2'b00;
        NZQs = 5'b00001;
        start_coeff_token = 1;
        #20;
        start_coeff_token = 0;

        // Wait for encoding to finish
        wait(finish_coeff_token == 1);
        #10;

        // Finish the simulation
        #20;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t | nC: %0d | T1: %0b | NZQs: %0b | start_coeff_token: %b | finish_coeff_token: %b | coeffTokenC3Flag: %b | fifo_push: %b | fifo_data: %b",
                 $time, nC, T1, NZQs, start_coeff_token, finish_coeff_token, coeffTokenC3Flag, fifo_push, fifo_data);
    end

endmodule
