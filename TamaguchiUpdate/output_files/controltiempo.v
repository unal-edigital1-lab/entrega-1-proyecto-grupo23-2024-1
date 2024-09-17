module controltiempo(
	input clk,
	input reset,
	input boton_acelerar,
	output reg secondpassed
);

reg [25:0]contador;
reg [25:0]limite;

initial begin
	contador <= 0;
	secondpassed <= 0;
	limite <= 50000000;
end

always@(*)begin
	if(boton_acelerar) limite <= 1000000;
	else limite <= 50000000;
end

always@(posedge clk, posedge reset)begin
	if(reset)begin
		contador <= 0;
		secondpassed <= 0;
		limite <= 50000000;
	end
	else begin
		if(contador > limite)begin
			secondpassed <= 1;
			contador <= 0;
		end
		else begin
			contador <= 0;
			secondpassed <= 0;
		end
	end
end

endmodule