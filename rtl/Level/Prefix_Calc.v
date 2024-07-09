`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2024 11:41:03 AM
// Design Name: 
// Module Name: prefix_calc
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


module Prefix_Calc #(parameter data_length = 9)(
			
input                       clk,
input                       rst,

// Control and Ack signals 
input                       start,
input                       start_output,
output reg                  finish,

// Data from the controller
input [data_length:0]     level_code,
input [2:0]                 suffix_len,

// Output prefix to the fifo
output reg                  fifo_push,
output reg                  fifo_data
);

reg         [2:0]           i_sufx_len ;
//reg signed [data_length:0]  i_level_code;  // PLEASE ENSURE REGISTER LEGNTH
//wire signed [data_length:0]  shifted_i_level_code;  // PLEASE ENSURE REGISTER LEGNTH
reg  [data_length:0]  i_level_code;  // PLEASE ENSURE REGISTER LEGNTH
wire  [data_length:0]  shifted_i_level_code;  // PLEASE ENSURE REGISTER LEGNTH
assign shifted_i_level_code = i_level_code >> (i_sufx_len);

reg [3:0] state;

reg [data_length:0]         prefix;

reg [data_length-1:0]       output_counter;

always@(posedge clk, negedge rst) begin
    if(!rst) begin
        i_sufx_len      <= suffix_len;
        i_level_code    <= level_code;
        prefix          <= 'b0;
        finish          <= 1'b0;
        state           <= 'b0;
        output_counter  <= 'b0;
        fifo_push       <= 'b0;
    end 
    else begin
            if(start) begin
                case(state)
                    'd0: state <= ((shifted_i_level_code < 'd14)? 'd1: 'd2);
                    'd1: 
                    begin
                        prefix <= shifted_i_level_code;
                        state <= 'd2;
                    end
                    'd2: finish <= 1;
                endcase
            end 
        else if (start_output) begin
            if(output_counter < prefix) begin
                output_counter  <= output_counter + 'b1;
                fifo_data       <= 'b0;
                fifo_push       <= 'b1;
                finish          <= 'b0;
            end
            else if (output_counter == prefix)begin
                fifo_data       <= 'b1;
                fifo_push       <= 'b1;
                finish          <= 'b0;
                output_counter  <= output_counter + 'b1;
            end
            else begin
                fifo_push       <= 'b0;
                finish          <= 'b1;
            end
        end
    end
end





endmodule
