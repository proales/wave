void screenshot() {
  try{
    Robot robot_Screenshot = new Robot();
    screenshot = new PImage(robot_Screenshot.createScreenCapture(new Rectangle(0,150,500,425)));
  }
  catch (AWTException e){ }
}