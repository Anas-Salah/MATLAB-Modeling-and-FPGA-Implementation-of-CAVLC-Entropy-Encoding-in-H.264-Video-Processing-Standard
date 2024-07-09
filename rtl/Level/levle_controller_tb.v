`timescale 1ns / 1ps

module level_controller_tb;

  // Parameters
  parameter DATA_WIDTH = 9;
  parameter STATE_WIDTH = 4;
  parameter NZQ_WIDTH = 5;

  // Inputs
  reg clk;
  reg rst;
  reg start_levels;
  reg prefix_finish;
  reg suffix_finish;
  reg [NZQ_WIDTH-1:0] NZQ;
  reg [1:0] T1s;
  wire signed [DATA_WIDTH-1:0] mb_bram_data;

  // Outputs
  wire finish_levels;
  wire output_mux;
  wire prefix_start;
  wire suffix_start;
  wire prefix_start_out;
  wire suffix_start_out;
  wire mb_bram_en;
  wire [3:0] mb_bram_address;
  wire [2:0] suffix_len;
  wire signed [DATA_WIDTH:0] level_code;
  
  
  
  
  // Instantiate the Unit Under Test (UUT)
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
    .NZQ(NZQ),
    .T1s(T1s),
    .suffix_len(suffix_len),
    .level_code(level_code)
  );
    
    reg [8:0] memory [0:15]; // Declare a memory array
    assign mb_bram_data = memory[mb_bram_address];
    // Clock generation
    initial begin
        clk = 0;
        forever begin 
				#5 clk = ~clk; // 10ns period
				if(prefix_start || prefix_start_out)
					prefix_finish <= 'd1;
				if(suffix_start || suffix_start_out)
					suffix_finish <= 'd1;
					
			end
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        $readmemh("F:\memory_data.txt", memory);
        rst = 1;
        start_levels = 0;
        NZQ = 0;
        T1s = 0;        
        prefix_finish = 0;
        suffix_finish = 0;

        // Wait for global reset to finish
        #10;
        rst = 0;
        #10;
        rst = 1;

        // Test case 1: Simple start and stop
        @(posedge clk);
        start_levels = 1;
        NZQ = 5'd5;
        T1s = 2'd3;
        @(posedge clk);
        start_levels = 0;


        // Wait for some cycles
        #10000;

        // Finish the test
        $stop;
    end

   

endmodule