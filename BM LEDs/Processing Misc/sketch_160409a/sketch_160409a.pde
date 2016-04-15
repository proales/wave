import themidibus.*;
import com.rngtng.launchpad.*;

Launchpad device;

void setup() {
  device = new Launchpad(this);
  noLoop();
}

void draw() {
  device.testLeds();
  delay(1000);
  device.reset();
  delay(1000);
  device.changeGrid( 4, 4, LColor.RED_HIGH + LColor.GREEN_LOW);
}