# CSCI 5611 Project 1
 Agents Collision in 3D Enviroment

# Video

# List of Features 
## Part 2
* Single Agent Navigation
* 3D Rendering and Camera
* Improved Agent & Scene Rendering
* Orientation Smoothing
* Multiple Agents Planning+
## Part 3
* Crowd Simulation
## Others
* Loading Screen


# Art Contest



# User Guide
Press 'r' to reset the scene

Press 'm' to change the render mode.

* mode 0 - only render the direction from agent current location to goal
* mode 1 - add the path of agent
* mode 2 - add the collider of obstacles and agents

Arrow Keys can rotate the camera along x axis (Left and Right) and y axis (Up and down)

Press 'w' and 's' move camera front and back

Press 'a' and 'd' move camera left and right

Press 'q' and 'e' move camera top and down

Press '=' to add agent (maximum number for agent on the scene is 20)

Press '-' to take away agent from scene

# Discription of Features and Timestamp
## Single Agent Navigation
**Timestamp:**

Agent (i.e. tank) is implimented with path finding and it can short-cut its path while it is moving to the goal. 

Once the agent reachs its goal, it will altomatically generate a new goal and navigate to it.

It also has the **_orientation smoothing_** function, which allows it to turn smoothly. (Angular velocity is 180 degree per second)


## 3D Rendering & Camera
**Timestamp:**

Camera can rotate along its x axis and y axis and it can translate based on its x axis, y axis and z axis.


## Models and Textures - Improved Agent & Scene Rendering
**windmills** - stands for the obstacles with larger radius

**silos** - stands for the obstacles with smaller radius

**tanks** - stands for the agents

*Models coming from https://quaternius.com/index.html*

**Desert-Bush** - floor texture

*Texture coming from https://assetstore.unity.com/packages/2d/textures-materials/glovergames-free-ground-textures-135418*






## Multi Agent Planning and Crowd Simulation
**Timestamp:** 
Simulation is generated on the random generated scene. Press '=' to add agents and press '-' to take agents away.
Whenever a agent(i.e. tank) reaches its current goal, it will altomatically generate a new goal on the scene and navigate itself to the new goal.


# Difficulties Encontered
* Shader program is hard to impliment in this project, so I finally gave up.
* The insertion point (i.e. cursor) of the editor is not in its position for Processing 4.0b1. I will try the lower vesion in the next project.


