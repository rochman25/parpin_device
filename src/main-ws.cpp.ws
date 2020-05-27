#include <Arduino.h>

#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <WebSocketsClient.h>
#include <Hash.h>
#include <ArduinoJson.h>

ESP8266WiFiMulti WiFiMulti;
WebSocketsClient webSocket;

#define USE_SERIAL Serial

void webSocketEvent(WStype_t type, uint8_t *payload, size_t length)
{
	// char message[256];
	// DynamicJsonDocument document(200);
	// document["t"] = "1";
	// JsonObject client = document.createNestedObject("d");
	// client["topic"] = "thing";
	// serializeJson(document, message);

	// DynamicJsonBuffer jsonBuffer(128);

	// JsonObject &root = jsonBuffer.createObject();
	// root["t"] = 1;

	// JsonArray &data = root.createNestedArray("d");
	// data.add("topic","thing");
	// // data["topic"] = "thing";
	// // 6 is the number of decimals to print

	// StreamString databuf;
	// root.printTo(databuf);
	String message = "";
	const int capacity = JSON_ARRAY_SIZE(2) + 4 * JSON_OBJECT_SIZE(2);
	StaticJsonDocument<capacity> doc;
	doc["t"] = 1;
	JsonObject data = doc.createNestedObject("d");
	data["topic"] = "alat";
	serializeJson(doc, message);

	switch (type)
	{
	case WStype_DISCONNECTED:
		// USE_SERIAL.printf("%s/n",payload);
		USE_SERIAL.printf("[WSc] Disconnected! \n");
		delay(1000);
		break;
	case WStype_CONNECTED:
	{
		USE_SERIAL.printf("[WSc] Connected to url: %s\n", payload);
		webSocket.sendTXT(message);
		// send message to server when Connected
		// webSocekt.sendTXT(root);

		// serializeJson(document,webSocket);
	}
	break;
	case WStype_TEXT:
		USE_SERIAL.printf("[WSc] get text: %s\n", payload);
		// webSocket.sendTXT(message);
		// webSocket.sendTXT(databuf);
		// USE_SERIAL.println(databuf);
		// send message to server
		// webSocket.sendTXT("Yo server ini dari wemos");
		break;
	case WStype_BIN:
		USE_SERIAL.printf("[WSc] get binary length: %u\n", length);
		hexdump(payload, length);

		// send data to server
		// webSocket.sendBIN(payload, length);
		break;
	case WStype_PING:
		// pong will be send automatically
		USE_SERIAL.printf("[WSc] get ping\n");
		break;
	case WStype_PONG:
		// answer to a ping we send
		USE_SERIAL.printf("[WSc] get pong\n");
		// USE_SERIAL.printf("[WSc] get text: %s\n", payload);
		break;
	default:
		USE_SERIAL.printf("[WSc] get type: %u\n", type);
		break;
	}
}

void setup()
{
	// char message[128];
	// StaticJsonDocument<128> doc;
	// doc['t'] = '1';

	// DynamicJsonDocument document(200);
	// document["t"] = "1";
	// JsonObject client = document.createNestedObject("d");
	// client["topic"] = "thing";
	// serializeJson(document, message);

	// USE_SERIAL.begin(921600);

	USE_SERIAL.begin(115200);

	//Serial.setDebugOutput(true);
	USE_SERIAL.setDebugOutput(true);

	USE_SERIAL.println();
	USE_SERIAL.println();
	USE_SERIAL.println();

	for (uint8_t t = 4; t > 0; t--)
	{
		USE_SERIAL.printf("[SETUP] BOOT WAIT %d...\n", t);
		USE_SERIAL.flush();
		delay(1000);
	}

	WiFiMulti.addAP("Private", "12345678");

	//WiFi.disconnect();
	while (WiFiMulti.run() != WL_CONNECTED)
	{
		delay(100);
	}

	// server address, port and URL
	webSocket.begin("192.168.43.73", 3333,"/adonis-ws");

	// event handler
	webSocket.onEvent(webSocketEvent);

	// webSocket.sendTXT(message);

	// use HTTP Basic Authorization this is optional remove if not needed
	// webSocket.setAuthorization("user", "Password");

	// try ever 5000 again if connection has failed
	webSocket.setReconnectInterval(5000);

	// start heartbeat (optional)
	// ping server every 15000 ms
	// expect pong from server within 3000 ms
	// consider connection disconnected if pong is not received 2 times
	webSocket.enableHeartbeat(15000, 3000, 5);
}

void loop()
{
	String message = "";
	const int capacity = JSON_ARRAY_SIZE(2) + 4 * JSON_OBJECT_SIZE(2);
	StaticJsonDocument<capacity> doc;
	doc["t"] = 7;
	JsonObject data = doc.createNestedObject("d");
	data["topic"] = "alat";
	data["event"] = "message";
	JsonObject msg = data.createNestedObject("data");
	msg["userId"] = "alat 1";
	msg["body"] = "hai gaes aku wemos";

	serializeJson(doc, message);
	// USE_SERIAL.println(message);
	webSocket.sendTXT(message);
	webSocket.loop();
	delay(2000);

}