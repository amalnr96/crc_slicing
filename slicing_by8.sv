// Company           :   tud                      
// Author            :   naam21            
// E-Mail            :   <email>                    
//                    			
// Filename          :   mem_ctrl.v                
// Project Name      :   prz    
// Subproject Name   :   task    
// Description       :   <short description>            
//
// Create Date       :   Fri Jul 21 05:21:46 2023 
// Last Change       :   $Date$
// by                :   $Author$                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module mem_ctrl (
         input wire clk, input wire rst,
         //core 
         input wire [31:0] data_in,output reg [31:0] data_out,
         input wire [15:0] mem_adr, input wire core_en, input wire core_w_en,input wire [1:0] size,
         //ext        
		 output reg i_bus_en,output reg i_bus_we,output reg i_bus_rdy_ex, output reg[15:0] i_bus_addr, output reg[31:0] i_bus_write_data, 
		 input [31:0] o_bus_read_data,
         //pram         
		 output reg pram_en,output reg pram_w_en,output reg adr_p_mem,output reg pram_data_in,input pram_data_out,output reg bm_sel);
   
  
   
 
    reg             bm_cal;
    
    
    reg   [1:0]      current_state;
    reg   [1:0]      next_state;
    
    localparam IDLE   = 2'b00;
    localparam PRAM   = 2'b01;
    localparam EXMEM  = 2'b10;
    localparam INIT   = 2'b11;
    
    

   always @(posedge clk or negedge rst) begin
        if (!rst) begin
            	    current_state    <= IDLE ;
            end

        else 
                    current_state    <=  next_state;    
         end
  
  
    always @ ( * ) begin
		next_state = current_state; 
        case(current_state)
 	        IDLE: begin
	             if (core_en) begin
		              if (|mem_adr[15:14]) 
                        next_state    =  EXMEM;
                      else 
                        next_state    =  PRAM;
		         end
	        end
        
            PRAM: begin
	    	  
		          adr_p_mem       =  mem_adr;
                  pram_en         =  core_en;
                  pram_w_en       =  core_w_en;
                  pram_data_in    =  data_in;
                  i_bus_en        =  1'b0;
		       
		        if (size == 2'b10) 
                    bm_cal = 32'hffff_ffff;
            	else if   (size == 2'b01 && (mem_adr[0] | mem_adr[1]))  
                    bm_cal = 32'hffff_0000;
            	else if   (size == 2'b01 && (!(mem_adr[0] | mem_adr[1]))) 
                    bm_cal = 32'h0000_ffff;       
            	else  if  (size == 2'b00 && (!(mem_adr[0])) && (!(mem_adr[1])))  
                    bm_cal = 32'h0000_00ff;
            	else if   (size == 2'b00 && (mem_adr[0]) && (!(mem_adr[1])))
                    bm_cal = 32'h0000_ff00;
            	else if   (size == 2'b00 && (!(mem_adr[0])) && (mem_adr[1]))
                    bm_cal = 32'h00ff_0000;
            	else if   (size == 2'b00 && (mem_adr[0]) && (mem_adr[1]))
                    bm_cal = 32'hff00_0000;
                pram_data_in    =  data_in;
                next_state    =  IDLE; 
            end

            EXMEM: begin
	    	   
                  pram_en          =  1'b0;
                  i_bus_we         =  core_w_en;
                  i_bus_en         =  core_en;
                  i_bus_addr       =  mem_adr;
                  i_bus_write_data =  data_in;
                  next_state       =  IDLE;
            end
        endcase
    end

    
 //pram
 assign bm_sel		 = bm_cal;   
 
 

/* 
 //external
 assign i_bus_we         = ex_w_en_q;
 assign i_bus_en         = ex_en_q;
 assign i_bus_addr       = mem_adr_q;
 assign i_bus_write_data = data_in;
// assign i_bus_rdy_ex     = bus_rdy_q;
 //assign i_bus_read_data = 
 //assign o_ack
 //assign i_bus_access_size
 */
 assign data_out     = (|mem_adr[15:14])? pram_data_out:0;

endmodule

