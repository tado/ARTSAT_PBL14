/*
 * ARTSAT Music
 * play notes form the sensor values of artsat
 *
 */
 
import ddf.minim.*;
import ddf.minim.ugens.*;

import java.util.Date;

Minim minim;
AudioOutput out;

JSONArray results;
int time;
int beginTime, endTime;
FloatList valueList;
IntList timeList;
int currentTime;
int currentNote = 0;
int speed = 100;

void setup() {
  // basic setup
  size(1440, 900, OPENGL);
  frameRate(60);
  rectMode(CENTER);

  // init minim  
  minim = new Minim(this);
  out = minim.getLineOut();

  // set begin time and end time
  beginTime = 1100000000;
  endTime =   1401517197;

  // get all availabe sensor data during a period
  results = getSensorDataRange(beginTime, endTime);
  valueList = new FloatList();
  timeList = new IntList();

  // generate time and value lists form the results
  for (int i = 0; i < results.size (); i++) {
    int time = results.getJSONObject(i).getInt("time");
    timeList.append(time);
    float sca = results.getJSONObject(i).getJSONObject("sensors").getFloat("sca");
    valueList.append(sca);
  }

  // init curren time
  currentTime = timeList.get(0);
}

void draw() {
  background(0);
  noStroke();

  // draw all results by dots
  for (int i = 0; i < results.size (); i++) {
    float x = map(timeList.get(i), timeList.get(0), timeList.get(results.size()-1), 0, width);
    float y = map(valueList.get(i), 0, 1000, height, 0);

    if (timeList.get(i) < currentTime) {
      fill(255, 31, 31); 
      if (currentNote < i) {
        // set frequency from the value
        float freq = map(valueList.get(i), 0, 1000, 100, 12000);
        // play note
        out.playNote( 0.0, 1.0, freq);
        // reset current note num
        currentNote = i;
      }
    } else {
      fill(255);
    }
    // draw dot
    rect(x, y, 2, 2);
  }

  // draw current time line 
  float x = map(currentTime, timeList.get(0), timeList.get(results.size()-1), 0, width);
  stroke(127);
  line(x, 0, x, height);
  currentTime += speed;

  // reset time (loop)
  if (currentTime > timeList.get(results.size()-1)) {
    currentTime = timeList.get(0);
    currentNote = 0;
  }

  // convert unix time to Date
  Date date = new Date();
  date.setTime((long)currentTime * 1000);
  // draw date by text
  fill(255);
  text(String.valueOf(date), 5, 20);
}

// function to get all availabe sensor data during a period via web api
JSONArray getSensorDataRange(int begin, int end) {
  JSONObject json, sensors;
  JSONArray results;
  json = loadJSONObject("http://api.artsat.jp/invader/sensor_data_range.json?begin=" + begin + "&end=" + end);
  results = json.getJSONArray("results");
  println("result size = " + results.size());
  return results;
}

