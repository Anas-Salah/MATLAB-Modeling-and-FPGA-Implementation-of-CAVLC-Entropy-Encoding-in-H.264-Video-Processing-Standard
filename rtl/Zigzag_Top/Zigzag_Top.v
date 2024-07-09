`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2024 11:46:36 AM
// Design Name: 
// Module Name: Zigzag_Top
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


`timescale 1ns / 1ps
// This test combine the input buffer, the ROM and the counter
`include "Counter.v"
`include "Dual_Port_BRAM.v"
`include "Zigzag_Order_ROM.v"

// what about the internal signal 
module Zigzag_Top #(addrWIDTH= 4, WIDTH= 9, DEPTH = 16 )(
    input clk_i,                    // Clock input
    input rst_i,
    input en_i,                     // Enable signal for the counter and the BRAMs
    input [WIDTH-1:0] res_data_i,   // this is the input residual data 
    input read_en_i,
    input write_en_i,
    input [addrWIDTH-1:0] read_addr_i,   // the read adress 
    
    output [addrWIDTH-1:0] ZZO_o,   // Zigzag order(ZZO): This is the output from ROM to the Residual buffer
    output [WIDTH-1:0] dob_o         // The output data 

);

// Internal Signal
wire [3:0] address;


// Counter 
Counter #(.CounterWidth(addrWIDTH)) u0_counter  (
    .clk(clk_i),      // Clock input
     .rst(rst_i),    // rst signal
     .en(en_i),       // Enable signal
    
     .count(address) // 4-bit counter output
);


// BRAM 

Dual_Port_BRAM #(.addrWIDTH(addrWIDTH), .WIDTH(WIDTH), .DEPTH(DEPTH) ) ZZ_BRAM (
.clk(clk_i),
.rst(rst_i),

.ena(en_i),          // This is write enable 
.enb(read_en_i),     // This is the read  enable 
.wea(en_i),          // write address enable 
.addra(address),   // the write address

.addrb(read_addr_i),     // read_addr is read address 
.dia(res_data_i),       // res_data is an input from the residul buffer to the ZZ_BRAM 9*16 

.dob(dob_o)
);


// ROM 
Zigzag_Order_ROM ZZ_ROM (
    .address(address),
    .data(ZZO_o)
);

endmodule
