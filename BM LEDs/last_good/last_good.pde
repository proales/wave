//import java.awt.Color;

// Screenshot libraries
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.Rectangle;

// Midi librarires
import themidibus.*;

// Pixel pusher libraries
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;

// Midi setup
MidiBus myBus;
MidiBus myBus2;
int volume = 0;
int note = 0;
boolean step1On = false;
boolean step2On = false;
boolean step3On = false;

// Pixel Pusher setup.
DeviceRegistry registry;
TestObserver testObserver;
 
PImage screenshot; 
int pixelSize = 50;
int columns = 10;
int rows = 10;
int brightnessAdjustment = 0;
int colorSelected = 0;
int colorOverlay = 0;
int[] avgColors;
List<Strip> strips;

int[] map = {
  99, 98, 97, 96, 95, 94, 93, 92, 91, 90,
  80, 81, 82, 83, 84, 85, 86, 87, 88, 89,
  79, 78, 77, 76, 75, 74, 73, 72, 71, 70,
  60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
  59, 58, 57, 56, 55, 54, 53, 52, 51, 50,
  40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
  39, 38, 37, 36, 35, 34, 33, 32, 31, 30,
  20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
  19, 18, 17, 16, 15, 14, 13, 12, 11, 10,
  0,   1,  2,  3,  4,  5,  6,  7,  8,  9};

void setup() {
  // Define window screensize
  size(1100,500);
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
  
  avgColors = new int[100];
}

void draw() {
  int avgColor = 0;
  int adjustedColor = 0;
  int recoloredColor = 0;
  
  screenshot();
  image(screenshot,0,0,500,500);
  loadPixels();
  for (int x = 0; x < 10; x++) {
    for (int y = 0; y < 10; y++) {
      avgColor = avgColor(x, y);
      //avgColor = colorOverlay;
      adjustedColor = increaseBrightness(avgColor, brightnessAdjustment);
      if (step1On) {
        recoloredColor = mergeColors(adjustedColor, colorOverlay);
      } else {
        recoloredColor = adjustedColor;
      }
      fill(recoloredColor);
      rect(500 + x * pixelSize, 0 + y * pixelSize, pixelSize, pixelSize);
      avgColors[x + y * 10] = recoloredColor;
    }
  }
  
  if (testObserver.hasStrips) {   
    registry.startPushing();
    registry.setAutoThrottle(true);    
    strips = registry.getStrips();
  
    int numStrips = strips.size();
    if (numStrips == 0)
       return;
    for(Strip strip : strips) {
      for (int stripx = 0; stripx < strip.getLength(); stripx++) {
          strip.setPixel(avgColors[map[stripx]], stripx);
       }
    }
  }

  fill(colorSelected);
  rect(1000, 0, 100, 250);
 
  fill(colorOverlay);
  rect(1000, 250, 100, 250);
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
 
void screenshot() {
  try{
    Robot robot_Screenshot = new Robot();
    screenshot = new PImage(robot_Screenshot.createScreenCapture(new Rectangle(0,150,500,425)));
  }
  catch (AWTException e){ }
}

void keyPressed() {
  if (keyCode == UP) {
    brightnessAdjustment += 10;
  } else if (keyCode == DOWN) {
    brightnessAdjustment -= 10;
  }
  print("Brightness at: " + brightnessAdjustment + "\n");
}

void controllerChange(int channel, int number, int value) {
 if (number == 2) {
   if (abs(value - volume) > 1) {
     volume = value * 2 - 50;
   }
 } else if (number == 20) {
   if (abs(value - 38 - note) > 2) {
     note = constrain(value - 38, 1, 70);
   }
 }
  
 if (volume <= 70) {
   brightnessAdjustment = volume;
 } else {
   if (brightnessAdjustment > 0) {
     brightnessAdjustment =- 2;
   }
   brightnessAdjustment = constrain(brightnessAdjustment, 0, 100);
 }
 
 if (note > 1) {
   colorSelected = linearToColor(note);
 } else {
   colorSelected = color(255, 255, 255);
 }
 
 if (!step2On) {
   colorOverlay = colorSelected;
 }
 
 println("Volume: " + volume + " Note: " + note + " Brightness: " + brightnessAdjustment + " Overlay: " + step1On + " Lock: " + step2On);
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