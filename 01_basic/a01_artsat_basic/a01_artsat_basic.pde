void setup() {
  JSONObject json = loadJSONObject("http://api.artsat.jp/invader/sensor_data.json");

  JSONArray results = json.getJSONArray("results");
  JSONObject sensors = results.getJSONObject(0).getJSONObject("sensors");

  float lat = sensors.getFloat("lat");
  float lon = sensors.getFloat("lon");
  float alt = sensors.getFloat("alt");
  int time = results.getJSONObject(0).getInt("time");

  println(time + ", " + lat + ", " + lon + ", " + alt);
}

void draw() {
  
}

