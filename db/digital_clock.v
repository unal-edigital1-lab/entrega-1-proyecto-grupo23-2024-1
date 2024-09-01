module digital_clock (
    input wire clk,         // Señal de reloj
    input wire reset,       // Señal de reset
    output reg [5:0] sec,   // Segundos (0-59)
    output reg [5:0] min,   // Minutos (0-59)
    output reg [4:0] hour   // Horas (0-23)
);

    // Parámetros para el límite de cada unidad de tiempo
    parameter SEC_LIMIT = 59;
    parameter MIN_LIMIT = 59;
    parameter HOUR_LIMIT = 23;

    // Señal para contar ciclos del reloj
    reg [31:0] counter;
    reg second_tick;

    // Inicialización y actualización
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Resetear los valores
            sec <= 0;
            min <= 0;
            hour <= 0;
            counter <= 0;
            second_tick <= 0;
        end else begin
            // Incrementar el contador de ciclos del reloj
            counter <= counter + 1;

            // Generar un pulso cada segundo
            if (counter == 32'd49999999) begin
                counter <= 0;
                second_tick <= 1;
            end else begin
                second_tick <= 0;
            end

            // Actualizar el reloj cada segundo
            if (second_tick) begin
                if (sec == SEC_LIMIT) begin
                    sec <= 0;
                    // Actualizar los minutos
                    if (min == MIN_LIMIT) begin
                        min <= 0;
                        // Actualizar las horas
                        if (hour == HOUR_LIMIT) begin
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
            end
        end
    end
endmodule

