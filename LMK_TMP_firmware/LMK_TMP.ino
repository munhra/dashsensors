#include <Adafruit_Sensor.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ArduinoOTA.h>
#include <DHT.h>


#define FOTA_HOST_NAME "LetMeKnowTemperatureHumidity"
#define DHTTYPE DHT11

const char* ssid = "FollowMe-Pi3";
const char* password  = "FollowMeRadio";

const int httPort = 3002;
const char* host = "192.168.42.1";

String sensorName = "dht11";

 WiFiClient client;

int DHTPIN = 2;
DHT dht(DHTPIN,DHTTYPE);
float temperatureCelsius, humidity, temeratureFahrenheit; 

ESP8266WebServer server(80);

void setup() {
Serial.begin(115200);
setupWifi();
sendRegister();

server.on("/other", []() {
  server.send(200, "text/plain", "Other URL");
});

// to LMK
server.on("/data",handleData);
 
server.on("/", handleRootPath); 
server.begin();
Serial.println("Server listening");
}

void loop() {

 // reading sensor
 temperatureCelsius = dht.readTemperature();
 humidity    = dht.readHumidity();
 temeratureFahrenheit  = dht.readTemperature(true);

 if(!client.connect(host,httPort)){
  Serial.println("Connection Failed.");
  ESP.restart();
  return;
 }
 client.stop();
 
  server.handleClient(); 
  delay(500);
}

void setupWifi(){
  Serial.print("Connecting to");
  Serial.println(ssid);

  WiFi.begin(ssid,password);

  while(WiFi.status()!= WL_CONNECTED){
    delay(500);
    Serial.print(".");
  }

  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void sendRegister(){
    WiFiClient client;

    if(!client.connect(host,httPort)){
      Serial.println("Connection Failed.");
      ESP.restart();
      return;
    }

    String url = "/api/Door/ip?ipDoor="+ipToString(WiFi.localIP());
    client.println(String("POST ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" + 
               "Connection: close\r\n\r\n");
  client.write(200);
  client.flush();
  client.stop();
}

String ipToString(IPAddress ip){
  String s = "";

  for(int i=0; i<4;i++)
    s += i ? "." + String(ip[i]) : String(ip[i]);

  return s;
}

void handleRootPath() {
  server.send(200, "text/plain", "Hello world"); 
}
void handleData(){
    if(isnan(temperatureCelsius) || isnan(humidity) || isnan(temeratureFahrenheit)){
      String jsonError = "{\"error\":\"error\"}";
      server.send(200, "application/json",jsonError);
    }
    else{
    String json = "{";
                json+=     "\"temperature\":"+String(temperatureCelsius)+",";
                // json+=     "\"tempFahrenheit\":"+String(temeratureFahrenheit)+",";
                json+=     "\"humidity\":"+String(humidity); 
                json+= "}";
    server.send(200, "application/json", json);
    }
}
