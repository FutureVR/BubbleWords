ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
ArrayList<PVector> textPositions = new ArrayList<PVector>();
int counter = 0;
int counterLimit = 40;
int numberOfBubbles = 1200;

PFont myFont;
String myString = "Welcome TO ...";
float textSize = 200;
color textColor = color(255, 255, 254);

boolean startAnimation = false;
boolean timeSet = false;
boolean firstStringSet = false;
int phase = 0;
float timeCount = 0;
float firstTime = 0;
float currentTime = 0;

float timeLimit1 = 9000;
float timeLimit2 = 8000;


void setup()
{
  size(1600, 1600);
  background(255);
  loadPixels();
  
  myFont = createFont("Georgia", 64);
  textFont(myFont);

  
  for(int i = 0; i < numberOfBubbles; i++)
  {
    float posX = random(0, width);
    float posY = random(0, height);
    bubbles.add( new Bubble(new PVector(posX, posY)));
  }
  
  textSize(textSize); 
}


void draw()
{
  background(255);
  
  if (startAnimation == false)
  {
    textSize(100);
    fill( color(0, 0, 0) );
    text("PRESS THE SCREEN", width / 2, height / 5);
    textSize(textSize);
  }

  fill(textColor);
  textAlign(CENTER, CENTER);
  textSize(textSize);
  
  text(myString, width / 2, height / 2);
  checkPixels();
  
  for(Bubble b : bubbles)
  {
    b.mainUpdate();  
  }
  
  if(startAnimation)
  {
    if(phase == 0) playAnimation("FUN", 500, timeLimit1);
    if(phase == 1) playAnimation("WITH", 400, timeLimit1);
    if(phase == 2) playAnimation("PROCESSING", 220, timeLimit1);
    if(phase == 3) playAnimation("FUN\nWith\nPROCESSING", 220, timeLimit2);
    if(phase == 4)
    {
      startAnimation = false;
      phase = 0;
    }
  }
}


void playAnimation(String s, float ts, float timeLimit)
{
  if(!timeSet)
  {
    timeSet = true;
    firstTime = millis();
  }
  currentTime = millis();
  
  if( millis() - firstTime > timeLimit)
  {
    myString = s; 
    textSize = ts;
    checkPixels();
    for(Bubble b : bubbles) b.wandering = false;
    
    for(Bubble b : bubbles) b.setFixedPosition = true;
    timeSet = false;
    phase++;
  }
}


void mousePressed()
{
  startAnimation = true;
  
  for(Bubble b : bubbles)
  {
   b.wandering = false;
   b.setFixedPosition = true;
  }
}


void checkPixels()
{
  loadPixels();
  textPositions.clear();
  
  for(int y = 0; y < width - 1; y++)
  {
    for(int x = 0; x < height - 1; x++)
    {
      color c = pixels[x + y * width];
      
      if(blue(c) == blue(textColor))
      {
       counter++;
       if(counter >= counterLimit)
       {
         counter = 0;
         textPositions.add( new PVector(x, y));
       }
      }
    }
  }
}