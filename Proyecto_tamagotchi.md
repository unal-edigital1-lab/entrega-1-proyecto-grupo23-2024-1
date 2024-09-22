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


![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/start_reset.jpeg)

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

#### INIT_SEQ_1
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/init1.jpeg)
```verilog
		  INIT_SEQ_1 [0] = {1'b0, 8'h00};
        INIT_SEQ_1 [1] = {1'b0, 8'h10};
        INIT_SEQ_1 [2] = {1'b1, 8'h00};                     
        INIT_SEQ_1 [3] = {1'b1, 8'h00}; 
        INIT_SEQ_1 [4] = {1'b0, 8'h00};
        INIT_SEQ_1 [5] = {1'b0, 8'h11};  
        INIT_SEQ_1 [6] = {1'b1, 8'h00}; 
        INIT_SEQ_1 [7] = {1'b1, 8'h00}; 
        INIT_SEQ_1 [8] = {1'b0, 8'h00};
        INIT_SEQ_1 [9] = {1'b0, 8'h12};
        INIT_SEQ_1 [10] = {1'b1, 8'h00};
        INIT_SEQ_1 [11] = {1'b1, 8'h00};
        INIT_SEQ_1 [12] = {1'b0, 8'h00};
        INIT_SEQ_1 [13] = {1'b0, 8'h13};
        INIT_SEQ_1 [14] = {1'b1, 8'h00};
        INIT_SEQ_1 [15] = {1'b1, 8'h00}; 
        INIT_SEQ_1 [16] = {1'b0, 8'h00};
        INIT_SEQ_1 [17] = {1'b0, 8'h14};
        INIT_SEQ_1 [18] = {1'b1, 8'h00};   
        INIT_SEQ_1 [19] = {1'b1, 8'h00};

```
#### INIT_SEQ_2
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/init2.jpeg)
```verilog
		  INIT_SEQ_2 [0] = {1'b0, 8'h00};
        INIT_SEQ_2 [1] = {1'b0, 8'h11};
        INIT_SEQ_2 [2] = {1'b1, 8'h00};                     
        INIT_SEQ_2 [3] = {1'b1, 8'h18}; 
        INIT_SEQ_2 [4] = {1'b0, 8'h00};
        INIT_SEQ_2 [5] = {1'b0, 8'h12};  
        INIT_SEQ_2 [6] = {1'b1, 8'h61}; 
        INIT_SEQ_2 [7] = {1'b1, 8'h21}; 
        INIT_SEQ_2 [8] = {1'b0, 8'h00};
        INIT_SEQ_2 [9] = {1'b0, 8'h13};
        INIT_SEQ_2 [10] = {1'b1, 8'h00};
        INIT_SEQ_2 [11] = {1'b1, 8'h6F};
        INIT_SEQ_2 [12] = {1'b0, 8'h00};
        INIT_SEQ_2 [13] = {1'b0, 8'h14};
        INIT_SEQ_2 [14] = {1'b1, 8'h49};
        INIT_SEQ_2 [15] = {1'b1, 8'h6F}; 
        INIT_SEQ_2 [16] = {1'b0, 8'h00};
        INIT_SEQ_2 [17] = {1'b0, 8'h10};
        INIT_SEQ_2 [18] = {1'b1, 8'h08};   
        INIT_SEQ_2 [19] = {1'b1, 8'h00};

```
#### INIT_SEQ_3
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/init3.jpeg)
```verilog
		INIT_SEQ_3 [0] = {1'b0, 8'h00};
        INIT_SEQ_3 [1] = {1'b0, 8'h11};
        INIT_SEQ_3 [2] = {1'b1, 8'h10};                     
        INIT_SEQ_3 [3] = {1'b1, 8'h3B};
```
#### INIT_SEQ_4 
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/init4.jpeg)
```verilog
        INIT_SEQ_4 [0] = {1'b0, 8'h00};
        INIT_SEQ_4 [1] = {1'b0, 8'h01};
        INIT_SEQ_4 [2] = {1'b1, 8'h01};                     
        INIT_SEQ_4 [3] = {1'b1, 8'h1C}; 
        INIT_SEQ_4 [4] = {1'b0, 8'h00};
        INIT_SEQ_4 [5] = {1'b0, 8'h02};  
        INIT_SEQ_4 [6] = {1'b1, 8'h01}; 
        INIT_SEQ_4 [7] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [8] = {1'b0, 8'h00};
        INIT_SEQ_4 [9] = {1'b0, 8'h03};
        INIT_SEQ_4 [10] = {1'b1, 8'h10};
        INIT_SEQ_4 [11] = {1'b1, 8'h38};
        INIT_SEQ_4 [12] = {1'b0, 8'h00};
        INIT_SEQ_4 [13] = {1'b0, 8'h07};
        INIT_SEQ_4 [14] = {1'b1, 8'h00};
        INIT_SEQ_4 [15] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [16] = {1'b0, 8'h00};
        INIT_SEQ_4 [17] = {1'b0, 8'h08};
        INIT_SEQ_4 [18] = {1'b1, 8'h08};   
        INIT_SEQ_4 [19] = {1'b1, 8'h08};
        INIT_SEQ_4 [20] = {1'b0, 8'h00};
        INIT_SEQ_4 [21] = {1'b0, 8'h0B};
        INIT_SEQ_4 [22] = {1'b1, 8'h11};                     
        INIT_SEQ_4 [23] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [24] = {1'b0, 8'h00};
        INIT_SEQ_4 [25] = {1'b0, 8'h0C};  
        INIT_SEQ_4 [26] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [27] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [28] = {1'b0, 8'h00};
        INIT_SEQ_4 [29] = {1'b0, 8'h0F};
        INIT_SEQ_4 [30] = {1'b1, 8'h0D};
        INIT_SEQ_4 [31] = {1'b1, 8'h01};
        INIT_SEQ_4 [32] = {1'b0, 8'h00};
        INIT_SEQ_4 [33] = {1'b0, 8'h1A};
        INIT_SEQ_4 [34] = {1'b1, 8'h00};
        INIT_SEQ_4 [35] = {1'b1, 8'h20};
        INIT_SEQ_4 [36] = {1'b0, 8'h00};
        INIT_SEQ_4 [37] = {1'b0, 8'h20};
        INIT_SEQ_4 [38] = {1'b1, 8'h00};   
        INIT_SEQ_4 [39] = {1'b1, 8'h00};
		  INIT_SEQ_4 [40] = {1'b0, 8'h00};
        INIT_SEQ_4 [41] = {1'b0, 8'h21};
        INIT_SEQ_4 [42] = {1'b1, 8'h00};                     
        INIT_SEQ_4 [43] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [44] = {1'b0, 8'h00};
        INIT_SEQ_4 [45] = {1'b0, 8'h30};  
        INIT_SEQ_4 [46] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [47] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [48] = {1'b0, 8'h00};
        INIT_SEQ_4 [49] = {1'b0, 8'h31};
        INIT_SEQ_4 [50] = {1'b1, 8'h00};
        INIT_SEQ_4 [51] = {1'b1, 8'hDB};
        INIT_SEQ_4 [52] = {1'b0, 8'h00};
        INIT_SEQ_4 [53] = {1'b0, 8'h32};
        INIT_SEQ_4 [54] = {1'b1, 8'h00};
        INIT_SEQ_4 [55] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [56] = {1'b0, 8'h00};
        INIT_SEQ_4 [57] = {1'b0, 8'h33};
        INIT_SEQ_4 [58] = {1'b1, 8'h00};   
        INIT_SEQ_4 [59] = {1'b1, 8'h00};
		  INIT_SEQ_4 [60] = {1'b0, 8'h00};
        INIT_SEQ_4 [61] = {1'b0, 8'h34};
        INIT_SEQ_4 [62] = {1'b1, 8'h00};                     
        INIT_SEQ_4 [63] = {1'b1, 8'hDB}; 
        INIT_SEQ_4 [64] = {1'b0, 8'h00};
        INIT_SEQ_4 [65] = {1'b0, 8'h3A};  
        INIT_SEQ_4 [66] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [67] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [68] = {1'b0, 8'h00};
        INIT_SEQ_4 [69] = {1'b0, 8'h36};
        INIT_SEQ_4 [70] = {1'b1, 8'h00};
        INIT_SEQ_4 [71] = {1'b1, 8'h5F};
        INIT_SEQ_4 [72] = {1'b0, 8'h00};
        INIT_SEQ_4 [73] = {1'b0, 8'h37};
        INIT_SEQ_4 [74] = {1'b1, 8'h00};
        INIT_SEQ_4 [75] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [76] = {1'b0, 8'h00};
        INIT_SEQ_4 [77] = {1'b0, 8'h38};
        INIT_SEQ_4 [78] = {1'b1, 8'h00};   
        INIT_SEQ_4 [79] = {1'b1, 8'hDB};
		  INIT_SEQ_4 [80] = {1'b0, 8'h00};
        INIT_SEQ_4 [81] = {1'b0, 8'h39};
        INIT_SEQ_4 [82] = {1'b1, 8'h00};                     
        INIT_SEQ_4 [83] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [84] = {1'b0, 8'h00};
        INIT_SEQ_4 [85] = {1'b0, 8'h60}; 
        INIT_SEQ_4 [86] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [78] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [88] = {1'b0, 8'h00};
        INIT_SEQ_4 [89] = {1'b0, 8'h61};
        INIT_SEQ_4 [90] = {1'b1, 8'h08};
        INIT_SEQ_4 [91] = {1'b1, 8'h08};
        INIT_SEQ_4 [92] = {1'b0, 8'h00};
        INIT_SEQ_4 [93] = {1'b0, 8'h62};
        INIT_SEQ_4 [94] = {1'b1, 8'h08};
        INIT_SEQ_4 [95] = {1'b1, 8'h0A}; 
        INIT_SEQ_4 [96] = {1'b0, 8'h00};
        INIT_SEQ_4 [97] = {1'b0, 8'h63};
        INIT_SEQ_4 [98] = {1'b1, 8'h00};   
        INIT_SEQ_4 [99] = {1'b1, 8'h0A};
		  INIT_SEQ_4 [100] = {1'b0, 8'h00};
        INIT_SEQ_4 [101] = {1'b0, 8'h64};
        INIT_SEQ_4 [102] = {1'b1, 8'h0A};                     
        INIT_SEQ_4 [103] = {1'b1, 8'h08}; 
        INIT_SEQ_4 [104] = {1'b0, 8'h00};
        INIT_SEQ_4 [105] = {1'b0, 8'h66};  
        INIT_SEQ_4 [106] = {1'b1, 8'h08}; 
        INIT_SEQ_4 [107] = {1'b1, 8'h08}; 
        INIT_SEQ_4 [108] = {1'b0, 8'h00};
        INIT_SEQ_4 [109] = {1'b0, 8'h66};
        INIT_SEQ_4 [110] = {1'b1, 8'h00};
        INIT_SEQ_4 [111] = {1'b1, 8'h00};
        INIT_SEQ_4 [112] = {1'b0, 8'h00};
        INIT_SEQ_4 [113] = {1'b0, 8'h67};
        INIT_SEQ_4 [114] = {1'b1, 8'h0A};
        INIT_SEQ_4 [115] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [116] = {1'b0, 8'h00};
        INIT_SEQ_4 [117] = {1'b0, 8'h68};
        INIT_SEQ_4 [118] = {1'b1, 8'h07};   
        INIT_SEQ_4 [119] = {1'b1, 8'h10};
		  INIT_SEQ_4 [120] = {1'b0, 8'h00};
        INIT_SEQ_4 [121] = {1'b0, 8'h69};
        INIT_SEQ_4 [122] = {1'b1, 8'h07};                     
        INIT_SEQ_4 [123] = {1'b1, 8'h10}; 
        INIT_SEQ_4 [124] = {1'b0, 8'h00};
        INIT_SEQ_4 [125] = {1'b0, 8'h17};  
        INIT_SEQ_4 [126] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [127] = {1'b1, 8'h12}; 

```
#### ADRESS_SEQ 
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/adress.jpeg)
```verilog
		  ADRESS_SEQ [0] = {1'b0, 8'h00};
        ADRESS_SEQ [1] = {1'b0, 8'h07};
        ADRESS_SEQ [2] = {1'b1, 8'h10};                     
        ADRESS_SEQ [3] = {1'b1, 8'h17}; 
        ADRESS_SEQ [4] = {1'b0, 8'h00};
        ADRESS_SEQ [5] = {1'b0, 8'h02};  
        ADRESS_SEQ [6] = {1'b1, 8'h10}; 
        ADRESS_SEQ [7] = {1'b1, 8'h38}; 
        ADRESS_SEQ [8] = {1'b0, 8'h00};
        ADRESS_SEQ [9] = {1'b0, 8'h36};
        ADRESS_SEQ [10] = {1'b1, 8'h00};
        ADRESS_SEQ [11] = {1'b1, 8'hAF};
        ADRESS_SEQ [12] = {1'b0, 8'h00};
        ADRESS_SEQ [13] = {1'b0, 8'h37};
        ADRESS_SEQ [14] = {1'b1, 8'h00};
        ADRESS_SEQ [15] = {1'b1, 8'h00}; 
        ADRESS_SEQ [16] = {1'b0, 8'h00};
        ADRESS_SEQ [17] = {1'b0, 8'h38};
        ADRESS_SEQ [18] = {1'b1, 8'h00};   
        ADRESS_SEQ [19] = {1'b1, 8'hDB};
        ADRESS_SEQ [20] = {1'b0, 8'h00};
        ADRESS_SEQ [21] = {1'b0, 8'h39};
        ADRESS_SEQ [22] = {1'b1, 8'h00};                     
        ADRESS_SEQ [23] = {1'b1, 8'h00}; 
        ADRESS_SEQ [24] = {1'b0, 8'h00};
        ADRESS_SEQ [25] = {1'b0, 8'h20};  
        ADRESS_SEQ [26] = {1'b1, 8'h00}; 
        ADRESS_SEQ [27] = {1'b1, 8'h00}; 
        ADRESS_SEQ [28] = {1'b0, 8'h00};
        ADRESS_SEQ [29] = {1'b0, 8'h21};
        ADRESS_SEQ [30] = {1'b1, 8'h00};
        ADRESS_SEQ [31] = {1'b1, 8'h00};
        ADRESS_SEQ [32] = {1'b0, 8'h00};
        ADRESS_SEQ [33] = {1'b0, 8'h22};
```


### Implementación Sensor



### Implementación FSM Tamagotchi


## Conclusiones





