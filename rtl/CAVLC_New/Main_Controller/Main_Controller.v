`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 12:45:44 AM
// Design Name: 
// Module Name: systemControl
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


module System_Control #(    parameter DATA_WIDTH = 8
) (    
input   wire            CLK,
input   wire            RST,
input   wire            START,

// Zigzag Scanning
output  reg            zigzag_en,


// Coeff Token
input   wire            coeff_token_enc,
input   wire            coeff_token_length,
input   wire            coeff_token_end,

output                  coeff_token_en,

// Traling Ones
//input   wire            trailing_ones_num,
input   wire            trailing_ones_sign,
input   wire            trailing_ones_sign_end,

output                  trailing_ones_sign_en,
// Levles
input   wire            levels_enc,
input   wire            levels_length,
input   wire            levels_enc_end,

output                  levels_enc_en,
// Total Zeros
//input   wire            NZQ_num,
input   wire            total_zeros_enc,
input   wire            total_zeros_length,
input   wire            total_zeros_enc_end,

output                  total_zeros_enc_en,

// Run of Zeros
//input   wire            total_zeros_num,
input   wire            run_enc,
input   wire            run_length,

input   wire            run_enc_end,

output                  run_enc_en,


input   wire            ser_done,
input   wire            DATA_VALID,
input   wire            PAR_EN,
output   reg    [1:0]   mux_sel,
output   reg            ser_en,
output   reg            BUSY
);

// state parameters 
localparam  
            IDLE =               3'b000 ,
            ZIGZAG_SCANNING =    3'b001 ,
            COEFF_TOKEN =        3'b010 ,  
            TRAILING_ONE_SIGN =  3'b011 ,  
            LEVELS =             3'b100 ,  
            TOTAL_ZEROS =        3'b101  ,  
            RUN_OF_ZEROS =       3'b110 ;
    
// internal signal
reg     [2:0]            state_reg , state_next ;
reg     [3:0]            counter;
reg           counter_en;
// state_reg
always @ (posedge CLK or negedge RST)
begin
    if (!RST)
        state_reg <= IDLE;
    else
        begin
        state_reg <= state_next;

        end

end

// next_state_logic and output logic
always @ (*) 
begin

// but here initial values for all the outputs
    state_next = state_reg;
    mux_sel    = 2'b01;
    ser_en     = 1'b0;
    BUSY       = 1'b0;
   // counter    = 'b0; this is't output to be here 
    case (state_reg)
        IDLE : begin
                    if( START )
                        state_next = COEFF_TOKEN;
               end
        ZIGZAG_SCANNING : begin
                    counter_en = 1'b1;
                    zigzag_en = 1'b1;
                    if(counter == 'd15)
                        state_next = COEFF_TOKEN;
                    else
                        state_next = ZIGZAG_SCANNING;
               end
               
        COEFF_TOKEN : begin
                    state_next = DATA;
                    mux_sel    = 2'b00;
                    BUSY       = 1'b1;
               end
        TRAILING_ONE_SIGN : begin
                    // here we need to use ser_done
                    mux_sel    = 2'b10;
                    ser_en     = 1'b1;
                    BUSY       = 1'b1; 
                    if (ser_done)
                        state_next = PARITY;
                    else
                        state_next = TRAILING_ONE_SIGN;
                    /*if (counter == DATA_WIDTH -1)
                        state_next = PARITY;
                    else
                        state_next = DATA;*/
           
               end
        TOTAL_ZEROS : begin
                    BUSY       = 1'b1; 
                    if (PAR_EN)
                        begin
                            mux_sel    = 2'b11;
                            state_next = LEVELS;
                        end
                    else 
                        // mux_sel    = 2'b01; WRONG HERE    BIG MISTAKE Because the simulator ignored the if statement even it's right not wrong
                        begin
                            mux_sel    = 2'b01;
                            if (DATA_VALID)
                                state_next = LEVELS;
                            else 
                                state_next = IDLE;
                        end
               end
        LEVELS : begin
                    BUSY       = 1'b1; 
                    mux_sel    = 2'b01;
                    if (DATA_VALID)
                        state_next = TOTAL_ZEROS;
                    else 
                        state_next = LEVELS;
               end               
        default: begin
                    state_next = IDLE;
                    mux_sel    = 2'b01;
                    ser_en     = 1'b0;
                    BUSY       = 1'b0;
                
               end
    endcase

end



// counter 
always @ (posedge CLK or negedge RST)
    begin 
      if (!RST)
        counter <= 'b0;
      else if (counter_en)        
        begin       
        counter <= counter +1;
        end
    end


endmodule
