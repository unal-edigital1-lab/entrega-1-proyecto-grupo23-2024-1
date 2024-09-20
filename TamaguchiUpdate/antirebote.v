module antirebote (
    input boton,
    input clk,
    output reg rebotado             
);

reg previo; //valor previo del boton
reg[21:0] contador;//conteo hasta 50ms




initial begin
	previo <= 0;
	contador <= 0;
	rebotado <= 0;
end




always @(posedge clk)begin
	if(contador == 2500000)begin
		if(boton^previo)begin
			previo <= boton;
			contador <= 0;
			rebotado <= boton;
		end
	end
	else begin
		contador <= contador + 1'b1;
	end
end
endmodule