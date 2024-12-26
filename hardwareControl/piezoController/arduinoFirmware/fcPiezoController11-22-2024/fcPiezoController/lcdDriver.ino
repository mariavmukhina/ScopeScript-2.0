char lcdLine1[16];                       // Memory for LCD line 1
char lcdLine2[16];                       // Memory for LCD line 2

// Display Commands
#define COMMAND        0xFE              // Special command prefix
#define CLEARDISP      0x01              // Clear the display
#define CURSORRIGHT    0x14              // Move the cursor right one position
#define CURSORLEFT     0x10              // Move cursor left one position
#define SCROLLRIGHT    0x1C              // Scroll the display right
#define SCROLLLEFT     0x18              // Scroll the display left
#define DISPLAYON      0x0C              // Turn the display on
#define DISPLAYOFF     0x08              // Turn the display off
#define UCURSORON      0x0E              // Turn underline cursor on
#define UCURSOROFF     0x0C              // Turn underline cursor off
#define BOXCURSORON    0x0D              // Turn blinking box cursor on
#define BOXCURSOROFF   0x0C              // Turn blinking box cursor off
#define SETCURSOR      0x80              // Set cursor position (requires second byte)

// Miscellaneous Delays
#define LCDDelay       100               // General delay timer (ms)

// Function to initialize the LCD
void setupLCD() {
    Serial1.begin(9600);                 // Start communication at default baud rate
    delay(500);                          // Allow LCD time to power up

    // Set baud rate to 38400
    Serial1.write(0x81);                 // Baud rate control command
    Serial1.write(8);                    // Set to 38400 baud (value 8 per datasheet)
    delay(100);                          // Allow time for baud rate change
    Serial1.begin(38400);                // Restart communication at new baud rate
    delay(100);

    LCDClear();                          // Clear the screen
}

// Function to clear the display
void LCDClear() {
    Serial1.write(COMMAND);              // Send command prefix
    Serial1.write(CLEARDISP);            // Clear the display command
    delay(100);                          // Delay to allow command processing
}

/* clears the serial LCD */
void clearLCD(){
  Serial1.print(F("                "));
  Serial1.print(F("                "));
}

// Function to set the cursor position
void setCursorPosition(uint8_t position) {
    Serial1.write(COMMAND);              // Send command prefix
    Serial1.write(SETCURSOR);            // Set cursor position command
    Serial1.write(position);             // Send position (0-31 for 2x16 LCD)
}

// Functions to move to first and second LCD lines
void firstLCDLine() {
    setCursorPosition(0);                // Top left of the display
}

void secondLCDLine() {
    setCursorPosition(16);               // Start of the second line
}

// Function to write "constant" mode to the LCD
void writeConstantThroughLCD() {
    LCDClear();
    firstLCDLine();
    printVersionf(); 
    secondLCDLine();
    Serial1.print(F(">>constthru mode"));  
}

// Function to write "pass-through" mode to the LCD
void writePassThroughLCD() {
    LCDClear();
    firstLCDLine();
    printVersionf(); 
    secondLCDLine();
    Serial1.print(F(">>passthru mode"));
}

// Function to write "ZStack ready" to the LCD
void writeZStackLCD() {
    LCDClear();
    firstLCDLine();
    printVersionf();
    secondLCDLine();
    Serial1.print(F(">>zStack ready"));
}

// Function to write "printing data" to the LCD
void writePrintingLCD() {
    LCDClear();
    firstLCDLine();
    printVersionf();
    secondLCDLine();
    Serial1.print(F(">>printing data"));
}

// Function to write "TTL trigger mode" to the LCD
void writeTriggerThroughLCD() {
    LCDClear();
    firstLCDLine();
    printVersionf(); 
    secondLCDLine();
    Serial1.print(F(">>TTLtriggerMode"));  
}

// Function to print version info
void printVersionf() {
    Serial1.print(F("fchang v20150307")); 
}

// Function to display an error message
void errorMsg() {
    LCDClear();
    firstLCDLine();
    Serial1.print(F("error in serial")); 
}
