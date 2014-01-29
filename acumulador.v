`timescale 1ns / 1ps
/*
Modulo que se encarga de acumular las teclas presionadas desde el teclado en un registro de memoria.
cmd_o[terminar,limpiar,asterisco]
*/
module acumulador
	(reset, data_i, data_o,  cmd_o, cmd_i);

	//Registros del bloque
	input reset;
	//Registros Conexion
   input [6:0] data_i;
	input cmd_i;
   output reg [31:0] data_o;
   output reg [2:0] cmd_o;
	//Registros internos
	reg [31:0] claveA_Reg;
	reg [3:0] posicion;
	//Parametros internos
	localparam LIMPIAR=127;
	localparam TERMINAR=13;

	initial begin
		posicion = 0;
		claveA_Reg = 0;
		cmd_o = 0;
		data_o = 0;
	end

	always@(data_i) begin		
		if (reset) begin
			data_o <= 0;
			cmd_o <= 0;
			claveA_Reg <= 0;
			posicion = 0;
		end else begin
			if (data_i >= 48 && data_i <= 57) begin//0-9
				claveA_Reg <= (claveA_Reg<<8) | {1'b0,data_i};
				cmd_o <= (cmd_o|3'b001);
				if (posicion<3) begin
					posicion = posicion+1;
				end else begin
					posicion = 3;
				end
			end else begin
				case(data_i)
					LIMPIAR:
						begin
							claveA_Reg <= 0;
							posicion = 0;
							cmd_o <= (cmd_o|3'b010);
						end
					TERMINAR:
						begin
							if (posicion == 3) begin
								data_o <= claveA_Reg;
								posicion = 0;
								cmd_o <= (cmd_o|3'b100);
							end
						end
					default:;
				endcase
			end
		end
		if (cmd_i)
			cmd_o <= 0;
	end
endmodule
