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







### Implementación Sensor



### Implementación FSM Tamagotchi


## Conclusiones





