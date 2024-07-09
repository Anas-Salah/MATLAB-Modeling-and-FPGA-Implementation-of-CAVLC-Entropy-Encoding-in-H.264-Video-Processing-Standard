// Note we need to connect this with the main FSM


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 01:25:29 PM
// Design Name: 
// Module Name: CAVLCSteps
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

// In the FSM you will wait for sixteen clock cycles to get the right value 
module Statistic_Buffer(
input clk, rst,
input counters_en,

input [8:0] word,
input [3:0] BRAM_addr,


output [4:0] NZQ_num,
output [3:0] totalZerosNum,
output  [1:0] trailOneNum, // it's the trailing one length and also the number of trailing ones 
output  [2:0] trailOneSign,
output  reg  preprocessingEndFlag
    );
reg [1:0]   trailOneNum_reg;
reg         trailOneStopFlag; // This flag will terminate the process if the number of trailing ine exceed three or hit NZQ
reg [2:0]   trailOneSign_reg;
reg [3:0]   totalZerosNum_reg,totalZerosBefNum_reg;
reg NZFlag;
reg [4:0] NZQ_num_reg;

    
  always @ (posedge clk or negedge rst)
      begin
      if (! rst)
        begin 
          trailOneNum_reg       <= 'b0;
          trailOneSign_reg      <= 'b0;
          trailOneStopFlag       <= 'b0;
          totalZerosNum_reg     <= 'b0;
          totalZerosBefNum_reg  <= 'b0;
          NZFlag                <= 1'b0;
        end
                  
      else if (counters_en)
        begin 
           if ( (word == 9'h001) && (trailOneNum_reg < 3) && (!trailOneStopFlag) )
            begin 
              trailOneNum_reg  <= trailOneNum_reg +1 ;
              trailOneSign_reg <= {trailOneSign_reg[1:0],1'b0};
              NZFlag  <= 1'b1;   
            end
          else if ((word == 9'h101)  && (trailOneNum_reg) < 3 && (!trailOneStopFlag) )
            begin 
              trailOneNum_reg <= trailOneNum_reg +1 ;
              trailOneSign_reg <= {trailOneSign_reg[1:0],1'b1};
              NZFlag  <= 1'b1;    
            end    
          else if (word == 9'h000 && NZFlag   ) // will start if a non zero coeff word is to calculated
            begin
              trailOneNum_reg <= trailOneNum_reg  ;
              trailOneSign_reg <= trailOneSign_reg;
              totalZerosBefNum_reg <= totalZerosBefNum_reg +1;
            end
           else if (word == 9'h000)
            begin
              trailOneNum_reg <= trailOneNum_reg  ;
              trailOneSign_reg <= trailOneSign_reg;
              totalZerosNum_reg <= totalZerosNum_reg ;
            end   
           else if (BRAM_addr == 4'b1111)
            begin
              preprocessingEndFlag = 1'b1;
            end               
                          
          else 
            begin 
              trailOneStopFlag   <= 1'b1;
              trailOneNum_reg   <= trailOneNum_reg  ;
              trailOneSign_reg  <= trailOneSign_reg;
              NZFlag  <= 1'b1;                             // Non zero flag to start count the total number of zeros
            end
                  
        end
        
  end 

  
  always @ (posedge clk or negedge rst)
      begin
          if (! rst )
            begin 
              NZQ_num_reg     <= 'b0;
            end                 
           else if (!(word == 9'h000) && counters_en)
            begin
              NZQ_num_reg <= NZQ_num_reg+1 ;
            end                      
      end 


// output logic 

 
assign          trailOneNum    = trailOneNum_reg;
assign          trailOneSign   = trailOneSign_reg;
assign          totalZerosNum  = totalZerosBefNum_reg;
assign          NZQ_num        = NZQ_num_reg;

      
endmodule

//test bench for the CAVLC steps 

/*
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2024 01:39:15 PM
// Design Name: 
// Module Name: test_tb
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


module test_tb;
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
*/


