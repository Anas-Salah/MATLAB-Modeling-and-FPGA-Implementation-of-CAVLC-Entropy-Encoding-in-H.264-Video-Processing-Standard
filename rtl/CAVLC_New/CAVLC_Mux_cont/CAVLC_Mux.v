`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2024 02:33:40 PM
// Design Name: 
// Module Name: CAVLC_Mux
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


module CAVLC_Mux (
input    wire   [2:0]    mux_sel,
input    wire            coeff_token,
input    wire            trailing_ones_sign,
input    wire            levles,
input    wire            total_zeros,
input    wire            reun_before,

output   reg             CAVLC_out

);


always @ (*)
begin
    case (mux_sel)
        3'b000 : CAVLC_out = coeff_token ;                 //           00 : TX_OUT = 1'b0 ;  
        3'b001 : CAVLC_out = trailing_ones_sign ;          //           01 : TX_OUT = 1'b1 ;
        3'b010 : CAVLC_out = levles ;                      //           10 : TX_OUT = ser_data ; THE BIG PROBLEM IS FORGOT     2'b
        3'b011 : CAVLC_out = total_zeros ;                 //           11 : TX_OUT = par_bit ;
        3'b011 : CAVLC_out = reun_before ;         
        
    endcase
end
    
endmodule