#include <Arduino.h>

#include <ESP8266WiFiMulti.h>
ESP8266WiFiMulti WifiMulti;

int LED = D3;

void setup()
{
    pinMode(LED, OUTPUT);

    Serial.begin(115200);
    Serial.setDebugOutput(true);
    Serial.println();
    Serial.println();

    for (uint8_t t = 1; t < 4; t++)
    {
        Serial.printf("[SETUP] Booting %d...\n", t);
        Serial.flush();
        delay(1000);
    }

    WifiMulti.addAP("Private", "12345678");
    while (WifiMulti.run() != WL_CONNECTED)
    {
        pinMode(BUILTIN_LED, OUTPUT);
        pinMode(D0, WAKEUP_PULLUP);
        digitalWrite(BUILTIN_LED, LOW);
        Serial.printf("[SETUP] Network failed \n");
        delay(1000);
        digitalWrite(BUILTIN_LED, HIGH);
        delay(1000);
    }
}

void loop()
{
    if (WifiMulti.run() != WL_CONNECTED)
    {
        digitalWrite(LED, LOW);
        pinMode(BUILTIN_LED, OUTPUT);
        pinMode(D0, WAKEUP_PULLUP);
        digitalWrite(BUILTIN_LED, LOW);
        Serial.printf("[SETUP] Network failed \n");
        delay(1000);
        digitalWrite(BUILTIN_LED, HIGH);
        delay(1000);
    }
    else{
        digitalWrite(LED, LOW);
        delay(3000);
        digitalWrite(LED, HIGH);
        delay(1000);
    }
}
