
void draw() {
  //beat.detect(in.mix);
  //if ( beat.isOnset() ) {
  //  println("hit " + hitCount);
  //  hitCount++;
  //  brightnessAdjustment = 25;
  //} else {
  //  if (brightnessAdjustment > 0) brightnessAdjustment = -1;
  //}
  background(0);
  image(kinect.getVideoImage(), 640, 0);
  image(kinect.getDepthImage(), 0, 0);
  //fill(255);
  //text(
  //  "Press 'i' to enable/disable between video image and IR image,  " +
  //  "Press 'c' to enable/disable between color depth and gray scale depth,  " +
  //  "Press 'm' to enable/diable mirror mode, "+
  //  "UP and DOWN to tilt camera   " +
  //  "Framerate: " + int(frameRate), 10, 515);
  
  int avgColor = 0;
  int adjustedColor = 0;
  int recoloredColor = 0;
  
  screenshot();
  image(screenshot,0,500,500,500);
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
      rect(500 + x * pixelSize, 500 + y * pixelSize, pixelSize, pixelSize);
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
  rect(1000, 500, 100, 250);
 
  fill(colorOverlay);
  rect(1000, 750, 100, 250);
} 