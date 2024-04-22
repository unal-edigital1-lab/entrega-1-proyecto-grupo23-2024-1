# Entrega 1 del proyecto WP01

## PROYECTO TAMAGOTCHI

## Funcionalidad Principal:
El nucleo del sistema esta diseñado para simular interactivamente el cuidado de una mascota virtual, permitiendo al usuario participar en actividades esenciales tales como alimentar, jugar, dormir y curar, a traves de una interfaz visual y de un sistema de botones y sensores de manera que sea entretenido para el portador.

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

Botones de Interaccion (2): Facilitan acciones directas como alimentar, jugar, o curar, posibilitando la implementacion de actividades especÃ­ficas para el bienestar del Tamagotchi.

Acelerador de Tiempo: Permite modificar la velocidad del tiempo en el Tamagotchi, incrementando la rapidez de los cambios de estado para simular diferentes velocidades temporales.

## Sistema de Sensado:

Con el objetivo de crear una mascota virtual que sea mas interactiva con el portador se hace necesario usar sensores que nos permitan medir variables fisicas del entorno donde se encuentre el dueño, esto con el fin de hacer mas interesante la aplicacion y cuidado de la mascota virtual. Para esto se pueden usar sensores como los siguientes:

- Sensor de Luz: Simula los ciclos de di­a y noche, influyendo en las rutinas de actividad y descanso de la mascota.

- Sensor de Movimiento: Promueve la actividad fisica al requerir que el usuario mueva el dispositivo para mantener en forma al Tamagotchi, ejemplo el usuario se puede desplazar y dar la sensacion de caminar para el tamagotchi.

- Sensor de Temperatura: Este sensor puede simular el clima y afectar el estado de animo y las necesidades de la mascota. Por ejemplo, si hace calor, el Tamagotchi puede necesitar mas agua, mientras que en climas frios podri­a necesitar una manta.


## Estados Minimos:

El Tamagotchi operara a traves de una serie de estados que reflejan las necesidades fisicas y emocionales de la mascota virtual, para hacerle saber al portador los estados  saber:

Hambriento: Este estado alerta sobre la necesidad de alimentar a la mascota. La falta de atencion a esta necesidad puede desencadenar un estado de enfermedad.

Energia: Denota la necesidad de entretenimiento de la mascota. La inactividad prolongada puede llevar a estados de aburrimiento o tristeza.

Descanso: Identifica cuando la mascota requiere reposo para recuperar energia, especialmente despues de peri­odos de actividad intensa o durante la noche, limitando la interaccion del usuario durante estas fases.

Salud: va a niveles de enfermo por el descuido en el cuidado de la mascota, requiriendo intervenciones especi­ficas para su recuperacion.

Animo: Refleja el bienestar general de la mascota como resultado de satisfacer adecuadamente sus necesidades bÃ¡sicas.

### Otros posibles estados:

Crecimiento/Evolucion: La mascota experimentara distintas fases de crecimiento, cada una con requisitos y comportamientos especi­ficos, ilustrando el desarrollo y maduracion de la mascota a lo largo del tiempo.

Personalizacion: Permite al usuario personalizar la apariencia del Tamagotchi, como cambiar su color, agregar accesorios o modificar su entorno.

Logros y Recompensas: Implementa un sistema de logros y recompensas que motive al usuario a cuidar bien de su Tamagotchi. Por ejemplo, podra desbloquear nuevas caracteristicas, accesorios o juegos al alcanzar ciertos hitos

Exploracion: Introduce la capacidad de explorar diferentes entornos virtuales con el Tamagotchi. Por ejemplo, podran explorar un parque, una playa, una ciudad, entre otros.

Actividades Especificas segun el Momento del Dia: Actividades que solo estan disponibles durante ciertos momentos del di­a. Por ejemplo, durante el dia, el Tamagotchi podr­a tener la opcion de jugar afuera, mientras que por la noche podri­a preferir quedarse dentro y ver la television.

Cambios Visuales en el Entorno: Modifica el entorno del Tamagotchi para reflejar el momento del dia. Por ejemplo, durante el dia, el sol podrÃ­a estar brillando y los pajaros podran estar cantando, mientras que por la noche el cielo podri­a estar estrellado y la luna podr­a brillar en el horizonte.

Influencia en el Estado de Animo: El estado de di­a, tarde o noche puede influir en el estado de Animo y las necesidades del Tamagotchi. Por ejemplo, durante el di­a podra estar mas activo y feliz, mientras que por la noche podrÃ­a estar mas tranquilo y necesitar descansar.


### Sensor de temperatura
https://pistaseducativas.celaya.tecnm.mx/index.php/pistas/article/view/614/549

SHT75 

#### Protocolo I2c


#### Protocolo RS232


### Sensor de Luz

MÃ³dulo Sensor De Luz Ldr SENL



#### Conversor Analogo-Digital 

PmodAD1

El conversor analagico-digital de 12 bits se caracteriza por su implementaciin utilizando un protocolo de comunicacion similar a SPI de dos canales. Este diseño permite una conversion A/D simultanea con una velocidad de hasta un MSa (muestra por segundo) por canal, tiene alimentaciÃ²n de 2.35 a 5.25 voltios.

##### Digrama del circuito

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-20%2008-20-51.png)

##### Tabla de pines 

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-20%2008-21-31.png)

### Sensor de Movimiento 

La implementacion de un sensor de movimiento en este proyecto seria util en aplicaciones que permitan interactuar con la mascota virtual y la persona fisica dueña del tamagotchi. 

Es decir cuando la mascota virtual requiera ejercitarse el portador (dueño/propietario) puede hacerlo caminando en la vida real, Mostrando al tiempo algun ejemplo de animacion de la mascota moviendose en la pantalla para generar mas interactividad a las acciones.

Para realizar estas acciones se requiere un sensor que permita detectar que el portador (persona fisica) se este moviendo en la vida rea; con este objetivo se pueden encontrar sensores en el mercado que nos permite detectar esta accion como lo es la implementacion de un acelerometro, un giroscopio o un sensor infrarojo de movimiento


### -> Acelerometro

Es un dispositivo utilizado para medir la aceleración o vibración de un objeto o estructura. Funciona detectando los cambios en la fuerza de aceleración experimentada por el dispositivo en diferentes direcciones.

Midiendo la fuerza de aceleración en la unidad "g" (gravedad). Puede medir la aceleración en uno, dos o tres planos, dependiendo del tipo de acelerómetro.

Principio de funcionamiento: Los acelerómetros utilizan diferentes principios para medir la aceleración. Algunos acelerómetros utilizan el principio piezoeléctrico, donde la aceleración genera una carga eléctrica en un material piezoeléctrico. Otros utilizan el principio capacitivo, donde la aceleración causa cambios en la capacitancia de un capacitor. También hay acelerómetros basados en tecnología MEMS (Microelectromechanical Systems), que utilizan estructuras microscópicas para medir la aceleración.

Acelerómetros de 3 ejes: Los acelerómetros de 3 ejes son los más utilizados.(Utilizados mayoritariamento en dispositivos celulares) Estos pueden detectar aceleraciones en tres direcciones diferentes: X, Y y Z. Esto permite medir la aceleración en cualquier dirección tridimensional.

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/acelerometro%20funcionamiento.webp)

### -> Giroscopio

Es un dispositivo mecánico que se utiliza para medir, mantener o cambiar la orientación en el espacio de un objeto o vehículo.Compuesto por un cuerpo con simetría de rotación que gira alrededor de un eje. La rotación del cuerpo crea una propiedad llamada momento angular, que se mantiene constante a menos que se aplique un par externo. Esto permite al giroscopio mantener su orientación en el espacio.

Principio de funcionamiento: Los giroscopios utilizan el principio de conservación del momento angular para medir la rotación. Cuando el giroscopio gira, su eje de rotación tiende a mantener su dirección original debido a la conservación del momento angular.

Hay varios tipos de giroscopios, incluyendo giroscopios mecánicos, giroscopios láser y giroscopios MEMS (sistemas microelectromecánicos). 

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Giroscopio.jpg)


## Caja negra

## Diagrama de estados


