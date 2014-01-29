`timescale 1ns / 1ps
/*
Modulo que se encarga de comparar dos tipos de claves y determinar si son iguales
*/
module comparador
	(reset, data_i, cmd, data_o);
	//Registros del bloque
	input reset;
	//Registros Procesador
   input [15:0] data_i;
	input [2:0] cmd;
   output reg data_o;
	//Registros internos
	reg [15:0] claveA_Reg;
	reg [15:0] claveB_Reg;
	integer i;
	//Parametros internos
	localparam CLAVE1=1;
	localparam CLAVE2=2;
	localparam COMPARAR=3;
	localparam CLAVES_IGUALES=1;
	localparam CLAVES_DIFERENTES=0;

	initial begin
		data_o = 0;
	end

	always@(cmd) begin
		if(reset) begin
			claveA_Reg <= 1;
			claveB_Reg <= 0;
		end else begin
			case(cmd)
				CLAVE1:
					begin
						for(i=0; i<16; i=i+1) begin
							claveA_Reg[i] <= data_i[i];
						end
					end
				CLAVE2:
					begin
						for(i=0; i<16; i=i+1) begin
							claveB_Reg[i] <= data_i[i];
						end
					end
				COMPARAR: 
					begin
						if(claveA_Reg==claveB_Reg)begin
							data_o = CLAVES_IGUALES;
						end 
						else begin
							data_o = CLAVES_DIFERENTES;
							//i=17;
						end
					end
				default:;
			endcase
		end
	end
endmodule
