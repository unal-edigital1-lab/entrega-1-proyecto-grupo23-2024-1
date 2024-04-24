# Entrega 1 del proyecto WP01

## PROYECTO TAMAGOTCHI

## Funcionalidad Principal:
El núcleo del sistema está diseñado para simular interactivamente el cuidado de una mascota virtual, permitiendo al usuario participar en actividades esenciales tales como alimentar, jugar, dormir y curar, a través de una interfaz visual y de un sistema de botones y sensores de manera que sea entretenido para el portador.

## Sistema de Visualización:

### Visualización de Información de Estado:

Pantalla LCD ILI9341: Esencial para representar visualmente el estado actual del Tamagotchi, incluyendo emociones y necesidades básicas de la mascota virtual.

### Indicadores Simples:

Display de 7 Segmentos: Utilizado para mostrar niveles y puntuaciones específicas, como el nivel de hambre o felicidad, complementando la visualización principal.

### PANTALLA: ILI9341

## Sistema de Botones:

### Botones :
La interacción usuario-sistema se realizará mediante los siguientes botones configurados:

Reset: Reestablece el Tamagotchi a un estado inicial conocido al mantener pulsado el botón durante al menos 5 segundos. Este estado inicial simula el despertar de la mascota con salud óptima.

comer: Permite a la mascota virtual alimentarse y subir su estado de ánimo y reducir el nivel de hambre.

Descansar: Permite a la mascota descansar para aumentar su energía.

Acelerador de Tiempo: Permite modificar la velocidad del tiempo en el Tamagotchi, incrementando la rapidez de los cambios de estado para simular diferentes velocidades temporales.

## Sistema de Sensado:

Con el objetivo de crear una mascota virtual que sea más interactiva con el portador se hace necesario usar sensores que nos permitan medir variables físicas del entorno donde se encuentre el dueño, esto con el fin de hacer más interesante la aplicación y cuidado de la mascota virtual. Para esto se pueden usar sensores como los siguientes:

- Sensor de Luz: Simula los ciclos de día y noche, influyendo en las rutinas de actividad y descanso de la mascota.

- Sensor de Movimiento: Promueve la actividad física al requerir que el usuario mueva el dispositivo para mantener en forma al Tamagotchi.

- Sensor de Temperatura: Este sensor puede simular el clima y afectar el estado de ánimo y las necesidades de la mascota.
  
## Estados Mínimos:

El Tamagotchi operará a través de una serie de estados que reflejan las necesidades físicas y emocionales de la mascota virtual, para hacerle saber al portador los estados saber:

Hambriento: Este estado alerta sobre la necesidad de alimentar a la mascota. La falta de atención a esta necesidad puede desencadenar un estado de enfermedad.

Energía: Denota la necesidad de entretenimiento de la mascota. La inactividad prolongada puede llevar a estado de tristeza.

Descanso: Identifica cuando la mascota requiere reposo para recuperar energía.

Salud: va a niveles de enfermo por el descuido en el cuidado de la mascota, requiriendo intervenciones específicas para su recuperación.

Ánimo: Refleja el bienestar general de la mascota como resultado de satisfacer adecuadamente sus necesidades básicas.

### Otros estados:


Actividades Específicas según el Momento del Día: Actividades que solo están disponibles durante ciertos momentos del día. 

Cambios Visuales en el Entorno: Modifica el entorno del Tamagotchi para reflejar el momento del día. Por ejemplo, durante el día, el sol podría estar brillando y los pájaros podrían estar cantando, mientras que por la noche el cielo podría estar estrellado y la luna podría brillar en el horizonte.

Influencia en el Estado de Ánimo: El estado de día, tarde o noche puede influir en el estado de Ánimo y las necesidades del Tamagotchi. 


## Sensor de temperatura SHT31


![image](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/assets/159670741/23dc7a5d-b5de-4ec0-9bdd-e6523005be3e)



### Caracteristicas principales:

 Voltaje de alimentación (Vcc): Puede operar en un rango de voltaje de 2.15V a 5V con un voltaje de operacion optimo de 3.3V.
    
Voltaje POR (Voltaje de encendido): Es el voltaje umbral al cual el sensor comienza a encenderse, su rango va  de 1.8V a 2.15V, despues de este umbral el sensor necesita el
tiempo TPU para entrar en reposo, una vez en reposo esta listo para recibir los comando del microcontrolador.

Consumo de corriente: Cuando el sensor se encuentra en reposo consume entre 0,2 y 2 microamperios, mientras que cuando se encuentra midiendo, el consumo aumenta a un rango de 
600 a 1500 microamperios.

 Resolución de temperatura: Ofrece una alta precisión en la medición de la temperatura, con un margen de error de tan solo ±0.2°C en el rango de temperaturas de 0 a 90 grados.
    
Tiempo de respuesta Tau: completa su primer ciclo tau del 63% a los 2 segundos.

Interface: Se comunica a través de la interfaz I2C, lo que facilita su integración en sistemas electrónicos y microcontroladores compatibles con este protocolo de comunicación.


### Asignacion de pines:

![image](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/assets/159670741/8c7358c4-b376-484e-8b9e-2fda3075a146)

1) SDA (serial data imput/output): Linea de transmision de datos bidireccional de el microcontrolador al sensor.
2) ADDR: Address pin: cambia la direccion I2C del sensor dependiendo de si esta en logica alta o baja.
3) Alert: da las condiciones de alarma, no se utilizara, se deja flotando.
4) SCL (Serial clock): Controla la transmision de datos en el SDA.
5) Entrada de fuente de alimentacion.
6) nReset fuerza un reseteo en el sensor.
7) No tiene funcion electrica.
8) Vss o ground (conexion a tierra).


### Serial Clock y serial data:

El SCL es utilizado para sincronizar el envio de datos entre el microcontrolador y el sensor en la linea SDA, Mientras la linea del relog se encuentre alto se permitira la comunicacion entre el microcontrolador y el sensor, en cambio si la linea del relog se encuentra baja se detendra la transmision, cada secuencia de comunicacion consta de una condicion de inicio
y su respectiva parada, el sensor puede forzar la parada y alargar el pulso del relog en bajo con la tecnica de Clock stretching en el cual indica al microcontrolador que 
debe esperar mientras el sensor procesa los datos.

El SDA se usa para transferir daos desde y hacia el sensor La línea SDA es esencial para el intercambio de información en el bus I²C. Es la línea por la cual fluyen los datos entre el microcontrolador y el sensor los cuales son el maestro y el esclavo.

Dispositivo Maestro (Microcontrolador): Es el dispositivo que inicia y controla la comunicación. Puede comenzar la transferencia de datos y proporciona la señal de reloj a través de SCL.
Dispositivo Esclavo (Sensor): Es el dispositivo que recibe las órdenes del maestro y ejecuta las instrucciones.


### Secuencia de comunicacion de medicion:

![image](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/assets/159670741/56f88ae9-ce95-4a30-8866-8e6d52cfbcd2)


Inicio de la Comunicación:
Todo intercambio de datos en I²C comienza con una instruccion de inicio generada por el microcontrolador. Esta condición sucede cuando la SDA se desplaza de un nivel alto a un nivel bajo mientras SCL se mantiene en alto.

Seleccion del sensor mediante dirección:
El maestro envía una secuencia de 7 bits que contiene la dirección del esclavo con el que desea comunicarse. Estos bits se envían secuencialmente a través de la SDA con cada pulso de reloj en SCL, el sensor de temperatura tiene posibilidad mediante el bit en la linea ADDR cambiar su direccion esto en caso de que se utilice mas de un sensor con la misma dirección.

Bit de Lectura/Escritura:
Junto con la dirección, el microcontrolador también envía un bit que indica si la operación que se desea realizar si es lectura (SDA alto) o de escritura (SDA bajo).

Confirmación de Recibo (ACK):
Después de recibir 8 bits, el sensor debe realiza la confirmación de la comunicacion. Esto lo hace tomando el control de la linea SDA y bajando durante un pulso de reloj.

Transmisión de Datos:
Los datos se transmiten en paquetes de 8 bits (un byte). Después de cada byte, se espera un ACK de confirmacion de recibido antes de continuar. Si se está escribiendo en un esclavo, el maestro coloca los datos en SDA; si se está leyendo, el esclavo coloca los datos en SDA con la medición, para medir la temperatura se utilizan 2 bytes uno el mas significante, indica los valores mas grandes como son las decenas y unidades, seguido por una confirmacion ACK y posteriormente se transfiere el bit menos significativo que contendra los valores menores que serian decimas o centecimas de grado.

![image](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/assets/159670741/20156690-3df8-4d64-b1d5-377cb46d2e27)

Condición de Parada:
La comunicación finaliza con una "condición de parada" que el maestro genera, haciendo que SDA cambie de estado de un nivel bajo a un nivel alto mientras SCL está alto.
   


#### Protocolo I2c

El protocolo de comunicación I2C (Inter-Integrated Circuit) es un puerto y protocolo de comunicación serial utilizado para transferir datos entre dos dispositivos digitales. El protocolo I2C define la trama de datos y las conexiones físicas utilizadas para transferir bits entre los dispositivos. Utiliza dos líneas de comunicación, una línea de datos (SDA) y una línea de reloj (SCL), para transmitir información de manera sincronizada.

Comunicación maestro-esclavo: En el protocolo I2C, uno de los dispositivos actúa como maestro y los demás como esclavos. El maestro inicia y controla la comunicación, mientras que los esclavos responden a las solicitudes del maestro.

Direcciones de dispositivo: Cada dispositivo conectado al bus I2C tiene una dirección única que lo identifica. El maestro utiliza estas direcciones para seleccionar el dispositivo con el que desea comunicarse.

El protocolo I2C admite diferentes velocidades de transferencia, que van desde unos pocos kilobits por segundo hasta varios megabits por segundo. La velocidad de transferencia se configura mediante la frecuencia del reloj.

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/I2C.jpg)




### Sensor de Luz

Módulo Sensor De Luz Ldr SENL

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-22%2012-49-57.png)

Sensor de luz que cuenta con una entrada de alimentación, una entrada a tierra, una salida analógica y otra salida digital.

La salida digital del sensor es de un bit, lo que quiere decir que solo hay un estado donde hay luz y otro donde no, esto se puede arreglar con un conversor analógico-digital donde obtenemos un muestreo de la salida analógica y tener diferentes niveles de paso de luz

#### Conversor Analógico-Digital 

PmodAD1

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-22%2013-23-15.png)

El conversor analógico-digital de 12 bits se caracteriza por su implementación utilizando un protocolo de comunicación similar a SPI de dos canales. Este diseño permite una conversión A/D simultánea con una velocidad de hasta un MSa (muestra por segundo) por canal, tiene alimentación de 2.35 a 5.25 voltios.

##### Diagrama del circuito

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-20%2008-20-51.png)

##### Tabla de pines 

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-20%2008-21-31.png)

### Sensor de Movimiento 

La implementación de un sensor de movimiento en este proyecto sería útil en aplicaciones que permitan interactuar con la mascota virtual y la persona física dueña del Tamagotchi. 

Es decir cuando la mascota virtual requiera ejercitarse el portador (dueño/propietario) puede hacerlo caminando en la vida real, mostrando al tiempo algún ejemplo de animación de la mascota moviéndose en la pantalla para generar más interactividad a las acciones.

Para realizar estas acciones se requiere un sensor que permita detectar que el portador (persona física) se esté moviendo en la vida real; con este objetivo se pueden encontrar sensores en el mercado que nos permite detectar esta acción como lo es la implementación de un acelerómetro, un giroscopio o un sensor infrarrojo de movimiento


### -> Acelerómetro

Es un dispositivo utilizado para medir la aceleración o vibración de un objeto o estructura. Funciona detectando los cambios en la fuerza de aceleración experimentada por el dispositivo en diferentes direcciones.

Midiendo la fuerza de aceleración en la unidad "g" (gravedad). Puede medir la aceleración en uno, dos o tres planos, dependiendo del tipo de acelerómetro.

Principio de funcionamiento: Los acelerómetros utilizan diferentes principios para medir la aceleración. Algunos acelerómetros utilizan el principio piezoeléctrico, donde la aceleración genera una carga eléctrica en un material piezoeléctrico. Otros utilizan el principio capacitivo, donde la aceleración causa cambios en la capacitancia de un capacitor. También hay acelerómetros basados en tecnología MEMS (Microelectromechanical Systems), que utilizan estructuras microscópicas para medir la aceleración.

Acelerómetros de 3 ejes: Los acelerómetros de 3 ejes son los más utilizados.(Utilizados mayoritariamente en dispositivos celulares) Estos pueden detectar aceleraciones en tres direcciones diferentes: X, Y y Z. Esto permite medir la aceleración en cualquier dirección tridimensional.

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/acelerometro%20funcionamiento.webp)


Acelerómetro Digital de 3 Ejes ADXL345 

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-22%2013-16-30.png)

Acelerómetro Digital de 3 Ejes ADXL345, utilizado principalmente en aplicaciones móviles. Se caracteriza por su bajo consumo de energía, dispone de sensibilidad ajustable a una resolución de 16 bits. Se puede conectar fácilmente a través de su interfaz SPI (3 o 4 hilos) e I2C.

Principales Características:

    Voltaje de Alimentación DC: 2V ~ 3.3V
    Corriente de operación: 140uA
    Interfaz: I2C - SPI (5 MHz)
    Auto Test: Ejes X, Y, Z
    Frecuencia de Reloj Interna: 400 KHz
    Rangos: 2g, 4g, 8g y 16g
    Sensibilidad: 4 LSB/g
    Temperatura de funcionamiento: -40°C ~ 85°C



## Caja negra

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/IMG_0109.jpg)

## Diagrama de estados


### Hambre
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/WhatsApp%20Unknown%202024-04-23%20at%205.53.41%20PM/WhatsApp%20Image%202024-04-23%20at%204.39.39%20PM.jpeg)

El estado de hambre de la mascota virtual dependerá de si ha comido recientemente y del tiempo transcurrido desde su última comida. Habrá dos estados principales: uno en el que la mascota esté hambrienta y otro en el que se sienta saciada.
La variable "tiempo" indica que ha transcurrido una cantidad específica de tiempo.
### Descanso
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/WhatsApp%20Unknown%202024-04-23%20at%205.53.41%20PM/WhatsApp%20Image%202024-04-23%20at%204.39.36%20PM.jpeg)

El estado de descanso de la mascota virtual estará determinado por la cantidad de tiempo que ha pasado sin dormir y si ha tenido oportunidad de descansar. Sin embargo, el tiempo que la mascota pasa en estado de descanso también será relevante para su bienestar general.
La variable "tiempo" indica que ha transcurrido una cantidad específica de tiempo.
### Energía
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/WhatsApp%20Unknown%202024-04-23%20at%205.53.41%20PM/WhatsApp%20Image%202024-04-23%20at%204.39.39%20PM%20(1).jpeg)

La energía de la mascota virtual estará influenciada por su estado de hambre y descanso, lo que resultará en tres estados diferentes de energía. Estos estados cambiarán dinámicamente dependiendo de las entradas recibidas.

### Actividad física
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/WhatsApp%20Unknown%202024-04-23%20at%205.53.41%20PM/WhatsApp%20Image%202024-04-23%20at%204.39.37%20PM.jpeg)

La actividad física de la mascota virtual dependerá de los datos recibidos del acelerómetro, los cuales determinarán cuánta actividad física realiza la mascota.

### Momento del día
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/WhatsApp%20Unknown%202024-04-23%20at%205.53.41%20PM/WhatsApp%20Image%202024-04-23%20at%204.39.46%20PM.jpeg)

El momento del día para la mascota virtual estará determinado por la cantidad de luz recibida a través del sensor de luz. Esta información influirá en el estado de ánimo de la mascota, afectando su comportamiento y emociones.

### Temperatura
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/WhatsApp%20Unknown%202024-04-23%20at%205.53.41%20PM/WhatsApp%20Image%202024-04-23%20at%204.39.38%20PM%20(1).jpeg)

La temperatura de la mascota virtual estará determinada por el sensor de temperatura, y será crucial para evaluar su salud. Por ejemplo, si la mascota se encuentra en un ambiente frío, podría estar en riesgo de resfriarse.
### Ánimo 
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/WhatsApp%20Unknown%202024-04-23%20at%205.53.41%20PM/WhatsApp%20Image%202024-04-23%20at%204.39.45%20PM.jpeg)

El estado de ánimo de la mascota virtual estará influenciado principalmente por el momento del día y la energía que tenga en ese momento. Indirectamente, estos dos factores también dependerán del descanso y el hambre de la mascota.
### Salud

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/WhatsApp%20Unknown%202024-04-23%20at%205.53.41%20PM/WhatsApp%20Image%202024-04-23%20at%204.39.38%20PM.jpeg)
El estado más importante de la mascota virtual será su salud, la cual estará determinada por tres variables principales: la actividad física, la temperatura y el estado de ánimo. Este estado de salud será el resultado de la interacción entre todas estas variables.
