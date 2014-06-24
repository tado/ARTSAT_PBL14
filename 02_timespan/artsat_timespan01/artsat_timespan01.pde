JSONObject json, sensors;
JSONArray results;

int time;
float lat, lon, alt;
int beginTime, endTime;

void setup() {
  beginTime = 1391212800;
  endTime = 1401517197;
  noLoop();
}

void draw() {
  json = loadJSONObject("http://api.artsat.jp/invader/sensor_data_range.json?begin=" + beginTime + "&end=" + endTime);
  
  results = json.getJSONArray("results");
  println(results);
}

