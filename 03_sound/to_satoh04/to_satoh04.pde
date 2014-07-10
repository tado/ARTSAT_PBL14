import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import java.util.Calendar;
import java.text.SimpleDateFormat;

int beginTime = 1391212800;
int endTime = 1401517197;
int soundLength = 4000; //msec

Minim minim;
AudioOutput out;
AudioRecorder recorder;

Oscil[] osc = new Oscil[24];
JSONArray results;
String[] sensors = {
  "alt", "bt", "bv", "gx", "gy", "gz", "lat", "lon", "mx", "my", "mz", "sca", "scmx", "scmy", "scmz", "scpx", "scpy", "scpz", "stmx", "stmy", "stmz", "stpx", "stpy", "stpz"
};
int time;
int currentTime;
int num = 0;
int day = 0;

void setup() {
  size(800, 600);
  frameRate(60);

  currentTime = 0;
  results = getSensorDataRange(beginTime, endTime);
  //println(results);
  minim = new Minim(this);
  out = minim.getLineOut();


  for (int i = 0; i < osc.length; i++) {
    Pan pan = new Pan(random(-0.5, 0.5));
    osc[i] = new Oscil(0, 0.5, Waves.SINE);
    osc[i].patch(pan);
    pan.patch(out);
  }
}

void draw() {
  float[] freq = new float[24];
  background(0);
  fill(255);

  int time = results.getJSONObject(num).getInt("time");
  Calendar cal = Calendar.getInstance();
  cal.setTimeInMillis((long)time * 1000);

  if (currentTime != time) {
    if (recorder != null) {
      recorder.endRecord();
      recorder.save();
      println("Done saving.");
    }
    day = cal.get(Calendar.DATE);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-hh-mm");
    recorder = minim.createRecorder(out, sdf.format(cal.getTime()) + ".wav");
    recorder.beginRecord();
    currentTime = time;
  }

  for (int i = 0; i < osc.length; i++) {
    freq[i] = results.getJSONObject(num).getJSONObject("sensors").getFloat(sensors[i]);
    osc[i].setFrequency(freq[i]);
  }  

  stroke( 255 );
  for ( int i = 0; i < out.bufferSize () - 1; i++ ) {
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    line( x1, height / 4 + out.left.get(i)*50, x2, height / 4 + out.left.get(i+1)*50);
    line( x1, height / 4 * 3 + out.right.get(i)*50, x2, height / 4 * 3 + out.right.get(i+1)*50);
  }

  fill(255);
  text(String.valueOf(cal.getTime()), 5, 20);

  num = millis() / soundLength;
  if (time > endTime) {
    num = 0;
  }
}

JSONArray getSensorDataRange(int begin, int end) {
  JSONObject json, sensors;
  JSONArray results;
  json = loadJSONObject("http://api.artsat.jp/invader/sensor_data_range.json?begin=" + begin + "&end=" + end);
  results = json.getJSONArray("results");
  return results;
}

