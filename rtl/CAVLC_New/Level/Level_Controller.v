module Level_Controller #(parameter DATA_WIDTH = 9 , STATE_WIDTH = 4, NZQ_WIDTH = 5)(
    input                                 clk,
    input                                 rst,
    
    // OUTSIDE CONTROLLER & ACK 
    input                                 start_levels,
    output reg                            finish_levels,

    // MUX CONTROL TO CONTROL THE OUTPUT BETWEEN PREFIX AND SUFFIX BLOCKS
    output reg                            output_mux,
    
    // PREFIX AND SUFFIX BLOCKS CONTROL LINES & ACKs
    output reg                            prefix_start,
    output reg                            suffix_start,
    output reg                            prefix_start_out,
    output reg                            suffix_start_out,
    input                                 prefix_finish,
    input                                 suffix_finish,
    

    // IO WITH INPUT FIFO (HOLDING MB DATA)
    output reg                            mb_bram_en,
    output reg        [3:0]               mb_bram_address,
    input signed      [DATA_WIDTH-1:0]    mb_bram_data,
    
    // INPUT DATA FROM PREVIOUS STAGES
    input             [NZQ_WIDTH-1:0]     NZQ,
    input             [1:0]               T1s,
    
    // OUTPUT DATA TO PREFIX AND SUFFIX BLOCKS
    output reg        [2:0]               suffix_len,
    output reg signed [DATA_WIDTH:0]     level_code				
    );     
    
    
    //  \\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////
    //                    Internal Signals                        \\
    ////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
           
   reg        [STATE_WIDTH -1 :0] current_state, next_state;        
   reg        [1:0]               T1s_counter_reg;
   reg        [4:0] ele_counter;
	reg        first_addr;
	reg        first_element;
			  
	always@(posedge clk, negedge rst) begin
		if(!rst) begin
			first_addr			<= 'b1;
			first_element 		<= 'b1;
			next_state			<= 'd0;
			T1s_counter_reg	<=	T1s;
			finish_levels		<='b0;
			output_mux  		<= 'b0;
			prefix_start  		<= 'b0;
			suffix_start  		<= 'b0;
			prefix_start_out  <= 'b0;
			suffix_start_out  <= 'b0;
			mb_bram_en  		<= 'b0;
			mb_bram_address  	<= 'b0;
			suffix_len			<= 'b0;
			level_code			<= 'b0;
			ele_counter			<= 'b0;
		end else begin
			case(current_state)
				'd0: begin	// IDLE State
					if(start_levels) begin
						next_state	<= 'b1;
						T1s_counter_reg	<=	T1s;
					end else begin
						next_state	<= 'b0;
					end
				end
				
				'd1: begin	// get_next_element State
					mb_bram_en <= 1'b1;
               next_state <= 'd2;
               // for making the first adrees from zero 
					if (first_addr) begin
						mb_bram_address <= 'b0;
						first_addr   <= 1'b0;
					end
					else begin
						mb_bram_address <= mb_bram_address +1;
					end
				end
				
				
				'd2: begin		// Handling Zeros, T1s and first elements
					if(mb_bram_data == 'b0) begin // Skip zero
						next_state <= 'd1;
					end else begin
						ele_counter <= ele_counter + 'd1;
						 if((T1s_counter_reg == 0) && (first_element  == 1'b1)) begin
							  next_state <= 'd3;
						 end
						 // this will handle the levels
						 else if ((T1s_counter_reg == 0) && (first_element  == 1'b0)) begin
								next_state <= 'd4;                        
						 end
						 else begin
							  next_state <= 'd1;
							  T1s_counter_reg  <= T1s_counter_reg  - 1;
						 end
					end
				end
				
				'd3: begin
					first_element <= 'b0;
					next_state    <= 'd5;
					if ((NZQ > 4'd10) &&  (T1s < 2'd3)) begin
					  suffix_len    <= 1'b1;
					end
					else begin
					  suffix_len  <= 1'b0;
					end
					
					if (T1s <2'd3) begin                           
						 if (mb_bram_data > 'b0) begin
							level_code <=  ( 1 <<< mb_bram_data ) -4;
						 end
						 else begin
							level_code <= - ( 1<<< mb_bram_data) -3;
						 end                                                                             
					end                        
					else begin 
					
						 if (mb_bram_data > 'b0) begin
							level_code <=  ( 1 <<< mb_bram_data ) -2;
						 end
						 else begin
							level_code <= - ( 1<<< mb_bram_data) -1;
						 end
					end
				end
				
				'd4: begin // calculating the suffix length for the next elements
                        next_state = 'd5;
                         if(suffix_len == 0) begin
                            suffix_len <= suffix_len + 'd1;
                         end
                         
                        if(mb_bram_data[7:0] > (((suffix_len - 1) << 'd3) & (suffix_len < 'd6)) ) begin
                            suffix_len <= suffix_len + 'd1;
                        end
                      end
                      
                'd5: begin  //   calculating i_level code 
                       
                        next_state <= 'd6;
                            if (mb_bram_data > 'b0) begin
										level_code <=  ( 1 <<<mb_bram_data ) -2;
                            end
                            else begin
										level_code <= - ( 1<<<mb_bram_data) -1;
                            end
                      end
                'd6: begin  //   start excution
                            next_state <= 'd7;
                            prefix_start     <= 'b1;
                            suffix_start     <= 'b1;
                      end
                'd7: begin  //   wait until end 
                          if (prefix_finish && suffix_finish)
                            next_state <= 'd8;
                          else
                            next_state <= 'd7;                          
                      end                 
                      
                'd8: begin  //   start output prefix
                        output_mux <= 0;
                        if(prefix_finish) begin
                            next_state <= 'd9;
                        end
                      end                           
            
                'd9: begin  //   start output suffix 
                        output_mux <= 1;
                        if(suffix_finish) begin
                            next_state <= 'd10;
                        end
                      end
                      
                'd10: begin  //   if last elemnt raise the finish flag
                        if(ele_counter < NZQ) begin
                            next_state <= 'd1;
                        end
                        else begin
                            next_state <= 'd0;  // IDLE STATE
									 finish_levels <= 'd1;
                        end
                      end
			endcase
		end
	end	
	
	always@(negedge clk, negedge rst) begin
		if(!rst) begin
			current_state <= 'b0;
		end else begin
			current_state <= next_state;
		end
	end	
	
	
			  
endmodule