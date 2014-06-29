import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;
Oscil wave;
AudioInput in;
AudioRecorder recorder;

void setup() {
  size(512, 200, P3D);

  minim = new Minim(this);
  out = minim.getLineOut();
  wave = new Oscil( 440, 0.5f, Waves.SINE );
  wave.patch( out );

  recorder = minim.createRecorder(out, "myrecording.wav");
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(1);

  for (int i = 0; i < out.bufferSize () - 1; i++) {
    line( i, 50  - out.left.get(i)*50, i+1, 50  - out.left.get(i+1)*50 );
    line( i, 150 - out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50 );
  }

  if ( recorder.isRecording() ) {
    text("Currently recording...", 5, 15);
  } else {
    text("Not recording.", 5, 15);
  }
}

void mouseMoved() {
  float amp = map( mouseY, 0, height, 1, 0 );
  wave.setAmplitude( amp );

  float freq = map( mouseX, 0, width, 110, 880 );
  wave.setFrequency( freq );
}

void keyPressed() {
  if ( key == 'r' ) {
    if (recorder.isRecording()) {
      recorder.endRecord();
    } else {
      recorder.beginRecord();
    }
  }
  if ( key == 's' ){
    recorder.save();
    println("Done saving.");
  }
}

