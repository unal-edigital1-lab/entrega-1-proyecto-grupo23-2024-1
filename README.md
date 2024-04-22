# Entrega 1 del proyecto WP01

## PROYECTO TAMAGOTCHI

## Funcionalidad Principal:
El nucleo del sistema esta dise�ado para simular interactivamente el cuidado de una mascota virtual, permitiendo al usuario participar en actividades esenciales tales como alimentar, jugar, dormir y curar, a traves de una interfaz visual y de un sistema de botones y sensores de manera que sea entretenido para el portador.

## Sistema de Visualizacion:

### Visualizacion de Informacion de Estado:

Matriz de Puntos 8x8: Esencial para representar visualmente el estado actual del Tamagotchi, incluyendo emociones y necesidades basicas de la mascota virtual.

### Indicadores Simples:

Display de 7 Segmentos: Utilizado para mostrar niveles y puntuaciones especificas, como el nivel de hambre o felicidad, complementando la visualizacion principal.

### PANTALLA: LCD

## Sistema de Botones:

### Botones :
La interaccion usuario-sistema se realizara mediante los siguientes botones configurados:

Reset: Reestablece el Tamagotchi a un estado inicial conocido al mantener pulsado el boton durante al menos 5 segundos. Este estado inicial simula el despertar de la mascota con salud optima.

Test: Activa el modo de prueba al mantener pulsado por al menos 5 segundos, permitiendo al usuario navegar entre los diferentes estados del Tamagotchi con cada pulsacion.

Botones de Interaccion (2): Facilitan acciones directas como alimentar, jugar, o curar, posibilitando la implementacion de actividades específicas para el bienestar del Tamagotchi.

Acelerador de Tiempo: Permite modificar la velocidad del tiempo en el Tamagotchi, incrementando la rapidez de los cambios de estado para simular diferentes velocidades temporales.

## Sistema de Sensado:

Con el objetivo de crear una mascota virtual que sea mas interactiva con el portador se hace necesario usar sensores que nos permitan medir variables fisicas del entorno donde se encuentre el due�o, esto con el fin de hacer mas interesante la aplicacion y cuidado de la mascota virtual. Para esto se pueden usar sensores como los siguientes:

- Sensor de Luz: Simula los ciclos de di�a y noche, influyendo en las rutinas de actividad y descanso de la mascota.

- Sensor de Movimiento: Promueve la actividad fisica al requerir que el usuario mueva el dispositivo para mantener en forma al Tamagotchi, ejemplo el usuario se puede desplazar y dar la sensacion de caminar para el tamagotchi.

- Sensor de Temperatura: Este sensor puede simular el clima y afectar el estado de animo y las necesidades de la mascota. Por ejemplo, si hace calor, el Tamagotchi puede necesitar mas agua, mientras que en climas frios podri�a necesitar una manta.


## Estados Minimos:

El Tamagotchi operara a traves de una serie de estados que reflejan las necesidades fisicas y emocionales de la mascota virtual, para hacerle saber al portador los estados  saber:

Hambriento: Este estado alerta sobre la necesidad de alimentar a la mascota. La falta de atencion a esta necesidad puede desencadenar un estado de enfermedad.

Energia: Denota la necesidad de entretenimiento de la mascota. La inactividad prolongada puede llevar a estados de aburrimiento o tristeza.

Descanso: Identifica cuando la mascota requiere reposo para recuperar energia, especialmente despues de peri�odos de actividad intensa o durante la noche, limitando la interaccion del usuario durante estas fases.

Salud: va a niveles de enfermo por el descuido en el cuidado de la mascota, requiriendo intervenciones especi�ficas para su recuperacion.

Animo: Refleja el bienestar general de la mascota como resultado de satisfacer adecuadamente sus necesidades básicas.

### Otros posibles estados:

Crecimiento/Evolucion: La mascota experimentara distintas fases de crecimiento, cada una con requisitos y comportamientos especi�ficos, ilustrando el desarrollo y maduracion de la mascota a lo largo del tiempo.

Personalizacion: Permite al usuario personalizar la apariencia del Tamagotchi, como cambiar su color, agregar accesorios o modificar su entorno.

Logros y Recompensas: Implementa un sistema de logros y recompensas que motive al usuario a cuidar bien de su Tamagotchi. Por ejemplo, podra desbloquear nuevas caracteristicas, accesorios o juegos al alcanzar ciertos hitos

Exploracion: Introduce la capacidad de explorar diferentes entornos virtuales con el Tamagotchi. Por ejemplo, podran explorar un parque, una playa, una ciudad, entre otros.

Actividades Especificas segun el Momento del Dia: Actividades que solo estan disponibles durante ciertos momentos del di�a. Por ejemplo, durante el dia, el Tamagotchi podr�a tener la opcion de jugar afuera, mientras que por la noche podri�a preferir quedarse dentro y ver la television.

Cambios Visuales en el Entorno: Modifica el entorno del Tamagotchi para reflejar el momento del dia. Por ejemplo, durante el dia, el sol podría estar brillando y los pajaros podran estar cantando, mientras que por la noche el cielo podri�a estar estrellado y la luna podr�a brillar en el horizonte.

Influencia en el Estado de Animo: El estado de di�a, tarde o noche puede influir en el estado de Animo y las necesidades del Tamagotchi. Por ejemplo, durante el di�a podra estar mas activo y feliz, mientras que por la noche podría estar mas tranquilo y necesitar descansar.


### Sensor de temperatura


SHT75 



#### Protocolo I2c

El protocolo de comunicaci�n I2C (Inter-Integrated Circuit) es un puerto y protocolo de comunicaci�n serial utilizado para transferir datos entre dos dispositivos digitales. El protocolo I2C define la trama de datos y las conexiones f�sicas utilizadas para transferir bits entre los dispositivos. Utiliza dos l�neas de comunicaci�n, una l�nea de datos (SDA) y una l�nea de reloj (SCL), para transmitir informaci�n de manera sincronizada.

Comunicaci�n maestro-esclavo: En el protocolo I2C, uno de los dispositivos act�a como maestro y los dem�s como esclavos. El maestro inicia y controla la comunicaci�n, mientras que los esclavos responden a las solicitudes del maestro.

Direcciones de dispositivo: Cada dispositivo conectado al bus I2C tiene una direcci�n �nica que lo identifica. El maestro utiliza estas direcciones para seleccionar el dispositivo con el que desea comunicarse.

El protocolo I2C admite diferentes velocidades de transferencia, que van desde unos pocos kilobits por segundo hasta varios megabits por segundo. La velocidad de transferencia se configura mediante la frecuencia del reloj.

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/I2C.jpg)

#### Protocolo RS232

El protocolo RS232, tambi�n conocido como Recommended Standard 232, es una interfaz de comunicaci�n serial que establece una norma para el intercambio de datos binarios en serie entre un Equipo Terminal de Datos (DTE) y un Equipo Terminal de Comunicaciones (DCE). 

El protocolo RS232 define los est�ndares el�ctricos, mec�nicos y funcionales para la comunicaci�n serial. ( Ampliamente utilizado en aplicaciones de comunicaci�n de datos, como la conexi�n de dispositivos perif�ricos a computadoras, m�dems, impresoras, entre otros. )

Caracter�sticas el�ctricas: El protocolo RS232 utiliza niveles de voltaje positivos y negativos para representar los bits de datos. Los niveles t�picos son +12V para representar un "0" l�gico y -12V para representar un "1" l�gico. Sin embargo, los niveles de voltaje pueden variar seg�n la implementaci�n.

Utiliza un conector de 9 pines o un conector de 25 pines para establecer la conexi�n f�sica entre los dispositivos. Los pines se utilizan para transmitir y recibir datos, control de flujo y se�ales de control adicionales.

El protocolo RS232 admite diferentes velocidades de transmisi�n, que van desde unos pocos bits por segundo hasta varios megabits por segundo. La velocidad de transmisi�n se configura mediante la tasa de baudios, que representa la cantidad de s�mbolos transmitidos por segundo.

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/RS232.jpg)
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Protocolo%20RS232.jpg)


### Sensor de Luz

Modulo Sensor De Luz Ldr SENL

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-22%2012-49-57.png)

Sensor de luz que cuenta con una entrada de alimentaciòn, una entrada a tierra, una salida anàloga y otra salida digital.

La salida digital del sensor es de un bit, lo que quiere decir que solo hay un estado donde hay luz y otro donde no, esto se puede arreglar con un conversor analogo-digital donde obtenemos un muestreo de la salida analoga y tener diferentes niveles de paso de luz

#### Conversor Analogo-Digital 

PmodAD1

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-22%2013-23-15.png)

El conversor analagico-digital de 12 bits se caracteriza por su implementaciin utilizando un protocolo de comunicacion similar a SPI de dos canales. Este dise�o permite una conversion A/D simultanea con una velocidad de hasta un MSa (muestra por segundo) por canal, tiene alimentacion de 2.35 a 5.25 voltios.

##### Digrama del circuito

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-20%2008-20-51.png)

##### Tabla de pines 

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-20%2008-21-31.png)

### Sensor de Movimiento 

La implementacion de un sensor de movimiento en este proyecto seria util en aplicaciones que permitan interactuar con la mascota virtual y la persona fisica due�a del tamagotchi. 

Es decir cuando la mascota virtual requiera ejercitarse el portador (due�o/propietario) puede hacerlo caminando en la vida real, Mostrando al tiempo algun ejemplo de animacion de la mascota moviendose en la pantalla para generar mas interactividad a las acciones.

Para realizar estas acciones se requiere un sensor que permita detectar que el portador (persona fisica) se este moviendo en la vida rea; con este objetivo se pueden encontrar sensores en el mercado que nos permite detectar esta accion como lo es la implementacion de un acelerometro, un giroscopio o un sensor infrarojo de movimiento


### -> Acelerometro

Es un dispositivo utilizado para medir la aceleraci�n o vibraci�n de un objeto o estructura. Funciona detectando los cambios en la fuerza de aceleraci�n experimentada por el dispositivo en diferentes direcciones.

Midiendo la fuerza de aceleraci�n en la unidad "g" (gravedad). Puede medir la aceleraci�n en uno, dos o tres planos, dependiendo del tipo de aceler�metro.

Principio de funcionamiento: Los aceler�metros utilizan diferentes principios para medir la aceleraci�n. Algunos aceler�metros utilizan el principio piezoel�ctrico, donde la aceleraci�n genera una carga el�ctrica en un material piezoel�ctrico. Otros utilizan el principio capacitivo, donde la aceleraci�n causa cambios en la capacitancia de un capacitor. Tambi�n hay aceler�metros basados en tecnolog�a MEMS (Microelectromechanical Systems), que utilizan estructuras microsc�picas para medir la aceleraci�n.

Aceler�metros de 3 ejes: Los aceler�metros de 3 ejes son los m�s utilizados.(Utilizados mayoritariamento en dispositivos celulares) Estos pueden detectar aceleraciones en tres direcciones diferentes: X, Y y Z. Esto permite medir la aceleraci�n en cualquier direcci�n tridimensional.

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/acelerometro%20funcionamiento.webp)


Acelerómetro Digital de 3 Ejes ADXL345 

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-22%2013-16-30.png)

Acelerómetro Digital de 3 Ejes ADXL345, utilizado principalmente en aplicaciones móviles. Se caracteriza por su bajo consumo de energí­a, dispone de sensibilidad ajustable a una resolución de 16 bits. Se puede conectar fácilmente a través de su interfaz SPI (3 o 4 hilos) e I2C.

Principales Características:

    Voltaje de Alimentación DC: 2V ~ 3.3V
    Corriente de operación: 140uA
    Interfaz: I2C - SPI (5 MHz)
    Auto Test: Ejes X, Y, Z
    Frecuencia de Reloj Interna: 400 KHz
    Rangos: 2g, 4g, 8g y 16g
    Sensibilidad: 4 LSB/g
    Temperatura de funcionamiento: -40°C ~ 85°C

### -> Giroscopio

Es un dispositivo mec�nico que se utiliza para medir, mantener o cambiar la orientaci�n en el espacio de un objeto o veh�culo.Compuesto por un cuerpo con simetr�a de rotaci�n que gira alrededor de un eje. La rotaci�n del cuerpo crea una propiedad llamada momento angular, que se mantiene constante a menos que se aplique un par externo. Esto permite al giroscopio mantener su orientaci�n en el espacio.

Principio de funcionamiento: Los giroscopios utilizan el principio de conservaci�n del momento angular para medir la rotaci�n. Cuando el giroscopio gira, su eje de rotaci�n tiende a mantener su direcci�n original debido a la conservaci�n del momento angular.

Hay varios tipos de giroscopios, incluyendo giroscopios mec�nicos, giroscopios l�ser y giroscopios MEMS (sistemas microelectromec�nicos). 

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Giroscopio.jpg)


## Caja negra

## Diagrama de estados


