/*
 *
 * Get all availabe sensor data and plot
 *
 */

JSONArray results;
int time;
float lat, lon, alt;
int beginTime, endTime;
FloatList scaList;

void setup() {
  size(800, 600);
  frameRate(60);

  beginTime = 1391212800;
  endTime = 1401517197;
  results = getSensorDataRange(beginTime, endTime);
  scaList = new FloatList();

  for (int i = 0; i < results.size (); i++) {
    float sca = results.getJSONObject(i).getJSONObject("sensors").getFloat("sca");
    scaList.append(sca);
  }
}

void draw() {
  background(0);
  fill(255);
  noStroke();
  for (int i = 0; i < results.size (); i++) {
    float x = width / float(results.size()) * i;
    float y = map(scaList.get(i), 0, 1000, height, 0);
    ellipse(x, y, 3, 3);
  }
}

JSONArray getSensorDataRange(int begin, int end) {
  JSONObject json, sensors;
  JSONArray results;
  json = loadJSONObject("http://api.artsat.jp/invader/sensor_data_range.json?begin=" + begin + "&end=" + end);
  results = json.getJSONArray("results");
  return results;
}

