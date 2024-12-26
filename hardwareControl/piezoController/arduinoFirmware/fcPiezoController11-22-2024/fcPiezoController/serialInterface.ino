#define myBaudRate 115200 
void setupSerialInterface() {
  // Setup communication with PC
  Serial.begin(myBaudRate); 
}

/* 
 states:
 b - hold stage position, BF trigger is constant, PL is TTL triggered
 f - hold stage position, PL triggers are constant, BF is TTL triggered
 c - hold position and keep everything on
 t - hold position, but TTL trigger everything
 o - turn off all leds
 r - reset Zstack, Zstack ready
 a - reset ZStack to zero
 p - print the programmed arrays 
 w - writing to Z arrays that program the DAC and TTL controls
 the format for writing is as follows:
 w(zIndex=i),(zFunc[i]),(zWavelength[i]),(kickItUpDelay[i]),(kickItUpDelta[i]),(slowItDownDelay[i]),(slowItDownDelta[i])
 s - set starting and ending index of Zstack program 
 s(zStart),(zEnd), then update DAC to zFunc[zStart]
 B - turn on the Brightfield LED
 O - turn off all lights
 */

void pollSerialInterface() {
  while (Serial.available() > 0) {
    char state = Serial.read();
    switch (state) {
      case 'c':
        constantPassThrough();
        break;
      case 'r':
        resetZstack();
        sendConfirmation();
        break;
      case 'a':
        resetZstackToZero();
        sendConfirmation();
        break;
      case 'p':
        printZData();
        break;    
      case 's':
        setZStartingEndingIndex();
        break;
      case 't':
        triggerPassThrough();
        break;
      case 'w':
        parseZData();
        break;
      case 'b':
        holdPositionBF();
        break;
      case 'f':
        holdPositionEpi();
        break;
      case 'o':
        turnOffAllLights();
        break;
      case 'z':
        testAllLights();
        break;
      case 'B': // NEW: Turn on the Brightfield LED
        turnOnBrightFieldLED();
        sendConfirmation();
        break;
      case 'O': // NEW: Turn off all lights
        turnOffAllLights();
        sendConfirmation();
        break;
      case 'E': // NEW: Turn on Epi 1
        turnOnAllEpiLED();
        break;
      case 'F': // NEW: Turn on Epi 2
        PORTF = B00000010;
        break;
      case 'G': // NEW: Turn on Epi 3
        PORTF = B00000100;
        break;
      case 'H': // NEW: Turn on Epi 4
        PORTF = B00001000;
        break;
      case 'I': // NEW: Turn on Epi 5
        PORTF = B00010000;
        break;
    
      default:
        Serial.print(F("Unknown command\n"));
        break;
    }
  }
}

void sendConfirmation() {
  Serial.print(F("ok\n")); 
}
