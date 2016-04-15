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
int volume = 0;
int note = 0;

// Pixel Pusher setup.
DeviceRegistry registry;
TestObserver testObserver;
 
PImage screenshot; 
int pixelSize = 50;
int columns = 10;
int rows = 10;
int brightnessAdjustment = 0;
 
void setup() {
  // Define window screensize
  size(1000,500);
  // No lines
  noStroke();
  
  // Setup Midi
  MidiBus.list();
  myBus = new MidiBus(this, "Moog Music, Inc.", "Real Time Sequencer"); 
  
  // Setup pixel pusher
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setLogging(false);
  registry.setAntiLog(true);

  
}

void draw() {
  int avgColor = 0;
  int adjustedColor = 0;
  int[] avgColors = new int[10];
  
  screenshot();
  image(screenshot,0,0,500,500);
  loadPixels();
  for (int x = 0; x < 10; x++) {
    for (int y = 0; y < 10; y++) {
      avgColor = avgColor(x, y);
      //avgColor = color(note, 0, 0);
      adjustedColor = increaseBrightness(avgColor, brightnessAdjustment);
      fill(adjustedColor);
      rect(500 + x * pixelSize, 0 + y * pixelSize, pixelSize, pixelSize);
    }
    avgColors[x] = adjustedColor;
  }
  
  if (testObserver.hasStrips) {   
    registry.startPushing();
    registry.setAutoThrottle(true);    
    List<Strip> strips = registry.getStrips();
  
    int numStrips = strips.size();
    if (numStrips == 0)
       return;
    for(Strip strip : strips) {
      for (int stripx = 0; stripx < strip.getLength(); stripx++) {
          strip.setPixel(avgColors[stripx], stripx);
       }
    }
  }
} 

color increaseBrightness (color c, int amount) {
  float newRed = constrain(red(c) + amount, 0, 255);
  float newGreen = constrain(green(c) + amount, 0, 255);
  float newBlue = constrain(blue(c) + amount, 0, 255);
  return color(newRed, newGreen, newBlue); 
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
  return pixels[y*1000+x];
}
 
void screenshot() {
  try{
    Robot robot_Screenshot = new Robot();
    screenshot = new PImage(robot_Screenshot.createScreenCapture(new Rectangle(0,150,500,500)));
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
    volume = value;
  } else if (number == 20) {
    note = value;
  }
  
  //println("Volume: " + volume + " Note: " + note);
  brightnessAdjustment = volume * 2;
  
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