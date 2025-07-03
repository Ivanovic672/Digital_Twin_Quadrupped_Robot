
void setup() {
  Serial.begin(9600);      // Monitor Serial
  Serial1.begin(9600);     // Comunicación con HC-05
}

void loop() {
  
  // Ejemplo: enviar 6 enteros separados por coma y un salto de línea
  Serial1.println("S,10,20,30,40,50,60");
  
  // Leer respuesta desde app, si la hay
  if (Serial1.available()) {
    String response = Serial1.readStringUntil('\n');
    Serial.print("Respuesta desde app: ");
    Serial.println(response);
  }

  delay(100);
}
