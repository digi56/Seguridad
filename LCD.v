`timescale 1ns / 1ps


module LCD	#(parameter core_addr = 'h16) (clk, en, Reset, addr, data_i, isDone, cmd, LCD_RS, LCD_RW, LCD_E, LCD_DATA);


	parameter       k = 18;
	input           clk;  
   input	en;
	input Reset;
   input [15:0] addr;
	input [15:0] data_i;
	input [2:0]	 cmd;
	output reg isDone;
	reg   [k+8-1:0] count=0;
	reg             lcd_stb;
	reg       [5:0] lcd_code;
	reg       [6:0] lcd_stuff;
	reg       [7:0] char_buffer;
	reg				 count_en;	
	output reg      LCD_RS;
	output reg      LCD_RW;
	output reg [3:0]LCD_DATA;
	output reg      LCD_E;
	localparam LCD_INIT = 1;
	localparam SEND_BYTE = 2;
	localparam LINE_2 = 3;
	localparam HOME = 4;
	localparam DESP = 5;
	localparam CLEAR = 6;
	localparam WAIT = 12;
	localparam WRITE1 = 13;
	localparam WRITE2 = 14;
	
	
	
	initial	begin
					count_en = 1;
					LCD_RS 	= 0;
					LCD_RW	= 0;
					LCD_DATA	= 0;
					LCD_E		= 0;
					lcd_code	= 0;
					lcd_stuff= 0;
					lcd_stb	= 0;
					char_buffer	= 0;
					
					
				end
	
	always @ (posedge clk) begin
	
		if (Reset) begin
					count_en <= 0;
					LCD_RS 	<= 0;
					LCD_RW	<= 0;
					LCD_DATA	<= 0;
					LCD_E		<= 0;
					lcd_code	<= 0;
					lcd_stuff<= 0;
					lcd_stb	<= 0;
					char_buffer	= 0;
		end

	
			if(addr == core_addr  && en ) begin
			
			count_en <=1;
			char_buffer = data_i;
			
			end
			else begin
				count <= 0;
				count_en <= 0;
				isDone <=0;
			end
	
			if(count_en)
				count  <= count + 1'b1;
			case(cmd)
						LCD_INIT: begin
							case (count[k+7:k+2])
									//-----------
									0:	lcd_code <= 6'b000011;// power-on initialization
									1: lcd_code <= 6'b000011;
									2: lcd_code <= 6'b000011;
									3: lcd_code <= 6'b000010;
									4: lcd_code <= 6'b000010;        // function set
									5: lcd_code <= 6'b001000;
									6: lcd_code <= 6'b000000;        // entry mode set
									7: lcd_code <= 6'b000110;
									8: lcd_code <= 6'b000000;        // display on/off control
									9: lcd_code <= 6'b001100;
									10: lcd_code <= 6'b000000;        // Cursor On
									11: lcd_code <= 6'b001111;        
									12: lcd_code <= 6'b000000;			// display on/off control
									13: lcd_code <= 6'b000001;
									//14: lcd_code <= 6'b100100;	//F de prueba
									//15: lcd_code <= 6'b100111;
									14: begin
											count_en <= 0;
											isDone <= 1 ;
											count <= 0;
										 end
										endcase 
								end		// LCD init ends
						SEND_BYTE:	begin
						
						case (count[k+7:k+2])
									0: lcd_code <= {1'b1, 1'b0, char_buffer[7:4]};
									1: lcd_code <= {1'b1, 1'b0, char_buffer[3:0]};
									2: begin
											count_en <= 0;
											isDone <= 1 ;
											count <= 0;
										 end
										endcase 
						end
						LINE_2:	begin
						
						case (count[k+7:k+2])
									0: lcd_code <= 6'b001100;
									1: lcd_code <= 6'b000000;
									2: begin
											count_en <= 0;
											isDone <= 1 ;
											count <= 0;
										 end
										endcase 
						end
						HOME:	begin
						
						case (count[k+7:k+2])
									0: lcd_code <= 6'b000000;
									1: lcd_code <= 6'b000010;
									2: begin
											count_en <= 0;
											isDone <= 1 ;
											count <= 0;
										 end
										endcase 
						end
						DESP:	begin
						
						case (count[k+7:k+2])
									0: lcd_code <= 6'b000001;
									1: lcd_code <= 6'b000100;
									2: begin
											count_en <= 0;
											isDone <= 1 ;
											count <= 0;
										 end
										endcase 
						end
						CLEAR:	begin
						
						case (count[k+7:k+2])
									0: lcd_code <= 6'b000000;
									1: lcd_code <= 6'b000001;
									2: begin
											count_en <= 0;
											isDone <= 1 ;
											count <= 0;
										 end
										endcase 
						end
								
						endcase
		lcd_stb <= ^count[k+1:k+0];  // clkrate / 2^(k+2)
		lcd_stuff <= {lcd_stb,lcd_code};
		{LCD_E,LCD_RS,LCD_RW,LCD_DATA[3],LCD_DATA[2],LCD_DATA[1],LCD_DATA[0]} <= lcd_stuff;
	end
endmodule
