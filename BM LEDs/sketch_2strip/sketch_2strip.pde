void setup() {
  // Define window screensize
  size(1100,1100);
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
  
  // Setup kinectc
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