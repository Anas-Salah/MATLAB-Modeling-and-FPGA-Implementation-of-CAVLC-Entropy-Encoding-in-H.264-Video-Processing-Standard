`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 02:43:13 AM
// Design Name: 
// Module Name: Level_Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Level_Top #(parameter DATA_WIDTH = 9 , STATE_WIDTH = 4, NZQ_WIDTH = 5)
	(
	input                                 clk,
    input                                 rst,
    
    // OUTSIDE CONTROLLER & ACK 
    input                                 start_levels,
    output                                finish_levels,


   

    // IO WITH INPUT FIFO (HOLDING MB DATA)
    output                                mb_bram_en,
    output            [3:0]               mb_bram_address,
    input signed      [DATA_WIDTH-1:0]    mb_bram_data,
    
    // INPUT DATA FROM PREVIOUS STAGES
    input             [NZQ_WIDTH-1:0]     NZQ,
    input             [1:0]               T1s,
    
    // OUTPUT fifo data and fifo push
    output o_fifo_data,
    output o_fifo_push

    );     



    /////////////////////////  Internal signals \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
        // PREFIX AND SUFFIX BLOCKS CONTROL LINES & ACKs
    wire                            prefix_start;
    wire                            suffix_start;
    wire                            prefix_start_out;
    wire                            suffix_start_out;
    wire                            prefix_finish;
    wire                            suffix_finish;
    wire        [2:0]               suffix_len;
    wire signed [DATA_WIDTH:0]      level_code;


    // MUX CONTROL TO CONTROL THE OUTPUT BETWEEN PREFIX AND SUFFIX BLOCKS
    wire                           output_mux;
	
	// Instantiate the Unit Under Test (UUT)
    Level_Controller #(
    .DATA_WIDTH(DATA_WIDTH),
    .STATE_WIDTH(STATE_WIDTH),
    .NZQ_WIDTH(NZQ_WIDTH)
    ) Level_Controller_U0 (
    .clk(clk),
    .rst(rst),
    .start_levels(start_levels),
    .finish_levels(finish_levels),
    .output_mux(output_mux),
    .prefix_start(prefix_start),
    .suffix_start(suffix_start),
    .prefix_start_out(prefix_start_out),
    .suffix_start_out(suffix_start_out),
    .prefix_finish(prefix_finish),
    .suffix_finish(suffix_finish),
    .mb_bram_en(mb_bram_en),
    .mb_bram_address(mb_bram_address),
    .mb_bram_data(mb_bram_data),
    .NZQ(NZQ),
    .T1s(T1s),
    .suffix_len(suffix_len),
    .level_code(level_code)
  );
  
  
  	 wire fifo_push_suffix;
	 wire fifo_data_suffix;
  
  Suffix_Calc #(.data_length(DATA_WIDTH)) Suffix_Calc_U0 (
        .clk(clk),
        .rst(rst),
        .start(suffix_start),
        .start_output(start_output),
        .finish(finish),
        .fifo_push(fifo_push_suffix),
        .fifo_data(fifo_data_suffix),
        .level_code(level_code),
        .suffix_len(suffix_len)
    );
	 
	 wire fifo_push_prefix;
	 wire fifo_data_prefix;
	 
	 Prefix_Calc #(.data_length(DATA_WIDTH)) Prefix_Calc_U0 (
        .clk(clk),
        .rst(rst),
        .start(prefix_start),
        .start_output(prefix_start_out),
        .finish(finish),
        .fifo_push(fifo_push_prefix),
        .fifo_data(fifo_data_prefix),
        .level_code(level_code),
        .suffix_len(suffix_len)
    );
	 
	 
	 // make a mux module here for the for the fifo push and fifo data.  
	 assign o_fifo_data = output_mux ? fifo_data_suffix : fifo_data_prefix;
	 assign o_fifo_push = output_mux ? fifo_push_suffix : fifo_push_prefix;
	 
endmodule
