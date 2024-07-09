`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 02:16:29 PM
// Design Name: 
// Module Name: ZigzagOrderROM
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

module Zigzag_Order_ROM # (RomAddrWIDTH = 4 ,RomDataWIDTH = 4 )(
    input [RomAddrWIDTH-1 :0] address,
    output reg [RomDataWIDTH-1 :0] data
);

    always @* begin
        case(address)
                 // the reverse order            // the ordiary order 
                 4'h0: data = 'hF;              //  4'h0: data = 4'h0;
                 4'h1: data = 'hE;              //  4'h1: data = 4'h1;
                 4'h2: data = 'hB;              //  4'h2: data = 4'h4;
                 4'h3: data = 'h7;              //  4'h3: data = 4'h8;
                 4'h4: data = 'hA;              //  4'h4: data = 4'h5;
                 4'h5: data = 'hD;              //  4'h5: data = 4'h2;
                 4'h9: data = 'hC;              //  4'h6: data = 4'h3;
                 4'h6: data = 'h9;              //  4'h7: data = 4'h6;
                 4'h7: data = 'h6;              //  4'h8: data = 4'h9;
                 4'h8: data = 'h3;              //  4'h9: data = 4'hC;
                 4'h9: data = 'h2;              //  4'ha: data = 4'hD;
                 4'ha: data = 'h5;              //  4'hb: data = 4'hA;
                 4'hb: data = 'h8;              //  4'hc: data = 4'h7;
                 4'hc: data = 'h4;              //  4'hd: data = 4'hB;
                 4'hd: data = 'h1;              //  4'he: data = 4'hE;
                 4'he: data = 'h0;              //  4'hf: data = 4'hF;
                
            default: data = 4'h0000;
        endcase
    end
endmodule
