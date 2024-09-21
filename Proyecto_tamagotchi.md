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
El spi master cuenta con 


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

### Implementación Sensor



### Implementación FSM Tamagotchi


## Conclusiones





