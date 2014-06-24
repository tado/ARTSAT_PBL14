/*
 *
 * Get all availabe sensor data and plot
 *
 */

JSONArray results;
int time;
float lat, lon, alt;
int beginTime, endTime;
FloatList scmxList, scmyList, scmzList, scpxList, scpyList, scpzList;
IntList timeList;

void setup() {
  size(1200, 600);
  frameRate(60);

  beginTime = 1200000000;
  endTime =   1401517197;
  results = getSensorDataRange(beginTime, endTime);
  scmxList = new FloatList();
  scmyList = new FloatList();
  scmzList = new FloatList();
  scpxList = new FloatList();
  scpyList = new FloatList();
  scpzList = new FloatList();
  timeList = new IntList();

  for (int i = 0; i < results.size (); i++) {
    int time = results.getJSONObject(i).getInt("time");
    timeList.append(time);
    float scmx = results.getJSONObject(i).getJSONObject("sensors").getFloat("scmx");
    scmxList.append(scmx);
    float scmy = results.getJSONObject(i).getJSONObject("sensors").getFloat("scmy");
    scmyList.append(scmy);
    float scmz = results.getJSONObject(i).getJSONObject("sensors").getFloat("scmz");
    scmzList.append(scmz);
    float scpx = results.getJSONObject(i).getJSONObject("sensors").getFloat("scpx");
    scpxList.append(scpx);
    float scpy = results.getJSONObject(i).getJSONObject("sensors").getFloat("scpy");
    scpyList.append(scpy);
    float scpz = results.getJSONObject(i).getJSONObject("sensors").getFloat("scpz");
    scpzList.append(scpz);
  }
}

void draw() {
  background(0);
  fill(255);
  noStroke();
  for (int i = 0; i < results.size (); i++) {
    float x, y;
    x = map(timeList.get(i), timeList.get(0), timeList.get(results.size()-1), 0, width);
    y = map(scmxList.get(i), 0, 1000, height, 0);
    fill(255, 0, 0);
    ellipse(x, y, 3, 3);
    y = map(scmyList.get(i), 0, 1000, height, 0);
    fill(0, 255, 0);
    ellipse(x, y, 3, 3);
    y = map(scmzList.get(i), 0, 1000, height, 0);
    fill(0, 0, 255);
    ellipse(x, y, 3, 3);
    y = map(scpxList.get(i), 0, 1000, height, 0);
    fill(255, 0, 255);
    ellipse(x, y, 3, 3);
    y = map(scpyList.get(i), 0, 1000, height, 0);
    fill(0, 255, 255);
    ellipse(x, y, 3, 3);
    y = map(scpzList.get(i), 0, 1000, height, 0);
    fill(255, 255, 0);
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

