module Modulo_sensor (
    input wire clk,
    input wire reset,
	 input wire miso,            //señal esclavo maestro
	 input wire [7:0] data_in,   // Datos a escribir en el sensor
    input wire read_en,         // Señal para habilitar lectura
 output reg cs,              // señal que indica inicio de medicion
    output reg sck,
    output reg mosi,             // señales de salida maestro a esclavo
    output reg [7:0] data_out  // Datos leídos del sensor

);

    // Definición de estados usando localparam
    localparam IDLE = 3'b000,
               SELECT = 3'b001,
               SEND_ADDRESS = 3'b010,
               READ_DATA = 3'b011,
               WRITE_DATA = 3'b100,
               DESELECT = 3'b101;

    reg [2:0] state;  // Registro para el estado actual
    reg [7:0] temp_data_out;
    reg [7:0] temp_data_in;
    reg [2:0] bit_counter;
    reg [7:0] address;
	 
	// assign  address [7] = read_en;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            cs <= 1;
            sck <= 0;
            mosi <= 0;
            data_out <= 8'b00000000;
            temp_data_out <= 8'b00000000;
            bit_counter <= 3'b000;
        end else begin
            case (state)
                IDLE: begin      //estado de espera
                    cs <= 1;  // Sensor sin activar
                    sck <= 0;
                    if (read_en) begin      //señal que indica que hay que leer
                        state <= SELECT;    //se cambia al estado select
								address <= {read_en, 7'h73};  // Dirección del registro `status` (0xF3) para leer
                    end else 
                        state <= SELECT;
                        address <= 7'h72;  // Dirección del registro `ctrl_hum` (0xF2) para escribir
                end

                SELECT: begin
                    cs <= 0;  // Señal que activa el sensor
                    state <= SEND_ADDRESS;
                    bit_counter <= 3'b111;
                    temp_data_out <= address;
                end

                SEND_ADDRESS: begin
                    sck <= ~sck;
                    if (sck) begin
                        mosi <= temp_data_out[bit_counter];
                        bit_counter <= bit_counter - 1;
                        if (bit_counter == 3'b000) begin
                            if (read_en) begin
                                state <= READ_DATA;
                                bit_counter <= 3'b111;
                            end else 
                                state <= WRITE_DATA;
                                bit_counter <= 3'b111;
                                temp_data_out <= data_in;  // Cargar datos para escribir

                        end
                    end
                end

                READ_DATA: begin
                    sck <= ~sck;
                    if (!sck) begin
                        temp_data_in[bit_counter] <= miso;
                        bit_counter <= bit_counter - 1;
                        if (bit_counter == 3'b000) begin
                            data_out <= temp_data_in;  // Actualizar salida con datos leídos
                            state <= DESELECT;
                        end
                    end
                end

                WRITE_DATA: begin
                    sck <= ~sck;
                    if (sck) begin
                        mosi <= temp_data_out[bit_counter];
                        bit_counter <= bit_counter - 1;
                        if (bit_counter == 3'b000) begin
                            state <= DESELECT;
                        end
                    end
                end

                DESELECT: begin
                    cs <= 1;  // Deselect sensor
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
