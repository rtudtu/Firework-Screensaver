/*******************************************************************************
 * Assignment 05: Screensaver         // Date: February 4, 2018
 * ARTG 2260: Programming Basics      // Instructor: Jose
 * Written By: Richard Tu             // Email: tu.r@husky.neu.edu
 * Title: 3D Fireworks!
 * Description: Processing program that will simulate fireworks in 3D!
 *              Fireworks are random colors, go to a set range in height, and
 *              will scale depending on the user's width/height (in fullscreen)
 *              too. The program also displays a 12 hour digital clock on
 *              the "floor".
 * Controls:
 * <UP>/<DOWN>/<LEFT>/<RIGHT>: Rotate the camera in the X and Y directions
 * <SPACE>: Reset the camera position
 * <s> or <S>: Save a screenshot into the \Screensaver folder (current directory)
 * <p> or <P>: Save a pdf into the \Screensaver folder (current directory)
 * <c>: Clears the board
 * <f>: Spawns fireworks - WARNING: Spawns as long as key is held - a lot
 * <g>: Grand finale (x3 as many fireworks)
 * NOTE: If the program is slow, lower "fireWorkFrequency" to lower firework count
 ******************************************************************************/
import processing.pdf.*;

color black = color(0);                    //Color: Black

PFont font;                                //font placeholder

ArrayList<Firework> fireworks;             //Arraylist of all Firework(s)
ArrayList<Sphere> spheres;                 //Arraylist of all Sphere(s)

PVector gravityVec = new PVector(0, 0.2);  //Strength of gravity 

String hour;                               //String for hour
String minute;                             //String for minute
String ampm;                               //"AM" or "PM"

float fireWorkFrequency = 0.1;              //% chance of firework spawning (out of 1)
float fireWorkLifeTime = 6;                //decrement of fireworks' lasting time
float sphereSizeLow = 10;                  //Lowest sphere size will be
float sphereSizeHigh = 30;                 //Highest sphere size will be  

int explosionParticles = 1000;             //# of particles after explosion
int rotateCountX = 0;                      //Rotate angle X
int rotateCountY = 0;                      //Rotate angle Y
int gKeyFrameCount = 0;                    //framecount for the 'g' key
int sKeyFrameCount = 0;                    //frameCount for the 's' key
int pKeyFrameCount = 0;                    //frameCount for the 'p' key
int inputDelay = 15;                       //input delay for user input
int fwAngle = 5;                           //variety in X and Z directions
int sphereBounce = 10;                     //How bouncy a sphere will be

boolean record;                            //To record or not for PDF
boolean grandFinale;                       //Display Grand Finale or not
boolean AM;                                //Toggle AM/PM

void setup() {
  fullScreen(P3D);
  //size(1000, 1000, P3D);  
  font = loadFont("DS-Digital-BoldItalic-100.vlw");
  textFont(font);
  fireworks = new ArrayList<Firework>();
  spheres = new ArrayList<Sphere>();
  colorMode(HSB);
  background(black);
}

void draw() {
  //start pdf recording if 'p' is pressed
  if (record) {
    beginRaw(PDF, "frame-####.pdf");
  }

  colorMode(RGB);
  pointLight(255, 255, 255, 0, 0, 0);
  colorMode(HSB);

  //Add a new firework depending on a random roll
  if (grandFinale) {
    if (random(1) < fireWorkFrequency * 3) {
      fireworks.add(new Firework());
    }
  } else {
    if (random(1) < fireWorkFrequency) {
      fireworks.add(new Firework());
    }
  }
  //Background color
  background(0, 25);
  translate(width/2, height/2, -1000);

  //Rotate screenY
  rotateY(rotateCountY * .004);

  //Rotate screenX
  rotateX(rotateCountX * .004);

  // Floor
  fill(120);
  if (grandFinale) {
    stroke(255, 255, 255);
  } else {
    stroke(255);
  }
  strokeWeight(1);
  beginShape();
  vertex(-width, height/2, -width);
  vertex(width, height/2, -width);
  vertex(width, height/2, width);
  vertex(-width, height/2, width);
  endShape(CLOSE);

  //Draw time
  AM = true;
  if (hour() > 0 && hour() < 10) {
    hour = "0" + hour();
  } else {
    if (hour() > 12 && hour() < 24) {
      hour = Integer.toString(hour() - 12);
      AM = false;
    } else if (hour() >= 10 && hour() <= 12) {
      hour = Integer.toString(hour());
    } else {
      hour = "12";
    }
  }
  if (minute() > 0 && minute() < 10) {
    minute = "0" + minute();
  } else {
    minute = Integer.toString(minute());
  }
  if (AM) {
    ampm = "AM";
  } else {
    ampm = "PM";
  }
  textSize(width / 2.6);
  fill(255, 255, 255);
  rotateX(PI/2);
  text(hour + ":" + minute + "" + ampm, -width/1.7, 0, (-height/2) + 5);
  rotateX(-PI/2);

  translate(0, 0, 0);

  //Draw fireworks  
  for (int i = fireworks.size()-1; i >= 0; i--) {
    Firework fw = fireworks.get(i);
    fw.drawFW();
    //If firework is "retired", remove it to save space
    if (fw.done()) {
      fireworks.remove(i);
    }
  }
  //Draw spheres  
  for (int j = spheres.size()-1; j >= 0; j--) {
    Sphere s = spheres.get(j);
    s.applyForce(gravityVec);
    //If sphere hits the floor, explode
    if (s.location.y > (height/2) - s.size && withinFloor(s.location)) {
      s.explode();
    }
    s.drawSphere();
    if (s.done() || s.location.y > height) {
      spheres.remove(j);
    }
  }
  println(spheres.size());

  //Stop recording if necessary
  if (record) {
    endRaw();
    record = false;
  }

  //Listen for key presses
  if (keyPressed) {
    //If UP/DOWN/RIGHT/LEFT are pressed, rotate screen
    if (keyCode == UP) {
      rotateCountX -= 10;
    }
    if (keyCode == DOWN) {
      rotateCountX += 10;
    }
    if (keyCode == RIGHT) {
      rotateCountY -= 10;
    }
    if (keyCode == LEFT) {
      rotateCountY += 10;
    }

    //If space is pressed, reset to default rotation
    if (key == ' ') {
      rotateCountY = 0;
      rotateCountX = 0;
    }

    //Clears the board
    if (key == 'c' || key == 'C') {
      fireworks.clear();
      spheres.clear();
    }

    //Toggle new firework
    if (key == 'f' || key == 'F') {
      fireworks.add(new Firework());
    }

    //Toggle Grand Finale
    if (key == 'g' || key == 'G') {
      if (frameCount > gKeyFrameCount + inputDelay) {
        if (grandFinale) {
          grandFinale = false;
        } else {
          grandFinale = true;
        }
      }
      gKeyFrameCount = frameCount;
    }

    //Save the frame to a file
    if (key == 's' || key == 'S') {
      if (frameCount > sKeyFrameCount + inputDelay) {
        saveFrame("Fireworks" + frameCount + ".png");
      }
      sKeyFrameCount = frameCount;
    }

    //Save the frame to a pdf
    if (key == 'p' || key == 'P') {
      if (frameCount > pKeyFrameCount + inputDelay) {
        record = true;
      }
      pKeyFrameCount = frameCount;
    }
  }
}

//returns true if vector is within the zone of the floor
boolean withinFloor(PVector vec) {
  if (vec.x > -width && vec.x < width && vec.z > -width && vec.z < width) {
    return true;
  } else {
    return false;
  }
}