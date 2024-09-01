`timescale 1ns / 1ps

module tb_digital_clock;

    // Señales de prueba
    reg clk;
    reg reset;
    wire [5:0] sec;
    wire [5:0] min;
    wire [4:0] hour;

    // Instanciar el módulo digital_clock
    digital_clock uut (
        .clk(clk),
        .reset(reset),
        .sec(sec),
        .min(min),
        .hour(hour)
    );

    // Generar señal de reloj
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Genera un reloj con periodo de 20ns (50 MHz)
    end

    // Generar señales de reset y monitorear la salida
    initial begin
        // Inicializar señales
        reset = 1;

        // Aplicar el reset durante un tiempo y luego liberarlo
        #50;
        reset = 0;

        // Ejecutar la simulación durante un período de tiempo para observar el comportamiento
        #100000000; // Tiempo en nanosegundos (ej. 100 ms)

        // Terminar la simulación
        $finish;
    end

    // Monitorear los valores de salida
    initial begin
        $monitor("Time: %0t | sec: %d | min: %d | hour: %d", $time, sec, min, hour);
    end

endmodule
