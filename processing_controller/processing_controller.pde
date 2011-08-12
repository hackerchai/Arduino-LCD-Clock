import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

void setup() 
{
  size(200, 200);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  delay(3000); //wait for arduino
  
  //get time
  int s = second();  // Values from 0 - 59
  println(s);
  int m = minute();  // Values from 0 - 59
  println(m);
  int h = hour();    // Values from 0 - 23
  println(h);

  for (int i = 0; i<h; i++) { //send hours data
   myPort.write('h');
   //delay(10);
  }
  for (int i = 0; i<m; i++) { //send minutes data
   myPort.write('m');
   //delay(10);
  }
  for (int i = 1; i<s; i++) { //send seconds data
   myPort.write('s');
   //delay(10);
  }
  myPort.write('E'); //end the transmittion
   
  int i = 1;
  while (i == 1) {}
  
}
