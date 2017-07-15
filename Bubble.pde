class Bubble
{ 
  
  //Editable Values
  public float myRadius = 4;
  float maxVelocity = 6;
  float maxForce = .5;
  float attackRadius = 100;
  
  // Non-editable Values
  PVector myPosition = new PVector();
  PVector myVelocity = new PVector(0, 0);
  PVector myAcceleration = new PVector();
  float myAngle = random(0, 360);
  float angleStep = 2;
  
  PVector targetPosition = new PVector(400, 400);
  PVector desiredVelocity = new PVector();
  PVector steering = new PVector();
  float distanceToTarget;
  float smallestDistance = 1000;
  int closestIndex;
  
  PVector fixedPosition;
  boolean setFixedPosition = false;
  boolean wandering = true;
  
  
  
  Bubble(PVector p)
  {
    myPosition.x = p.x;
    myPosition.y = p.y;
    
    targetPosition = new PVector(random(0, width), random(0, height));
  }
  
  
  void mainUpdate()
  {
    updateTarget();
    updateSteering();
    //spreadOut();
    updateMovement();
    display();
  }
  
  
  void updateMovement()
  {
    myVelocity.add(myAcceleration);
    myPosition.add(myVelocity);
    myAcceleration = new PVector(0, 0);
    
    myAngle += angleStep;
  }
  
  void updateSteering()
  {
    desiredVelocity = PVector.sub(targetPosition, myPosition);
    
    if(desiredVelocity.mag() < attackRadius)
    {
      float m = map(desiredVelocity.mag(), 0, attackRadius, 0, maxVelocity);
      desiredVelocity.setMag(m);
    }
    else
    {
      desiredVelocity.setMag(maxVelocity);
    }
    
    steering = PVector.sub(desiredVelocity, myVelocity);
    steering.limit(maxForce);
    addForce(steering);
  }

  void addForce(PVector force)
  {
    myAcceleration.add(force);
  }
  
  void updateTarget()
  {
    if(wandering)
    {
      if(int(random(0, 6)) == 0) 
      {
        float changeX = 10; 
        float changeY = 10; 
        targetPosition = new PVector(targetPosition.x + random(-changeX, changeX), targetPosition.y + random(-changeY, changeY));
      }
      
      if(int(random(0, 25)) == 0) 
      {
        float changeX = 50; 
        float changeY = 50; 
        targetPosition = new PVector(targetPosition.x + random(-changeX, changeX), targetPosition.y + random(-changeY, changeY));
      }
      
      if(int(random(0, 100)) == 0) 
      {
        PVector randVector = new PVector(random(0, width), random(0, height));
        targetPosition = randVector;
      }
    }
    else
    {
      if(setFixedPosition)
      {
        setFixedPosition = false;
        int index = (int)random(0, textPositions.size() - 1);
        fixedPosition = textPositions.get(index);
        if(index != 0) textPositions.remove(index);
      }
      
      targetPosition = fixedPosition;
    }
  }
  
  void spreadOut()
  {
    for(int i = bubbles.size() - 1; i >= 0; i--)
    {
      PVector distance = PVector.sub(myPosition, bubbles.get(i).myPosition);
      if(distance.mag() < 20)
      {
        distance.normalize();
        distance.mult(.1);
        addForce(distance);
      }    
    }  
  }
  
  void display()
  {
    fill(128, 0, 0);
    //fill(random(0, 255), random(0, 255), random(0, 255));
    
    pushMatrix();
    beginShape();
    translate(myPosition.x, myPosition.y);
    rotate(radians(myAngle));
    for(float angle = 0; angle < 360; angle += 60) vertex(myRadius * cos(radians(angle)), myRadius * sin(radians(angle)));
    endShape(CLOSE);
    popMatrix();
    
    //ellipse(myPosition.x, myPosition.y, myRadius, myRadius);
  }
}