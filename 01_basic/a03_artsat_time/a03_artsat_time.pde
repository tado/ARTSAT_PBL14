/*
 *
 * Get sensor data by time
 *
 */

JSONArray results;
float lat, lon, alt;
int time;

void setup() {
  size(800, 600);
  frameRate(60);

  time = 1364180400;
  results = getSensorDataTime(time);
  println(results);
}

void draw() {
  background(0);
  fill(255);
  int time = results.getJSONObject(0).getInt("time");
  float mx = results.getJSONObject(0).getJSONObject("sensors").getFloat("mx");
  float my = results.getJSONObject(0).getJSONObject("sensors").getFloat("my");
  float mz = results.getJSONObject(0).getJSONObject("sensors").getFloat("mz");

  text("mx = " + mx, 20, 20);
  text("my = " + my, 20, 35);
  text("mz = " + mz, 20, 50);
  text("time = " + time, 20, 65);
}

JSONArray getSensorDataTime(int time) {
  JSONObject json;
  JSONArray results;
  json = loadJSONObject("http://api.artsat.jp/invader/sensor_data.json?time=" + time);
  results = json.getJSONArray("results");
  return results;
}

