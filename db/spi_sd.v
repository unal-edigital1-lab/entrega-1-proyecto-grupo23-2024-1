module spi_sd(
    input wire clk,          // Reloj principal
    input wire rst,          // Reset
    input wire sd_out,       // Datos desde la tarjeta SD (equivalente a MISO)
    output reg sd_in,        // Datos hacia la tarjeta SD (equivalente a MOSI)
    output reg sd_clk,       // Reloj SPI
    output reg sd_cs,        // Chip Select para la tarjeta SD
    output reg [7:0] data_out, // Datos recibidos desde la tarjeta SD
    input wire [7:0] data_in,  // Datos a enviar a la tarjeta SD
    input wire start,        // Señal para iniciar la transmisión
    output reg done          // Señal que indica que la transmisión ha terminado
);

    // Definiciones de estados
    reg [3:0] state;
    localparam IDLE = 0;
    localparam SEND_CMD = 1;
    localparam WAIT_RESPONSE = 2;
    localparam DONE = 3;

    // Contador para bits enviados/recibidos
    reg [2:0] bit_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sd_in <= 1;
            sd_clk <= 1;
            sd_cs <= 1;         // Desactivar la tarjeta SD
            done <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        sd_cs <= 0;      // Activar la tarjeta SD
                        state <= SEND_CMD;
                        bit_cnt <= 7;    // Vamos a enviar 8 bits
                    end
                end
                SEND_CMD: begin
                    sd_clk <= ~sd_clk;   // Cambiar el reloj SPI
                    if (sd_clk == 0) begin
                        sd_in <= data_in[bit_cnt]; // Enviar el bit correspondiente
                        bit_cnt <= bit_cnt - 1;
                    end
                    if (bit_cnt == 0) begin
                        state <= WAIT_RESPONSE;
                        bit_cnt <= 7;  // Preparar para recibir 8 bits
                    end
                end
                WAIT_RESPONSE: begin
                    sd_clk <= ~sd_clk;   // Cambiar el reloj SPI
                    if (sd_clk == 0) begin
                        data_out[bit_cnt] <= sd_out; // Leer el bit desde la tarjeta SD
                        bit_cnt <= bit_cnt - 1;
                    end
                    if (bit_cnt == 0) begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    sd_cs <= 1;          // Desactivar la tarjeta SD
                    done <= 1;           // Indicar que la transmisión ha terminado
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
