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
      scaledNewNumber = -150;
     }
     
     if (abs(newNumber - colorNumber) > 100) {
       windUp = true;
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
   
   if (colorNumber > 2) {
     colorSelected = linearToColor(colorNumber);
   } else {
     colorSelected = color(255, 255, 255);
   }
   
   if (!step2On) {
     colorOverlay = colorSelected;
   }

 }
 
 if (windUp) {
   if (windUpTo <= brightnessAdjustment) {
       windUp = false;
   } else {
     if (windUpTo > 0) {
         brightnessAdjustment += 5; 
     }
   }
 }
  
 if (windDown) {
   if (brightnessAdjustment <= 5) {
     brightnessAdjustment = 0;
     windDown = false;
   } else {
     if(brightnessAdjustment > 0) {
       brightnessAdjustment -= 5; //(int) brightnessAdjustment * .15;  
     } else {
       brightnessAdjustment += 5; //(int) brightnessAdjustment * .15; 
     }
   }
 }
  
 //println("Volume: " + volume + "/" + brightnessAdjustment +  " Note: " + note + "/" + colorNumber + " max " + noteMax + "min " + noteMin );
 //println("Volume: " + volume + " Note: " + note + " Brightness: " + brightnessAdjustment);
}