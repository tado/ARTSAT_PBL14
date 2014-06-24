JSONArray results;

int time;
float lat, lon, alt;
int beginTime, endTime;

void setup() {
  beginTime = 1391212800;
  endTime = 1401517197;
  results = getSensorDataRange(beginTime, endTime);
  for (int i = 0; i < results.size(); i++) {
    int time = results.getJSONObject(i).getInt("time");
    println(time);
  }
}

void draw() {
}

JSONArray getSensorDataRange(int begin, int end) {
  JSONObject json, sensors;
  JSONArray results;
  json = loadJSONObject("http://api.artsat.jp/invader/sensor_data_range.json?begin=" + begin + "&end=" + end);
  results = json.getJSONArray("results");
  return results;
}

