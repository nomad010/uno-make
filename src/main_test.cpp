#include "arduino_lib/WProgram.h"

void setup() 
{
    pinMode(13, OUTPUT);
}

void loop() 
{
    digitalWrite(13, HIGH);
    delay(10000);
    digitalWrite(13, LOW);
    delay(500);
}

int main() 
{
    /// Setup the device
    init();
    setup();
    while(true)
        loop();
}

