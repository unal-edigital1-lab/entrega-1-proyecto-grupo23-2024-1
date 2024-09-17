module control_principal(
	input wire clk,
	input wire reset,
	input wire secondpassed,
	input wire boton_dormir,
	input wire boton_jugar,
	input wire boton_comer,
	input wire test, 
	input wire enfermo_sensor,
	output reg [2:0]hambre,
	output reg [2:0]diversion,
	output reg [2:0]energia,
	output reg dormido,
	output reg [2:0]estado
);

reg [8:0] contador_sueno;
reg [5:0] contador_diversion;
reg [6:0] contador_hambre;
reg [5:0] contador_dormir;

reg [2:0] contador_reset;
reg [2:0] contador_test; 
reg modo;

reg enfermo_control;

wire enfermo;
assign enfermo = enfermo_control | enfermo_sensor;

reg muerte;

initial begin
		hambre <= 3;
		diversion <= 3;
		energia <= 3;
		dormido <= 0;
		contador_sueno <= 0;
      contador_diversion <= 0;
      contador_hambre <= 0;
		contador_dormir <= 0;
		contador_reset <= 0;
		contador_test<= 0;
		modo <= 0;
		enfermo_control <= 0;
		muerte <= 0;
		estado <= 0;
end

localparam FELIZ = 0;
localparam HAMBRIENTO = 1;
localparam CANSADO = 2;
localparam ABURRIDO = 3;
localparam ENFERMO = 4;
localparam DORMIDO = 5;
localparam MUERTO = 6;

always @(*)begin
	if(!modo)begin
		if(!muerte)begin
			if(diversion < 2 & energia < 2 & hambre < 2)begin
				muerte <= 1;
				estado <= 6;
			end
			else begin
				if(enfermo)begin
					estado <= 4;
				end
				else begin
					if(dormido)begin
						estado <= 5;
					end
					else begin
						if(energia < 2)begin
							estado <= 2;
						end
						else begin 
							if(diversion < 2)begin
								estado <= 3;
							end
							else begin 
								if(hambre < 2)begin
									estado <= 1;
								end
								else begin 
									estado <= 0;
								end	
							end	
						end		
					end
				end
			end
		end
		else estado <= 6;
	end
end

always @(posedge secondpassed)begin
		if(reset)begin
			if(contador_reset == 5)begin
				hambre <= 3;
				diversion <= 3;
				energia <= 3;
				dormido <= 0;
				contador_sueno <= 0;
				contador_diversion <= 0;
				contador_hambre <= 0;
				contador_dormir <= 0;
				contador_reset <= 0;
				contador_test<= 0;
				modo <= 0;
				estado <= 0;
				enfermo_control <= 0;
				muerte <= 0;
			end
			else begin
				contador_reset <= contador_reset + 1;
			end
		end
		else begin
			contador_reset <= 0;
			if(test)begin
				if(!modo)begin
					if(contador_test == 5)begin
						modo <= 1;
						contador_test <= 0;
						estado<= 0;
						hambre <= 3;
						diversion <= 3;
						energia <= 3;
						dormido <= 0;
						contador_sueno <= 0;
						contador_diversion <= 0;
						contador_hambre <= 0;
						contador_dormir <= 0;
						contador_reset <= 0;
						enfermo_control <= 0;
						muerte <= 0;
					end
					else begin
						contador_test <= contador_test + 1;
					end
				end
			end
			else begin
				contador_test <= 0;
				if(!modo & !muerte)begin
					if(dormido)begin
						contador_sueno <= 0;
					end 
					else begin
						contador_sueno <= contador_sueno + 1'b1;
					end
		
					contador_diversion <= contador_diversion + 1'b1;
					contador_hambre <=contador_hambre + 1'b1;
					
					if(contador_sueno == 300)begin
						contador_sueno <= 0;
						energia <= energia - 1'b1;
					end
					if(contador_diversion == 60)begin
						contador_diversion <= 0;
						diversion <= diversion - 1'b1;
					end
					if(contador_hambre == 120)begin
						contador_hambre <= 0;
						hambre <= hambre - 1'b1;
					end
				end
			end
		end
end

always @(posedge test)begin
	if(modo)begin
		case (estado)
			0:begin
				hambre <= 1;
				diversion <= 3;
				energia <= 3;
				dormido <= 0;
				enfermo_control <= 0;
				muerte <= 0;
				estado <= 1;
			end
			1:begin
				hambre <= 3;
				diversion <= 3;
				energia <= 1;
				dormido <= 0;
				enfermo_control <= 0;
				muerte <= 0;
				estado <= 2;
			end
			2:begin
				hambre <= 3;
				diversion <= 1;
				energia <= 3;
				dormido <= 0;
				enfermo_control <= 0;
				muerte <= 0;
				estado <= 3;
			end
			3:begin
				hambre <= 3;
				diversion <= 3;
				energia <= 3;
				dormido <= 0;
				enfermo_control <= 1;
				muerte <= 0;
				estado <= 4;
			end
			4:begin
				hambre <= 3;
				diversion <= 3;
				energia <= 2;
				dormido <= 1;
				enfermo_control <= 0;
				muerte <= 0;
				estado <= 5;
			end
			5:begin
				hambre <= 1;
				diversion <= 1;
				energia <= 1;
				dormido <= 0;
				enfermo_control <= 0;
				muerte <= 1;
				estado <= 6;
			end
			6:begin
				hambre <= 3;
				diversion <= 3;
				energia <= 3;
				dormido <= 0;
				enfermo_control <= 0;
				muerte <= 0;
				estado <= 0;
			end
		endcase
	end
end





always @(posedge secondpassed, posedge boton_dormir)begin
	if(!enfermo & (hambre < 2) & !muerte)begin
		if(boton_dormir & !dormido)begin
			dormido <= 1;
			contador_dormir <= 0;
		end
		else begin
			if(dormido & !boton_dormir)begin
				contador_dormir <= contador_dormir + 1'b1;
				if(contador_dormir == 60)begin
					contador_dormir <= 0;
					energia <= energia + 1'b1;
				end
			end
		end
		if (energia == 4)begin
			dormido <= 0;
			contador_dormir <= 0;
		end
	end
	else begin
		dormido <= 0;
		contador_dormir <= 0;
	end
end

always @(posedge boton_comer)begin
	if(hambre < 4 & !muerte)begin
		hambre <= hambre + 1'b1;
		contador_hambre <= 0;
	end
end

always @(posedge boton_jugar)begin
	if(diversion < 4 & !muerte)begin
		diversion <= diversion + 1'b1;
		contador_diversion <= 0;
	end
end





endmodule