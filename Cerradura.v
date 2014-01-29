`timescale 1ns / 1ps


module Cerradura #(parameter core_addr = 'h16) (clk, en, Reset, addr, isDone, cmd, switch, cerr);

	input           clk;  
   input	en;
	input Reset;
   input [15:0] addr;
	input [2:0]	 cmd;
	input switch;
	reg[30:0] count;
	output reg isDone;
	output reg cerr;
	parameter k=150000000;
	localparam MANUAL = 1;
	localparam AUTOMATIC = 2;
	
	
	initial	begin
					cerr 	= 0;
					count = 0;
				end
	
	always @ (posedge clk) begin
	
		if (Reset) begin
					cerr <= 0; 
		end
		
		if (switch) begin
		
			cerr<=1;
			if (count == k) begin
				count = 0;
				cerr <= 0;
				isDone = 1;
			end
			else count = count + 1'b1;

		end
	
		if(addr == core_addr  && en ) begin
			
				cerr<=1;
				if (count == k) begin
					cerr <= 0;
					count = 0;
					isDone = 1;
				end
				else count = count + 1'b1;
							
		end
		
		if (count > 0) begin
			cerr<=1;
				if (count == k) begin
					cerr <= 0;
					count = 0;
					isDone = 1;
				end
				else count = count + 1'b1;
		end
	end
endmodule
