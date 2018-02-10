/**
 * Class Sphere which represents a single sphere post-explosion of a Firework
 **/
class Sphere {
  PVector acceleration;       //Sphere acceleration
  PVector velocity;           //Sphere velocity
  PVector location;           //Sphere location

  ArrayList<Particle> particles;    //Arraylist of particles

  float hue;                  //hue color of sphere
  float size;                 //size of sphere

  boolean drawSphere = true;

  //Represents a sphere post explosion
  Sphere(PVector loc, PVector vel, float hue, float size) {
    this.hue = hue;
    acceleration = new PVector(0, 0);
    velocity= vel.copy();
    location = loc.copy();
    this.size = size;
    particles = new ArrayList<Particle>();
  }

  //Add the force to acceleration to slow/speed up the sphere
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  //Draw Sphere
  void drawSphere() {
    updateSphere();
    displaySphere();
  }

  //Update Sphere location and velocity
  void updateSphere() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  //Display Sphere
  void displaySphere() {
    if (drawSphere) {
      fill(this.hue, 255, 255, 255);
      stroke(this.hue, 255, 255, 255);
      strokeWeight(this.size);
      //temporarily translate to location
      pushMatrix();
      translate(location.x, location.y, location.z);
      //sphere(this.size);
      point(0, 0);
      popMatrix();
    } else {
      location.y = 0;
    }

    for (int i = particles.size() - 1; i >=0; i--) {
      Particle part = particles.get(i);
      part.applyForce(gravityVec);
      part.drawPart();
      if (part.isDead()) {
        particles.remove(i);
      }
    }
  }

  //explode Sphere
  void explode() {
    for (int i = 0; i < this.size * 15; i++) {
      particles.add(new Particle(this.location, this.hue, "sphere"));    // Add "num" amount of particles to the arraylist
    }
    drawSphere = false;
  }

  //If sphere is done, return true
  boolean done() {
    if (!drawSphere && particles.size() < 1) {
      return true;
    } else { 
      return false;
    }
  }
}