
//////////////////////////////////////////////////////////////////////////////////
//   
//   
//        
//        localparam WIDTH = 9;      // The word width 
//        localparam addrWIDTH = 4;  // for the BRAM, counter width and the Rom output 
//        localparam DEPTH = 16;     // THe BRAM depth relative to the input 4*4 matrix 
//      Zigzag_Top #(               
//          .addrWIDTH(addrWIDTH),  
//          .WIDTH(WIDTH),          
//          .DEPTH(DEPTH)           
//      ) dut (
//          //The inputs\\                     
//          .clk(clk),              
//          .rst(rst),              
//          .en(en),
//          .res_data(res_data),
//          .read_en(read_en),
//          .read_addr(read_addr),


//          //The outputs\\                     
//          .ZZO(ZZO),      
//          .dob(dob)               
//      );                          
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
// This test combine the input buffer and the ROM and the counter

// what about the internal signal 
module test #(addrWIDTH= 4, WIDTH= 9, DEPTH = 16 )(
    input clk,                    // Clock input
    input rst,
    input en,                     // Enable signal for the counter and the BRAMs
    input [WIDTH-1:0] res_data,   // this is the input residual data 
    input read_en,
    input [addrWIDTH-1:0] read_addr,
    
    output [addrWIDTH-1:0] ZZO,   // Zigzag order(ZZO): This is the output from ROM to the Residual buffer
    output [WIDTH-1:0] dob

);

// Internal signals
wire [addrWIDTH-1:0] addra;
wire [3:0] address;
//wire [3:0] data; // the [3:0] data which will leve the rom to reach the read address of the bram 

 counter #(.CounterWidth(addrWIDTH)) u0_counter  (
    .clk(clk),      // Clock input
     .rst(rst),    // rst signal
     .en(en),       // Enable signal
    
     .count(address) // 4-bit counter output
);


/*
 dualPortBRAM Residual_buffer (
.clk(clk),
.rst(rst),

.ena(ena),
.enb(en),          // This is the input enable 
.wea(wea),
.addra(addra),

.addrb(data),     // here is the data from the pitput of the Rom // Note the data is the input here not addrb 
.dia(dia),

.dob(dob)
);
*/

wire [addrWIDTH-1:0] BRAM_write_adrr;
assign BRAM_write_adrr = address -1;
 dualPortBRAM #(.addrWIDTH(addrWIDTH), .WIDTH(WIDTH), .DEPTH(DEPTH) ) ZZ_BRAM (
.clk(clk),
.rst(rst),

.ena(en),            // This is write the read  enable 
.enb(read_en),          // This is the read  enable 
.wea(en),          // write enable address
.addra(address),   // the write address

.addrb(addrb),     // here is the data from the pitput of the Rom // Note the data is the input here not addrb 
.dia(res_data),       // res_data is the output from residul buffer to the ZZ_BRAM 9*16 

.dob(dob)
);

zigzagOrderROM ZZ_ROM (
    .address(address),
    .data(ZZO)
);

endmodule


//`timescale 1ns / 1ps
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

/*
module test_tb;

    // Constants
    localparam WIDTH = 9;
    localparam addrWIDTH = 4;
    localparam DEPTH = 16;
    localparam CLK_PERIOD = 10; // Clock period in ns

    // Signals
    reg clk;
    reg rst;
    reg en;
    wire [WIDTH-1:0] dob;

    // Instantiate the design under test (DUT)
    test #(
        .addrWIDTH(addrWIDTH),
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .dob(dob)
    );

    // Clock generation
    always #(CLK_PERIOD / 2) clk = ~clk;

    // rst generation
    initial begin
        rst = 0;
        clk = 0;
        en = 0 ;
        #20 rst = 1;
    end

    // Stimulus
    initial begin
        $monitor("Time=%0t, dob=%h", $time, dob);

        // Test without enable (en = 0)
        #10;
        

        $display("Test without enable (en = 0):");
        en = 0;
        #100;

        // Test with enable (en = 1)
        $display("Test with enable (en = 1):");
        en = 1;
        #100;
        
        // End simulation
        $finish;
    end

endmodule
*/