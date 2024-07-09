
module Run_Before_Controller #(parameter  DATA_WIDTH = 9 , NZQ_WIDTH = 5 , STATE_WIDTH = 4)(

    // clk and reset 
    input                                 clk,
    input                                 rst,
    
    // OUTSIDE CONTROLLER & ACK 
    input                                 start_run_before  ,
    output reg                            finish_run_before ,

    //  
    input             [NZQ_WIDTH-1:0]     NZQ,
    input             [3:0]               total_zeros_num,

    // IO WITH INPUT FIFO (HOLDING MB DATA) 
    // IO WITH INPUT BRAM (HOLDING MB DATA) 
    output wire        [3:0]               BRAM_addr,
    output reg                             BRAM_read_en,
    input signed      [DATA_WIDTH-1:0]     mb_BRAM_data,


    // DATA                                                                                     
    output   [3:0]   run_before,                                                                 
    output   [2:0]   zeros_left,             // the maximum value for the zeros_left is 7.       
                                                                                                
    // DATA CONTROLLER & ACK                                                                 
    output  reg      run_before_data_start,                                                           
    input            finish_data

    );
    
    /*
    1) If there are no more zeros left to encode, i.e. 6[run before] = TotalZeros, it is not necessary
    to encode any more run before values.
    
    2) It is not necessary to encode run before for the final or lowest frequency non-zero.
    coefficient.
    
    3) Use the three always block type for the FSM.
    */
    
//  \\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////
//                    Internal Signals                        \\
////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
           
      reg        [STATE_WIDTH -1 :0] current_state, next_state;
      
      reg        [NZQ_WIDTH -1:0]    NZQ_reg , NZQ_next ;
      reg        [NZQ_WIDTH -1:0]    run_counter_reg, run_counter_next;
      reg                            first_element_reg , first_element_next ;
      reg        [3:0]               BRAM_addr_reg, BRAM_addr_next;
      reg        [2:0]               zeros_left_reg,zeros_left_next;
      reg                            first_adrr;
   localparam  
            IDLE                 = 3'b000 ,
            GET_NEXT             = 3'b001 ,
            CHECK_ZERO           = 3'b010 ,  
            TRAILING_ONE_SIGNM   = 3'b011 ,  
            LEVELS               = 3'b100 ,  
            TOTAL_ZEROS          = 3'b101 ,  
            RUN_OF_ZEROS         = 3'b110 ;
    
    
//  \\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////
//                    Next state logic                       \\
////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\   
    always@(*) begin
    // Give an initial value for all the outputs
            BRAM_addr_next      = BRAM_addr_reg;
            first_element_next  = first_element_reg; // must be reg
            next_state = current_state; 
            BRAM_read_en = 1'b0;
            run_counter_next = run_counter_reg;
            run_before_data_start = 1'b0;
            finish_run_before = 1'b0;
            zeros_left_next   = zeros_left_reg;
            NZQ_next          = NZQ_reg;
            first_adrr            = 1'b0;
            case(current_state)             
            
                'd0: begin // IDLE STATE
                       
                       BRAM_addr_next        =  'b0;
                       first_element_next    = 1'b0;
                       BRAM_read_en          = 1'b0;
                       run_counter_next      =  'b0;
                       run_before_data_start = 1'b0;
                       finish_run_before     = 1'b0;
                       zeros_left_next       = total_zeros_num;
                       NZQ_next              = NZQ;
                       first_adrr            = 1'b1;
                       if (start_run_before)
                         begin
                          next_state = 'd1;
                          end 
                        else 
                          next_state = 'd0;
                    end            
                'd1: begin // get _next element
                            BRAM_read_en = 1'b1;
                            next_state = 'd2;
                            // for making the first adrees from zero 
                            if (first_adrr)
                              BRAM_addr_next = 'b0;
                            else
                              BRAM_addr_next = BRAM_addr_next +1;
                            
                    end 
                'd2: begin  // Check if the element is zero
                        BRAM_read_en = 0;
                        if(mb_BRAM_data == 'b0 && !first_element_reg) begin
                            next_state = 'd1;
                        end
                       else if(mb_BRAM_data == 'b0 && first_element_reg) begin
                            next_state = 'd1;
                            run_counter_next = run_counter_reg +1 ; 
                        end
                        else begin
                               NZQ_next = NZQ_reg +1;
                               if (!first_element_reg) 
                                 begin
                                   first_element_next = 1'b1;
                                   next_state = 'd1;
                                 end
                               else
                                 begin
                                   next_state = 'd3;
                                 end
                             end  
                    end

                'd3: begin // Excuting the run before and the zeros left 
                       run_before_data_start = 1'b1;
                       if (finish_data)
                         begin
                           next_state = 'd4;
                           run_before_data_start = 1'b0;
                           zeros_left_next = zeros_left_reg - run_counter_reg ; 
                         end
                       else 
                         next_state = 'd3;
                         
                      end

                'd4: begin // update the zeros left 
                       
                       if (zeros_left_next == 'b0)
                         begin
                           finish_run_before = 1'b1;
                           next_state = 'd0;         
                         end                  
                      else if (zeros_left_next > 3'd7)
                        begin
                          zeros_left_next = 3'd7;
                          next_state = 'd5;
                        end
                       else 
                         zeros_left_next = zeros_left_reg ;  
                         next_state = 'd5;              
                     end         
                     
                'd5: begin // check the last element to not make any thing for it 
                          if (NZQ_next == (NZQ - 1'b1))
                            begin
                              finish_run_before = 1'b1;
                              next_state = 'd0; 
                            end
                          else 
                            begin
                              next_state = 'd1; 
                            end
                          
                     end                          
                default: begin
                      // BUT A DEFAULT VALUES FOR ALL THE OUTPUTS HERE 
                           next_state = 'd0;
                      end    
            endcase
      end
    
//  \\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////
//                   Current State                             \\
////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\     
    
    always @ (posedge clk or negedge rst)
    begin
    if (!rst)
      begin      
          current_state   <= 'b0;          
     end
    else
        begin
        current_state <= next_state;
        end
end


// Register the inputs and intermediate registers
    always @ (posedge clk or negedge rst)
    begin
    if (!rst)
      begin         
          NZQ_reg             <= 'b0;; // NOTE this line need to be modified 
          first_element_reg   <= 1'b0;
          

      end
    else
        begin 
          NZQ_reg             <= NZQ_next; 
          first_element_reg   <= first_element_next; 
          

        end
    end

//  \\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////
//                   Output Logic                             \\
////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\  

// we don't have to register all the output only the things I want to register
    always @ (posedge clk or negedge rst)
    begin
        if (!rst)
            begin        
              BRAM_addr_reg       <= 'b0;
              run_counter_reg     <= 'b0;          
              zeros_left_reg      <= total_zeros_num;
            end
        else
            begin
              BRAM_addr_reg       <= BRAM_addr_next;   
              run_counter_reg     <= run_counter_next;          
              zeros_left_reg      <= zeros_left_next ;             
            end
    end


  //  run_before_data_start     this output is activated in the FSM 
  //  finish_run_before         this output is activated in the FSM 
  //  BRAM_read_en             this output is activated in the FSM 
  
   assign BRAM_addr   = BRAM_addr_reg;
   assign run_before  = run_counter_reg ; 
   assign zeros_left  = zeros_left_reg;
endmodule