# Entrega final del proyecto

-Jhon Michael
-Daniel
-Kevin Adrian Guerra Cifuentes
-David 
# PROYECTO TAMAGOTCHI


## Objetivos 

## Introducción

## Proceso

### Antirrebote y control del tiempo


### Implemetación Pantalla ili9225
#### Spi_Master

```verilog
module spi_master#(parameter DATA_SIZE = 9)(
    input wire  clk,
    input wire  rst, 
    input wire  [8:0] input_data, 
    input wire  available_data,
    output wire spi_sck, 
    output reg  spi_mosi, 
    output reg  spi_dc, 
    output wire spi_cs,
    output reg  idle
);
```
El módulo spi_master de la pantalla cuenta con 9 señales principales de entrada y salida. Ocho de ellas corresponden al protocolo estándar SPI, que incluye señales como el reloj (spi_sck), el chip select (spi_cs), y la línea de datos (spi_mosi). Adicionalmente, se incluye una señal extra denominada DC (Data/Command), que tiene la función de indicar a la pantalla si el dato que se va a transmitir corresponde a un comando o a un registro de datos. Esta señal es crucial para la correcta interpretación de la información enviada a la pantalla.


```verilog
reg[0:2] data_bit_counter = 3'b0;
reg[DATA_SIZE-1:0] data_reg;
reg sck_reg;
reg cs_reg;
```

El módulo cuenta con un contador que se encarga de alternar cada uno de los bits para enviarlos secuencialmente. Además, incluye un registro llamado data_reg, que almacena los datos a transmitir, garantizando que estos se mantengan estables incluso si llegan a cambiar durante la operación. También dispone de un registro para el reloj (sck_reg), que gestiona los ciclos del reloj SPI, y un registro de selección de chip (cs_reg), que controla cuándo el dispositivo está habilitado para la comunicación.


```verilog
wire dc = data_reg[8];
wire[0:DATA_SIZE-2] real_data = data_reg[DATA_SIZE-2:0]; 

assign spi_sck = sck_reg & cs_reg; 
assign spi_cs = !cs_reg; 

```


El dc será el noveno bit del registro data_reg, y se crea un registro llamado real_data que invierte el orden de los bits en relación con data_reg. Además, se asigna a spi_sck el resultado de la operación AND entre los registros sck y cs, mientras que la señal cs del SPI se obtiene como la negación de cs_reg.


```verilog

initial begin
    sck_reg <= 1'b1;
    data_reg <= 1'b0;
    data_bit_counter <= 1'b0;
    idle <= 1'b1;
    cs_reg <= 1'b0;
    spi_mosi <= 1'b1;
    spi_dc <= 1'b0;
end


```

Este bloque initial establece los valores iniciales de los registros y señales al inicio de la simulación. Aquí, sck_reg se inicializa en alto (1'b1), lo que indica que el reloj SPI comienza en un estado inactivo. El registro data_reg se establece en cero (1'b0), y el contador de bits (data_bit_counter) también se inicia en cero. La señal idle se fija en alto (1'b1) para indicar que el módulo está inactivo. El registro de selección de chip (cs_reg) se establece en bajo (1'b0), lo que típicamente indica que el dispositivo está habilitado. Finalmente, las señales spi_mosi y spi_dc se inicializan en alto (1'b1) y bajo (1'b0), respectivamente, preparando el sistema para la transmisión de datos.

```verilog
always @ (negedge clk, posedge rst) begin
    if(rst) begin
        sck_reg <= 1'b1;
        data_reg <= 1'b0;
        data_bit_counter <= 1'b0;
        idle <= 1'b1;
        cs_reg <= 1'b0;
        spi_mosi <= 1'b1;
        spi_dc <= 1'b0;
    end else begin
        if (available_data) begin
            data_reg <= input_data;
            idle <= 1'b0;
        end
        if (!idle) begin
            sck_reg <= !sck_reg;
            if (sck_reg) begin
                spi_dc <= dc;
                spi_mosi <= real_data[data_bit_counter];
                cs_reg <= 1'b1;
                data_bit_counter <= data_bit_counter + 1'b1;
                idle <= &data_bit_counter; 
            end
        end else begin
            sck_reg <= 1'b1;
            if (sck_reg) begin
                cs_reg <= 1'b0; 
                spi_dc <= 1'b1;
            end
        end
    end
end	
```

Cuando los datos están disponibles y el control indica que se deben leer, se almacenan en el registro correspondiente, y el módulo deja de estar apto para recibir más datos. Si idle es igual a 0, el registro sck se niega; sin embargo, si sck es 1, se actualiza spi_mosi para enviar los datos almacenados. El contador tiene 3 bits, por lo que idle se establecerá en 1 cuando el contador alcance 111. Cuando idle es 1, se eleva el registro sck para indicar que se debe enviar el último dato.

### controlador de la pantalla

El módulo del controlador de la pantalla será responsable de gestionar la carga de varias secuencias de inicialización y el envío de datos hacia la pantalla. Incluirá una secuencia de reinicio, cuatro secuencias de inicialización, y una secuencia de configuración de dirección que permitirá obtener y mostrar la imagen deseada.

Para obtener estas secuencias, el grupo utilizó un analizador de señales junto con el software Logic 2, extrayendo las señales mediante un Arduino con una librería previamente implementada. Este proceso permitió capturar y analizar las secuencias necesarias para el correcto funcionamiento del controlador de la pantalla.

#### START_RESET


!()[https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/start_reset.jpeg]

```verilog
START_RESET: begin
				case (step_reset)
				0: begin
					spi_sck_reg <= 1;
					if(delay_counter == DELAY_10ms)begin //es 60 ms 
						delay_counter <= 0;
						step_reset <= 1;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				1: begin
					spi_reset <= 0;
					if(delay_counter == DELAY_10us)begin
						delay_counter <= 0;
						step_reset <= 2;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				2: begin
					spi_dc_reg <= 0;
					if(delay_counter == DELAY_10us)begin
						delay_counter <= 0;
						step_reset <= 3;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				3: begin
					spi_cs_reg <= 0;
					if(delay_counter == DELAY_10us/2)begin
						delay_counter <= 0;
						step_reset <= 4;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end	
				4: begin
					spi_cs_reg <= 1;
					if(delay_counter == DELAY_10us)begin
						delay_counter <= 0;
						step_reset <= 5;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				5: begin
					spi_sck_reg <= 0;
					if(delay_counter == DELAY_10us/2)begin
						delay_counter <= 0;
						step_reset <= 6;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				6: begin
					spi_reset <= 1;
					if(delay_counter == DELAY_10us*100)begin
						delay_counter <= 0;
						step_reset <= 7;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				7:begin
					spi_reset <= 0;
					if(delay_counter == DELAY_10ms)begin
						delay_counter <= 0;
						step_reset <= 8;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				8:begin
					spi_reset <= 1;
					if(delay_counter == DELAY_10ms)begin
						delay_counter <= 0;
						state <= WAIT;
						state_next_wait <= SEND_INIT_1;
						delay_limit <= DELAY_10ms;//50ms
						step_reset <= 0;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				endcase

```


### Implementación Sensor



### Implementación FSM Tamagotchi


## Conclusiones





