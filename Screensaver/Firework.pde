/**
 * Class Firework to represent a single or group of particles depending on
 * state of firework (pre-explosion/post-explosion)
 **/
class Firework {

  ArrayList<Particle> particles;    //Arraylist of all particles for every firework
  Particle firework;                //firework particle
  float hue;                        //hue color of particle
  String shape;                     //shape of explosion

  Firework() {
    hue = random(255);
    firework = new Particle(random(-width, width), height/2, random(-width, width), hue);
    particles = new ArrayList<Particle>();   // Initialize the arraylist
  }

  //Run the Firework
  void drawFW() {
    if (firework != null) {
      fill(hue, 255, 255);
      firework.applyForce(gravityVec);
      firework.updatePart();
      firework.displayPart();

      if (firework.explode()) {
        firework.initial = false;
        if (random(1) > .5) {
          shape = "sphere";
        } else {
          shape = "sphere";
        }
        for (int i = 0; i < explosionParticles; i++) {
          particles.add(new Particle(firework.location, hue, shape));    // Add "num" amount of particles to the arraylist
        }
        spheres.add(new Sphere(firework.location, firework.velocity, firework.hue, random(10, 50)));
        firework = null;
      }
    } 
    //draw particles
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle part = particles.get(i);
      part.applyForce(gravityVec);
      part.drawPart();
      if (part.isDead()) {
        particles.remove(i);
      }
    }
  }

  //If Firework exploded - initial particle reached highest point, return true, else false
  boolean done() {
    if (firework == null && particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

  //If Firework is dead (when no particles left), return true, else false
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }
}