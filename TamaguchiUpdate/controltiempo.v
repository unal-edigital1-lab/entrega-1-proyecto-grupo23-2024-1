module controltiempo(
	input clk,
	input reset,
	input boton_acelerar,
	output reg secondpassed
);

reg [35:0]contador;
wire [35:0]limite;

initial begin
	contador <= 0;
	secondpassed <= 0;
end

assign limite = (boton_acelerar)?'d2000000:'d25000000;

always@(posedge clk, posedge reset)begin
	if(reset)begin
		contador <= 0;
		secondpassed <= 0;
	end
	else begin	
		if(contador > limite)begin
			secondpassed <= ~secondpassed;
			contador <= 0;
		end
		else begin
			contador <= contador + 1;
		end
		
	end
end


endmodule