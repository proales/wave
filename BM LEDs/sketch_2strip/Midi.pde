void noteOn(int channel, int pitch, int velocity) {
  if (pitch == 60) {
    step1On = !step1On;
    //println("Step 1: " + (step1On ? "ON" : "OFF"));
  } else if (pitch == 62) {
    step2On = !step2On;
    //println("Step 2: " + (step2On ? "ON" : "OFF"));
  } else if (pitch == 64) {
    step3On = !step3On;
    //println("Step 3: " + (step3On ? "ON" : "OFF"));
  }
}

void controllerChange(int channel, int number, int value) {
 int noteCalibration = 0; 
 int volumeCalibration = 1;
  
 // Volume 
 if (number == 2) {
   volume = value;
   
   if (value < volumeMin) volumeMin = value;
   if (value > volumeMax) volumeMax = value;
   
   int min = 0;
   int max = 127;
   
   int newNumber = ( (volumeMax - volumeMin) * (value - min) ) / (max - min) + volumeMin;
   int scaledNewNumber = (int) ((newNumber * 1) - 40);
   
   if (value >= volumeMax - 5) {
     windDown = true;
   } else {
     windDown = false;
      
     if (value == 0) {
      scaledNewNumber = -60;
     }
     
     if (scaledNewNumber - 20 >= brightnessAdjustment && scaledNewNumber > 0) {
       windUp = true;
       windUpTo = scaledNewNumber;
     } else {
       brightnessAdjustment = scaledNewNumber;
     }   
   }
   
 // Note
 } else if (number == 20) {
   note = value;
   
   if (value < noteMin) noteMin = value;
   if (value > noteMax) noteMax = value;
   
   int min = 0;
   int max = 127;
   
   int newNumber = ( (noteMax - noteMin) * (value - min) ) / (max - min) - noteMin;
   
   if (abs(newNumber - colorNumber) > 1) {
     colorNumber = newNumber;
   }
   
   boolean notAllWhite = true;
   
   if (colorNumber > 5) {
     colorSelected = linearToColor(colorNumber);
   } else if (colorNumber > 3) {
     colorSelected = color(99, 99, 99);
   } else if (colorNumber > 1) {
     colorSelected = color(55, 55, 55);
   } else {
     notAllWhite = false;
     colorSelected = color(255, 255, 255);
   }
   
   if (!step2On) {
     colorOverlay = colorSelected;
   }

 }
 
}