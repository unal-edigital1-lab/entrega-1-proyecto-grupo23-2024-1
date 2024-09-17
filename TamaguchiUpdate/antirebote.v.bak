module debounce (
    input boton,
    input clk,
    output reg botondebounced               
);

reg previous;
reg[21:0] contador;//conteo hasta 1.500.000

wire compare;
wire buttonneg; //prueba para botones normalmente abiertos


initial begin
	previous <= 0;
	contador <= 0;
	botondebounced <= 0;
end

assign buttonneg = ~boton;

assign compare = previous^buttonneg;





always @(posedge clk)begin
	if(contador == 0)begin
		if(compare == 1)begin
			previous <= buttonneg;
			contador <= 2500000;
			botondebounced <= buttonneg;
		end
	end
	else begin
		contador <= contador - 1'b1;
	end
end
endmodule