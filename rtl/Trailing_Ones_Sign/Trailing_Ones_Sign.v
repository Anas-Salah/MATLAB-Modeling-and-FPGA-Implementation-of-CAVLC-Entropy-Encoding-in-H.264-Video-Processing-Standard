`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2024 05:43:01 PM
// Design Name: 
// Module Name: Trailing_Ones_Sign
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


module Trailing_Ones_Sign(

input            clk,
input            rst,
input [1:0]      T1s_num,
input [2:0]      T1s_sign,
input            start_trailing_ones_sign, // ACK to the main controller 


output reg       finish_trailing_ones_sign, // ACK to the main controller 

output reg                  fifo_push,
output reg                  fifo_data

    );
    
    ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    /////////////////////////////  Internal Signals \\\\\\\\\\\\\\\\\\\\\\\\\\\
    ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    reg         [3:0]   counter;
    reg                 load_reg_f;
    reg         [2:0]   T1s_sign_reg;
always @ (posedge clk or negedge rst)
  begin
    if (!rst)
      begin
          fifo_push <= 1'b0;  
          fifo_data <= 1'b0;   
          finish_trailing_ones_sign   <= 1'b0;    
          T1s_sign_reg              <= 'b0; 
      end
     else
       begin
            if (start_trailing_ones_sign && (!load_reg_f) )
                begin
                    load_reg_f <= 1 ;                     
                    T1s_sign_reg  <=  T1s_sign;
 
                end
            else  if (start_trailing_ones_sign && (T1s_num  > counter) )
                begin
                    fifo_push          <= 1'b1;  
                    T1s_sign_reg       <= T1s_sign_reg >>1;
                    fifo_data          <= T1s_sign_reg [0];
                    counter            <= counter +1;
                end
             else if (start_trailing_ones_sign && (T1s_num  == counter))
                 begin
                   finish_trailing_ones_sign <= 1'b1;
                   fifo_push                 <= 1'b0;
                   counter                   <= counter +1;
                 end
             else 
                 begin
                 // Note OR you can reset this module from the FSM if ypu recieve a finish flag
                   finish_trailing_ones_sign              <= 1'b0;
                   load_reg_f          <= 1'b0;
                   fifo_push           <= 1'b0;
                   counter            <=  'b0;
                   fifo_data <= 1'b0;

                 end    

       end
  
  end    
  
  

    
    
endmodule
