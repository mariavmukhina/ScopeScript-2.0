void setup() {
  Serial.begin(115200);       // Start serial communication at 9600 baud
  setupLights();
}

void loop() {
  pollSerialInterface();
}
