`timescale 1ns / 1ps

module Modulo_sensor_tb;

    // Inputs
    reg clk;
    reg reset;
    reg miso;  // Aunque no lo usemos, es necesario para instanciar el módulo
    reg [7:0] data_in;
    reg read_en;

    // Outputs
    wire cs;
    wire sck;
    wire mosi;
    wire [7:0] data_out;
	 wire [7:0] contador;

    // Instantiate the Unit Under Test (UUT)
    Modulo_sensor uut (
        .clk(clk),
        .reset(reset),
        .miso(miso),  // Conectado pero no utilizado en la simulación
        .data_in(data_in),
        .read_en(read_en),
        .cs(cs),
        .sck(sck),
        .mosi(mosi),
        .data_out(data_out),
		  .contador(contador)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        miso = 0;
        data_in = 8'h33;  // Datos que se enviarán a través de MOSI
        read_en = 0;
		  #10
        reset = 0;


        // Test write operation (envío de datos por MOSI)


        // Espera para que la operación se complete
        #800;

        // Fin de la simulación
        #100;
        $end;
    end

    // Para visualizar MOSI, no es necesario modificar este bloque
    always @(posedge !sck) begin
        // En este caso, no necesitamos cambiar nada aquí
    end

endmodule
