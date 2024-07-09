`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 01:01:13 PM
// Design Name: 
// Module Name: CAVLCSteps_tb
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




module CAVLCSteps_tb;
 ///////////////////// Constants \\\\\\\\\\\\\\\\\\\\\\\\\\

localparam CLK_PERIOD = 10;
 ///////////////////// Signals \\\\\\\\\\\\\\\\\\\\\\\\\\

reg clk, rst,trailOneEn;
reg [8:0] word;

wire  [4:0] NZQ_num;
wire  [3:0] totalZerosNum;
wire  [1:0] trailOneNum; // it's the trailing one length and also the number of trailing ones 
wire  [2:0] trailOneSign;


        
reg [8:0] memory [0:15]; // Declare a memory array
 ///////////////////// Initla block  \\\\\\\\\\\\\\\\\\\\\\\\\\

initial begin
    // Initialize memory from a binary file
     // System Functions
 $dumpfile("test.vcd") ;       
 $dumpvars; 
 
 
 
    $readmemh("memory_data.txt", memory);

    // Initialize memory from a hexadecimal file
    //$readmemh("memory_data.hex", memory);
end



integer i;
    // Stimulus 
  
    initial begin      
        rst = 'b0;
        clk = 'b0;
        trailOneEn = 'b0 ;        
        word = 'b0;
        #20 
        rst = 'b1;
       
    trailOneEn = 'b1 ;
    #(CLK_PERIOD);  
     trailOneEn = 'b0 ;
     for (i= 0 ; i < 16 ; i = i+1 ) 
         begin
            word = memory[i]  ;
            #(CLK_PERIOD);  
         end
      trailOneEn = 'b1 ;
      #(CLK_PERIOD);
      trailOneEn = 'b0 ;
      #(CLK_PERIOD); word = 9'h000  ;  //      0                      
      #(CLK_PERIOD); word = 9'h000  ;  //      0
      #(CLK_PERIOD); word = 9'h000  ;  //      0
      #(CLK_PERIOD); word = 9'h000  ;  //      0
      #(CLK_PERIOD); word = 9'h000  ;  //      0
      #(CLK_PERIOD); word = 9'h000  ;  //      0
      #(CLK_PERIOD); word = 9'h000  ;  //      0
      #(CLK_PERIOD); word = 9'h000  ;  //      0
      #(CLK_PERIOD); word = 9'h000  ;  //      0
      #(CLK_PERIOD); word = 9'h101  ;  //     -1             
      #(CLK_PERIOD); word = 9'h000  ;  //      0
      #(CLK_PERIOD); word = 9'h000  ;  //      0
      #(CLK_PERIOD); word = 9'h103  ;  //     -3             
      #(CLK_PERIOD); word = 9'h003  ;  //      3
      #(CLK_PERIOD); word = 9'h004  ;  //      4
      #(CLK_PERIOD); word = 9'h102  ;  //     -2
      #(CLK_PERIOD); trailOneEn = 'b1 ;                


        #100;
        
        // End simulation
        $finish;
    end


 ///////////////////// Clock generation \\\\\\\\\\\\\\\\\\\\\\\\\\

    
    always #(CLK_PERIOD / 2) clk = ~clk;
    
    
 ///////////////////// Instantiate the design under test (DUT) \\\\\\\\\\\\\\\\\\\\\\\\\\

    
 CAVLCSteps DUT(
.clk(clk), 
.rst(rst),
.trailOneEn(trailOneEn),
.word(word),

.NZQ_num(NZQ_num),
.totalZerosNum(totalZerosNum),
.trailOneNum(trailOneNum), // it's the trailing one length and also the number of trailing ones 
.trailOneSign(trailOneSign)
);


endmodule

