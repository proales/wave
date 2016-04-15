
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

// Beat detect setup
Minim minim;
AudioPlayer song;
AudioInput in;
BeatDetect beat;
int hitCount = 0;

// General setup
PImage screenshot; 
int pixelSize = 50;
int columns = 10;
int rows = 10;
int[] avgColors;
List<Strip> strips;

// Theramin calibration and tuning
int brightnessAdjustment = 0;
int colorNumber = 0;
int colorSelected = 0;
int colorOverlay = 0;
int noteMin = 128;
int noteMax = 0;
int volumeMin = 128;
int volumeMax = 0;
boolean windDown = false;
boolean windUp = false;
int windUpTo = 0;

// Kinect setup
Kinect kinect;
float deg;
boolean ir = false;
boolean colorDepth = false;
boolean mirror = false;

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