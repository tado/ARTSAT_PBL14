float gx, gy, gz;
int time;

void setup() {
  size(640, 480, P3D);
  JSONObject json = loadJSONObject("http://api.artsat.jp/invader/sensor_data.json");

  JSONArray results = json.getJSONArray("results");
  JSONObject sensors = results.getJSONObject(0).getJSONObject("sensors");

  gx = sensors.getFloat("gx");
  gy = sensors.getFloat("gy");
  gz = sensors.getFloat("gz");
  time = results.getJSONObject(0).getInt("time");
  
  rectMode(CENTER);

  println(time + ", " + gx + ", " + gy + ", " + gz);
}

void draw() {
  background(0);
  translate(width/2, height/2);
  rotateX(radians(gx) * millis() / 1000.0);
  rotateY(radians(gy) * millis() / 1000.0);
  rotateZ(radians(gz) * millis() / 1000.0);
  box(100);
}

