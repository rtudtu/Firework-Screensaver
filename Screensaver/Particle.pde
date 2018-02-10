/**
 * Class Particle which represents a single particle either pre-explosion
 * or particles post-explosion
 **/
class Particle {
  PVector acceleration;       //Particle acceleration
  PVector velocity;           //Particle velocity
  PVector location;           //Particle location

  float hue;                  //hue color of particle
  float alpha;                //Particle's fading time boolean seed = false;

  boolean initial = false;    //initial particle or not

  //Represents a particle pre explosion (an initial particle)
  Particle(float x, float y, float z, float hue) {
    this.hue = hue;

    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-fwAngle, fwAngle), random(-25, -10), random(-fwAngle, fwAngle));
    location =  new PVector(x, y, z);
    initial = true;
    alpha = 255.0;
  }

  //Represents a particle post explosion
  Particle(PVector loc, float hue, String shape) {
    this.hue = hue;
    acceleration = new PVector(0, 0);
    if (shape == "sphere") {
      velocity = PVector.random3D();
    } else if (shape == "cube") {
      velocity= new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    }
    velocity.mult(random(20, 50));
    location = loc.copy();
    alpha = random(155.0, 255.0);
  }

  //Add the force to acceleration to slow/speed up the particle
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  //Draw particle
  void drawPart() {
    updatePart();
    displayPart();
  }

  //Update particle location and velocity
  void updatePart() {
    velocity.add(acceleration);
    location.add(velocity);
    if (!initial) {
      alpha -= fireWorkLifeTime;
      velocity.mult(0.9);
    }
    acceleration.mult(0);
  }

  //Display particles
  void displayPart() {
    //particle draw properties
    stroke(hue, 255, 255, alpha);
    if (initial) {
      strokeWeight(10);
    } else {
      strokeWeight(7);
    }
    //temporarily translate to location
    pushMatrix();
    translate(location.x, location.y, location.z);
    point(0, 0);
    popMatrix();
    //ellipse(location.x, location.y, 12, 12); //Ellipse instead of point
  }
  
    //If initial particle has been exploded, return true
  boolean explode() {
    if (initial && velocity.y > 0) {
      alpha = 0;
      return true;
    }
    return false;
  }

  //Returns true if the particle is visually gone
  boolean isDead() {
    if (alpha < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}