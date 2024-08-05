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

Reset: Reestablece el Tamagotchi a un estado inicial conocido al mantener pulsado el botón durante al menos 5 segundos. Este estado inicial simula el despertar de la mascota con salud óptima.

comer: Permite a la mascota virtual alimentarse y subir su estado de ánimo y reducir el nivel de hambre.

Descansar: Permite a la mascota descansar para aumentar su energía.

Acelerador de Tiempo: Permite modificar la velocidad del tiempo en el Tamagotchi, incrementando la rapidez de los cambios de estado para simular diferentes velocidades temporales.

## Sistema de Sensado:


- Sensor de Temperatura: Este sensor puede simular el clima y afectar el estado de ánimo y las necesidades de la mascota.
  
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

 Voltaje de alimentacion interna (VDD)   :            1.7V a 3.6V
 Vlotaje minimo activacion (VDD):                         1.58V
 Voltaje alimentacion interfaz (VDDIO):               1.7V a 3.6V
  Vlotaje minimo activacion (VDDIO):                      0.65V
 Corriente inactivo:                                  0.1μA a 0.3μA
 Corriente Forzado:                                      0.1μA
 Corriente medicion:                                     350μA
 Tiempo encendido (VDD > 1.58 , VDDIO > 0.65):            2ms
 Rango Temperatura:                                   -40 a 85 °C
 Temperatura optima de medicion:                       0 a 65  °C
 Resolución:                                             0.1°C

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

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/cajanegratamagotchi.png)

## Diagrama de estados


![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/diagramadeestado.drawio.png)
