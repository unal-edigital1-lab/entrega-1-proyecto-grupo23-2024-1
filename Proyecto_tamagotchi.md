# ENTREGA FINAL DEL PROYECTO

## INTEGRANTES: 

-Jhon Michael Valencia Renteria

-Daniel Chacon

-Kevin Adrian Guerra Cifuentes

-David Valderrama

# PROYECTO TAMAGOTCHI


## Objetivos 

### Objetivo General:

Desarrollar un sistema digital que simule una mascota virtual con comportamientos autónomos y que requiera interacción del usuario para mantener su estado de bienestar, utilizando un controlador lógico programable (FPGA) y técnicas de diseño digital.

### Objetivos Específicos:

* Diseñar y simular módulos digitales que gestionen los principales estados de la mascota virtual, como hambre, energía, diversión, y salud, basándose en las acciones del usuario.
* Implementar un sistema de temporización que regule el paso del tiempo dentro del juego, permitiendo que la mascota envejezca y cambie su estado de acuerdo a las acciones del usuario y el tiempo transcurrido.
* Desarrollar un sistema de filtrado anti-rebote para las señales de entrada, evitando fluctuaciones indeseadas al presionar botones que controlan las acciones del usuario.
* Probar y verificar el comportamiento del sistema mediante simulaciones y pruebas en hardware real (FPGA), garantizando que la mascota reaccione de manera adecuada a las entradas del usuario y a las condiciones del entorno simulado.
* Proveer un mecanismo de visualización que permita al usuario conocer el estado actual de la mascota virtual y las acciones necesarias para mantenerla viva y feliz.
  
Este proyecto será guiado por el profesor Ferney Alberto Beltrán Molina, quien supervisará el diseño, implementación y pruebas de los diferentes módulos que conforman el sistema de la mascota virtual.

## Introducción

El proyecto Mascota Virtual (Tamagotchi) está inspirado en los populares dispositivos electrónicos de los años 90, donde los usuarios cuidaban de una mascota digital. Este tipo de mascota requiere atención constante en áreas como alimentación, diversión, descanso y salud, lo que permite simular la experiencia de cuidado y responsabilidad de una mascota real.

En este proyecto, se implementará un sistema que emula una mascota virtual controlada a través de diferentes entradas, como botones para realizar acciones específicas (alimentar, jugar, dormir) y sensores que detectan el estado de la mascota. El sistema también incluye un mecanismo de control del tiempo y de filtrado de señales de entrada (como el anti-rebote de botones), asegurando un comportamiento estable y predecible de la mascota virtual.

## Proceso

### Diagrama de Caja Negra

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/diagrama_caja_negra.png)

### ANTIRREBOTE Y CONTROL DEL TIEMPO:


### CÓDIGO ANTIREBOTE:


Se hizo un módulo Verilog llamado antirebote implementa un sistema de anti-rebote para un botón. Los botones físicos suelen tener un comportamiento de "rebote" (pequeñas fluctuaciones en la señal cuando son presionados), lo que puede causar múltiples activaciones no deseadas. El objetivo de este módulo es eliminar esos rebotes y proporcionar una señal estable cuando el botón es presionado.

Procedemos a desglosar el código línea por línea:

DEFINICIÓN DEL MÓDULO Y ENTRADAS/SALIDAS:

```verilog
    module antirebote (
    input boton,
    input clk,
    output reg rebotado );
```
ENTRADAS:

boton: La señal del botón físico que podría tener rebotes.
clk: Señal de reloj que controla la secuencia de operaciones.

Salida:
rebotado: Señal de salida filtrada, libre de rebotes. Esta señal refleja el estado del botón pero solo cambia cuando se ha confirmado que el botón fue presionado de manera estable (sin rebotes).

REGISTROS INTERNOS:

```verilog
    reg previo; //valor previo del boton
    reg[21:0] contador; //conteo hasta 50ms
```
previo: Almacena el valor anterior del botón para detectar cambios en su estado.
contador: Un contador de 22 bits que se utiliza para medir el tiempo durante el cual el botón debe estar estable para que se considere como una acción válida (sin rebotes). Este contador se utiliza para ignorar fluctuaciones rápidas en la señal del botón.

INICIALIZACIÓN:

```verilog
    initial begin
    previo <= 0; 
    contador <= 0; 
    rebotado <= 0;
    end
```
EL BLOQUE INITIAL ESTABLECE LOS VALORES INICIALES:
PREVIO: Se inicia en 0, lo que significa que inicialmente no se detecta ninguna pulsación de botón.
contador: Comienza en 0, lo que significa que aún no se ha comenzado a contar el tiempo de estabilidad del botón.
REBOTADO: Se inicia en 0, lo que significa que inicialmente la salida no indica ninguna pulsación de botón.
Lógica secuencial

```verilog
    always @(posedge clk) begin
    if (contador == 2500000) begin
    if (boton ^ previo) begin
      previo <= boton;
      contador <= 0;
      rebotado <= boton;
    end
    end else begin
    contador <= contador + 1'b1;
    end
    end
```
EXPLICACIÓN PASO A PASO:

Sensibilidad al flanco positivo del reloj (posedge clk):

Cada vez que hay un pulso de reloj, el bloque always se ejecuta.

Comprobación del valor del contador:
Si el contador ha alcanzado el valor 2500000, lo que significa que ha transcurrido aproximadamente 50 ms (dependiendo de la frecuencia del reloj), entonces se verifica si el estado actual del botón (boton) es diferente del valor previo almacenado en previo.
El número 2500000 fue elegido como un tiempo de espera (debounce) para eliminar los rebotes. Asumiendo un reloj de 50 MHz, esto sería un retardo de aproximadamente 50 ms.
Si el estado del botón ha cambiado (boton ^ previo):
^ es el operador XOR, que compara si el valor actual de boton es diferente del valor anterior almacenado en previo.
Si boton y previo son diferentes, significa que el botón ha cambiado de estado (presionado o liberado) de manera estable.
Se actualiza previo para reflejar el nuevo valor del botón.
El contador se reinicia a 0 para empezar a contar el tiempo nuevamente.
La salida rebotado también se actualiza para reflejar el nuevo estado del botón, ya libre de rebotes.
Si el estado del botón no ha cambiado:
Si el contador no ha alcanzado 2500000, simplemente se incrementa el valor del contador. Esto permite que el sistema continúe midiendo el tiempo de estabilidad del botón.

Por todo esto podemos decir un resumen del codgio, el cual es el siguiente :

* El módulo espera hasta que el botón mantenga un estado estable (sin fluctuaciones) durante 50 ms antes de cambiar el valor de la señal de salida rebotado.
* Si el botón cambia de estado (de presionado a no presionado o viceversa) pero el cambio ocurre muy rápido (debido a los rebotes), este módulo lo ignora hasta que el botón permanezca en un estado estable durante el tiempo configurado.
* Este sistema asegura que los pulsos de un botón físico no provoquen cambios indeseados debido a los rebotes mecánicos, proporcionando una señal de salida más limpia.


### CÓDIGO DE CONTROL DE TIEMPO:

Se implementó un código de Verilog implementa un módulo llamado controltiempo, que genera una señal secondpassed para indicar que ha transcurrido una cierta cantidad de tiempo (en segundos o fracciones de segundo). El tiempo de espera puede acelerarse si se presiona un botón (boton_acelerar). 

Se procede a desglosarlo línea por línea.

DEFINICIÓN DEL MÓDULO Y ENTRADAS/SALIDAS:

```verilog
    module controltiempo(
    input clk,
    input reset,
    input boton_acelerar,
    output reg secondpassed
    );
```
ENTRADAS:

CLK: Señal de reloj (clock) que controla el ritmo del módulo.\

RESET: Señal de reinicio que restablece el contador y las salidas.

BOTON_ACELERAR: Si está activado, acelera el paso del tiempo.

SALIDAS:

SECONDPASSED: Una señal que indica si ha pasado el tiempo definido (puede ser un segundo o menos si el botón boton_acelerar está presionado).

REGISTROS INTERNOS

```verilog
    reg [35:0]contador;
    wire [35:0]limite;
```
CONTADOR: Un registro de 36 bits que cuenta el número de ciclos de reloj (clk).

LIMITE: ES un cable (wire) que define cuántos ciclos de reloj deben pasar antes de que secondpassed cambie de estado (indicando que ha pasado el tiempo especificado). El valor de este límite depende de si el botón boton_acelerar está presionado o no.

BLOQUE INITIAL

```verilog
    initial begin
    contador <= 0;
    secondpassed <= 0;
    end
```
Esta es la sección de inicialización. Se establece que al comenzar, el contador está en 0 y la señal secondpassed también está en 0. Esto garantiza que el módulo comience en un estado limpio.

ASIGNACIÓN CONDICIONAL DEL LÍMITE:

```verilog
    assign limite = (boton_acelerar) ? 'd2000000 : 'd25000000;
```
EL VALOR DE LIMITE SE ASIGNA DE FORMA CONDICIONAL:

* Si boton_acelerar está presionado (boton_acelerar == 1), el límite se reduce a 2,000,000 ciclos de reloj (un valor más bajo que acelera el conteo).
* Si boton_acelerar no está presionado (boton_acelerar == 0), el límite se establece en 25,000,000 ciclos, que podría representar aproximadamente 1 segundo (dependiendo de la frecuencia del reloj).

LÓGICA SECUENCIAL

```verilog
    always@(posedge clk, posedge reset) begin
     if(reset) begin 
      contador <= 0;
      secondpassed <= 0;
     end else begin
    if(contador > limite) begin
      secondpassed <= ~secondpassed;
      contador <= 0;
    end else begin
      contador <= contador + 1;
    end
    end
    end
```
Sensibilidad al flanco positivo del reloj (posedge clk) o al flanco positivo de reset (posedge reset):

* Si reset es activado, el contador se reinicia a 0 y secondpassed también se restablece a 0.
* Si no está activado el reset, se comienza el proceso de conteo:
* Si el valor del contador ha superado el limite:

Se invierte el valor de secondpassed, indicando que ha pasado el tiempo definido (el ciclo de tiempo ha terminado).

El contador se reinicia a 0 para comenzar un nuevo ciclo de conteo.

Si el contador no ha alcanzado el límite, simplemente se incrementa en 1.

Se resume el funcionamiento del código el cual es el siguiente:

* El módulo comienza con contador en 0 y secondpassed en 0.
* Con cada pulso de reloj (clk), el contador se incrementa.
* Si el botón boton_acelerar está presionado, el limite es menor (2,000,000 ciclos) y el tiempo entre cambios de secondpassed es más rápido.
* Si el botón no está presionado, el limite es mayor (25,000,000 ciclos) y el tiempo entre cambios de secondpassed es más lento (representando aproximadamente 1 segundo).
* Cuando reset se activa, todo el sistema vuelve a su estado inicial (contador y secondpassed a 0).

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


### IMPLEMENTACIÓN SENSOR:




### IMPLEMENTACIÓN FSM TAMAGOTCHI:

Código control principal:

Se implementó un código Verilog es un módulo llamado control_principal, el cual parece implementar el control de un sistema basado en estados para una especie de mascota virtual, con funciones relacionadas con hambre, diversión, energía y otros parámetros. Este sistema esta programado para reaccionar a diversos eventos (como presionar botones o señales externas), ajustando el estado de la mascota. 

Se procede a explicar línea por línea el codigo de control principal:

DEFINICIÓN DEL MÓDULO Y ENTRADAS/SALIDAS

```verilog
    module control_principal(
    input wire clk,
    input wire reset,
    input wire secondpassed,
    input wire boton_dormir,
    input wire boton_jugar,
    input wire boton_comer,
    input wire test,
    input wire enfermo_sensor,
    output reg [2:0]hambre,
    output reg [2:0]diversion,
    output reg [2:0]energia,
    output reg [2:0]estado,
    output reg modo
    );
```
EL MÓDULO CONTROL_PRINCIPAL TIENE VARIAS ENTRADAS Y SALIDAS:

ENTRADAS: CLK (reloj), reset (reiniciar el sistema), secondpassed (indica si ha pasado un segundo), boton_dormir, boton_jugar, boton_comer, test y enfermo_sensor.

SALIDAS: REGISTROS de 3 bits hambre, diversion, energia, estado, y un modo modo.

Estas entradas/salidas son cables (wire y reg), que representan señales que cambian según el tiempo o los eventos.

REGISTROS INTERNOS Y FLAGS

```verilog
    reg [10:0] contador_sueno;
    reg [10:0] contador_diversion;
    reg [10:0] contador_hambre;
    reg [10:0] contador_dormir;
```
Estos registros son contadores que se utilizan para medir el tiempo transcurrido desde que comenzó a afectar cada uno de los parámetros de la mascota (hambre, diversión, energía, sueño, etc.).

```verilog
    reg [35:0] contador_reset;
    reg [35:0] contador_test;
    reg dormido;
    reg enfermo_control;
    wire enfermo;
    assign enfermo = enfermo_control | enfermo_sensor;
```
* contador_reset y contador_test son contadores de alta precisión.
* dormido indica si la mascota está durmiendo.
* enfermo_control controla el estado de enfermedad, y enfermo es una señal combinada que indica si está enfermo en base a enfermo_control o el sensor enfermo_sensor.

```verilog
      reg muerte;
      reg flag_jugar;
      reg flag_dormir;
      reg flag_time;
      reg flag_comer;
      reg flag_test;
 ``` 
* muerte indica si la mascota ha muerto.
* Los flags (flag_jugar, flag_dormir, flag_time, flag_comer, flag_test) son usados para prevenir que los eventos se repitan en un solo ciclo de reloj.

INICIALIZACIÓN:

```verilog
    initial begin
    hambre <= 3;
    diversion <= 3;
    energia <= 3;
    dormido <= 0;
    contador_sueno <= 0;
    contador_diversion <= 0;
    contador_hambre <= 0;
    contador_dormir <= 0;
    contador_reset <= 0;
    contador_test <= 0;
    modo <= 0;
    enfermo_control <= 0;
    muerte <= 0;
    flag_jugar <= 0;
    flag_dormir <= 0;
    flag_time <= 0;
    flag_comer <= 0;
    flag_test <= 0;
    end
```  
Esta parte inicializa los registros en valores predeterminados. La mascota comienza con hambre, diversión y energía en nivel 3, y no está dormida ni enferma. También se ponen a 0 todos los contadores y flags.

ESTADOS PREDEFINIDOS:

```verilog
    localparam FELIZ = 0;
    localparam HAMBRIENTO = 1;
    localparam CANSADO = 2;
    localparam ABURRIDO = 3;
    localparam ENFERMO = 4;
    localparam DORMIDO = 5;
    localparam MUERTO = 6;
```    
Define varios estados predefinidos: FELIZ, HAMBRIENTO, CANSADO, ABURRIDO, ENFERMO, DORMIDO, y MUERTO. Estos son los diferentes estados en los que puede estar la mascota.
Lógica combinacional para el estado

```verilog
    always @(*) begin
      if(!muerte) begin
    if(diversion < 2 & energia < 2 & hambre < 2) begin
      estado <= 6;  // MUERTO
    end else if (enfermo) begin
      estado <= 4;  // ENFERMO
    end else if (dormido) begin
      estado <= 5;  // DORMIDO
    end else if (energia < 2) begin
      estado <= 2;  // CANSADO
    end else if (diversion < 2) begin
      estado <= 3;  // ABURRIDO
    end else if (hambre < 2) begin
      estado <= 1;  // HAMBRIENTO
    end else begin
      estado <= 0;  // FELIZ
    end
    end else begin
    estado <= 6;  // MUERTO
    end
    end
```    
Determina el estado de la mascota basándose en varios factores. Si tiene hambre, poca energía y poca diversión, la mascota muere. Si está enferma o dormida, su estado cambia respectivamente. Si tiene energía baja, hambre o aburrimiento, el estado se ajusta según esos parámetros.

BLOQUE SECUENCIAL DE ACTUALIZACIÓN:

```verilog
    always @(posedge clk) begin
    if(secondpassed) begin
    flag_time <= 1;
    if(!flag_time) begin
      if (!modo & !muerte) begin // Actualiza contadores de hambre, diversión y energía
```     
Aquí se actualizan los contadores y los niveles de los parámetros cada vez que secondpassed se activa, lo cual indica que ha pasado un segundo. Por ejemplo, si un contador llega a un cierto valor (como contador_diversion), se reduce el nivel de diversión.

También se controla el modo de juego, se reinician los contadores si es necesario, y se verifica si los botones de acción (boton_comer, boton_jugar, boton_dormir) han sido presionados para modificar el estado de la mascota.

Este es un esquema general del funcionamiento. La lógica se organiza para que, dependiendo de las señales recibidas (como botones y paso del tiempo), los parámetros internos cambien, ajustando el estado de la mascota virtual. 


## Conclusiones

* Integración exitosa de módulos digitales: A través del desarrollo del proyecto, se logró implementar un sistema que simula el comportamiento de una mascota virtual, integrando módulos que controlan los estados de hambre, diversión, energía y salud. Cada módulo interactúa de forma coherente, logrando una simulación fluida y autónoma de la mascota virtual.



