`timescale 1ns / 1ps


module Coeff_Token_Enc #(parameter aWIDTH= 6 , vcWIDTH= 8) (
input       clk,
input       rst,
input [3:0] nC, // 4 bits for the worst case 
input [1:0] T1,
input [4:0] NZQs,
input       start_coeff_token, // ACK to the main controller 


output reg       finish_coeff_token, // ACK to the main controller 

output reg       coeffTokenC3Flag, // A flag for the coeff token code for vlc three which is fixed length

output reg                  fifo_push,
output reg                  fifo_data

    );

//    It's good to make four adresses for optimization t oreduce the mux size 
    // I thinl it will be already reduced due to optimization 


//    Adrres of Num_VLC0 1 bit for nC 2 bits for T1s and 4 bits for  NZQs   

/* 
The output is 8 bits and divided as follow:
4 bit for the length 
and 4 bits for the value but the length is decremented by one means that if 
the length is 16 bits I will represent it as f in hexadecimal 
*/

// also if I have one bit lenght I will represent it as 0 
// special case incase of no thing case it will not happen but I modeled it as 8'h10 and it will be reconized at the decding module to reduce the number of bits 
/*
The input address is as foloow 7 bits {2 bits for the T1s and 5 bits for the total NZQs ranging from }
*/
/*
The comparison in the case statement should be done with specific values,
 not ranges like >= 'd8. You can use specific values to match cases like 'd8, 'd9, etc.,
  but for greater than or equal comparison, you would need to use a separate if condition.
*/

     //////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    //////////////////////////    Internal Signals      \\\\\\\\\\\\\\\\\\\\\
   ///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
reg     [5:0]    coeff_token_data_reg; // Note make the desired size here please 
reg     [7:0]    coeffTokenC;
reg              load_reg_f;
reg     [3:0]    counter;

wire [6:0] addr_calc; 
assign addr_calc = {T1, NZQs};


 /*       vlcOneAddr
          vlcTwoAddr
          vlcThreeAddr
          
          // Thor the inistantiation 

*/
wire   [7:0]  vlcCodeZero;
wire   [7:0]  vlcCodeOne;
wire   [7:0]  vlcCodeTwo;
wire   [5:0]  vlcCodeThree;

// -- Choicing the VLC --

Coeff_Token_Num_Vlc_Zero u0 (
            .addr(addr_calc),
            .vlcCodeZero(vlcCodeZero)        
        );
    
        Coeff_Token_Num_Vlc_One u1 (
            .addr(addr_calc),
            .vlcCodeOne(vlcCodeOne)        
        );         
 
        Coeff_Token_Num_Vlc_Two u2 (
            .addr(addr_calc),
            .vlcCodeTwo(vlcCodeTwo)        
        );          
    
        Coeff_Token_Num_Vlc_Three u3 (
            .addr(addr_calc),
            .vlcCodeThree(vlcCodeThree)        
        );  
    
 always @(*) begin
    if (nC == 0 || nC == 1) begin
       coeffTokenC = vlcCodeZero;
       coeffTokenC3Flag = 1'b0; 
    end
    else if (nC == 2 || nC == 3) begin
      coeffTokenC = vlcCodeOne;
      coeffTokenC3Flag = 1'b0;          
    end   
    else if (nC == 4 || nC == 5 || nC == 6 || nC == 7) begin
       coeffTokenC = vlcCodeTwo;
       coeffTokenC3Flag = 1'b0;      
    end
    else begin
          
           coeffTokenC = vlcCodeThree ;       
           coeffTokenC3Flag = 1'b1;     
    end
end       

    
    
     //////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    ////////////////////////// Assigning the output PIN \\\\\\\\\\\\\\\\\\\\\
   ///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    always @ (posedge clk or negedge rst) begin
    if (!rst) 
        begin
          fifo_push           <= 1'b0;      
          fifo_data <= 1'b0;
          counter                 <=  'b0;
          coeff_token_data_reg <= 'b0;
          finish_coeff_token              <= 1'b0; 
          load_reg_f          <= 1'b0;
        end
    else
        begin 
             if (start_coeff_token && (!load_reg_f) && !coeffTokenC3Flag )
                begin
                    load_reg_f<=1 ;                     
                    coeff_token_data_reg  <=  coeffTokenC [3:0];
 
                end
             else if (start_coeff_token && (coeffTokenC [7:4] > counter) && (load_reg_f) && !coeffTokenC3Flag )
                begin
                    fifo_push            <= 1'b1;  
                    coeff_token_data_reg  <= coeff_token_data_reg >>1;
                    fifo_data <= coeff_token_data_reg [0];
                    counter              <= counter +1;
                end
             else if (start_coeff_token && (coeffTokenC [7:4] == counter) && !coeffTokenC3Flag )
                 begin
                   finish_coeff_token              <= 1'b1;
                   fifo_push                       <= 1'b0;
                   counter                         <= counter +1;
                 end

                 
             else if (!coeffTokenC3Flag)
                 begin
                 // Note OR you can reset this module from the FSM if ypu recieve a finish flag
                   finish_coeff_token      <= 1'b0;
                   load_reg_f              <= 1'b0;
                   fifo_push               <= 1'b0;
                   counter                 <=  'b0;
                   fifo_data <= 1'b0;

                 end                 
        end
end


// for handling the fixed length code if 
always @(posedge clk ) 
begin 
     if (start_coeff_token && (!load_reg_f) && coeffTokenC3Flag )
     begin
         load_reg_f<=1 ;                     
         coeff_token_data_reg  <=  coeffTokenC [5:0];

     end
     else if (start_coeff_token && coeffTokenC3Flag && counter < 'd6 )   // NOTE Check this please
        begin
            counter              <= counter +1;
            fifo_push            <= 1'b1;  
            coeff_token_data_reg  <= coeff_token_data_reg >>1;
            fifo_data <= coeff_token_data_reg [0];
        end 
        
        
        
        // ADD condition here for finish if the output is table 3 
        
        
        
        
     else if (coeffTokenC3Flag)
        begin
        // Note OR you can reset this module from the FSM if ypu recieve a finish flag
          finish_coeff_token      <= 1'b0;
          load_reg_f              <= 1'b0;
          fifo_push               <= 1'b0;
          counter                 <=  'b0;
          fifo_data <= 1'b0;

        end 

end 
    
    
    
    
    
    
endmodule
