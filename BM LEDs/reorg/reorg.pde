void setup() {
  // Define window screensize
  size(1100,1000);
  // No lines
  noStroke();
  
  // Setup Midi
  MidiBus.list();
  myBus = new MidiBus(this, "Logidy UMI3", "Real Time Sequencer"); 
  myBus2 = new MidiBus(this, "Moog Music, Inc.", "Real Time Sequencer"); 
  
  // Setup pixel pusher
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setLogging(false);
  registry.setAntiLog(true);
  
  // Setup kinect
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  kinect.enableIR(true);
  kinect.enableColorDepth(false);
  kinect.enableMirror(true);
  deg = kinect.getTilt();
  
  avgColors = new int[100];
  
  minim = new Minim(this);
  minim.debugOn();
  in = minim.getLineIn(Minim.STEREO, int(1024));
  beat = new BeatDetect();
}


color increaseBrightness (color c, int amount) {
  float newRed = constrain(red(c) + amount, 0, 255);
  float newGreen = constrain(green(c) + amount, 0, 255);
  float newBlue = constrain(blue(c) + amount, 0, 255);
  return color(newRed, newGreen, newBlue); 
}

color mergeColors(color a, color b) {
  // Options BLEND, ADD, SUBTRACT, DARKEST, LIGHTEST, DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN, OVERLAY, HARD_LIGHT, SOFT_LIGHT, DODGE, or BURN
  return blendColor(a, b, OVERLAY);
}

int avgColor(int col, int row) {
  int red = 0;
  int green = 0;
  int blue = 0;
  int currentColor;
  int totalPixels = pixelSize * pixelSize;
  
  for (int x = 0; x < pixelSize; x++) {
    for (int y = 0; y < pixelSize; y++) {
      currentColor = getPixel(col * pixelSize + x, row * pixelSize + y);
      red += red(currentColor);
      green += green(currentColor);
      blue += blue(currentColor);
    }
  }
  
  return color(red/totalPixels, green/totalPixels, blue/totalPixels);
}

int getPixel (int x, int y) {
  return pixels[y*1100+x];
}
 
void keyPressed() {
   if (key == 'i') {
     ir = !ir;
     kinect.enableIR(ir);
   } else if (key == 'c') {
     colorDepth = !colorDepth;
     kinect.enableColorDepth(colorDepth);
   }else if(key == 'm'){
     mirror = !mirror;
     kinect.enableMirror(mirror);
   }
    
  if (keyCode == UP) {
    brightnessAdjustment += 10;
  } else if (keyCode == DOWN) {
    brightnessAdjustment -= 10;
  }
  print("Brightness at: " + brightnessAdjustment + "\n");
}


color linearToColor (int value) {
return HSBtoRGB(((float) value)/100.0*.85, (float) 1, (float) 1);
}

color HSBtoRGB(float h, float s, float v) {
   double r = 0, g = 0, b = 0, i, f, p, q, t;
   i = Math.floor(h * 6);
   f = h * 6 - i;
   p = v * (1 - s);
   q = v * (1 - f * s);
   t = v * (1 - (1 - f) * s);
   switch ((int) (i % 6)) {
       case 0: r = v; g = t; b = p; break;
       case 1: r = q; g = v; b = p; break;
       case 2: r = p; g = v; b = t; break;
       case 3: r = p; g = q; b = v; break;
       case 4: r = t; g = p; b = v; break;
       case 5: r = v; g = p; b = q; break;
   }
   return color((float) r * 255, (float) g * 255, (float) b * 255);
}

// Pixel Pusher setup class.
class TestObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
        //println("Registry changed!");
        if (updatedDevice != null) {
          //println("Device change: " + updatedDevice);
        }
        this.hasStrips = true;
    }
}

void noteOn(int channel, int pitch, int velocity) {
  if (pitch == 60) {
    step1On = !step1On;
    println("Step 1: " + (step1On ? "ON" : "OFF"));
  } else if (pitch == 62) {
    step2On = !step2On;
    println("Step 2: " + (step2On ? "ON" : "OFF"));
  } else if (pitch == 64) {
    step3On = !step3On;
    println("Step 3: " + (step3On ? "ON" : "OFF"));
  }
}