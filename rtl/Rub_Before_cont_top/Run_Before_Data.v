`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2024 01:55:17 PM
// Design Name: 
// Module Name: Run_Before
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


module Run_Before (

input           clk,
input           rst,

// DATA
input   [3:0]   run_before,
input   [2:0]   zeros_left,             // the maximum value for the zeros_left is 7.

// OUTSIDE CONTROLLER & ACK 
input           run_before_data_start,
//input           start_output,
output reg        finish,              // Note to modify this 

// Output prefix to the fifo
output reg                  fifo_push,
output reg                  fifo_data
    );
// Internal_signals
reg         [6:0]   run_before_code;
wire        [6:0]  	addr;
reg         [2:0]   run_before_data_reg;
reg         [3:0]   counter;
reg         load_reg_f;
always @ (posedge clk or negedge rst) begin
    if (!rst) 
        begin
          fifo_push           <= 1'b0;  
          fifo_data <= 1'b0;    
          run_before_data_reg <= 'b0;
          counter             <=  'b0;
          finish              <= 1'b0; 
          load_reg_f          <= 1'b0; 
          
        end
    else
        begin 
             if (run_before_data_start && (!load_reg_f) )
                begin
                   load_reg_f<=1 ;                     
                    run_before_data_reg  <=  run_before_code [6:4];
 
                end
             else if (run_before_data_start && (run_before_code [3:0] > counter) && (load_reg_f))
                begin
                    fifo_push            <= 1'b1;  
                    run_before_data_reg  <= run_before_data_reg >>1;
                    fifo_data <= run_before_data_reg [0];
                    counter              <= counter +1;
                end
             else if (run_before_data_start && (run_before_code [3:0] == counter))
                 begin
                   finish              <= 1'b1;
                   fifo_push            <= 1'b0;
                   counter              <= counter +1;
                 end
             else 
                 begin
                 // Note OR you can reset this module from the FSM if ypu recieve a finish flag
                   finish              <= 1'b0;
                   load_reg_f          <= 1'b0;
                   fifo_push           <= 1'b0;
                   counter            <=  'b0;
                   fifo_data <= 1'b0;

                 end                 
        end

end


// Note I ASSIGN THIS VALUE TO BE AT THE OUTPUT IMMEDIATLY


assign addr = {zeros_left , run_before};

always @(*)begin 
   // added this is condition here to reduce the power 
   if (run_before_data_start)
     begin
        case(addr) 
            /*i_zero_left 1*/        
            // zeroLeft, runbefore     value , length   
            // Note that the index of Zeros left starts from one and the run before start from zero as it support that 
            {3'h1  ,  4'h0 }   : run_before_code =  7'h11 ;
            {3'h1  ,  4'h1 }   : run_before_code =  7'h01 ;
            {3'h1  ,  4'h2 }   : run_before_code =  7'h00 ;
            {3'h1  ,  4'h3 }   : run_before_code =  7'h00 ;
            {3'h1  ,  4'h4 }   : run_before_code =  7'h00 ;
            {3'h1  ,  4'h5 }   : run_before_code =  7'h00 ;
            {3'h1  ,  4'h6 }   : run_before_code =  7'h00 ;
                                 
                                
            /*i_zero_left 2*/    
            {3'h2  ,  4'h0 }   : run_before_code =  7'h11 ;
            {3'h2  ,  4'h1 }   : run_before_code =  7'h12 ;
            {3'h2  ,  4'h2 }   : run_before_code =  7'h02 ;
            {3'h2  ,  4'h3 }   : run_before_code =  7'h00 ;
            {3'h2  ,  4'h4 }   : run_before_code =  7'h00 ;
            {3'h2  ,  4'h5 }   : run_before_code =  7'h00 ;
            {3'h2  ,  4'h6 }   : run_before_code =  7'h00 ;
                                 
                                 
            /*i_zero_left 3*/    
            {3'h3  ,  4'h0 }   : run_before_code =  7'h32 ;
            {3'h3  ,  4'h1 }   : run_before_code =  7'h22 ;
            {3'h3  ,  4'h2 }   : run_before_code =  7'h12 ;
            {3'h3  ,  4'h3 }   : run_before_code =  7'h02 ;
            {3'h3  ,  4'h4 }   : run_before_code =  7'h00 ;
            {3'h3  ,  4'h5 }   : run_before_code =  7'h00 ;
            {3'h3  ,  4'h6 }   : run_before_code =  7'h00 ;
                                 
                                 
             /*i_zero_left 4*/   
            {3'h4  ,  4'h0 }   : run_before_code =  7'h32 ;
            {3'h4  ,  4'h1 }   : run_before_code =  7'h22 ;
            {3'h4  ,  4'h2 }   : run_before_code =  7'h12 ;
            {3'h4  ,  4'h3 }   : run_before_code =  7'h13 ;
            {3'h4  ,  4'h4 }   : run_before_code =  7'h03 ;
            {3'h4  ,  4'h5 }   : run_before_code =  7'h00 ;
            {3'h4  ,  4'h6 }   : run_before_code =  7'h00 ;
                                
                                
            /*i_zero_left 5*/   
            {3'h5  ,  4'h0 }   : run_before_code =  7'h32 ;
            {3'h5  ,  4'h1 }   : run_before_code =  7'h22 ;
            {3'h5  ,  4'h2 }   : run_before_code =  7'h33 ;
            {3'h5  ,  4'h3 }   : run_before_code =  7'h23 ;
            {3'h5  ,  4'h4 }   : run_before_code =  7'h13 ;
            {3'h5  ,  4'h5 }   : run_before_code =  7'h03 ;
            {3'h5  ,  4'h6 }   : run_before_code =  7'h00 ;
                                
                                
            /*i_zero_left 6*/   
            {3'h6  ,  4'h0 }   : run_before_code =  7'h32 ;
            {3'h6  ,  4'h1 }   : run_before_code =  7'h03 ;
            {3'h6  ,  4'h2 }   : run_before_code =  7'h13 ;
            {3'h6  ,  4'h3 }   : run_before_code =  7'h33 ;
            {3'h6  ,  4'h4 }   : run_before_code =  7'h23 ;
            {3'h6  ,  4'h5 }   : run_before_code =  7'h53 ;
            {3'h6  ,  4'h6 }   : run_before_code =  7'h43 ;
                                 
                                 
             /*i_zero_left 7*/   
            {3'h7  ,  4'h0 }   : run_before_code =  7'h73 ;
            {3'h7  ,  4'h1 }   : run_before_code =  7'h63 ;
            {3'h7  ,  4'h2 }   : run_before_code =  7'h53 ;
            {3'h7  ,  4'h3 }   : run_before_code =  7'h43 ;
            {3'h7  ,  4'h4 }   : run_before_code =  7'h33 ;
            {3'h7  ,  4'h5 }   : run_before_code =  7'h23 ;
            {3'h7  ,  4'h6 }   : run_before_code =  7'h13 ;
            {3'h7  ,  4'h7 }   : run_before_code =  7'h14 ;             
            {3'h7  ,  4'h8 }   : run_before_code =  7'h15 ;             
            {3'h7  ,  4'h9 }   : run_before_code =  7'h16 ;             
            {3'h7  ,  4'ha }   : run_before_code =  7'h17 ;             
            {3'h7  ,  4'hb }   : run_before_code =  7'h18 ;             
            {3'h7  ,  4'hc }   : run_before_code =  7'h19 ;                
            {3'h7  ,  4'hd }   : run_before_code =  7'h1a ;
            {3'h7  ,  4'he }   : run_before_code =  7'h1b ;
        
            default: begin
                                 run_before_code =  7'h0 ;
    
          end
        endcase
      end 
      else
      run_before_code  =  7'h0 ;
      
end 


endmodule
