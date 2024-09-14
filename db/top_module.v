`timescale 1ns / 1ps
module top_module(
    input wire clk,          // Reloj principal
    input wire rst_neg,      // Reset activo en bajo
    input wire neg_start,        // Señal para iniciar la transmisión SPI
    input wire sd_out,       // Datos desde la tarjeta SD (equivalente a MISO)
    output wire sd_in,       // Datos hacia la tarjeta SD (equivalente a MOSI)
    output wire sd_clk,      // Reloj SPI
    output wire sd_cs,       // Chip Select para la tarjeta SD
    output wire [0:6] sseg,  // Salidas del display de 7 segmentos
    output reg [5:0] an,     // Activación de dígitos del display de 7 segmentos
    output wire led          // LED para indicar habilitación
);
    wire start = ~neg_start;
    wire rst = ~rst_neg;
    wire [7:0] data_out;   // Datos recibidos desde la tarjeta SD

    // Instancia del módulo SPI
    spi_sd spi_instance (
        .clk(clk),
        .rst(rst),
        .sd_out(sd_out),
        .sd_in(sd_in),
        .sd_clk(sd_clk),
        .sd_cs(sd_cs),
        .data_out(data_out),
        .data_in(8'h0A),    // No estamos enviando datos en este ejemplo
        .start(start),
        .done()             // No necesitamos la señal done aquí
    );

    reg [3:0] bcd = 0;
    wire [5:0] sec;
    wire [5:0] min;
    wire [4:0] hour;

    // Instancia de los módulos de tiempo y conversión BCD a 7 segmentos
    tiempo mi_tiempo (
        .clk(clk),
        .rst(rst),
        .sec(sec),
        .min(min),
        .hour(hour),
        .A(1'b0)            // Aquí podrías conectar un botón o una señal para controlar
    );

    BCDtoSSeg bcdtosseg (
        .BCD(bcd),
        .SSeg(sseg)
    );

    // Divisor de frecuencia para controlar la actualización del display
    reg [26:0] cfreq = 0;
    wire enable;

    assign enable = cfreq[16];
    assign led = enable; // Cambiar a asignación continua con wire

    always @(posedge clk) begin
        if (rst) begin
            cfreq <= 0;
        end else begin
            cfreq <= cfreq + 1;
        end
    end

    reg [2:0] count = 0;
    always @(posedge enable) begin
        if (rst) begin
            count <= 0;
            an <= 6'b111111; // Apagar todos los dígitos
        end else begin
            count <= count + 1;
            case (count)
                3'h0: begin
                    bcd <= data_out % 10;   // Muestra el dígito menos significativo
                    an <= 6'b111110; // Activar el primer dígito
                end
                3'h1: begin
                    bcd <= (data_out / 10) % 10; // Muestra el segundo dígito
                    an <= 6'b111101; // Activar el segundo dígito
                end
                3'h2: begin
                    bcd <= 4'h0;  // Si solo tienes un dígito, este será cero
                    an <= 6'b111011; // Activar el tercer dígito
                end
                3'h3: begin
                    bcd <= 4'h0;  // Si solo tienes un dígito, este será cero
                    an <= 6'b110111; // Activar el cuarto dígito
                end
                3'h4: begin
                    bcd <= 4'h0;  // Si solo tienes un dígito, este será cero
                    an <= 6'b101111; // Activar el quinto dígito
                end
                3'h5: begin
                    bcd <= 4'h0;  // Si solo tienes un dígito, este será cero
                    an <= 6'b011111; // Activar el sexto dígito
                end
            endcase
        end
    end

endmodule

