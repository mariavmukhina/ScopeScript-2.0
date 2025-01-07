/* 
Frederick Chang fchang@fas.harvard.edu, Kleckner Lab, 20150307, Piezo Controller
Maria Mukhina mukhina@umd.edu, Mukhina Lab, 20250107, updates forScopeScript 2.0
 
 This circuit controls an analogue voltage controlled piezo z-stage and light sources slaved to the
 TTL pulses of a CCD camera (either sCMOS or EMCCD). 
 Feedforward recipies for Z steps of the stage are used for faster Z stacks.  
 
 ==HARDWARE INPUT/OUTPUT==========================================================
 the 16bit dac chip bus
 D0-D7       ->  PA0-PA7
 D8-D15      ->  PC7-PC0
 
 the 16bit dac chip logic controls
 A0n         ->  PG1
 A1n         ->  PG0
 WRn         ->  PD7
 CLRn        ->  PG2
 
 camera TTL interrupt input
 INT0        ->  PD0 
 
 the LED status outputs
 RED_LED     ->  PB6
 GREEN_LED   ->  PB5
 BLUE_LED  ->  PB4
 
 the TTL control mapping from arduino to Toptica Laser, Retra UV LED, and Peka LED, zWavelength[i] is Bxxxxxxxx
 PORTF = B00000001; // Retra UV TTL
 PORTF = B00000010; // Toptica Laser 488 (TTL in #3)
 PORTF = B00000100; // Toptica Laser 561 (TTL in #2)
 PORTF = B00001000; // Toptica Laser 640 (TTL in #1)
 PORTF = B00010000; // empty
 PORTF = B00100000; // empty
 PORTF = B01000000; // Peka Brightfield TTL 
 PORTF = B00000000; //all off
 
 Serial Baud Rate
 myBaudRate = 115200
 
 ==PIEZO STATE INDICATORS=========================================================
 Green LED On: piezo controller is reset and ready for triggers
 Red LED Blinks: indicates integration window of fluorescent wavelengths 
 corresponds to any triggering at (PORTF 1-32)
 Blue LED Blinks: indicates integration window of brightfield wavelength 
 corresponds to any triggering at (PORTF 64)
 
==PURPOSE=========================================================================
to control piezo stage by feed forward signal, slaved to TTL integration signal
from the camera
 
 ___---____---___---___---___  TTL integration signal of scmos camera
   |  | 
   |  on falling edge turn off all led lights and actuate piezo to next stage position
   on rising edge turn on led light

==CONTROLLER VARIABLES============================================================
#define maxSteps 256                   // maximum number of programmed z positions
volatile unsigned int zIndex;          // zStep state index, interrupt controlled.
int zFunc[maxSteps];                   // DAC outputs per zIndex
byte zWavelength[maxSteps];            // Wavelength Output per zIndex
byte kickItUpDelay[maxSteps];          // accelerating stage delay
byte slowItDownDelay[maxSteps];        // decelerating stage
int kickItUpDelta[maxSteps];           // accelerating stage additional voltage
int slowItDownDelta[maxSteps];         // decelerating stage additional voltage
unsigned int zStart = 0;               // Zstep program start index
unsigned int zEnd   = 0;               // Zstep program ending index

==CONTROLLER STATEMACHINE=========================================================
triggering rules
 1) reset circuit to z0 = zFunc[zEnd], start and end of stream is the same
 3) on rising edge: turn on specified zWavelength[zIndex]
 4) on falling edge: 
    i) turn off all lights on PORTF, 
    ii) DAC(zStep[zIndex] + kickItUpDelta[zIndex]) 
        delay(kickItUpDelay[zIndex]), 
        DAC(zStep[zIndex] + slowItDownDelta[zIndex])
        delay(slowItDownDelay[zIndex]),
        DAC(zStep[zIndex])
        zIndex++
        zIndex = max(zStart,(zIndex) % (zEnd+1));  zIndex goes from zStart to zEnd
 */

