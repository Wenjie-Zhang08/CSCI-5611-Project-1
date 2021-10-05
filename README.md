# CSCI 5611 Project 1
 Agents Collision in 3D Enviroment

# Video
Uploaded in this repository, Proj1.mp4

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
![ART](https://user-images.githubusercontent.com/81786534/135957016-ec2ebdc2-0712-4fe6-86d0-4bcc921edc29.png)

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
**Timestamp:** 00:00-01:05

Agent (i.e. tank) is implimented with path finding and it can short-cut its path while it is moving to the goal. 

Once the agent reachs its goal, it will altomatically generate a new goal and navigate to it.

It also has the **_orientation smoothing_** function, which allows it to turn smoothly. (Angular velocity is 180 degree per second)

![debugModeSingleAgent](https://user-images.githubusercontent.com/81786534/135963001-b2213382-bb4e-42a4-aa9b-41fe1fcb4a84.png)



## 3D Rendering & Camera
**Timestamp:** 01:05-02:05

Camera can rotate along its x axis and y axis and it can translate based on its x axis, y axis and z axis.

![Camera0](https://user-images.githubusercontent.com/81786534/135963321-ebde8966-b14f-4c16-9b08-b0bdbf8755cc.jpg)

![Camera1](https://user-images.githubusercontent.com/81786534/135963326-aa022115-8415-4649-98b5-3b612c15581c.jpg)

## Models and Textures - Improved Agent & Scene Rendering
**windmills** - stands for the obstacles with larger radius

**silos** - stands for the obstacles with smaller radius

**tanks** - stands for the agents

*Models come from https://quaternius.com/index.html*

**Desert-Bush** - floor texture

*Texture comes from https://assetstore.unity.com/packages/2d/textures-materials/glovergames-free-ground-textures-135418*



## Multi Agent Planning and Crowd Simulation
**Timestamp:** 2:05-4:05

Simulation is generated on the random generated scene. Press '=' to add agents and press '-' to take agents away.
Whenever a agent(i.e. tank) reaches its current goal, it will altomatically generate a new goal on the scene and navigate itself to the new goal.

![multiagents](https://user-images.githubusercontent.com/81786534/135963202-4cfab0f0-a52c-4c94-ad32-bdd56e5d153d.jpg)

# Difficulties Encontered
* Shader program is hard to impliment in this project, so I finally gave up.
* The insertion point (i.e. cursor) of the editor is not in its position for Processing 4.0b1. I will try the lower vesion in the next project.


