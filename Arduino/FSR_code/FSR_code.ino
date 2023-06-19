// Collection parameters
int sampling_freq = 10; // collect every 10 ms (100 Hz)

// Connect FSR to analog pins A0, A1, A2, A3, A10
int F1pin = A0; 
int F2pin = A1;
int F3pin = A2;
int F4pin = A3;
int F5pin = A10;

// Define F1, F2, F3, F4, F5 to get analog readings
int F1;
int F2;
int F3;
int F4;
int F5;

// Define headers variable for data output
String headers = "F1,F2,F3,F4,F5";
bool header = true;

// put your setup code here, to run once:
void setup() {
  Serial.begin(9600);
  while(!Serial){}; // do nothing if serial not connected
}

// put your main code here, to run repeatedly:
void loop() {

  // Print column headers
  while(header){ 
    Serial.print(headers);
    Serial.println();
    header = false;
  }

  // Read data from sensors
  F1 = analogRead(F1pin);
  F2 = analogRead(F2pin);
  F3 = analogRead(F3pin);
  F4 = analogRead(F4pin);
  F5 = analogRead(F5pin);

  // Print data in serial monitor
  Serial.print(F1); // print reading for F1
  Serial.print(",");
  Serial.print(F2); // print reading for F2
  Serial.print(",");
  Serial.print(F3); // print reading for F3
  Serial.print(",");
  Serial.print(F4); // print reading for F4
  Serial.print(",");
  Serial.print(F5); // print reading for F5
  Serial.println(); // print new line

  // sampling rate
  delay(sampling_freq); 
}