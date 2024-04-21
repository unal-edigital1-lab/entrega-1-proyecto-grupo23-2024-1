# Entrega 1 del proyecto WP01

## proyecto tamagotchi

## Funcionalidad Principal:
El núcleo del sistema está diseñado para simular interactivamente el cuidado de una mascota virtual, permitiendo al usuario participar en actividades esenciales tales como alimentar, jugar, dormir y curar, a través de una interfaz visual y de un sistema de botones y sensores.

## Sistema de Visualización:

## Visualización de Información de Estado:
Matriz de Puntos 8x8: Esencial para representar visualmente el estado actual del Tamagotchi, incluyendo emociones y necesidades básicas.

## Indicadores Simples:
Display de 7 Segmentos: Utilizado para mostrar niveles y puntuaciones específicas, como el nivel de hambre o felicidad, complementando la visualización principal.

## Sistema de Botones:
## Botones :
La interacción usuario-sistema se realizará mediante los siguientes botones configurados:

Reset: Reestablece el Tamagotchi a un estado inicial conocido al mantener pulsado el botón durante al menos 5 segundos. Este estado inicial simula el despertar de la mascota con salud óptima.

Test: Activa el modo de prueba al mantener pulsado por al menos 5 segundos, permitiendo al usuario navegar entre los diferentes estados del Tamagotchi con cada pulsación.

Botones de Interacción (2): Facilitan acciones directas como alimentar, jugar, o curar, posibilitando la implementación de actividades específicas para el bienestar del Tamagotchi.

Acelerador de Tiempo: Permite modificar la velocidad del tiempo en el Tamagotchi, incrementando la rapidez de los cambios de estado para simular diferentes velocidades temporales.

### Sistema de Sensado:

Sensor de Luz: Simula los ciclos de día y noche, influyendo en las rutinas de actividad y descanso de la mascota.

Sensor de Movimiento: Promueve la actividad física al requerir que el usuario mueva el dispositivo para mantener en forma al Tamagotchi, ejemplo el usuario se puede desplazar y dar la sensacion de caminar para el tamagotchi.

Sensor de Temperatura: Este sensor puede simular el clima y afectar el estado de ánimo y las necesidades de la mascota. Por ejemplo, si hace calor, el Tamagotchi puede necesitar más agua, mientras que en climas fríos podría necesitar una manta.


### Estados Mínimos:

El Tamagotchi operará a través de una serie de estados que reflejan las necesidades físicas y emocionales de la mascota virtual, a saber:

Hambriento: Este estado alerta sobre la necesidad de alimentar a la mascota. La falta de atención a esta necesidad puede desencadenar un estado de enfermedad.

Energía: Denota la necesidad de entretenimiento de la mascota. La inactividad prolongada puede llevar a estados de aburrimiento o tristeza.

Descanso: Identifica cuando la mascota requiere reposo para recuperar energía, especialmente después de períodos de actividad intensa o durante la noche, limitando la interacción del usuario durante estas fases.

Salud: va a niveles de enfermo por el descuido en el cuidado de la mascota, requiriendo intervenciones específicas para su recuperación.

Ánimo: Refleja el bienestar general de la mascota como resultado de satisfacer adecuadamente sus necesidades básicas.

### Otros posibles casos:

Crecimiento/Evolución: La mascota experimentará distintas fases de crecimiento, cada una con requisitos y comportamientos específicos, ilustrando el desarrollo y maduración de la mascota a lo largo del tiempo.

Personalización: Permite al usuario personalizar la apariencia del Tamagotchi, como cambiar su color, agregar accesorios o modificar su entorno.

Logros y Recompensas: Implementa un sistema de logros y recompensas que motive al usuario a cuidar bien de su Tamagotchi. Por ejemplo, podría desbloquear nuevas características, accesorios o juegos al alcanzar ciertos hitos

Exploración: Introduce la capacidad de explorar diferentes entornos virtuales con el Tamagotchi. Por ejemplo, podrían explorar un parque, una playa, una ciudad, entre otros.

Actividades Específicas según el Momento del Día: Puedes diseñar actividades específicas que solo estén disponibles durante ciertos momentos del día. Por ejemplo, durante el día, el Tamagotchi podría tener la opción de jugar afuera, mientras que por la noche podría preferir quedarse dentro y ver la televisión.

Cambios Visuales en el Entorno: Modifica el entorno del Tamagotchi para reflejar el momento del día. Por ejemplo, durante el día, el sol podría estar brillando y los pájaros podrían estar cantando, mientras que por la noche el cielo podría estar estrellado y la luna podría brillar en el horizonte.

Influencia en el Estado de Ánimo: El estado de día, tarde o noche puede influir en el estado de ánimo y las necesidades del Tamagotchi. Por ejemplo, durante el día podría estar más activo y feliz, mientras que por la noche podría estar más tranquilo y necesitar descansar.








### Sensor de temperatura
https://pistaseducativas.celaya.tecnm.mx/index.php/pistas/article/view/614/549

SHT75 

#### Protocolo I2c


#### Protocolo RS232


### Sensor de Luz

Módulo Sensor De Luz Ldr SENL



#### Conversor Anàlogo-Digital 

PmodAD1

El conversor analógico-digital de 12 bits se caracteriza por su implementación utilizando un protocolo de comunicación similar a SPI de dos canales. Este diseño permite una conversión A/D simultánea con una velocidad de hasta un MSa (muestra por segundo) por canal, tiene alimentaciòn de 2.35 a 5.25 voltios.

##### Digrama del circuito

![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-20%2008-20-51.png)
##### Tabla de pines 
![](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo23-2024-1/blob/main/imagenes/Captura%20desde%202024-04-20%2008-21-31.png)
### Sensor de Movimiento 






## Caja negra

## Diagrama de estados


