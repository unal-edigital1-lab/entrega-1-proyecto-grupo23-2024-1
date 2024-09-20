module TamaguchiUpdate (
        input wire clk, //50Mhz
        input wire rst_neg, // reset negado PIN 90
		  
		  input bjugar,
		  input bdormir,
		  input bcomer,
		  input btest,
		  input btime,
		  
		  //spi pantalla
        output wire spi_mosi,
        output wire spi_cs,
        output wire spi_sck,
        output wire spi_dc,
		  output wire spi_reset,
		  
		  
		  //spi sensor
		   input miso_sensor,
			output wire cs_sensor,
			output wire sck_sensor,
			output wire mosi_sensor,
			output wire bandera_salud,
			output wire repuesto, //miso de salida para prueba con analizador sensor
			output wire sck_repuesto//sck de salida para prueba con analizador sensor
    );
	 
    reg clk_out;
	 reg [4:0]contador;
	 wire rst;
	 assign sck_repuesto = sck_sensor;
	 assign rst = !rst_neg;
    initial begin
		  clk_out <= 'b0;
		  contador <= 'b0;
    end
	 assign repuesto = miso_sensor;
	 //divisor de frecuencia
	 always@(posedge clk)begin //reloj de 1Mhz
		 if (contador == 5'hF) begin
                contador <= 5'h0;          // Reiniciar el contador cuando llega a 15
                clk_out <= ~clk_out;      // Invertir el estado del reloj de salida
            end else begin
                contador <= contador + 1;   // Incrementar el contador
            end
	 end
    
	
	 wire rebjugar;
	 wire rebdormir;
	 wire rebcomer;
	 wire rebtest;
	 wire rebtime;
	 
	 //antirebote
	 antirebote juego(bjugar,clk,rebjugar);
	 antirebote sueno(bdormir,clk,rebdormir);
	 antirebote comida(bcomer,clk,rebcomer);
	 antirebote test(btest,clk,rebtest);
	 antirebote times(btime,clk,rebtime);
	 
	 //control aceleracion tiempo
	 controltiempo cntl(clk, rst, rebtime,secondpassed);
	 
	 wire sensorsalud;
	 wire secondpassed;
	 wire [2:0]hambre;
	 wire [2:0]energia;
	 wire [2:0]diversion;
	 wire [2:0]estado;
	 wire modo;
	 
	 assign bandera_salud = !sensorsalud;
	 //control maquina principal
	 control_principal controlTama(
	.clk(clk),
	.reset(rst),
	.secondpassed(secondpassed),
	.boton_dormir(rebdormir),
	.boton_jugar(rebjugar),
	.boton_comer(rebcomer),
	.test(rebtest), 
	.enfermo_sensor(!sensorsalud),
	.hambre(hambre),
	.diversion(diversion),
	.energia(energia),
	.estado(estado),
	.modo(modo)
	 );
	 
	 
	 
	 
	 //pantalla 
    ControlImagen cimage(
		.clk(clk),
		.rst(rst),
		.hambre(hambre),
		.diversion(diversion),
		.energia(energia),
		.salud(sensorsalud),
		.state(estado),
		.modo(modo),
		.spi_mosi(spi_mosi),
		.spi_cs(spi_cs),
		.spi_sck(spi_sck),
		.spi_dc(spi_dc),
		.spi_reset(spi_reset)
	 );
	 
	 //sensor
	 ControlSensor sensortemperatura(
	.clk(clk_out), //1Mhz
	.rst(rst),
	.miso_sensor(miso_sensor),
	.cs_sensor(cs_sensor),
	.sck_sensor(sck_sensor),
	.mosi_sensor(mosi_sensor),
	.bandera_salud(sensorsalud)
	 );
	 
endmodule