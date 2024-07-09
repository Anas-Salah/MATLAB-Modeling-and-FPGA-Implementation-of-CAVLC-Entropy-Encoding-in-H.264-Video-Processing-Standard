`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 11:22:03 AM
// Design Name: 
// Module Name: dualPortBRAM
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


module Dual_Port_BRAM #(addrWIDTH= 4, WIDTH= 9, DEPTH = 16 )(clk,rst,ena,enb,wea,addra,addrb,dia,dob);
input clk,ena,enb,wea,rst;
input [addrWIDTH-1:0] addra,addrb;
input [WIDTH-1:0] dia;
output [WIDTH-1:0] dob;
reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [WIDTH-1:0] dob;
integer i;
wire [addrWIDTH-1:0] write_addr;

assign write_addr  = addra - 1'b1;

    always @(posedge clk or negedge rst) begin
        if (!rst)
            begin
              for ( i= 0 ; i < DEPTH; i = i+1 ) 
                begin
                 ram[i] <= 'b0;
                end 
                   
            end
                   
        else
        begin
            if (ena) begin
                if (wea)
                ram[write_addr] <= dia;
                end
        end
    end
           
    always @(posedge clk ) begin
       if (enb)
        dob <= ram[addrb];
        end
                
    
    
endmodule