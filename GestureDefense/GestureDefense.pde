/**
 * Yellowtail
 * by Golan Levin (www.flong.com).
 * 
 * Click, drag, and release to create a kinetic gesture.
 * 
 * Yellowtail (1998-2000) is an interactive software system for the gestural 
 * creation and performance of real-time abstract animation. Yellowtail repeats 
 * a user's strokes end-over-end, enabling simultaneous specification of a 
 * line's shape and quality of movement. Each line repeats according to its 
 * own period, producing an ever-changing and responsive display of lively, 
 * worm-like textures.
 */

ShootingBox box;

//Polygon tempP;
//int tmpXp[];
//int tmpYp[];

void setup() {
  frameRate(60);
  size(600,600,P2D);
  background(0, 0, 0);
  noStroke();
  
  box = new ShootingBox(250,400,100,100);

}

void draw() {
  background(0);
  box.update();

}

void mousePressed() {
  box.mousePressed();
}

void mouseDragged() {
  box.mouseDragged();
}

void mouseReleased() {
  box.mouseReleased();
}

void keyPressed() {
  box.keyPressed();
}
