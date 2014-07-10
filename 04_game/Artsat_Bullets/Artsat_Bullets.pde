/*
 * ARTSAT Bullets
 * 計測したデータに応じて弾を打つ
 *
 */

import java.util.Date;

JSONArray results;
int time;
int beginTime, endTime;
FloatList valueList;
IntList timeList;
int currentTime;
int currentNote = 0;
int speed = 400;

Bullets bullets;

void setup() {
  // 画面基本設定
  size(1440, 900, OPENGL);
  frameRate(60);
  background(0);

  // 弾丸クラス初期化
  bullets = new Bullets();

  // 開始時間と終了時間を設定
  beginTime = 1100000000;
  endTime =   1401517197;

  // 期間中の全ての値をAPIから取得して、リストに格納
  results = getSensorDataRange(beginTime, endTime);
  valueList = new FloatList();
  timeList = new IntList();
  for (int i = 0; i < results.size (); i++) {
    int time = results.getJSONObject(i).getInt("time");
    timeList.append(time);
    float sca = results.getJSONObject(i).getJSONObject("sensors").getFloat("sca");
    valueList.append(sca);
  }

  // 現在の時間を初期化
  currentTime = timeList.get(0);
}

void draw() {
  background(0);

  // 全てのデータを出力
  for (int i = 0; i < results.size (); i++) {
    // 現在の時間と一番近いデータヲ取得
    if (timeList.get(i) < currentTime) {
      fill(255, 31, 31);
      if (currentNote < i) {
        // 取得したデータの値から弾を生成
        int num = int(map(valueList.get(i), 0, 100, 1, 5));
        for(int j = 0; j < num; j++){
          float x = random(width);
          float y = random(-100, -10);
          PVector p = new PVector(x, y);
          bullets.addBullet(p);
        }
        currentNote = i;
      }
    }
  }

  // 現在の時間を更新
  currentTime += speed;

  // 時間をループ
  if (currentTime > timeList.get(results.size()-1)) {
    currentTime = timeList.get(0);
    currentNote = 0;
  }

  // 弾を描く
  bullets.draw();

  // UNIXタイムを日時に変換
  Date date = new Date();
  date.setTime((long)currentTime * 1000);
  // 日時をテキストで表示
  fill(255);
  text(String.valueOf(date), 5, 20);
}

// ARTSAT Web Apiから期間中のデータを取得する関数
JSONArray getSensorDataRange(int begin, int end) {
  JSONObject json, sensors;
  JSONArray results;
  json = loadJSONObject("http://api.artsat.jp/invader/sensor_data_range.json?begin=" + begin + "&end=" + end);
  results = json.getJSONArray("results");
  println("result size = " + results.size());
  return results;
}

// 弾丸に関するクラス
class Bullets {

  // 弾の位置
  ArrayList<PVector> bulletsPos;
  // 弾のスピード
  FloatList bulletsSpeed;

  // コンストラクタ（初期化）
  Bullets() {
    bulletsPos = new ArrayList<PVector>();
    bulletsSpeed = new FloatList();
  }

  // 弾を指定した場所に追加
  void addBullet(PVector pos) {
    bulletsPos.add(pos);
    bulletsSpeed.append(random(3, 5));
  }

  // 弾を描く
  void draw() {
    for (int i = 0; i < bulletsPos.size (); i++) {
      fill(255);
      noStroke();
      rectMode(CENTER);
      rect(bulletsPos.get(i).x, bulletsPos.get(i).y, 2, 5);
      bulletsPos.get(i).y += bulletsSpeed.get(i);
    }
    for (int i = 0; i < bulletsPos.size (); i++) {
      if (bulletsPos.get(i).y > height) {
        bulletsPos.remove(i);
        bulletsSpeed.remove(i);
      }
    }
  }
}
