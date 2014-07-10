/*
 *
 * Get sensor data by time
 *
 */
//import ddf.minim.spi.*;
//import ddf.minim.signals.*;
import ddf.minim.*;
//import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
//import ddf.minim.effects.*;

Minim minim;
AudioOutput out;

Oscil[] osc = new Oscil[24];

JSONArray results;
String[] sensors = {
  "alt", "bt", "bv", "gx", "gy", "gz", "lat", "lon", "mx", "my", "mz", "sca", "scmx", "scmy", "scmz", "scpx", "scpy", "scpz", "stmx", "stmy", "stmz", "stpx", "stpy", "stpz"
};
int time;

void setup() {
  size(800, 600);
  frameRate(60);

  time = 1397366807;
  results = getSensorDataTime(time);
  println(results);

  //------------------------------------------------
  minim = new Minim(this);
  out = minim.getLineOut();

  for (int i = 0; i < osc.length; i++) {
    osc[i] = new Oscil(0, 0.5, Waves.SINE);
    osc[i].patch(out);
  }
}

void draw() {
  float[] freq = new float[24];
  background(0);
  fill(255);

  int time = results.getJSONObject(0).getInt("time");

  for (int i = 0; i < osc.length; i++) {
    freq[i] = results.getJSONObject(0).getJSONObject("sensors").getFloat(sensors[i]);
    osc[i].setFrequency(freq[i]);
  }

  stroke( 255 );
  for ( int i = 0; i < out.bufferSize () - 1; i++ ) {
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
  }
}

JSONArray getSensorDataTime(int time) {
  JSONObject json;
  JSONArray results;
  json = loadJSONObject("http://api.artsat.jp/invader/sensor_data.json?time=" + time);
  results = json.getJSONArray("results");
  return results;
}

