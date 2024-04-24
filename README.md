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


### Sensor de temperatura


SHT30

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-23%2022-40-07.png)
El Sensor de temperatura y humedad SHT30 es un dispositivo versátil diseñado para medir con precisión tanto la temperatura como la humedad en diversos entornos. Sus características principales son:

    Voltaje de alimentación (Vcc): Puede operar en un rango de voltaje de 2.5V a 5V, lo que lo hace compatible con una amplia variedad de sistemas y microcontroladores.

    Resolución de temperatura: Ofrece una alta precisión en la medición de la temperatura, con una resolución de ±0.3°C. Esto garantiza mediciones confiables y precisas incluso en condiciones variables.

    Resolución de humedad: Igualmente importante, su capacidad para medir la humedad con una resolución de ±2% asegura mediciones exactas y consistentes en entornos con diferentes niveles de humedad.

    Interface: Se comunica a través de la interfaz I2C, lo que facilita su integración en sistemas electrónicos y microcontroladores compatibles con este protocolo de comunicación.

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