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


![image](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/assets/159670741/23dc7a5d-b5de-4ec0-9bdd-e6523005be3e)

Es un sensor de presión, temperatura y humedad optimizado para registrar bajo ruido y alta resolucion que maneja tanto el protocolo de comunicacion I2C como el SPI y se
alimenta de voltajes entre 1.7 y 3.6 voltios otorgando mediciones exactas en todo el rango de voltajes. El BME 280 opera con 3 modos de energia, Sleep mode (inactividad), 
Normal mode (medicion regular) y Forced mode (unica medicion).


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

Alimentación:

El sensor posee 2 alimentaciones el VDD que suministra los bloques funcionales internos de el dispositivo y el VDDIO que alimenta la interfaz de comunicacion de este
El sensor posee la funcionalidad POR que restablece los valores de los registros a un valor predeterminado cuando VDD y VDDIO se encuentran por debajo de sus voltajes
minimos de activación.

Se debe mantener las señales de la interfaz en un nivel logico bajo cuando VDDIO se encuentran desactivados para evitar daños.

Si hay alimentacion en VDDIO pero no en VDD, los pines se mantendran en alta impedancia y el bus de datos se puede utilizar sin problema.

Seleccion de modo: Se puede intercambiar de modo de operación seleccionando entre 

![image](https://github.com/user-attachments/assets/518a7908-dc8a-4c03-9e94-2f5c345771da)



### Serial Clock y serial data:

El SCL es utilizado para sincronizar el envio de datos entre el microcontrolador y el sensor en la linea SDA, Mientras la linea del relog se encuentre alto se permitira la comunicacion entre el microcontrolador y el sensor, en cambio si la linea del relog se encuentra baja se detendra la transmision, cada secuencia de comunicacion consta de una condicion de inicio
y su respectiva parada, el sensor puede forzar la parada y alargar el pulso del relog en bajo con la tecnica de Clock stretching en el cual indica al microcontrolador que 
debe esperar mientras el sensor procesa los datos.

El SDA se usa para transferir daos desde y hacia el sensor La línea SDA es esencial para el intercambio de información en el bus I²C. Es la línea por la cual fluyen los datos entre el microcontrolador y el sensor los cuales son el maestro y el esclavo.

Dispositivo Maestro (Microcontrolador): Es el dispositivo que inicia y controla la comunicación. Puede comenzar la transferencia de datos y proporciona la señal de reloj a través de SCL.
Dispositivo Esclavo (Sensor): Es el dispositivo que recibe las órdenes del maestro y ejecuta las instrucciones.





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
