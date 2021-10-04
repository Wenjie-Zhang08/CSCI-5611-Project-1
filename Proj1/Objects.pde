
public class Agent{
  Vec2 goal;
  Vec2 nextStop;
  private Vec2 currentLocation;
  float velocity = 100;
  ArrayList<Vec2> path;
  Boolean idle;
  Vec2 originalDir;
  float currentAngle = 0;
  float angleVel;
  float angleOffset;
  Vec2 currentV;
  Vec2 tempLoc;
  
  public Agent(Vec2 s, Vec2 g){
    currentLocation = s;
    
    goal = g;
    idle = true;
    nextStop = s;
    path = new ArrayList();
    
    originalDir = new Vec2(1,0);
    angleVel = 180;
    angleOffset = 180;
  }
  
  public void Update(float dt){
    if(idle){
     return;
    }
    //print(dt);
    // update Angle
    turnToDir(dt);
    
    // update pos
    float rad = 5;
    
    
    Vec2 deltaPos = currentV.times(dt);
    float dist = deltaPos.length();
    float distToNS = rayCircleIntersectTime(nextStop,rad, currentLocation, currentV.normalized());
    //float distToNS = currentLocation.distanceTo(nextStop);
    
    //if((distToNS >= 0 && dist >= distToNS)){
    if((distToNS >= 0 && dist >= distToNS)||pointInCircle(nextStop,rad,currentLocation, 0.0f)){
       //check whether angle < angle thres
          //currentLocation = new Vec2(nextStop.x,nextStop.y);
          if(path.size() == 0){
           // currentLocation = nextStop;
            idle = true;
            return;
          }
          nextStop = path.remove(0);
    }
    currentLocation = currentLocation.plus(deltaPos);   
       
       /* old version
       
       // arrive at next stop
       // first move to next stop

       // check whether we reached the final goal
       if(path.size() == 0){
        idle = true;
        return;
       }
       
       dist -= distToNS;
       nextStop = path.remove(0);
      */
    
    //Vec2 dir = nextStop.minus(currentLocation).normalized();
    //currentLocation= currentLocation.plus(dir.times(dist));
   
    
    
    // if path
    // check whether skip
    
    
    // go along with path
    
    
    
  }
  
  private void turnToDir(float dt){

    Vec2 dir = currentV.normalized();
    // calculate angle
    float sine = cross(dir,originalDir);
    float cosi = dot(dir,originalDir);
      //if(cosi == 0){
      // if(sine > 0) angle = 90;
      // else angle = -90;
      //}
      //else{
    float angle = acos(cosi)/PI * 180;
    if(sine < 0) angle = -angle;
       //}

    // then we need to turn to angle;
    
    
    //float diff = ((angle-currentAngle)+360)%360;
    float diff = angle - currentAngle;
    diff = diff % 360.0;
    //if(diff < 0) diff += 360; //[0,360]
    if(diff <= -180) diff += 360;
    if(diff > 180) diff -= 360;
    // left or right?
    
    float turnAng = angleVel * dt;
    if(turnAng >= abs(diff)){
     currentAngle = angle;
     return;
    }
    //println(angle,currentAngle,diff);
    if(diff < 0){
       turnAng = - turnAng;
    }
    currentAngle = currentAngle + turnAng;
    if(currentAngle <= -180){
      currentAngle += 360.0; 
    }
    else if(currentAngle > 180){
      currentAngle -= 360.0;
    }
  }
  
  
  public void setGoal(Vec2 g){
   goal =  g;
  }
  

  
  public void setVelocity(Vec2 v){
    currentV = v;
    if(currentV.length() >= 1.5 * velocity)
      currentV.setToLength(1.5 * velocity);
  }
  
  public void setNextStop(Vec2 pos){
    nextStop = pos;
    
  }
  
  public void setCurrentLocation(Vec2 p){
    currentLocation = p;
  }
  
  public void setPath(ArrayList<Vec2> p){
    path = p;
  }
  
  public Vec2 getCurrentLocation(){
    return currentLocation;
  }
  
  public Vec2 getNextStop(){
    return nextStop;  
  }
  
  public Vec2 getCurrentVelocity(){
   return currentV; 
  }
  
  public float getAngle(){
   return (currentAngle + angleOffset)/180.0*PI; 
  }
}
