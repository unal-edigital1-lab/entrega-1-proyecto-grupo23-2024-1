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
	output reg [2:0]estado,
	output reg modo
);

reg [10:0] contador_sueno;
reg [10:0] contador_diversion;
reg [10:0] contador_hambre;
reg [10:0] contador_dormir;


reg [35:0] contador_reset;
reg [35:0] contador_test; 
reg dormido;
reg enfermo_control;

wire enfermo;
assign enfermo = enfermo_control | enfermo_sensor;

reg muerte;

reg flag_jugar;
reg flag_dormir;
reg flag_time;
reg flag_comer;
reg flag_test;

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
		flag_jugar <= 0;
		flag_dormir <= 0;
		flag_time <= 0;
		flag_comer <= 0;
		flag_test <= 0;
end

localparam FELIZ = 0;
localparam HAMBRIENTO = 1;
localparam CANSADO = 2;
localparam ABURRIDO = 3;
localparam ENFERMO = 4;
localparam DORMIDO = 5;
localparam MUERTO = 6;

always @(*)begin
		if(!muerte)begin
			if(diversion < 2 & energia < 2 & hambre < 2)begin
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

always@(posedge clk)begin
	if(secondpassed)begin
		flag_time <= 1;
		if(!flag_time)begin
			if (!modo & !muerte)begin
			
				if(contador_diversion<60)begin
					contador_diversion <= contador_diversion + 1'b1;
				end
				else begin
					contador_diversion <= 0;
					if(diversion > 0)diversion <= diversion-1'b1;
				end
				
				if(contador_sueno<300)begin
					contador_sueno <= contador_sueno + 1'b1;
				end
				else begin
					contador_sueno <= 0;
					if(energia > 0)energia <= energia-1'b1;
				end
				
				if(contador_hambre<120)begin
					contador_hambre <= contador_hambre + 1'b1;
				end
				else begin
					contador_hambre <= 0;
					if(hambre > 0)hambre <= hambre-1'b1;
				end
				
				if(dormido)begin
					if(energia == 4)dormido <= 0;
					if(hambre <2)dormido <= 0;
					if(contador_dormir < 60)begin
						contador_dormir <= contador_dormir+ 1;
					end
					else begin
						contador_dormir <= 0;
						contador_sueno <= 0;
						if(energia < 4)energia <= energia + 1;
					end
				end
				else begin
					contador_dormir <= 0;
				end
				
				if(estado == 6)muerte <= 1;
			end
		end
	end
	else begin
		flag_time <= 0;
	end
	
	if(reset)begin
		if(contador_reset >= 250000000)begin
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
			flag_jugar <= 0;
			flag_dormir <= 0;
			flag_time <= 0;
			flag_comer <= 0;
			flag_test <= 0;
		end
		else begin
			contador_reset <= contador_reset + 1;
		end
	end
	else begin
		contador_reset <= 0;
	end
	
	if(boton_comer)begin
		flag_comer <= 1;
		if(!flag_comer& !modo &!muerte)begin
			if(hambre < 4)hambre <= hambre + 1;
			dormido <= 0;
		end
	end
	else begin
		flag_comer <= 0;
	end
	
	if(boton_jugar)begin
		flag_jugar <= 1;
		if(!flag_jugar& !modo &!muerte)begin
			if(diversion < 4)diversion <= diversion + 1;
			dormido <= 0;
		end
	end
	else begin
		flag_jugar <= 0;
	end
	
	if(boton_dormir)begin
		flag_dormir <= 1;
		if(!flag_dormir& !modo&!muerte)begin
			if(dormido)begin
				dormido <= 0;
			end
			else begin
				if(hambre > 1) dormido <= 1;
			end
			
		end
	end
	else begin
		flag_dormir <= 0;
	end
	
	if(!modo)begin
		if(test)begin
			if(contador_test == 250000000)begin
				hambre <= 4;
				diversion <= 4;
				energia <= 4;
				dormido <= 0;
				contador_test<= 0;
				modo <= 1;
				enfermo_control <= 0;
				muerte <= 0;
			end
			else begin
				contador_test <= contador_test + 1;
			end
		end
		else begin
			contador_test <= 0;
		end
	end
	
	if(test)begin
		flag_test <= 1;
		if(!flag_test & modo)begin
			case(estado)
			0:begin
				hambre <= 1;
				diversion <= 4;
				energia <= 4;
				dormido <= 0;
				enfermo_control <= 0;
				muerte <= 0;
			end
			1:begin
				hambre <= 4;
				diversion <= 4;
				energia <= 1;
				dormido <= 0;
				enfermo_control <= 0;
				muerte <= 0;
			end
			2:begin
				hambre <= 4;
				diversion <= 1;
				energia <= 4;
				dormido <= 0;
				enfermo_control <= 0;
				muerte <= 0;
			end
			3:begin
				hambre <= 2;
				diversion <= 2;
				energia <= 2;
				dormido <= 0;
				enfermo_control <= 1;
				muerte <= 0;
			end
			4:begin
				hambre <= 3;
				diversion <= 3;
				energia <= 3;
				dormido <= 1;
				enfermo_control <= 0;
				muerte <= 0;
			end
			5:begin
				hambre <= 0;
				diversion <= 0;
				energia <= 0;
				dormido <= 0;
				enfermo_control <= 0;
				muerte <= 1;
			end
			6:begin
				hambre <= 4;
				diversion <= 4;
				energia <= 4;
				dormido <= 0;
				enfermo_control <= 0;
				muerte <= 0;
			end
			endcase
		end
	end
	else begin
		flag_test <= 0;
	end

	
end

endmodule





