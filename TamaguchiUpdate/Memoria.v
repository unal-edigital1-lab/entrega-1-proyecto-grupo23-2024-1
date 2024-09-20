module Memoria(
input clk,
input rst,
input [2:0]adress,
input [7:0]contador_pixel,
output reg[15:0]pixel
);

reg [15:0] memoria_estado_0[0:168];
reg [15:0] memoria_estado_1[0:168];
reg [15:0] memoria_estado_2[0:168];
reg [15:0] memoria_estado_3[0:168];
reg [15:0] memoria_estado_4[0:168];
reg [15:0] memoria_estado_5[0:168];
reg [15:0] memoria_estado_6[0:168];

initial begin
	pixel <= 0;
	$readmemh("1.txt", memoria_estado_0);
	$readmemh("2.txt", memoria_estado_1);
	$readmemh("3.txt", memoria_estado_2);
	$readmemh("4.txt", memoria_estado_3);
	$readmemh("5.txt", memoria_estado_4);
	$readmemh("6.txt", memoria_estado_5);
	$readmemh("7.txt", memoria_estado_6);
end

always@(*)begin
	if(rst)begin
		pixel <= 0;
	end
	else begin
		case(adress)
			0:pixel <= memoria_estado_0[contador_pixel];
			1:pixel <= memoria_estado_1[contador_pixel];
			2:pixel <= memoria_estado_2[contador_pixel];
			3:pixel <= memoria_estado_3[contador_pixel];
			4:pixel <= memoria_estado_4[contador_pixel];
			5:pixel <= memoria_estado_5[contador_pixel];
			6:pixel <= memoria_estado_6[contador_pixel];
		endcase
	end
end

endmodule