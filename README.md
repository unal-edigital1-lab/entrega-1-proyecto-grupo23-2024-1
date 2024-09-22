# Entrega 1 del proyecto WP01

## PROYECTO TAMAGOTCHI

## Funcionalidad Principal:
El núcleo del sistema está diseñado para simular interactivamente el cuidado de una mascota virtual, permitiendo al usuario participar en actividades esenciales tales como alimentar, jugar, dormir y curar, a través de una interfaz visual y de un sistema de botones y sensores de manera que sea entretenido para el portador.

## Sistema de Visualización:

### Visualización de Información de Estado:

Pantalla LCD ILI9225: El display LCD TFT 2.0" es una pantalla a colores con una resolución de 176x220 píxeles, controlador gráfico ILI9225, comunicación SPI y puede mostrar hasta 262144 colores RGB distintos. Esencial para representar visualmente el estado actual del Tamagotchi, incluyendo emociones y necesidades básicas de la mascota virtual.

## PANTALLA: ILI9225
### Especificación de la pantalla ILI9225:

La pantalla ILI9225 es un controlador de pantalla LCD de 2.0 pulgadas, comúnmente utilizada en proyectos electrónicos con microcontroladores.
Esta pantalla tiene un esquema general de pines, los cuales son: 

* VCC: Alimentación (generalmente 3.3V o 5V, dependiendo del modelo).
* GND: Tierra.
* CS: Chip Select, selecciona el dispositivo.
* RST: Reset, reinicia la pantalla.
* RS: Register Select (también llamado DC o A0), selecciona entre comandos y datos.
* WR: Write (para escribir datos).
* RD: Read (para leer datos).
* LED_A o BL (Backlight): Anodo del backlight (luz de fondo), si se proporciona.
* D0 - D15: Pines de datos (para comunicación paralela, algunos módulos solo tienen D0-D7).
* SCL (Serial Clock): Reloj para la comunicación SPI.
* SDA (Serial Data) / MOSI (Master Out Slave In): Datos para la comunicación SPI.
  
### Pines para SPI (Modo Serial)

En modo SPI, los pines típicamente serán:

* VCC: Alimentación del módulo (3.3V o 5V).
* GND: Tierra.
* CS: Selección del chip.
* RST: Reinicio del módulo.
* RS/DC: Selección entre datos y comandos.
* SCL: Reloj serial.
* SDA/MOSI: Datos del maestro al esclavo.
* BL: Retroiluminación.

### Pines para Paralelo (Modo Paralelo)

En modo paralelo, los pines típicamente serán:

* VCC: Alimentación del módulo (3.3V o 5V).
* GND: Tierra.
* CS: Selección del chip.
* RST: Reinicio del módulo.
* RS/DC: Selección entre datos y comandos.
* WR: Señal de escritura.
* RD: Señal de lectura.
* D0 - D15: Pines de datos.
* BL: Retroiluminación.

## Protocolo de comunicación:

La pantalla ILI9225 puede comunicarse mediante dos protocolos de comunicación principales: paralelo y SPI, pero en este caso nos enfocaremos en la comunicación SPI:

### Comunicación SPI (Serial Peripheral Interface)
es un protocolo serial que usa menos pines que la comunicación paralela. Es más fácil de implementar y más común en microcontroladores con pocos pines.

### Pines:

* MOSI (Master Out Slave In): Datos del maestro al esclavo.
* MISO (Master In Slave Out): Datos del esclavo al maestro (a menudo no se usa).
* SCLK (Serial Clock): Reloj serial.
* CS: Chip Select.
* RST: Reset.
* RS (o DC/A0): Register Select (para diferenciar entre comandos y datos).
  
### Secuencia de comunicación:

* Establece CS bajo (activo).
* Establece RS para seleccionar si es un comando (bajo) o datos (alto).
* Envía los datos en serie mediante MOSI, sincronizados con SCLK.
* Repite según sea necesario.
* Establece CS alto (inactivo) cuando termines.

### Indicadores Simples:

Display de 7 Segmentos: Utilizado para mostrar niveles y puntuaciones específicas, como el nivel de hambre o felicidad, complementando la visualización principal.


## Sistema de Botones:

### Botones :
La interacción usuario-sistema se realizará mediante los siguientes botones configurados:

test: permite visualizar los diferentes estados del tamagotchi

Reset: Reestablece el Tamagotchi a un estado inicial conocido al mantener pulsado el botón durante al menos 5 segundos. Este estado inicial simula el despertar de la mascota con salud óptima.

comer: Permite a la mascota virtual alimentarse y subir su estado de ánimo y reducir el nivel de hambre.

Descansar: Permite a la mascota descansar para aumentar su energía.

jugar: permite al tamagotchi divertirse para evitar estar en estado de aburrimiento

Acelerador de Tiempo: Permite modificar la velocidad del tiempo en el Tamagotchi, incrementando la rapidez de los cambios de estado para simular diferentes velocidades temporales.

## Sistema de Sensado:


- Sensor de Temperatura: Este sensor puede simular el clima y serà visualizado en la pantalla
  
## Estados :

El Tamagotchi operará a través de una serie de estados que reflejan las necesidades físicas y emocionales de la mascota virtual, para hacerle saber al portador los estados saber:

Hambriento: Este estado alerta sobre la necesidad de alimentar a la mascota. La falta de atención a esta necesidad puede desencadenar un estado de enfermedad.

Energía: Denota la necesidad de entretenimiento de la mascota. La inactividad prolongada puede llevar a estado de tristeza.

Descanso: Identifica cuando la mascota requiere reposo para recuperar energía.

Salud: va a niveles de enfermo por el descuido en el cuidado de la mascota, requiriendo intervenciones específicas para su recuperación.

Ánimo: Refleja el bienestar general de la mascota como resultado de satisfacer adecuadamente sus necesidades básicas.

Cambios Visuales en el Entorno: Modifica el entorno del Tamagotchi para reflejar el momento del día. Por ejemplo, durante el día, el sol podría estar brillando y los pájaros podrían estar cantando, mientras que por la noche el cielo podría estar estrellado y la luna podría brillar en el horizonte.

## Sensor de temperatura BME280


![image](https://github.com/user-attachments/assets/555d231b-9240-4572-814c-285442ad4682)


Es un sensor de presión, temperatura y humedad optimizado para registrar bajo ruido y alta resolucion que maneja tanto el protocolo de comunicacion I2C como el SPI y se
alimenta de voltajes entre 1.7 y 3.6 voltios otorgando mediciones exactas en todo el rango de voltajes. 

### Caracteristicas principales:

* Voltaje de alimentacion interna (VDD)   :            1.7V a 3.6V
* Vlotaje minimo activacion (VDD):                         1.58V
* Voltaje alimentacion interfaz (VDDIO):               1.7V a 3.6V
*  Vlotaje minimo activacion (VDDIO):                      0.65V
* Corriente inactivo:                                  0.1μA a 0.3μA
* Corriente Forzado:                                      0.1μA
* Corriente medicion:                                     350μA
* Tiempo encendido (VDD > 1.58 , VDDIO > 0.65):            2ms
* Rango Temperatura:                                   -40 a 85 °C
* Temperatura optima de medicion:                       0 a 65  °C
* Resolución:                                             0.1°C

![image](https://github.com/user-attachments/assets/ca90c08d-ea1f-4f49-a78e-5d0c4bbd40d2)

### Activacion del sensor:

El sensor posee 2 alimentaciones el VDD que suministra los bloques funcionales internos de el dispositivo y el VDDIO que alimenta la interfaz de comunicacion de este
El sensor posee la funcionalidad POR que restablece los valores de los registros a un valor predeterminado en el instante inmediatamente anterior al encendido del sensor
cuando VDD y VDDIO se encuentran por debajo de sus voltajes minimos de activación.

Se debe mantener las señales de la interfaz en un nivel logico bajo cuando VDDIO se encuentran desactivados para evitar daños.

Si hay alimentacion en VDDIO pero no en VDD, los pines se mantendran en alta impedancia y no transmitira señales permitiendo el uso del bus de datos para otros perifericos.

###Seleccion de modo: 

El sensor tiene 3 modos de operación Sleep mode (inactividad), Normal mode (medicion regular) y Forced mode (unica medicion) por medio de un multiplexor y una señal de control
de 2 bits es posible realizar el cambio de estados.

Sleep mode (inactividad): No realiza mediciones, tiene bajo consumo de energia y se establece por defecto al encender el sensor y permite el acceso a registros.

Normal mode (medicion regular): realiza mediciones con una frecuencia regular determinada por el relog y aumenta el consumo de energia.

Forced mode (unica medicion): Tal y como indica su nombre, realiza una unica medicion forzada luego de la correspondiente instrucción para volver a el Sleep mode
y realizar la lectura de medición.

![image](https://github.com/user-attachments/assets/518a7908-dc8a-4c03-9e94-2f5c345771da)

###Diagrama de flujo de medida:

Como el sensor realiza mediciones de temperatura presion y humedad, es necesario dejar en 0 las variables que controlan estas mediciones para tomar unicamente las de
temperatura, adicionalmente el sensor posee un filtro IIR que permite atenuar el ruido de la señal para reducir las fluctuacione que puede ser activado para reducir
el ruido de estas señales y obtener mejores mediciones.

![image](https://github.com/user-attachments/assets/06ee7749-0e3e-4853-9d16-8516d3613f2a)

###Mapa de memoria:

![image](https://github.com/user-attachments/assets/f65729ff-9e3a-4ec7-be18-842489769aa3)

En el mapa podemos observar los registros que contienen los datos de  temperatura, presion y humedad medidos pero como solo nos interesa medir la temperatura, 
desactivamos presion y humedad en cambiando los parametros osrs_p[2:0] y osrs_h[2:0] de los registros Ctrl meas y ctrl hum respectivamente, a su vez con el registro
ctrl meas se cambia el estado de medicion visto anteriormente y con el registro config podemos activar y desactivar el filtro del sensosr y establecer su coeficiente, 
tambien el mapa nos indica en que registro se encuentra el reset, el chip ID y los datos de calibración

La lectura y escritura del dispositivo se realiza leyendo y escribiendo registros con un ancho de 8 bits, 

### Serial Clock y serial data:

El SCL es utilizado para sincronizar el envio de datos entre el microcontrolador y el sensor en la linea SDA, Mientras la linea del relog se encuentre alto se permitira la comunicacion entre el microcontrolador y el sensor, en cambio si la linea del relog se encuentra baja se detendra la transmision, cada secuencia de comunicacion consta de una condicion de inicio
y su respectiva parada, el sensor puede forzar la parada y alargar el pulso del relog en bajo con la tecnica de Clock stretching en el cual indica al microcontrolador que 
debe esperar mientras el sensor procesa los datos.

El SDA se usa para transferir daos desde y hacia el sensor La línea SDA es esencial para el intercambio de información en el bus I²C. Es la línea por la cual fluyen los datos entre el microcontrolador y el sensor los cuales son el maestro y el esclavo.

Dispositivo Maestro (Microcontrolador): Es el dispositivo que inicia y controla la comunicación. Puede comenzar la transferencia de datos y proporciona la señal de reloj a través de SCL.
Dispositivo Esclavo (Sensor): Es el dispositivo que recibe las órdenes del maestro y ejecuta las instrucciones.





## Caja negra

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/diagrama_caja_negra.png)

## Diagrama de estados


![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/diagramadeestado.drawio.png)

## Funcionamiento pantalla ili9225


## INTERPRETACIÓN DE LOS CÓDIGOS: 


### CÓDIGO ANTIREBOTE:


Se hizo un módulo Verilog llamado antirebote implementa un sistema de anti-rebote para un botón. Los botones físicos suelen tener un comportamiento de "rebote" (pequeñas fluctuaciones en la señal cuando son presionados), lo que puede causar múltiples activaciones no deseadas. El objetivo de este módulo es eliminar esos rebotes y proporcionar una señal estable cuando el botón es presionado.

Procedemos a desglosar el código línea por línea:

DEFINICIÓN DEL MÓDULO Y ENTRADAS/SALIDAS:

    module antirebote (
    input boton,
    input clk,
    output reg rebotado );

ENTRADAS:

boton: La señal del botón físico que podría tener rebotes.
clk: Señal de reloj que controla la secuencia de operaciones.

Salida:
rebotado: Señal de salida filtrada, libre de rebotes. Esta señal refleja el estado del botón pero solo cambia cuando se ha confirmado que el botón fue presionado de manera estable (sin rebotes).

REGISTROS INTERNOS:

    reg previo; //valor previo del boton
    reg[21:0] contador; //conteo hasta 50ms

previo: Almacena el valor anterior del botón para detectar cambios en su estado.
contador: Un contador de 22 bits que se utiliza para medir el tiempo durante el cual el botón debe estar estable para que se considere como una acción válida (sin rebotes). Este contador se utiliza para ignorar fluctuaciones rápidas en la señal del botón.

INICIALIZACIÓN:

    initial begin
    previo <= 0; 
    contador <= 0; 
    rebotado <= 0;
    end

EL BLOQUE INITIAL ESTABLECE LOS VALORES INICIALES:
PREVIO: Se inicia en 0, lo que significa que inicialmente no se detecta ninguna pulsación de botón.
contador: Comienza en 0, lo que significa que aún no se ha comenzado a contar el tiempo de estabilidad del botón.
REBOTADO: Se inicia en 0, lo que significa que inicialmente la salida no indica ninguna pulsación de botón.
Lógica secuencial

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

    module controltiempo(
    input clk,
    input reset,
    input boton_acelerar,
    output reg secondpassed
    );

ENTRADAS:

CLK: Señal de reloj (clock) que controla el ritmo del módulo.\

RESET: Señal de reinicio que restablece el contador y las salidas.

BOTON_ACELERAR: Si está activado, acelera el paso del tiempo.

SALIDAS:

SECONDPASSED: Una señal que indica si ha pasado el tiempo definido (puede ser un segundo o menos si el botón boton_acelerar está presionado).

REGISTROS INTERNOS

    reg [35:0]contador;
    wire [35:0]limite;

CONTADOR: Un registro de 36 bits que cuenta el número de ciclos de reloj (clk).

LIMITE: ES un cable (wire) que define cuántos ciclos de reloj deben pasar antes de que secondpassed cambie de estado (indicando que ha pasado el tiempo especificado). El valor de este límite depende de si el botón boton_acelerar está presionado o no.

BLOQUE INITIAL

    initial begin
    contador <= 0;
    secondpassed <= 0;
    end

Esta es la sección de inicialización. Se establece que al comenzar, el contador está en 0 y la señal secondpassed también está en 0. Esto garantiza que el módulo comience en un estado limpio.

ASIGNACIÓN CONDICIONAL DEL LÍMITE:

    assign limite = (boton_acelerar) ? 'd2000000 : 'd25000000;

EL VALOR DE LIMITE SE ASIGNA DE FORMA CONDICIONAL:

* Si boton_acelerar está presionado (boton_acelerar == 1), el límite se reduce a 2,000,000 ciclos de reloj (un valor más bajo que acelera el conteo).
* Si boton_acelerar no está presionado (boton_acelerar == 0), el límite se establece en 25,000,000 ciclos, que podría representar aproximadamente 1 segundo (dependiendo de la frecuencia del reloj).

LÓGICA SECUENCIAL

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


### Código control principal:

Se implementó un código Verilog es un módulo llamado control_principal, el cual parece implementar el control de un sistema basado en estados para una especie de mascota virtual, con funciones relacionadas con hambre, diversión, energía y otros parámetros. Este sistema esta programado para reaccionar a diversos eventos (como presionar botones o señales externas), ajustando el estado de la mascota. 

Se procede a explicar línea por línea el codigo de control principal:

DEFINICIÓN DEL MÓDULO Y ENTRADAS/SALIDAS

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
    
EL MÓDULO CONTROL_PRINCIPAL TIENE VARIAS ENTRADAS Y SALIDAS:

ENTRADAS: CLK (reloj), reset (reiniciar el sistema), secondpassed (indica si ha pasado un segundo), boton_dormir, boton_jugar, boton_comer, test y enfermo_sensor.

SALIDAS: REGISTROS de 3 bits hambre, diversion, energia, estado, y un modo modo.

Estas entradas/salidas son cables (wire y reg), que representan señales que cambian según el tiempo o los eventos.

REGISTROS INTERNOS Y FLAGS

    reg [10:0] contador_sueno;
    reg [10:0] contador_diversion;
    reg [10:0] contador_hambre;
    reg [10:0] contador_dormir;
    
Estos registros son contadores que se utilizan para medir el tiempo transcurrido desde que comenzó a afectar cada uno de los parámetros de la mascota (hambre, diversión, energía, sueño, etc.).

    reg [35:0] contador_reset;
    reg [35:0] contador_test;
    reg dormido;
    reg enfermo_control;
    wire enfermo;
    assign enfermo = enfermo_control | enfermo_sensor;
  
* contador_reset y contador_test son contadores de alta precisión.
* dormido indica si la mascota está durmiendo.
* enfermo_control controla el estado de enfermedad, y enfermo es una señal combinada que indica si está enfermo en base a enfermo_control o el sensor enfermo_sensor.

      reg muerte;
      reg flag_jugar;
      reg flag_dormir;
      reg flag_time;
      reg flag_comer;
      reg flag_test;
  
* muerte indica si la mascota ha muerto.
* Los flags (flag_jugar, flag_dormir, flag_time, flag_comer, flag_test) son usados para prevenir que los eventos se repitan en un solo ciclo de reloj.

INICIALIZACIÓN:

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
    
Esta parte inicializa los registros en valores predeterminados. La mascota comienza con hambre, diversión y energía en nivel 3, y no está dormida ni enferma. También se ponen a 0 todos los contadores y flags.

ESTADOS PREDEFINIDOS:

    localparam FELIZ = 0;
    localparam HAMBRIENTO = 1;
    localparam CANSADO = 2;
    localparam ABURRIDO = 3;
    localparam ENFERMO = 4;
    localparam DORMIDO = 5;
    localparam MUERTO = 6;
    
Define varios estados predefinidos: FELIZ, HAMBRIENTO, CANSADO, ABURRIDO, ENFERMO, DORMIDO, y MUERTO. Estos son los diferentes estados en los que puede estar la mascota.
Lógica combinacional para el estado

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
    
Determina el estado de la mascota basándose en varios factores. Si tiene hambre, poca energía y poca diversión, la mascota muere. Si está enferma o dormida, su estado cambia respectivamente. Si tiene energía baja, hambre o aburrimiento, el estado se ajusta según esos parámetros.

BLOQUE SECUENCIAL DE ACTUALIZACIÓN:

    always @(posedge clk) begin
    if(secondpassed) begin
    flag_time <= 1;
    if(!flag_time) begin
      if (!modo & !muerte) begin // Actualiza contadores de hambre, diversión y energía
      
Aquí se actualizan los contadores y los niveles de los parámetros cada vez que secondpassed se activa, lo cual indica que ha pasado un segundo. Por ejemplo, si un contador llega a un cierto valor (como contador_diversion), se reduce el nivel de diversión.

También se controla el modo de juego, se reinician los contadores si es necesario, y se verifica si los botones de acción (boton_comer, boton_jugar, boton_dormir) han sido presionados para modificar el estado de la mascota.

Este es un esquema general del funcionamiento. La lógica se organiza para que, dependiendo de las señales recibidas (como botones y paso del tiempo), los parámetros internos cambien, ajustando el estado de la mascota virtual. 





