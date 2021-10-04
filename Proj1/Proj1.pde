//CSCI 5611 - Graph Search & Planning
//PRM Sample Code [Proj 1]
//Instructor: Stephen J. Guy <sjguy@umn.edu>

// This is Part 2 (b) and Part 3
// Name: Wenjie Zhang
// ID: 5677291



// load 
String workingPath;
String assetPath;
String[] imageNames = {"Big-Goldy-Face.jpg","wood.bmp","Desert_Bushes.png"};//https://assetstore.unity.com/packages/2d/textures-materials/glovergames-free-ground-textures-135418
String[] tNames = {"Goldy","Floor","Ground"};

PImage icon;

String[] objNames = {"frog.obj","Silo.obj","TowerWindmill.obj","Tank3.obj","Flag.obj"};// Models coming from https://quaternius.com/index.html
String[] oNames = {"Frog","Silo","Windmill","Tank","Flag"};

float loading = -1;
Boolean loaded = false;

int numObs = 100; // haven't been used
// scene
Camera camera;
Scene scene;



void setup() {;
   // PShader defaultShader = new PShader(this, "vertDefaultPass.glsl", "fragDefaultPass.glsl");
   // shader(defaultShader);
   workingPath = sketchPath("assets");
   //println(workingPath);
   size(1024,768, P3D);
   thread("loadScene"); 
   // load loading screen
   icon = loadImage(workingPath+File.separator + imageNames[0]);
   noStroke();
   
   // set up -> draw
   
}






// draw is update
void draw(){
  
 if(!loaded){
    background(0); 
    drawLoadingScene(loading);
    return;
  }
  
  // start drawing secnes

    
background(128); 
  //background(255);
  lights();
  directionalLight(255, 255, 255, 0, -1.4142, 1.4142);
  camera.Update(1.0/frameRate);
  scene.Update(1.0/frameRate);
  scene.Draw();

  
  // only at the end of draw, generate fb
}


void keyPressed()
{
  camera.HandleKeyPressed();
  scene.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
  scene.HandleKeyReleased();
}

//----------------------------------------
// Loading
//----------------------------------------

// load
// throw to thread
void loadScene(){   
   ArrayList<String> objectNames = new ArrayList();
   ArrayList<String> textureNames = new ArrayList();
   PShape[] shapes =new PShape[objNames.length] ;
   PImage[] images = new PImage[imageNames.length];
   float total = imageNames.length+objNames.length;
   float loadedNum = 0.0;
   for(int i = 0; i < imageNames.length; i++){
       images[i] = loadImage(workingPath+File.separator + imageNames[i]); //What image to load, experiment with transparent images 
       noStroke();
       textureNames.add(tNames[i]);
       loadedNum ++;
       loading   =loadedNum/total ;
       
      // println(loading);
    //drawloading();    
   }
   for(int i = 0; i < objNames.length; i++){
     shapes[i] = loadShape(workingPath +File.separator+ objNames[i]);
     noStroke();
     objectNames.add(oNames[i]);
     loadedNum ++;
     loading = loadedNum/total;
     //println(loading);
     
   }
   camera = new Camera();
   scene = new Scene();
   scene.loadTextures(images,textureNames);
   scene.loadObjs(shapes,objectNames);
   loaded = true;
}

// draw loading screen
void drawLoadingScene(float k) {
  background(0); //Clear the background to black
  
  //We must first tell processing where to translate and rotate the image to, before we draw it
  //translate(width / 2 + 100 * cos(time), height / 2 + 100 * sin(time), -100); //TODO: Replace this with time-based integration!
  //rotateY(time);
  
  //We will draw the image on a quad (rectangle) made of 4 verticies

  beginShape();
  texture(icon);
  // vertex( x, y, z, u, v) where u and v are the texture coordinates in pixels
  vertex(width*0.25, height*0.25, 0, 0, 0);
  vertex(width*0.75, height*0.25, 0, icon.width, 0);
  vertex(width*0.75, height*0.75, 0, icon.width, icon.height);
  vertex(width*0.25, height*0.75, 0, 0, icon.height);
  endShape();
  
 
  beginShape();
  fill(100,100,100);
  noStroke();
  vertex(width * 0.25, height *0.8,0);
  vertex(width * 0.25,height *0.9,0);
  vertex(width * (0.25+0.5),height *0.9,0);
  vertex(width * (0.25+0.5),height * 0.8,0);
  endShape();
  
  

  beginShape();
    fill(237, 34, 93);
  noStroke();
  vertex(width * 0.25, height *0.8,0);
  vertex(width * 0.25,height *0.9,0);
  vertex(width * (0.25+0.5*k),height *0.9,0);
  vertex(width * (0.25+0.5*k),height * 0.8,0);
  endShape();

}
