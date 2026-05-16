// ═══════════════════════════════════════════════════════════════
// SmartParking — Sensor de Estacionamiento HC-SR04
// Arduino Uno R3
// ═══════════════════════════════════════════════════════════════
// Pines:
//   Pin 2  → LED Verde    (Libre)
//   Pin 3  → LED Amarillo (Error / No operativo)
//   Pin 4  → LED Rojo     (Ocupado / Detectando)
//   Pin 5  → Trigger (HC-SR04)
//   Pin 6  → Echo    (HC-SR04)
// ═══════════════════════════════════════════════════════════════

// Pines utilizados
#define LEDVERDE 2
#define LEDAMARILLO 3
#define LEDROJO 4
#define TRIGGER 5
#define ECHO 6

// Constantes
const float sonido = 34300.0;       // Velocidad del sonido en cm/s
const float distanciaCerca = 10.0;  // Umbral para espacio ocupado (cm)

void setup() {
  Serial.begin(9600);

  // Modo entrada/salida de los pines
  pinMode(LEDVERDE, OUTPUT);
  pinMode(LEDAMARILLO, OUTPUT);
  pinMode(LEDROJO, OUTPUT);
  pinMode(ECHO, INPUT);
  pinMode(TRIGGER, OUTPUT);

  // Apagamos todos los LEDs al iniciar
  apagarLEDs();

  // Mensaje de inicio
  Serial.println("SmartParking Sensor v1.0");
  Serial.println("Iniciando monitoreo...");
}

void loop() {
  iniciarTrigger();
  float distancia = calcularDistancia();

  apagarLEDs();
  alertas(distancia);

  delay(500);
}

void apagarLEDs() {
  digitalWrite(LEDVERDE, LOW);
  digitalWrite(LEDAMARILLO, LOW);
  digitalWrite(LEDROJO, LOW);
}

void alertas(float distancia) {
  if (distancia == 0.0) {
    // Sensor desconectado, dañado o lectura fuera de rango → LED Amarillo
    digitalWrite(LEDAMARILLO, HIGH);
    Serial.println("ESTADO:2"); // Estado 2: No operativo / Error
  }
  else if (distancia < distanciaCerca) {
    // Objeto detectado cerca → LED Rojo
    digitalWrite(LEDROJO, HIGH);
    Serial.println("ESTADO:1"); // Estado 1: Detectando presencia
  }
  else {
    // Sin objeto cerca → LED Verde
    digitalWrite(LEDVERDE, HIGH);
    Serial.println("ESTADO:0"); // Estado 0: Libre
  }
}

void iniciarTrigger() {
  // Enviar pulso de 10us al trigger
  digitalWrite(TRIGGER, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGGER, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIGGER, LOW);
}

float calcularDistancia() {
  // Leer duración del pulso echo (con timeout de 30ms = ~510cm)
  unsigned long tiempo = pulseIn(ECHO, HIGH, 30000);

  if (tiempo == 0) {
    return 0.0; // Timeout → error de lectura
  }

  // Calcular distancia: d = (t * v) / 2
  float distancia = (tiempo * sonido) / 2000000.0;

  return distancia;
}
