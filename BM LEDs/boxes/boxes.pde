import java.awt.Robot;
import java.awt.AWTException;
import java.awt.Rectangle;
 
PImage screenshot; 
int pixelSize = 50;
int columns = 10;
int rows = 10;
int brightnessAdjustment = 0;
 
void setup() {
  size(1000,500);
  noStroke();
}

void draw() {
  int avgColor;
  int adjustedColor;
  
  screenshot();
  image(screenshot,0,0,500,500);
  loadPixels();
  for (int x = 0; x < 10; x++) {
    for (int y = 0; y < 10; y++) {
      avgColor = avgColor(x, y);
      adjustedColor = increaseBrightness(avgColor, brightnessAdjustment);
      fill(adjustedColor);
      rect(500 + x * pixelSize, 0 + y * pixelSize, pixelSize, pixelSize);
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