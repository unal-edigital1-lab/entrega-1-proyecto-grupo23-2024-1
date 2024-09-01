`timescale 1ns/1ps

module tiempo (
    input wire clk,        // Señal de reloj de entrada (50 MHz)
    input wire rst,        // Señal de reset
    output reg [5:0] sec,  // Contador de segundos (0-59)
    output reg [5:0] min,  // Contador de minutos (0-59)
    output reg [4:0] hour  // Contador de horas (0-23)
);

    // Parámetros de frecuencia
    parameter frecuencia = 50000000;  // Frecuencia del reloj de entrada (50 MHz)
    parameter max_count = frecuencia - 1; // Contar hasta 49,999,999 para 1 segundo

    reg [25:0] count;  // Contador para generar un pulso de 1 segundo

    // Generación de un pulso de 1 segundo a partir de un reloj de 50 MHz
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            sec <= 0;   // Inicialización del contador de segundos
            min <= 0;   // Inicialización del contador de minutos
            hour <= 0;  // Inicialización del contador de horas
        end else begin
            if (count == max_count) begin
                count <= 0;
                if (sec == 59) begin
                    sec <= 0;
                    if (min == 59) begin
                        min <= 0;
                        if (hour == 23) begin
                            hour <= 0;
                        end else begin
                            hour <= hour + 1;
                        end
                    end else begin
                        min <= min + 1;
                    end
                end else begin
                    sec <= sec + 1;
                end
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule


  