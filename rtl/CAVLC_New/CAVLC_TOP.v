`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 02:50:00 PM
// Design Name: 
// Module Name: CAVLC_TOP
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
    parameter addrWIDTH = 4;
    parameter WIDTH = 9;
    parameter DEPTH = 16;
    parameter nWIDTH = 4;
    parameter DATA_WIDTH = 9;
    parameter STATE_WIDTH = 4;
    parameter NZQ_WIDTH = 5;
    
module CAVLC_TOP(
input   clk,
input   rst,
input   [WIDTH-1:0] res_data_i,
// input   wire    [nWIDTH-1:0]    nA,
// input   wire    [nWIDTH-1:0]    nB,


output fifo_data,
output fifo_push
    );
    
    
    
    
    
    // Parameters 
       

    
  //////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 //////////////////////////////////////////////////// Zigzag Scanning  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


    Zigzag_Top #(addrWIDTH, WIDTH, DEPTH) Zigzag_Top_dut (
        .clk_i(clk),
        .rst_i(rst),
        .en_i(en_i),
        .res_data_i(res_data_i),
        .read_en_i(read_en_i),
        .write_en_i(write_en_i),
        .read_addr_i(read_addr_i),
        .ZZO_o(ZZO_o),
        .dob_o(dob_o)
    );


/*
    nC_Selector #(nWIDTH) nC_Selector_inst (
        .nA(nA),
        .nB(nB),
        .nC(nC)
    );

*/
  //////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 //////////////////////////////////////////////////// CAVLC Counters & T1s sign \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    

// In the FSM you will wait for sixteen clock cycles to get the right value 
    CAVLCSteps cavlc_steps_inst (
        .clk(clk),
        .rst(rst),
        .counters_en(counters_en),
        .word(dob_o),
        .BRAM_addr(BRAM_addr),
        .NZQ_num(NZQ_num),
        .totalZerosNum(totalZerosNum),
        .trailOneNum(trailOneNum),
        .trailOneSign(trailOneSign),
        .preprocessingEndFlag(preprocessingEndFlag)
    );
    
    
    
    
 //////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 ///////////////////////////////////////////////////////// coeff token   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      
parameter aWIDTH = 6;
parameter vcWIDTH = 8;

// Instantiate the coeffTokenEnc module
coeffTokenEnc #(aWIDTH, vcWIDTH) coeffTokenEnc_inst (
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
    
  //////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 ///////////////////////////////////////////////////////// Levels   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      	// Instantiate the Unit Under Test (UUT)
      	/*
  level_controller #(
    .DATA_WIDTH(DATA_WIDTH),
    .STATE_WIDTH(STATE_WIDTH),
    .NZQ_WIDTH(NZQ_WIDTH)
  ) uut (
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
    .NZQ(NZQ_num),
    .T1s(trailOneNum),
    .suffix_len(suffix_len),
    .level_code(level_code)
  );
  
  
  
  parameter DATA_LENGTH = 9;
  
  suffix_calc #(.data_length(DATA_LENGTH)) suf (
        .clk(clk),
        .rst(rst),
        .start(suffix_start),
        .start_output(start_output),
        .finish(finish),
        .fifo_push(fifo_push),
        .fifo_data(fifo_data),
        .level_code(level_code),
        .suffix_len(suffix_len)
    );
	 
	 
	 prefix_calc #(.data_length(DATA_LENGTH)) pref (
        .clk(clk),
        .rst(rst),
        .start(prefix_start),
        .start_output(prefix_start_out),
        .finish(finish),
        .fifo_push(fifo_push),
        .fifo_data(fifo_data),
        .level_code(level_code),
        .suffix_len(suffix_len)
    );
   */
  //////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 ///////////////////////////////////////////////////////// Total zeros   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      /*
    // Parameter definitions
    parameter aWIDTH = 8;
    parameter tzcWIDTH = 7;

    // Instantiate the totalZerosEnc module
    totalZerosEnc #(aWIDTH, tzcWIDTH) totalZerosEnc_inst (
        .addr(addr),
        .TotalZeroCode(TotalZeroCode)
    );
*/
    
    
  //////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 //////////////////////////////////////////////////// Run Before   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  
    
    
///////////////////////////////////////////////////////////// Run_Before_data \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    Run_Before run_before_inst (
        .clk(clk),
        .rst(rst),
        .run_before(run_before),
        .zeros_left(zeros_left),
        .run_before_data_start(run_before_data_start),
        .finish(finish),
        .fifo_push(fifo_push),
        .fifo_data(fifo_data)
    );
    
    
    
    parameter  DATA_WIDTH = 9 , NZQ_WIDTH = 5 , STATE_WIDTH = 4;
    ///////////////////////////////////////////////////////////// Run_Before_Controller \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 Run_Before_Controller #(
        .DATA_WIDTH(DATA_WIDTH),
        .NZQ_WIDTH(NZQ_WIDTH),
        .STATE_WIDTH(STATE_WIDTH)
    ) run_before_controller_inst (
        .clk(clk),
        .rst(rst),
        .start_run_before(start_run_before),
        .finish_run_before(finish_run_before),
        .NZQ(NZQ),
        .total_zeros_num(total_zeros_num),
        .BRAM_addr(BRAM_addr),
        .BRAM_read_en(BRAM_read_en),
        .mb_BRAM_data(mb_BRAM_data),
        .run_before(run_before),
        .zeros_left(zeros_left),
        .run_before_data_start(run_before_data_start),
        .finish_data(finish_data)
    );

    













endmodule
