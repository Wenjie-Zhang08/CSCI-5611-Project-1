public class Scene{

 float groundH;
 float groundW;
 
 // Agents
 Agent[] agents;
 float agentRad;
 int numAgents,maxNumAgents;
 float agentVel;
 Vec2[] agentF;
 Boolean canAddNewAgent = true;
 Boolean canTakeAway = true;
 
 // Obstacles
 int numObstacles,maxNumObstacles;
 Vec2[] circlePos;
 float[] circleRad;
 
 // Node
 int numNodes,maxNumNodes;
 Vec2[] nodePos;
 
 // path
 ArrayList<Integer>[]  neighbors;
 Boolean[] visited;
 int[] parent;
 float[] gdist;
 float[] astar;
 float dist_thres;
 ArrayList<Integer> starts;
 ArrayList<Integer> goals;
 
 // Textures
 PImage[] textures;
 ArrayList<String> textureNames;
 
 // render mode
 int mode = 0;
 boolean showAgentPaths;
 boolean showDebug;
 boolean showSG;
 Boolean canChangeMode = true;
 
 // Objs
 PShape[] shapes;
 ArrayList<String> shapeNames;

 // constructor
 public Scene(){
   
   groundH = 1000;
   groundW = 1000;
   
   
   //textures = imgs;
   //textureNames = tnames;
   // generate obstacles in scene

   maxNumObstacles = 100;
   numObstacles = 15;
   
   agentRad = 25;

    
   circlePos = new Vec2[maxNumObstacles]; //Circle positions
   circleRad = new float[maxNumObstacles];  //Circle radii
   
   // scene path finding
   maxNumNodes = 1000;
   numNodes = 500;
   
   nodePos =  new Vec2[maxNumNodes];
   neighbors = new ArrayList[maxNumNodes];  //A list of neighbors can can be reached from a given node
   //We also want some help arrays to keep track of some information about nodes we've visited
   visited = new Boolean[maxNumNodes]; //A list which store if a given node has been visited
   parent = new int[maxNumNodes];//A list which stores the best previous node on the optimal path to reach this node
   gdist = new float[maxNumNodes];//g
   astar = new float[maxNumNodes];//f=g+h
   
   dist_thres = 200;
   
   // init agents(rad is inited before)
   numAgents = 1;
   maxNumAgents = 20;
   agentVel = 100;
   
   agents = new Agent[maxNumAgents];
   agentF = new Vec2[maxNumAgents];
    
   //
   
   
   // inital everything
   reset();
   
 }
 
 
 public void reset(){
   // init paths
   mode = 0;
   setMode();
   placeRandomObstacles();
   generateRandomNodes();
   connectNeighbors();
   initAgents();
 }
 
 public void loadTextures(PImage[] t, ArrayList<String> tnames){
   textures = t;
   textureNames = tnames;
 }
 
 public void loadObjs(PShape[] s, ArrayList<String> snames){
   shapes = s;
   shapeNames = snames;
 }
 
 
 
 public void initAgents(){
   for(int i = 0; i < numAgents; i++){
    generateAgent(i) ;
   }
   
   
   /*
   float bound = 50;
  for (int i = 0; i < numAgents; i++){
    Vec2 startPos =new Vec2(random(bound,groundW - bound),random(bound,groundH - bound));
      boolean insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,startPos,2);
      //boolean insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
      while (insideAnyCircle){
        startPos = new Vec2(random(bound,groundW - bound),random(bound,groundH - bound));
        insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,startPos,2);
        //insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
       }
      Vec2 goalPos = new Vec2(random(bound,groundW - bound),random(bound,groundH - bound));
      insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,goalPos,2);
      //boolean insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
      while (insideAnyCircle){
        goalPos = new Vec2(random(bound,groundW - bound),random(bound,groundH - bound));
        insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,goalPos,2);
        //insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
      }
      //now we generate a new agent
      Agent agt = new Agent(startPos,goalPos);
      agents[i] = agt;
   }
   */
 }
 //----------------------------------------
 // Update Scene
 //----------------------------------------
 
 public void Update(float dt){
   UpdateAgents(dt);
 }
 
 

 
 private void UpdateAgents(float dt){
   for(int i = 0; i < numAgents; i++){     
     if(agents[i].idle){
       AgentNewGoal(i);       
       AgentFindPath(i);
     }
     // if collision, find path
     else{
       // check collision, set to idle? which means we need to refind the path
      Vec2 ns = agents[i].getNextStop();
      Vec2 aPos = agents[i].getCurrentLocation();
      Vec2 dir = aPos.minus(ns).normalized();
      float distBetween = ns.distanceTo(aPos);
      hitInfo circleListCheck = rayCircleListIntersect(circlePos,circleRad, numObstacles,ns,dir,distBetween);
      if(circleListCheck.hit){
         AgentFindPath(i);
         agents[i].idle = true;
      }
      else{
         AgentShortPath(i);
      }
       
     }
     AgentOriginalVelocity(i);
     
   }
   
   /*for (int i = 0; i < numAgents;i ++){
     agentF[i] = computeAgentForces(i);
   }
   */
   
   for(int i = 0; i < numAgents; i++){
     AgentUpdateVelocity(i);
   }
   for(int i = 0; i < numAgents;i++){
    agents[i].Update(dt); 
   }
   SolveAgentCollision();
 }
 
 private void AgentOriginalVelocity(int index){
   // if agent is idle
   if(agents[index].idle){
     if(agents[index].path.size() == 0)
     {
       agents[index].setVelocity(new Vec2(0,0));
       return;  // still idle
     }
     agents[index].setNextStop(agents[index].path.remove(0));
     //turn = true;
     agents[index].idle = false;
   }
   
   // now we generate the original velocity
   Vec2 vel = agents[index].nextStop.minus(agents[index].getCurrentLocation()).normalized();
   vel = vel.times(agentVel);
   
   
   agents[index].setVelocity(vel);
   
 }
 /*
 private void AgentUpdateVelocity(int index){
  Vec2 vel = agents[index].getCurrentVelocity();
  vel.add(agentF[index]);
  agents[index].setVelocity(vel);
 }
 */
 
 private void AgentUpdateVelocity(int index){
   Vec2 vel = agents[index].getCurrentVelocity();
   vel.add(computeAgentForces(index));
   agents[index].setVelocity(vel);
 }
 
 
 
 private void AgentShortPath(int index){
   int shortGoal = -1;
   int sz =  agents[index].path.size();
   //if(sz == 0) return;
   Vec2 currentLoc = agents[index].getCurrentLocation();
   for(int i = sz-1; i >= 0 ; i-= 1){
      Vec2 checkPos = agents[index].path.get(i);
      Vec2 dir = currentLoc.minus(checkPos).normalized();
      float distBetween = checkPos.distanceTo(currentLoc);
      hitInfo circleListCheck = rayCircleListIntersect(circlePos,circleRad, numObstacles,checkPos,dir,distBetween);
      if(!circleListCheck.hit){
        agents[index].setNextStop(checkPos);
        shortGoal = i;
        //print(shortGoal,checkPos);
        break;
      }
     
   }
   //if(shortGoal == -1) return;
   for(int j = 0; j <=  shortGoal;j++){
     agents[index].path.remove(0);
   }
 }
 
 
 private void AgentNewGoal(int index){
  float bound = 50;
  Vec2 goalPos = new Vec2(random(bound,groundW - bound),random(bound,groundH - bound));
  Boolean insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,goalPos,2);
  //boolean insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
  while (insideAnyCircle){
    goalPos = new Vec2(random(bound,groundW - bound),random(bound,groundH - bound));
    insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,goalPos,2);
    //insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
  }
  agents[index].goal = goalPos;
 }
 
 private void AgentFindPath(int index){
   Vec2 start = agents[index].getCurrentLocation();
   Vec2 goal = agents[index].goal;
   ArrayList<Integer> path = planPath(start,goal,circlePos,circleRad,numObstacles,nodePos,numNodes);
   ArrayList<Vec2> locPath = new ArrayList();
   //locPath.add(start);
   if(path.size() == 0){
     locPath.add(goal);
     agents[index].setPath(locPath);
     return;
   }
   if(path.get(0)== -1){
      return; 
   }
   for(int i = 0; i < path.size();i++){
     Vec2 np = nodePos[path.get(i)];
     locPath.add(new Vec2(np.x,np.y));     
   }
   locPath.add(goal);
   agents[index].setPath(locPath);
 }
 
//------------------------------------
// TTC Force
//------------------------------------

float computeTTC(Vec2 pos1, Vec2 vel1, float radius1, Vec2 pos2, Vec2 vel2, float radius2){
  return rayCircleIntersectTime(pos1,radius1+radius2,pos2,vel2.minus(vel1));
}

Vec2 computeAgentForces(int index){
  //TODO: Make this better
  Vec2 acc = new Vec2(0,0);
  float k_avoid = 2;
  float k_avoid_obs = 5;
  // We do not need to force of the goal
  //if(stopped[id]) return acc;
  /*
  Vec2 goal_vel = goalPos[id].minus(agentPos[id]);
  if(goal_vel.length()> goalSpeed) goal_vel.setToLength(goalSpeed);
  Vec2 goal_force = (goal_vel.minus( agentVel[id])).times(k_goal);
  acc.add(goal_force);
  */
  
  
  // First impliment the basic one
  float tH = 3;
  // Then consider about the distance and object function
  Vec2 myPosition = agents[index].getCurrentLocation();
  Vec2 myVel = agents[index].getCurrentVelocity();
  // Then we compute the avoidance force
  for(int i = 0; i < numAgents; i++){
    
    if(i == index) continue;// don't consider myself
    //if(stopped[i])continue;
    
    //
    Vec2 theirPosition = agents[i].getCurrentLocation();
    Vec2 theirVel = agents[i].getCurrentVelocity();
    // else we calculate the force between neighbors
    float ttc = computeTTC(theirPosition,theirVel,agentRad,myPosition,myVel,agentRad);
    //println(ttc);
    //if(id == 0 && i == 2) print(ttc);
    if(ttc <= 0 || ttc >= tH) continue;
    
    // we need to calculate the impact on the agent
    // first is the moment of collision
    Vec2 A_future =myPosition.plus(myVel.times(ttc));
    Vec2 B_future = theirPosition.plus(theirVel.times(ttc));
    Vec2 f_dir = A_future.minus(B_future).normalized();
    Vec2 avoidence_force = f_dir.times(((tH-ttc)/ttc)*k_avoid);
    acc.add(avoidence_force);    
  }  
  
  
  tH = 1;
  for(int i = 0; i < numObstacles; i++){
     Vec2 theirPosition = circlePos[i];
     float ttc = computeTTC(theirPosition,new Vec2(0,0),circleRad[i],myPosition,myVel,agentRad);
         if(ttc <= 0 || tH >= tH) continue;
    
    // we need to calculate the impact on the agent
    // first is the moment of collision
    Vec2 A_future =myPosition.plus(myVel.times(ttc));
    Vec2 B_future = theirPosition;
    Vec2 f_dir = A_future.minus(B_future).normalized();
    Vec2 avoidence_force = f_dir.times(((tH-ttc)/ttc)*k_avoid_obs);
    acc.add(avoidence_force);
  }
  
  
  return acc;
}


//-----------------------------------
// Solve Agent Collision
//-----------------------------------
private void SolveAgentCollision(){
  for(int i = 0; i < numAgents; i++){
    Vec2 pos = agents[i].getCurrentLocation();
    for(int j = 0; j < numObstacles; j++){
      if(pointInCircle(circlePos[j], circleRad[j],pos,0.0)){
        // solve collision
        //calculate ttc
        /*
        Vec2 sp = agents[i].getCurrentLocation();
        Vec2 dir = agents[i].currentV.normalized();
        float ttc = rayCircleIntersectTime(circlePos[j],circleRad[j],sp,dir);
        float dist  = ttc - 0.01;
        pos = sp.plus(dir.times(dist));*/
        Vec2 dir = pos.minus(circlePos[j]).normalized();
        float dist = circleRad[j]  + 0.01;
        pos = circlePos[j].plus(dir.times(dist));
        break;
      }
      
    }
    agents[i].setCurrentLocation(pos);
  }
  
}





/*
//Update agent positions & velocities based acceleration
void moveAgent(float dt){
  //Compute accelerations for every agents
  for (int i = 0; i < numAgents; i++){
    agentAcc[i] = computeAgentForces(i);
  }
  //Update position and velocity using (Eulerian) numerical integration
  for (int i = 0; i < numAgents; i++){
    //if(stopped[i]) continue;
    agentVel[i].add(agentAcc[i].times(dt));
    agentPos[i].add(agentVel[i].times(dt));
  }
}
 */
 
 
 //----------------------------------------
 //  Draw Scene
 //----------------------------------------
 
 
 
 public void Draw(){
   DrawFloor();
   DrawObstacles();
   DrawAgents();
   //if(showDebug) DrawPaths();
   if(showAgentPaths) DrawAgentPaths();
   if(showSG) DrawSG();
 }
 
 private void DrawSG(){
   for(int i = 0; i < numAgents; i++){
        Vec2 st = agents[i].getCurrentLocation();
        Vec2 gl = agents[i].goal;
        stroke(255,0,0);
        strokeWeight(2);
        line(st.x,2,st.y,gl.x,2,gl.y);
     
   }
   
 }
 
 
 private void DrawAgents(){
  PShape model = shapes[shapeNames.indexOf("Tank")];
  PShape flag = shapes[shapeNames.indexOf("Flag")];
  float agentScale = 11;
  float flagScale = 3;
  float flagRad = 30;
  for(int i = 0; i < numAgents;i++){
    Vec2 loc = agents[i].getCurrentLocation();
    pushMatrix(); 
    translate(loc.x , 0, loc.y );
    rotateY(agents[i].getAngle());
    scale(agentRad/agentScale);
    // scale 3 rad 12
    shape(model);
    popMatrix();
    
 
    
    // draw goal
    if(!agents[i].idle){
      Vec2 goalLoc = agents[i].goal;
      pushMatrix();
      translate(goalLoc.x, 0,goalLoc.y);
      scale(flagRad/flagScale);
      shape(flag);
      popMatrix();
    }
    
    if(showDebug){
      pushMatrix();   
      // Test
      //stroke(5);
      translate(loc.x , 0, loc.y );
      rotateX( PI/2 );
      drawCylinder( 10,24,0.2 );
      popMatrix();   
    }
  }
   
   
 }
 
 private void DrawAgentPaths(){
     // draw the path of agent
  for(int j = 0 ; j < numAgents;j++){
  Agent a = agents[j];
  stroke(0,255,0);
  strokeWeight(5);
  ArrayList<Vec2> p = a.path;
  Vec2 cp = a.getCurrentLocation();
  if(p.size() == 0) {
    Vec2 gp = a.goal;
    line(gp.x,1,gp.y,cp.x,1,cp.y);
    continue;
  }
  
    stroke(0,255,0);
  strokeWeight(5);
  Vec2 cg = a.nextStop;
  Vec2 ls = p.get(0);
  line(cg.x,1,cg.y,cp.x,1,cp.y);
  line(cg.x,1,cg.y,ls.x,1,ls.y);
  for (int i = 0; i < p.size()-1;i++ ){
    ls = p.get(i);
    Vec2 le = p.get(i+1);
    stroke(0,255,0);
    strokeWeight(5);
    
    line(ls.x,1,ls.y,le.x,1,le.y);
  }
  }
   
   
 }
 
 private void DrawPaths(){

  for (int i = 0; i < numNodes; i++){
    for (int j : neighbors[i]){
         stroke(255,255,0);
  strokeWeight(5);
      line(nodePos[i].x,0.5,nodePos[i].y,nodePos[j].x,0.5,nodePos[j].y);
      
      //print(nodePos[i],nodePos[j]);
    }
  }
  
  

 }
 
 
 private void DrawFloor(){
  float w = 100;
  float h = 100;
  

  PImage image = textures[textureNames.indexOf("Ground")];
  
  for(int i = -100; i <= groundW; i  +=w){
    for(int j = -100; j <= groundH; j += h){
        pushMatrix(); 
        beginShape();
        texture(image);
        noStroke();
        //stroke(1);
        //strokeWeight(1);
        translate(i , 0, j );
        // vertex( x, y, z, u, v) where u and v are the texture coordinates in pixels
        vertex(0, 0, 0, 0, 0);
        vertex(w, 0, 0, image.width, 0);
        vertex(w,0, h, image.width, image.height);
        vertex( 0, 0,h, 0, image.height);
        endShape();
        popMatrix();   
     }
   }
   noStroke();
 }
 
 private void DrawObstacles(){
   PShape windmill = shapes[shapeNames.indexOf("Windmill")];
   PShape silo = shapes[shapeNames.indexOf("Silo")];
   float windMillScale  = 3;
   float siloScale = 2.5;
   float r_thres = 25;
   //
   float h = 30;
   int sides = 20;
   fill(150,100,100);
   noStroke();
   for (int i = 0; i < numObstacles; i++){
    Vec2 cp = circlePos[i];
    float r = circleRad[i] - agentRad;
    
    pushMatrix(); 
    translate(cp.x ,0, cp.y );
    if(r <= r_thres){
      rotateY(PI);
      scale(r/siloScale);
      // scale 3 rad 12
      shape(silo);
    }
    else{
      rotateY(PI);
      scale(r/windMillScale);
      // scale 3 rad 12
      shape(windmill);
    }

    popMatrix();
    
    if(showDebug){
      //r = circleRad[i] + agentRad;
      pushMatrix();    
      //stroke(5);
      translate(cp.x ,h/2, cp.y );
      rotateX( PI/2 );
      drawCylinder( sides,r,h );
      popMatrix();       
    }
   }
   
 }
 
 
 
 
 //-------------------------------------
 // Path Finding
 //-------------------------------------
 
 // ***** Important ******
 // Some changes need to be made on the rad
 
 void generateRandomNodes(){
  for (int i = 0; i < numNodes; i++){
    Vec2 randPos = new Vec2(random(groundW),random(groundH));
    boolean insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,randPos,2);
    //boolean insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
    while (insideAnyCircle){
      randPos = new Vec2(random(groundW),random(groundH));
      insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,randPos,2);
      //insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
    }
    nodePos[i] = randPos;
  }
}

void placeRandomObstacles(){
  //Initial obstacle position
  for (int i = 0; i < numObstacles; i++){
    
    circleRad[i] = (15+40*pow(random(1),3));
    circleRad[i] += agentRad;
    circlePos[i] = new Vec2(random(50,950),random(50,950));
    //while(pointInCircleList(circlePos,circleRad,i,circlePos[i],circleRad[i])){
    // circlePos[i] =  new Vec2(random(50,950),random(50,950));
    //}
  }
  
}
 
 
 
 //Set which nodes are connected to which neighbors (graph edges) based on PRM rules
void connectNeighbors(){
  Vec2[] centers = circlePos;
  float[] radii = circleRad;
  
  for (int i = 0; i < numNodes; i++){
    neighbors[i] = new ArrayList<Integer>();  //Clear neighbors list
    for (int j = 0; j < numNodes; j++){
      if (i == j) continue; //don't connect to myself 
      Vec2 dir = nodePos[j].minus(nodePos[i]).normalized();
      float distBetween = nodePos[i].distanceTo(nodePos[j]);
      //if (distBetween >= dist_thres) continue;
      hitInfo circleListCheck = rayCircleListIntersect(centers, radii, numObstacles, nodePos[i], dir, distBetween);
      if (!circleListCheck.hit){
        
        neighbors[i].add(j);
      }
    }
  }
}

// generate start and goal list

int SGList(Vec2 startPos,Vec2 goalPos, Vec2[] centers, float[] radii, int numObstacles, Vec2[] nodePos, int numNodes){
  Vec2 dir = goalPos.minus(startPos).normalized();
  float distBetween = startPos.distanceTo(goalPos);
  hitInfo circleListCheck = rayCircleListIntersect(centers, radii, numObstacles, startPos,dir,distBetween);
  if(!circleListCheck.hit){
    return 1;
  }
  starts = new ArrayList();
  goals = new ArrayList();
  for (int i = 0; i < numNodes; i++){
      dir = nodePos[i].minus(startPos).normalized();
      distBetween = nodePos[i].distanceTo(startPos);
      //if (distBetween < dist_thres){
          
          circleListCheck = rayCircleListIntersect(centers, radii, numObstacles, startPos, dir, distBetween);
          if (!circleListCheck.hit){
            starts.add(i);
          }
      //}
      
      dir = goalPos.minus(nodePos[i]).normalized();
      distBetween = nodePos[i].distanceTo(goalPos);
      //if (distBetween < dist_thres){
         //println(distBetween);
          circleListCheck = rayCircleListIntersect(centers, radii, numObstacles, nodePos[i], dir, distBetween);
          if (!circleListCheck.hit){
            goals.add(i);
          }
      //}
  }
  if(starts.size() == 0 || goals.size() == 0) return -1;
  //print(goals);
  return 0;
  
}


ArrayList<Integer> planPath(Vec2 startPos, Vec2 goalPos, Vec2[] centers, float[] radii, int numObstacles, Vec2[] nodePos, int numNodes){
  ArrayList<Integer> path = new ArrayList();  
  int ans = SGList(startPos,goalPos,centers,radii,numObstacles,nodePos,numNodes);
  if(ans == 1){
    return path;
  }
  else if (ans == -1){
   path.add(0, -1);
   return path;
  }
  
  
  path = runAStar(nodePos,numNodes, startPos,goalPos);
  return path;
}


void calculateObj(int currentNode, int childNode, Vec2[] nodePos, Vec2 goalPos){
  float currentg = gdist[currentNode];
  float childg = currentg + nodePos[currentNode].distanceTo(nodePos[childNode]);
  gdist[childNode] = childg;
  float heuristic= nodePos[childNode].distanceTo(goalPos);
  astar[childNode] = childg + heuristic;
}

int astarPos(ArrayList<Integer> ls, float obj){
   if(ls.size() == 0) return 0;
  
  for(int j = 0; j < ls.size();j++){
     if(obj <= astar[ls.get(j)])
         return j;
  }
  return ls.size();
  
}



//A* Path Finding
ArrayList<Integer> runAStar(Vec2[] nodePos, int numNodes,Vec2 startPos, Vec2 goalPos){
  ArrayList<Integer> fringe = new ArrayList();  //New empty fringe
  ArrayList<Integer> path = new ArrayList();
  int goalID = -1;
  
  
  for (int i = 0; i < numNodes; i++) { //Clear visit tags and parent pointers
    visited[i] = false;
    parent[i] = -1; //No parent yet
  }
  // we need to set the start dist for start ID
  for(int i = 0; i < starts.size(); i++){
    int index = starts.get(i);
    
    
    gdist[index] = startPos.distanceTo(nodePos[index]);
    astar[index] = goalPos.distanceTo(nodePos[index])+gdist[index];
      
    visited[index] = true;
    fringe.add(astarPos(fringe,astar[index]),index);
  }
  
  
  
  //println("\nBeginning Search");

  //println("Adding node", startID, "(start) to the fringe.");
  //println(" Current Fringe: ", fringe);
  
  while (fringe.size() > 0){
    int currentNode = fringe.get(0);
    fringe.remove(0);
    if (goals.indexOf(currentNode) != -1){
      //println("Goal found!");
      goalID = currentNode;
      //println(goalID);
      break;
    }
    for (int i = 0; i < neighbors[currentNode].size(); i++){
      int neighborNode = neighbors[currentNode].get(i);
      if (!visited[neighborNode]){
        visited[neighborNode] = true;
        parent[neighborNode] = currentNode;
        //fringe.add(neighborNode);
        //println("Added node", neighborNode, "to the fringe.");
        //println(" Current Fringe: ", fringe);
        
        
        // we need to calculate its h
        calculateObj(currentNode,neighborNode,nodePos,goalPos);
        
        float obj =  astar[neighborNode];
        //println(obj);
        // we need to know where it should be 
        fringe.add(astarPos(fringe,obj),neighborNode);

     

      }
    } 
  }
  
  if (fringe.size() == 0){
    //println("No Path");
    path.add(0,-1);
    return path;
  }
    
  //print("\nReverse path: ");
  int prevNode = parent[goalID];
  path.add(0,goalID);
  //print(goalID, " ");
  while (prevNode >= 0){
    //print(prevNode," ");
    path.add(0,prevNode);
    prevNode = parent[prevNode];
  }
  //print("\n");
  //print(path);
  return path;
}

//-------------------------------
// User Input Handler
//-------------------------------

void HandleKeyPressed(){
  if(key == 'r') reset();
  if(key == 'm'){
    changeMode();
    canChangeMode = false; 
  }
  if(key == '=') addAgent();
  if(key == '-'){
    canTakeAway = false;
    if(numAgents > 0) numAgents--;
  }
}

void HandleKeyReleased(){
  if(key == 'm') canChangeMode = true;
  if(key == '=') canAddNewAgent = true;
  if(key == '-') canTakeAway = true;
}

void changeMode(){
  if(!canChangeMode) return;
  mode ++;
  mode = mode % 3;
  setMode();
}

void setMode(){
  switch(mode){
   case 0:
     // original mode
     //showPath = false;
     showAgentPaths = false;
     showDebug = false;
     showSG = true;
     break;
     
   case 1:
     // route mode
     //showPath = false;
     showAgentPaths = true;
     showDebug = false;
     showSG = true;
     break;
   
   case 2:
     // debug mode
     //showPath = true;
     showAgentPaths = true;
     showDebug = true;
     showSG = true;
     break;
  }
  
}

// check whether it is inside any agent (before index)
private Boolean insideAnyAgent(int index, Vec2 point){
  for(int i = 0; i < index; i ++){
    if(pointInCircle(agents[i].getCurrentLocation(), 2*agentRad,point,0.0))
      return true;
  }
  return false;
}

private void generateAgent(int index){
  // first we random generate start
  float bound = 50;
  Vec2 startPos =new Vec2(random(bound,groundW - bound),random(bound,groundH - bound));
  boolean insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,startPos,2);
  //boolean insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
  while (insideAnyCircle || insideAnyAgent(index,startPos)){
    startPos = new Vec2(random(bound,groundW - bound),random(bound,groundH - bound));
    insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,startPos,2);
      //insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
     }
  Vec2 goalPos = new Vec2(random(bound,groundW - bound),random(bound,groundH - bound));
  insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,goalPos,2);
  //boolean insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
  while (insideAnyCircle){
    goalPos = new Vec2(random(bound,groundW - bound),random(bound,groundH - bound));
    insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,goalPos,2);
    //insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
  }
  //now we generate a new agent
  Agent agt = new Agent(startPos,goalPos);
  agents[index] = agt;
  
}


private void addAgent(){
  if(! canAddNewAgent) return;
  if(numAgents < maxNumAgents){
    generateAgent(numAgents);
    numAgents ++;
    
  }
  canAddNewAgent = false;
}


}
