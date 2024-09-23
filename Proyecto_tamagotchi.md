# ENTREGA FINAL DEL PROYECTO

## INTEGRANTES: 

-Jhon Michael Valencia Renteria

-Daniel Chacon

-Kevin Adrian Guerra Cifuentes

-David Valderrama

# PROYECTO TAMAGOTCHI
## Video funcionamiento
[Video del funcionamiento del tamagotchi](https://youtu.be/xxC4w_AxXqo?si=_BjDNCMBIhrSQ2Gv)
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

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/cajanegracorreigda.png)

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

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/spipantalladiagrama.png)

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


![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/controlilidiagrama.png)

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


#### Control imagen

Lo primero que se hizo fue ajustar la resolución de la pantalla para poder manejarla de la siguiente manera:

```verilog
reg [15:0] current_pixel;
reg transmission_done;
reg [15:0] contador_pixel;

wire [7:0] modulex;
wire [4:0] x;
wire [4:0] y;

wire [7:0] c_pixel_imagen;
wire [15:0] pixel_actual;

assign modulex = contador_pixel % 220;
assign x = modulex / 11;
assign y = contador_pixel / 2420;
assign c_pixel_imagen = x - 1 + (y - 2) * 13;


```
Donde se escala a una resolución de 20 de largo(x) y 16 de alto(y).

Para probar el funcionamiento de la pantalla, se pintó toda la superficie de rojo, tal como se muestra en la imagen. La pantalla maneja el formato RGB565, configurando todos los píxeles en F800.

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/pintadoderojo.jpeg)


Para visualizar el área donde irán las caras del tamagotchi, se pintó en rojo el recuadro correspondiente. Esto se hizo utilizando el valor 0xF800 en formato RGB565, asegurando que la sección destaque claramente en la pantalla.

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/semipintadoderojo.jpeg)


#### Memoria
Se implementa una memoria que se encargará de almacenar y proporcionar los datos de los píxeles correspondientes a las caras del tamagotchi. Esta memoria leerá y suministrará los valores necesarios para representar las diferentes expresiones faciales que se van a implementar en pantalla.

```verilog
module Memoria(
input clk,
input rst,
input [2:0]adress,
input [7:0]contador_pixel,
output reg[15:0]pixel
);

reg [15:0] memoria_estado_0[0:168];
reg [15:0] memoria_estado_1[0:168];
reg [15:0] memoria_estado_2[0:168];
reg [15:0] memoria_estado_3[0:168];
reg [15:0] memoria_estado_4[0:168];
reg [15:0] memoria_estado_5[0:168];
reg [15:0] memoria_estado_6[0:168];

initial begin
	pixel <= 0;
	$readmemh("1.txt", memoria_estado_0);
	$readmemh("2.txt", memoria_estado_1);
	$readmemh("3.txt", memoria_estado_2);
	$readmemh("4.txt", memoria_estado_3);
	$readmemh("5.txt", memoria_estado_4);
	$readmemh("6.txt", memoria_estado_5);
	$readmemh("7.txt", memoria_estado_6);
end

always@(*)begin
	if(rst)begin
		pixel <= 0;
	end
	else begin
		case(adress)
			0:pixel <= memoria_estado_0[contador_pixel];
			1:pixel <= memoria_estado_1[contador_pixel];
			2:pixel <= memoria_estado_2[contador_pixel];
			3:pixel <= memoria_estado_3[contador_pixel];
			4:pixel <= memoria_estado_4[contador_pixel];
			5:pixel <= memoria_estado_5[contador_pixel];
			6:pixel <= memoria_estado_6[contador_pixel];
		endcase
	end
end

endmodule

```

## IMPLEMENTACIÓN SENSOR:
### Modulo spi_sensor
```verilog
 input clk, 
 input rst,
 input miso_sensor,
 input [7:0]data_1,
 input [7:0]data_2,
 input [7:0]data_3,
 input [2:0]modo,
 input load_data,
 output reg cs_sensor,
 output wire sck_sensor,
 output reg mosi_sensor,
 output reg bandera_salud,
 output reg ready
);
```
El módulo spi_sensor que controla la comunicación se compone 8 entradas y 5 salidas. 

###Las entradas son: 

1) Reloj (clk): Establece la pauta para coordinar la ejecucion de los procesos internos del modulo

2) Reset (rst): Restablece los registros a un valor predeterminado y los procesos que dependen de estos

3) Inputs data_1, data_2 y data_3: Contienen los paquetes de datos con las instrucciones que se enviaran por el mosi al sensor

4) Modo (modo):  Se utiliza decidir si se envian 2 o 3 paquetes de datos de 8 bits

5) Master input slave output (miso_sensor) Recibe las mediciones de temperatura del sensor con valores hexadecimal en binario.

6) Load_data (load): Indica al modulo cuando debe enviarle datos al sensor.

###Las salidas son:

1) Chip select (cs_sensor): Se encarga de informar al sensor que va a empezar a enviar y recibir instrucciones y activa el relog de comunicacion (sck_sensor).

2) Reloj serial(sck_sensor): Indica cuándo los datos deben ser leidos y escritos en sensor para un optmo control de flujo de datos y determina la velocidad de transmision.
   
3) Master output slave input (Mosi_sensor): Envia las instrucciones al sensor de configuracion y lectura de datos.

4) Bandera (bandera_salud): Es con el que se establece si la mascota virtual esta saludable o enferma.

5) Señal de confirmacion (Ready): Indica que el modulo esta listo para realizar la comunicación.

### Declarando los registros, asignando el Relog serial y estableciendo parametros de retardo:

```verilog
reg [20:0]delay_counter;
reg[7:0]data_read_send;

reg [1:0]rst_state;
reg [3:0] rst_counter;

reg hab_sck;
reg reg_sck;

reg[2:0]chains_sended;

assign sck_sensor = hab_sck&reg_sck;

wire [0:7]data_inverted = data_read_send[7:0];

localparam DELAY_60ms = 93750;
localparam DELAY_1s = 1562500; // a reloj de 1.562Mhz
```
1) reg [20:0]delay_counter:  Es un contador que se utiliza para generar delays (retrasos) en el tiempo

2) reg[7:0]data_read_send: Almacena los datos que serán enviados por la linea (mosi).

3) reg [1:0]rst_state: Almacena el estado de la maquina de estados que controla la comunicación.

4) reg hab_sck: Habilita la activación del reloj para que se alterne.

5) reg reg_sck: Guarda un valor entre 1 y 0 y es quien controla la oscilacion de la señal SCK.

6) reg[2:0]chains_sended: Ayuda a controlar cuándo se ha terminado de enviar o recibir una cadena completa de datos. Dependiendo del modo, puede enviar 2 o 3 datos.

7) Asigna un valor entre 0 y 1 al reloj serial con una puerta logica AND con los registros hab_sck y reg_sck como entradas.

8) Declara los parametros de Delay 60ms y 1s y les asigna un valor que depende las oscilaciones del relog clk.

### Configuracion inicial del modulo:

```verilog
initial begin
		cs_sensor <= 1;
		mosi_sensor <= 1;
		reg_sck<= 0;
		hab_sck<= 1;
		bandera_salud <= 1;
		ready <= 0;
		delay_counter <= 0;
		data_read_send <= 0;
		rst_state <= 0;
		rst_counter <= 0;
		chains_sended <= 0;
end
```
El bloque initial establece los valores iniciales con los que el modulo empezara a trabajar. con cs_sensor en 1 que significa que la comunicacion con el sensor esta desactivada como convencion en la comunicacion SPI, el mosi del sensor se mantiene en 1 cuando no se realiza comunicación tal y como se pudo observar en las pruebas con el analizador logico, reg_sck y hab_sck se les asigna el valor 0 manteniendo asi el relog serial desactivado en 0, la bandera de salud se establece en 1 por que la mascota virtual inicialmente se encuentra saludable, ready se mantiene en 0 ya que el modulo no esta listo para realizar comunicaciones y el delay_counter, el data_read_send, el rst_state, el rst_counter y el chains_sended se mantienen en 0 a la espera de un nuevo valor que los actualice segun lo indiquen posteriormente las maquinas de estado.

### Bloque always y reset:
```verilog
always @(negedge clk, posedge rst)begin
	if(rst)begin
		cs_sensor <= 1;
		mosi_sensor <= 1;
		bandera_salud <= 1;
		ready <= 0;
		delay_counter <= 0;
		data_read_send <= 0;
		rst_state <= 0;
		reg_sck<= 0;
		hab_sck<= 1;
		chains_sended <= 0;
	end
```

El bloque Always indica que las acciones en su interior se repiten en cada flanco de bajada de la señal de reloj clk o en cada flanco de subida de el reset y en caso en que este se encuentre activo, se le asignan los mismos valores predeterminados a los registros y las salidas que los del bloque initial por lo que con esta accion reiniciamos el modulo.

### Maquina de estados de comunicación:
```verilog
		case(rst_state)
			0: begin
			
			   En esta etapa se lleva a cabo el proceso de inicializacion del 
			   sensor.
			end
			1:begin
				Cuando el módulo entra en este estado, realiza la transmisión y 
				recepción dedatos hacia el sensor en función del valor de modo.	
			end
		2:begin
			   se finaliza la comunicación desactivando la señal cs_sensor
			   (poniéndola en alto) y se prepara para volver a realizar
                           otra transmision y regresando a el estado 1
		end
		endcase
```
Esta maquina de estados controlada por el registro (rst_state) se compone de 3 etapas que se ejecutan de forma secuencial 
la primera etapa realiza el proceso de inicializacion de la comunicacion, la segunda etapa a traves de maquinas de estado y
procesos internos que se explicaran mas a detalle se encarga de llevar a a cabo la comunicación con el sensor y la ultima 
etapa finaliza la comunicación, reinicia los registros de control y se prepara para volver a el estado 1.

### Estado 0 de la maquina controlada por (rst_state) INICIALIZACIÓN:

```verilog
case(rst_state)
			0:begin
				case(rst_counter)
					0:begin
						reg_sck <=1;
						if(delay_counter == DELAY_60ms)begin
							rst_counter <= 1;
							delay_counter <= 0;
						end
						else begin
							delay_counter <= delay_counter + 1;
						end
					end
					1:begin
						cs_sensor <= 0;
						rst_counter <= 2;
					end
					2:begin
						cs_sensor <= 1;
						rst_counter<= 3;
					end
					3:begin
						rst_state <= 1;
						ready <= 1;
						rst_counter<= 0;
						reg_sck <= 1;
						hab_sck<= 0;
					end
				endcase
			end
```

Si al momento de ejecutarse el bloque Always el reset no se encuentra en 1, continua con el siguiente subbloque que es una maquina de estados controlado por el registro (rst_counter) cuya función es habilitar de forma secuencial las diferentes etapas de comunicación con el sensor, en este caso comienza con el estado cero que es previo a la activacion de la comunicación el cual posee otros subloques con  otra maquina de estados interna controlada por el registro (rst_counter).

Como (rst_counter) se encuentra establecido en 0 por defecto lo primero que hara la maquina de estados es activar reg_sck y esperar 60ms
y una vez este tiempo haya transcurrido, el contador de tiempo (delay_counter) volvera a 0 y (rst_counter) avanzara hasta el estado siguente.

![image](https://github.com/user-attachments/assets/7b18c822-a983-4fc8-867b-8af24460dc91)

Los estados 1 y 2 son estados de transicion cumplen unicamente la funcion de activar y desactivar (cs_sensor) emulando lo que el arduino le transmitia a el sensor tal y como se pudo observar con el analizador logico.

El estado 3 da inicio a la comunicación con el sensor cambiando el estado de rst_state a 1, activando (ready) que es la bandera que indica que el modulo esta listo para comunicarse vuelve a dejar el contador (rst_counter) en cero y deshabilita el relog serial.

### ¿Como se comunica el sensor?:

Para entender como trabaja el sensor, fue necesario el uso de una tarjeta arduino con un scrip con el codigo de operación del sensor
que se encuentra disponible en internet y la instalacion de las librerias correspondientes, posteriormente se procedio a conectar el
sensor a la tarjeta por los respectivos canales de comunicación y en estas conexiones se conecto un analizador logico el cual extrajo 
las señales y se pudo observar las señales y los intervalos de tiempo entre las instrucciónes.

![image](https://github.com/user-attachments/assets/e1be320b-ad18-45db-8443-c31fcd291ff7)

Tal y como se puede observar en la imagen, el sensor se comunica en grupos de 2 y 3 paquetes de 8 bits que en el modulo spi del sensor en la FPGA distinguimos como modos; en cada uno de estos envios la señal SCK oscila de tal manera que sube y se mantiene en alto en 8 ocasiones y en esos mismos intervalos el sensor lee la señal de 8 bits que llega por el canal mosi. Luego se observa un pequeño delay antes de que se repita el proceso una vez mas si se envian 2 paquetes y 2 veces mas si se envian 3 paquetes.

### Estado 1 de la maquina controlada por (rst_state) TRANSMISION DE DATOS:
### Modo = 3:
### Maquina de estados interna controlada por (chains_sended) = 0:

```verilog
if (modo == 3)begin
	if(delay_counter == DELAY_1s)begin
		case(chains_sended)
			0:begin
				if(ready)begin
					if(rst_counter == 0)begin
						data_read_send <= 8'hFA;
						ready <= 0;
					end
				end
				else begin
					if(rst_counter == 8)begin
						reg_sck <= 1;
						chains_sended <= 1;
						rst_counter <= 0;
						mosi_sensor <= 1;
					end
					else begin
						reg_sck <= !reg_sck;
						if(reg_sck)begin
							hab_sck<= 1;
							cs_sensor <= 0;
							mosi_sensor <= data_inverted[rst_counter];
							rst_counter <= rst_counter + 1;
						end
					end
				end
			end
```
Como se menciono anteriormente, el registro (modo) verifica si el numero de paquetes enviados sera de a 3 o de a 2, si se realiza de 3, el siguiente paso es esperar 1 segundo e iniciar el case (chains_sended) y las condiciónes que dependen de los registros (ready) y (rst_counter) habian sido establecidos en la etapa anterior para cumplir con estas condiciones, luego de continuar la secuencia se le asigna a (data_read_send) los bits de la dirección de registro interno de el sensor y se desactiva (ready) para continuar con la ejecución.

Despues se alterna el registro que controla las oscilaciones de la señal de relog y cuando este se encuentra en 1, se activa la comunicacion del relog serial (sck_sensor), se baja la señal (cs_sensor) que significa que se inicia la comunicación SPI,  
posteriormente se envia por medio del mosi_sensor los bits almacenados en (data_read_send) pero para que el envio se realice de forma inversa, se creo el registro (data_inverted) que contiene los mismos bits pero escritos de forma inversa en la casilla del vector de  registro cuya casilla corresponde al valor de (rst_counter) que aumenta cada ciclo de relog.

Una vez se han enviado los 8 bits, (chains_sended) cambia al siguiente estado para continuar la secuencia, (rst_counter) se le asigna el valor 0 para reiniciarlo y mosi se mantiene en alto, tal y como el arduino lo hace.

### Recepcion y almacenamiento de medición (chains_sended) = 1:
```verilog
Etapa (chains_sended) = 1
1:begin
	if(rst_counter == 8)begin
			//reg_sck <= 1;
			chains_sended <= 2;
			rst_counter <= 0;
			bandera_salud <= (data_read_send > 8'h84)?1'b0:1'b1;
		end
		else begin
			reg_sck <= !reg_sck;
			if(!reg_sck)begin
				hab_sck<= 1;
				cs_sensor <= 0;
				data_read_send[7-rst_counter] <= miso_sensor;
				rst_counter <= rst_counter + 1;
                 end
         end
end	
```


En este fragmento de codigo se recibe la informacion proveniente de los registros internos de el sensor midiendo la temperatura y se almacenan desde el bit mas significativo primero hasta el menos significativo, una vez se ha cargado el registro, el contador se reinicia y se asigna un valor a la bandera con un condicional indicando que si el dato almacenado es mayor a 30 grados escrito en hexadecimal, indique que la mascota esta enferma y envie dicho dato al modulo de la maquina de estados general llamado TamaguchiUpdate y continue la secuencia cambiando (chains_sended)

### Intervalo de inactividad (chains_sended) = 2 y 3:
```verilog
	2:begin
		if(rst_counter == 8)begin
				reg_sck <= 1;
				chains_sended <= 3;
				rst_counter <= 0;
			end
			else begin
				reg_sck <= !reg_sck;
				if(reg_sck)begin
					hab_sck<= 1;
					cs_sensor <= 0;
					rst_counter <= rst_counter + 1;
				end
			end
	end
	3:begin
		if(rst_counter == 8)begin
				reg_sck <= 1;
				rst_counter <= 0;
			end
			else begin
				reg_sck <= !reg_sck;
				if(reg_sck)begin
					hab_sck<= 1;
					cs_sensor <= 0;
					rst_counter <= rst_counter + 1;
				end
			end
```
En esta etapa no se realiza transmision o recepcion de informacion, solo se espera el paso de los ciclos de relog para luego mantener
reg_sck en alto, reiniciar el contador y pasar a el siguiente estado de (chains_sended <= 3) para realizar el mismo proceso de delay y finaliza el case (chains_sended).

### Delay de 1 segundo (delay_counter < DELAY_1s):
```verilog
else begin
	delay_counter <= delay_counter +1; //
	cs_sensor <= 1;
	hab_sck<= 0;
	reg_sck <= 1;
	rst_counter <= 0;
	chains_sended <= 0;
	ready <= 1;
end
```
Mientras no haya transcurrido el segundo de delay entre mediciones, el contador simplemente aumentara y se deshabilitara el relog serial
y cuando se cumpla dicha condición la maquina de estados de la cadena se iniciara en 0.

### Modo 2:
```verilog
else begin
	if(ready == 1)begin
		if(load_data == 1)begin
			data_read_send <= data_1; 
			ready <= 0;
			rst_counter <= 0;
		end
	end
```
Este es un bloque de preparación donde se almacenan los datos para enviarlos con 2 condiciones donde es necesario que este activa la señal (ready), este se encuentra activo por los bloques anteriores asi que al inicializarse este bloque se lleva a cabo el proceso de carga de datos donde se carga el registro (data_read_send) con la información de (data_1) provenientes del modulo de control y luego se desactiva el (ready) para ejecutar la siguiente accion.

```verilog
	else begin
		if(rst_counter == 8)begin
			reg_sck <= 1;
			case (chains_sended)
				0:begin
					rst_counter <= 0;
					data_read_send  <= data_2;
					chains_sended <= 1;
				end
				1:begin
					if(modo == 0)begin
						rst_state <= 2;
						rst_counter <= 0;
					end
					else begin
						rst_counter <= 0;
						data_read_send<= data_3;
						chains_sended <= 2;
					end
				end
				2:begin
					rst_state <= 2;
					rst_counter <= 0;
				end
			endcase
		end
		else begin
			reg_sck <= !reg_sck;
			if(reg_sck)begin
				hab_sck<= 1;
				cs_sensor <= 0;
				mosi_sensor <= data_inverted[rst_counter];
				rst_counter <= rst_counter + 1;
			end
		end
	end
end
```
Al no estar activo el (ready) se procede a realizar la carga de los datos alternando la activación del reloj y habilitando el reloj serial y habilitando la comunicación con el sensor al dejar la señal de control (cs_sensor) en 0, la carga se hace desde el data_inverted por que queremos enviar los datos empezando por el bit mas significativo.

Una vez realizado este proceso se continua con la secuencia y se vuelve a utilizar la maquina de estados del (chains_sended) esta vez para realizar la carga de los datos y reiniciar el contador para enviarlos nuevamente por el mosi y avanzar al siguiente estado.

### ¿Se envian 2 o 3 paquetes?:
```verilog
1:begin
			if(modo == 0)begin
				rst_state <= 2;
				rst_counter <= 0;
			end
			else begin
				rst_counter <= 0;
				data_read_send<= data_3;
				chains_sended <= 2;
			end
   ```
Si modo es igual a 0, se entiende que solo eran 2 paquetes de datos y se finalizara la transmision para pasar al siguiente estado de (rst_state) que es preparacion para repetir la medición pero en caso de no ser asi, se entiende que son 3 paquetes de datos por lo que se realiza una tercera carga para enviar por el mosi, luego se pasa al estado 2 del (chains_sended) donde se finaliza la transmision y se pasa al siguiente estado del (rst_state).

### Estado 2 de (rst_state):
```verilog
2:begin
			cs_sensor <= 1;
			rst_state <= 1;
			ready <= 1;
			hab_sck<= 0;
			chains_sended <= 0;
			delay_counter <= 0;
		end
```
Una vez finalizado toda la etapa 1 del (rst_state) el estado 2 deshabilita la comunicacion manteniendo alto  (cs_sensor) y deshabilitando el relog serial y volviendo a el estado 1 para repetir la medición.


Código control principal:

Se implementó un código Verilog es un módulo llamado control_principal, el cual parece implementar el control de un sistema basado en estados para una especie de mascota virtual, con funciones relacionadas con hambre, diversión, energía y otros parámetros. Este sistema esta programado para reaccionar a diversos eventos (como presionar botones o señales externas), ajustando el estado de la mascota. 

Se procede a explicar línea por línea el codigo de control principal:



### controlador del sensor:

Para realizar las mediciones del sensor no solo es necesario un adecuado modulo de comunicación sino que ademas necesitamos
un modulo con las instrucciones de configuracion inicial del sensor con las direcciones de registro y los datos de carga correspondientes.

```verilog
module ControlSensor (
 input clk, 
 input rst,
 input miso_sensor,
 output wire cs_sensor,
 output wire sck_sensor,
 output wire mosi_sensor,
 output wire bandera_salud
);
```
### Las entradas son:
1) Reloj (clk): Establece la pauta para coordinar la ejecucion de los procesos internos del modulo

2) Reset (rst): Restablece los registros a un valor predeterminado y los procesos que dependen de estos

3) Master input slave output (miso_sensor) Recibe las mediciones de temperatura del sensor con valores hexadecimal en binario.

### Las salidas son:

1) Chip select (cs_sensor): Se encarga de informar al sensor que va a empezar a enviar y recibir instrucciones y activa el relog de comunicacion (sck_sensor).

2) Reloj serial(sck_sensor): Indica cuándo los datos deben ser leidos y escritos en sensor para un optmo control de flujo de datos y determina la velocidad de transmision.
   
3) Master output slave input (Mosi_sensor): Envia las instrucciones al sensor de configuracion y lectura de datos.

4) Bandera (bandera_salud): Es con el que se establece si la mascota virtual esta saludable o enferma.

### Declarando los registros:

```verilog
reg [7:0] data_1;
reg [7:0] data_2;
reg [7:0] data_3;
reg [1:0]modo;
```
1) reg [7:0] data1, data2 y data3:  Almacenan los datos a enviar al modulo spi_sensor.

2) reg[1:0]: Contiene el modo con el que vamos a trabajar con el sensor, 00 es para envio de 2 paquetes de datos, 01 es para el envio
   de 3 y 11 es para la lectura de temperatura del sensor.
   
3) reg load_data: Indica que los datos están listos para enviarse

4) reg[24:0] INIT_SEQ_1 [0:1]: Banco de registro con las instrucciones de la primera secuencia.
   
5) reg[24:0] INIT_SEQ_2 [0:25]: Banco de registros con las instrucciones de la segunda secuencia.

6) reg[2:0]state: Estado actual de la máquina de estados

7) reg [4:0] config_count: controla cuántas secuencias se han enviado

8) reg [31:0] delay_count :Contador que permiten esperar un tiempo determinado antes de pasar al siguiente estado

9)reg [31:0] delay_limit: indica al cuando parar de contar.

### Estableciendo parametros locales:

```verilog
localparam START = 0;
localparam SEND_INIT_1 = 1;
localparam WAIT = 2;
localparam SEND_INIT_2 = 3;
localparam READ = 4;

localparam DELAY_10ms = 15625;
localparam DELAY_100ms = 156250;
```
Los parametros START, SEND_INIT_1, WAIT,  SEND_INIT_2, READ son los estados que controlan la secuencia de envio de datos y 
localparam DELAY_10ms y localparam DELAY_100ms son retardos en la ejecución.

```verilog
initial begin
	data_1 <= 0;
	data_2 <= 0;
	data_3 <= 0;
	modo <= 0;
	load_data<= 0;
	state <= 0;
	config_count <= 0;
	delay_count <= 0;
	delay_limit <= 0;
 ```
El bloque initial establece los valores iniciales con los que el modulo empezara a trabajar con todos los valores establecidos por defecto en 0 a la espera de estados que los actualice.

```verilog

wire [24:0] act_config;

assign act_config = (state == 1)? INIT_SEQ_1[config_count]: INIT_SEQ_2[config_count];
```

Esta conexion transfiere la secuencia de inicio a los registros data_1, data_2 y data_3 para que carguen las instrucciones en el sensor.

### Instrucciones de configuracion del sensor:
Utilizando el analizador logico se pudo observar el proceso de configuración del sensor que el arduino realizaba antes de realizar las mediciones.

![image](https://github.com/user-attachments/assets/6f04c209-66df-4a74-941a-33fb22812cea)

```verilog
        INIT_SEQ_1 [0] = {1'b0, 8'hD0,8'hFF,8'h00};
        INIT_SEQ_1 [1] = {1'b0, 8'h60,8'hB6,8'h00};
	
	INIT_SEQ_2 [0] = {1'b0, 8'hF3, 8'hFF,8'h00};
	INIT_SEQ_2 [1] = {1'b1, 8'h88, 8'hFF,8'hFF};
        INIT_SEQ_2 [2] = {1'b1, 8'h8A, 8'hFF,8'hFF};                     
        INIT_SEQ_2 [3] = {1'b1, 8'h8C, 8'hFF,8'hFF}; 
        INIT_SEQ_2 [4] = {1'b1, 8'h8E, 8'hFF,8'hFF};
        INIT_SEQ_2 [5] = {1'b1, 8'h90, 8'hFF,8'hFF}; 
        INIT_SEQ_2 [6] = {1'b1, 8'h92, 8'hFF,8'hFF};
        INIT_SEQ_2 [7] = {1'b1, 8'h94, 8'hFF,8'hFF};
        INIT_SEQ_2 [8] = {1'b1, 8'h96, 8'hFF,8'hFF};
        INIT_SEQ_2 [9] = {1'b1, 8'h98, 8'hFF,8'hFF};
        INIT_SEQ_2 [10] = {1'b1, 8'h9A, 8'hFF,8'hFF};
        INIT_SEQ_2 [11] = {1'b1, 8'h9C, 8'hFF,8'hFF};
        INIT_SEQ_2 [12] = {1'b1, 8'h9E, 8'hFF,8'hFF};
        INIT_SEQ_2 [13] = {1'b0, 8'hA1, 8'hFF,8'h00};
        INIT_SEQ_2 [14] = {1'b1, 8'hE1, 8'hFF,8'hFF};
        INIT_SEQ_2 [15] = {1'b0, 8'hE3, 8'hFF,8'h00};
        INIT_SEQ_2 [16] = {1'b0, 8'hE4, 8'hFF,8'h00};
        INIT_SEQ_2 [17] = {1'b0, 8'hE5, 8'hFF,8'h00};
        INIT_SEQ_2 [18] = {1'b0, 8'hE6, 8'hFF,8'h00}; 
        INIT_SEQ_2 [19] = {1'b0, 8'hE5, 8'hFF,8'h00};
	INIT_SEQ_2 [20] = {1'b0, 8'hE7, 8'hFF,8'h00};
	INIT_SEQ_2 [21] = {1'b0, 8'h74, 8'h00,8'h00};
	INIT_SEQ_2 [22] = {1'b0, 8'h72, 8'h05,8'h00};
	INIT_SEQ_2 [23] = {1'b0, 8'h75, 8'h00,8'h00};
	INIT_SEQ_2 [24] = {1'b0, 8'h74, 8'hB7,8'h00};
 ```

Al revisar los datos enviados por el mosi y compararlos con la tabla de registro del datasheet se crea 2 bancos  de registros con las secuencias de inicialización con cada registro con una longitud de 25 bits con datos en hexadecimal

### Instanciación
```verilog
spi_sensor driver_sensor(
.clk(clk),
.rst(rst),
.miso_sensor(miso_sensor),
.data_1(data_1),
.data_2(data_2),
.data_3(data_3),
.modo(modo),
.load_data(load_data),
.cs_sensor(cs_sensor),
.sck_sensor(sck_sensor),
.mosi_sensor(mosi_sensor),
.bandera_salud(bandera_salud),
.ready(ready)
);
```

Este bloque instancia a el modulo spi_sensor y realiza multiples conexiones para transferir comandos, enviar direcciones de registro,
enviar comandos de control ademas de recibir datos de este modulo.

### Inicialización bloque Always y configuración predeterminada del reset:
```verilog
Always @(posedge clk, posedge rst)begin
	if(rst)begin
		data_1 <= 0;
		data_2 <= 0;
		data_3 <= 0;
		modo <= 0;
		load_data<= 0;
		state <= 0;
		config_count <= 0;
		delay_count <= 0;
		delay_limit <= 0;
	end
```

El bloque Always indica que las acciones en su interior se repiten en cada flanco de subida de la señal de reloj clk o en cada flanco de subida de el reset y en caso en que este se encuentre activo, se le asignan los mismos valores predeterminados a los registros y las salidas que los del bloque initial por lo que con esta accion reiniciamos el modulo.

### Maquina de estados, secuencia de inicialización:

```verilog
else begin
		case (state)
			START:begin
				state <= SEND_INIT_1;
				load_data <= 0;
			end
			SEND_INIT_1:begin
				if(ready)begin
					if(config_count == 2)begin
						state <= WAIT;
						delay_limit <= DELAY_10ms;
						delay_count <= 0;
						config_count <= 0;
						load_data <= 0;
					end
					else begin
						modo <= {1'b0,act_config[24]};
						data_1 <= act_config[23:16];
						data_2 <= act_config[15:8];
						data_3 <= act_config[7:0];
						config_count <= config_count + 1;
						load_data <= 1;
					end
				end
				else begin
					load_data <= 0;
				end
			end
```
Si el reset no se mantiene pulsado, Se ejecuta la maquina de estados cuyo registro de control es (state), como state inicia por defecto en 0, comienza su ejecución en START donde se mantiene load_data en 0  se avanza al siguiente estado, en este nuevo estado se lee la entrada (reset) proveniente del modulo spi_sensor, en caso de ser 1 se cocatena el registro (modo) con el bit mas significativo en 1 y el menos significativo dependiente de el valor de el el bit 24 de el act_config que al ser un wire, simplemente transferira el valor de el registro INIT_SEQ_1 [0] [24] y se cargan los grupos de 8 bits de este cable a los registros data_1, data_2 y data_3 y se incrementa el valor de config_count para pasar a el siguiente registro INIT_SEQ_1 [1] y se activa load data para indicar que se esta cargando la información, si (reset) no esta activo se establece load_data en 0 y no se realiza la carga de datos.

Una vez cargados y transferidos se se asignan valores a los registros (delay_limit) y (delay_count) para que esten listos una vez inicie el siguiente estado y se avanza al estado de espera.

### Maquina de estados, Espera y Asignacion la segunda etapa de carga de instrucciones:

```verilog
	WAIT:begin
		if(delay_count == delay_limit)begin
			delay_count <= 0;
			delay_limit <= 0;
			state <= (delay_limit == DELAY_10ms)?SEND_INIT_2:READ;
		end
		else begin
			delay_count <= delay_count + 1;
		end
	end
	SEND_INIT_2:begin
		if(ready)begin
			if(config_count == 25)begin
				state <= WAIT;
				delay_limit <= DELAY_100ms;
				delay_count <= 0;
				config_count <= 0;
				load_data <= 0;
			end
			else begin
				modo <= {1'b0,act_config[24]};
				data_1 <= act_config[23:16];
				data_2 <= act_config[15:8];
				data_3 <= act_config[7:0];
				config_count <= config_count + 1;
				load_data <= 1;
			end
		end
		else begin
			load_data <= 0;
		end
	end
	READ:begin
		load_data <= 0;
		modo <= 2'b11;
	end
endcase
```
En el estado Wait se realiza un delay de 10ms y una vez transcurrido este tiempo, se igualan delay_count y delay_limit a 0, continua la secuencia pasando o a SEND_INIT_2 donde se verifica si el modulo spi_sensor mantiene (ready) en 1 para poder realizar la carga de datos
y de la misma forma que se cocateno modo establecer con la que se realizaria la comunicacion con el sensor y se carga la información a data_1, data_2 y data_3  25 veces hasta que el sensor queda configurado, retornando al estado de espera pero como ya no se encuentra (delay_limit) a 10 milisegundos de retardo, se cambia al estado READ donde se desactiva la carga de datos y se mantiene en el modo 3 para que el sensor realice automaticamente las lecturas.

### Para finalizar se muestra la simulación en el testbench y su comparacion con el comportamiento del arduino.

![image](https://github.com/user-attachments/assets/f0a09266-78f7-433b-a1a8-ffd34c84194f)

![image](https://github.com/user-attachments/assets/33bc263f-b581-4043-8808-86ec229f017f)

## IMPLEMENTACIÓN FSM TAMAGOTCHI:
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

### DIAGRAMDA DE ESTADO DEL CONTROL PRINCIPAL:

![image](https://github.com/user-attachments/assets/cb71dc8a-4c3d-4a3d-9b06-bdc5451f6a5a)


## CONCLUSIONES:


* Integración exitosa de módulos digitales: A través del desarrollo del proyecto, se logró implementar un sistema que simula el comportamiento de una mascota virtual, integrando módulos que controlan los estados de hambre, diversión, energía y salud. Cada módulo interactúa de forma coherente, logrando una simulación fluida y autónoma de la mascota virtual.

* El uso de el analizador logico fue fundamental para comprender la forma en la que perifericos con protocolos como la pantalla y el sensor se comunican y a partir de ello diseñar los modulos y cargar las configuaciones de inicialización y operación.

* En el proyecto se utilizo muchos de los conceptos vistos en clase y los laboratorios, principalmente las maquinas de estado, los bancos de registro y la instanciación de modulos ademas de permitir profundizar en temas como la comunicacion por protocolos y secuencias de inicialización




