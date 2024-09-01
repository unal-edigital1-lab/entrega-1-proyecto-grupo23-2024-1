`timescale 1ns/1ps

module tiempo_tb;

    // Señales de prueba
    reg clk;
    reg rst;
    wire [5:0] sec;
    wire [5:0] min;
    wire [4:0] hour;

    // Instanciación del módulo bajo prueba (DUT)
    tiempo uut (
        .clk(clk),
        .rst(rst),
        .sec(sec),
        .min(min),
        .hour(hour)
    );

    // Generación de la señal de reloj
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz: Periodo de 20 ns
    end

    // Secuencia de pruebas
    initial begin
        // Inicialización con reset
        rst = 1;
        #100;         // Mantén el reset durante 100 ns
        rst = 0;      // Quita el reset

        // Simulación de un tiempo prolongado para observar el comportamiento del reloj
        #500000000;  // Simula suficiente tiempo para ver cambios en los contadores

        // Finalizar simulación
        $finish;
    end

    // Monitoreo de las señales
    initial begin
        $monitor("Time: %0t | sec: %0d | min: %0d | hour: %0d", $time, sec, min, hour);
    end

endmodule

