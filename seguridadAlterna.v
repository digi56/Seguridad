`timescale 1ns / 1ps
module seguridadAlterna(clk, reset, addr, data_i, en, isDone, cmd, data_o, Columna, Fila); 
//module seguridadAlterna(clk, reset, addr, data_i, en, isDone, cmd, data_o, ascii);    
	parameter core_addr = 'h16;
	

	//Registros del bloque
	input clk;
	input reset;
	//Registros Procesador
   input [15:0] addr;
   input [15:0] data_i;
	input en;
	input [3:0] cmd;
   output reg isDone;
   output reg [15:0] data_o;
	input [3:0]Columna; 
	output [3:0] Fila;
	//input [6:0] ascii;
	//Registros internos
	//wire [6:0] ascii;
	wire isDone_teclado;
	
	wire [31:0] claveTeclado;

	reg [15:0] dataIn_Comp;
	wire dataOut_Comp;
	wire [2:0] cmdOut_Comp;
	reg [2:0] cmdComp;
	reg [1:0] regComp;
	reg cmdIn_Comp;
	//Parametros internos
	localparam CLAVE_H = 1;
	localparam CLAVE_L = 2;
	localparam COINCIDEN = 3;
	localparam INFORMAR = 4;
	reg [2:0] i;
	//Submodulos
	Top_Teclado top_teclado (.clk50(clk), .ascii(ascii), .Columna(Columna), .isDone(isDone_teclado), .Fila(Fila));
	acumulador acc (.reset(reset), .data_i(ascii), .data_o(claveTeclado), .cmd_o(cmdOut_Comp), .cmd_i(cmdIn_Comp) );
	comparador comp(.reset(reset), .data_i(dataIn_Comp), .cmd(cmdComp), .data_o(dataOut_Comp));

	initial begin
		isDone = 0;
		data_o = 0;
		cmdIn_Comp = 0;
		dataIn_Comp = 0;
		i = 0;
		cmdComp = 0;
		regComp = 0;
	end

	always@(clk) begin
		if (en && (addr==core_addr)) begin
			cmdIn_Comp <= 0;
			isDone <= 0;
			case(cmd)
				CLAVE_H:
					begin
						case(i)
							0:begin
								cmdComp <= 1;
								dataIn_Comp <= data_i;
								i=i+1;
							end
							1:begin
								cmdComp <= 2;
								dataIn_Comp <= claveTeclado[31:16];
								i=i+1;
							end
							2:begin
								cmdComp <= 3;
								regComp[0] <= dataOut_Comp;
								i=0;
								isDone <= 1;
							end
						endcase
					end
				CLAVE_L:
					begin
						case(i)
							0:begin
								cmdComp <= 1;
								dataIn_Comp <= data_i;
								i=i+1;
							end
							1:begin
								cmdComp <= 2;
								dataIn_Comp <= claveTeclado[15:0];
								i=i+1;
							end
							2:begin
								cmdComp <= 3;
								regComp[1] <= dataOut_Comp;
								i=0;
								isDone <= 1;
							end
						endcase
					end
				COINCIDEN:
					begin
						data_o <= {regComp[0]&&regComp[1]};
						isDone <= 1;
					end
				INFORMAR:
					begin
						data_o <= cmdOut_Comp;
						isDone <= 1;
						cmdIn_Comp <= 1;
					end
			endcase
		end
	end
endmodule
