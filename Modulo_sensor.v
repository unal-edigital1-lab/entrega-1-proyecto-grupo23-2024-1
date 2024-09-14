`timescale 1ns / 1ps
module Modulo_sensor 
(
    //Declara entradas y salidas
    input wire clk,
    input wire reset,
	 input wire miso,            //señal esclavo maestro
	 input wire [7:0] data_in,   // Datos a escribir en el sensor
    input wire read_en,         // Señal para habilitar lectura
    output reg cs,              // señal que indica inicio de medicion
    output reg sck,
    output reg mosi,             // señales de salida maestro a esclavo
    output reg [7:0] data_out,  // Datos leídos del sensor
    output reg [7:0] contador
);

    // Definición de estados usando localparam
    localparam IDLE = 3'b000,
               SELECT = 3'b001,
               SEND_ADDRESS = 3'b010,
               READ_DATA = 3'b011,
               WRITE_DATA = 3'b100,
               DESELECT = 3'b101;
					
    //Registros
    reg [2:0] state;  // Registro para el estado actual
    reg [7:0] temp_data_out;  //Registro datos envio al sensor MOSI
    reg [7:0] temp_data_in; // Registro datos recepcion del sensor MISO
    reg [4:0] bit_counter;// Registro que cuenta los bits que mandan y reciben
    reg [4:0] bit_counter2;
	 reg [7:0] address;  // Registro direccion en el sensor

	
    always @(posedge clk or posedge reset) begin 
	      
        if (reset) begin

            cs <= 1;
            sck <= 1;
            mosi <= 0;
            data_out <= 7'b00000000;
            temp_data_out <= 7'b00000000;
            bit_counter <= 4'b0000;
				bit_counter2 <= 4'b0000;
				state <= IDLE;
			   contador <= 7'b00000000;
				
        end else begin
		  contador <= contador+1;
            case (state)
                IDLE: begin      //estado de espera
                    cs <= 1;  // Sensor sin activar
                    sck <= 1;
                    if (read_en) begin      //señal que indica que hay que leer
              
								address <= {read_en, 7'b1010111};  // Dirección del registro `status` (0xF3) para leer
                        state <= SELECT;    //se cambia al estado select
						  end else 
             
                        address <= {read_en, 7'b1110011};  // Dirección del registro ` (0xF2) para escribir
                        state <= SELECT;        
					end
                SELECT: begin
                    cs <= 0;  // Señal que activa el sensor
                    bit_counter <= 4'b0111;
						  bit_counter2 <= 4'b1000;
                    temp_data_out <= address;
						  state <= SEND_ADDRESS;
                end
                SEND_ADDRESS: begin
						sck <= ~sck;
                    if (sck) begin
						  
                        mosi <= temp_data_out[bit_counter];
                        bit_counter <= bit_counter - 1;
								bit_counter2 <= bit_counter2 - 1;
                        if (bit_counter2 == 4'b0000) begin
                           bit_counter2 <= 4'b1000;
									bit_counter <= 4'b0110;
									//mosi <= temp_data_out[0];
									if (read_en) begin
										  state <= READ_DATA;
                            end else begin
                                temp_data_out <= data_in;  // Cargar datos para escribir
                                 mosi <= temp_data_out[7];
											sck <= 0;
										  state <= WRITE_DATA;
									end
								end
							end
						end
                READ_DATA: begin
                    sck <= ~sck;
                    if (sck) begin // ! operador logico que niega es decir se ejecuta si sck es 0
                        temp_data_in[bit_counter] <= miso; /* escribe  en Temp_data_in la informacion almacenada 
								en miso bit tras bit */
								bit_counter2 <= bit_counter2 - 1;
                        bit_counter <= bit_counter - 1;
                        if (bit_counter2 == 4'b0001) begin
                            data_out <= temp_data_in;  // Actualizar salida con datos leídos
                            state <= DESELECT;
                        end
                    end
                end
                WRITE_DATA: begin 
					 	sck <= ~sck;
						
                    if (sck) begin
                        mosi <= temp_data_out[bit_counter];  /*escribe  en Temp_data_in la informacion almacenada 
								en miso bit tras bit */
								bit_counter2 <= bit_counter2 - 1;
                        bit_counter <= bit_counter - 1;
                        if (bit_counter2 == 4'b0001) begin
								    cs <= 1;
									 sck<= 1;
									  mosi <= temp_data_out[0];
                            state <= DESELECT;
                        end
                    end
                end
					 
                DESELECT: begin
                    mosi <= temp_data_out[0];
                    cs <= 1;  // Deselect sensor
                    state <= IDLE;
                end

                //default: state <= IDLE;
            endcase
        end
      end


endmodule
