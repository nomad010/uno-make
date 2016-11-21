#include "arduino_lib/Arduino.h"

int val;
const int ledPin = 13;

void setup() 
{
    Serial.begin(115200);
    pinMode(ledPin, OUTPUT);
}

void loop() 
{
    if(Serial.available())
    {
        val = Serial.read();
    
        if(val == 'r')
            digitalWrite(ledPin, HIGH);
        else
            digitalWrite(ledPin, LOW);
    }
}

int main() 
{
    /// Setup the device
    init();
#if defined(USBCON)
    USBDevice.attach();
#endif
    setup();
    while(true)
    {
        loop();
        if(serialEventRun)
            serialEventRun();
    }
}

