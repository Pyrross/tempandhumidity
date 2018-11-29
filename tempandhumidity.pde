import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
int temp;     // Temperature from DHT11
int humidity; // Humidity from DHT11

Table table;

void setup() {
  // size:
  size(720, 360);
  // serial:
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  // table:
  
  if (new File("data/surveillance.csv").exists()) {
    table = new Table();
    
    table.addColumn("time");
    table.addColumn("temperature");
    table.addColumn("humidity");
  }
  else {
    table = loadTable("data/surveillance.csv", "header");
  }
}

void draw()
{
  background(50);
  if (myPort.available() > 0) { 
    String inString = myPort.readStringUntil('\n');
    float[] vals = float(split(inString, " "));
    println("Temperatur: ",vals[0], "Fugtighed: ", vals[1]);
    temp = round(vals[0]);
    humidity = round(vals[1]);
    TableRow newRow = table.addRow();
    String time = "" + hour() + ":" + Integer.toString(minute())  + ":" + Integer.toString(second()) + "_" + Integer.toString(day()) + "/" + Integer.toString(month()) + "-" + Integer.toString(year());
    newRow.setString("time", time);
    newRow.setInt("temperature", temp);
    newRow.setInt("humidity", humidity);
    
    saveTable(table, "data/surveillance.csv");
  }
  //Humidity
  strokeWeight(1);
  stroke(0);
  fill(255);
  ellipse(540,180,250,250);
  
  fill(0);
  textAlign(CENTER);
  for(int i=0; i<11; i++ ){
    //text(i*10, 540-(cos(-0.25*PI+(i*PI*1.5/10))*100), 180-sin(-0.25*PI+(i*PI*1.5/10))*100);
    text(i*10, 540+(cos(map(i,0,10,1.25*PI,-0.25*PI))*100), 180-sin(map(i,0,10,1.25*PI,-0.25*PI))*100);
  }
  
  
  stroke(255,10,10);
  strokeWeight(5);
  line(540,180,540+(cos(map(humidity,0,100,1.25*PI,-0.25*PI))*95), 180-sin(map(humidity,0,100,1.25*PI,-0.25*PI))*95);
  
  //termometer
  
  noStroke();
  fill(255);
  rectMode(CENTER);
  rect(180,170,30,200);
  ellipse(180,280,70,70);
  strokeWeight(1);
  fill(255);
  
  for(int i=0; i<7;i++){
    text(i*10-10,150,map(i,0,7,235,65));
  }
  
  fill(255,0,0);
  stroke(255,0,0);
  
  if(temp<0){
    fill(0,0,255);
    stroke(0,0,255);
  }
  
  ellipse(180,280,40,40);
  
  strokeWeight(7);
  line(180,280,180,map(temp,-10,60,235,65));
}/*
void serialEvent(Serial myPort) {
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');
    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      // split the string on the commas and convert the resulting substrings
      // into an integer array:
      float[] vals = float(split(inString, ","));
      // if the array has at least three elements, you know you got the whole
      // thing.  Put the numbers in the color variables:
      if (vals.length >= 2) {
        // map them to the range 0-255:
        temp = vals[0];
        humidity = vals[1];
      }
    }
  }*/
