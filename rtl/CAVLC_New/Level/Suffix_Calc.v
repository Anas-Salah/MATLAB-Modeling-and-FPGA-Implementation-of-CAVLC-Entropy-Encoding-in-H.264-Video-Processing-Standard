`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2024 11:41:28 AM
// Design Name: 
// Module Name: suffix_calc
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


module Suffix_Calc #(parameter data_length = 9)(
input                       clk,
input                       rst,

// Control and Ack signals 
input                       start,
input                       start_output,
output reg                  finish,

// Data from the controller
input [data_length:0]      level_code,
input [2:0]                suffix_len,

// Output prefix to the fifo
output reg                  fifo_push,
output reg                  fifo_data
    );
    
reg       [2:0]             i_suffix_len;
reg       [data_length:0]   i_level_code;  // PLEASE ENSURE REGISTER LEGNTH
reg       [2:0]             counter;
    
    always @ (posedge clk or negedge rst) begin
        if (!rst)
          begin
            i_suffix_len      <= suffix_len;
            i_level_code      <= level_code;
            counter           <= 'b0;
            
          end
        else
        begin
           if (i_suffix_len > counter)
             begin            
             counter            <= counter +1;
             i_level_code       <= {1'b0 , i_level_code [data_length:1]};
             fifo_data          <= i_level_code[0];
             fifo_push          <= 'b1;
             end
           else 
             begin                        
               fifo_push       <= 'b0;
               finish          <= 'b1;
             end
           
        end
   
    end

endmodule
