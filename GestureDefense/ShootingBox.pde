class ShootingBox{
  int x,y,w,h;
  
  
  Gesture gestureArray[];
  int nGestures = 3;  // Number of gestures
  int minMove = 5;     // Minimum travel for a new point
  int currentGestureID;
  color shooting_color = color(255, 255, 245);
  boolean mousePressedInBox = false;

  ShootingBox(int x,int y,int w, int h) {
    
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    currentGestureID = -1;
    gestureArray = new Gesture[nGestures];
    for (int i = 0; i < nGestures; i++) {
      gestureArray[i] = new Gesture(width, height);
    }
    clearGestures();

  }
  
  void update(){
    updateGeometry();
    noStroke();
    fill(shooting_color);
    for (int i = 0; i < nGestures; i++) {
      renderGesture(gestureArray[i], width, height);
    }
    
    noFill();
    strokeWeight(10);
    stroke(255,0,0);
    rect(x-10,y-10,w+20,h+20);
  }
  
  void renderGesture(Gesture gesture, int w, int h) {
    if (gesture.exists) {
      if (gesture.nPolys > 0) {
        Polygon polygons[] = gesture.polygons;
        int crosses[] = gesture.crosses;
  
        int xpts[];
        int ypts[];
        Polygon p;
        int cr;
  
        beginShape(QUADS);
        int gnp = gesture.nPolys;
        for (int i=0; i<gnp; i++) {
  
          p = polygons[i];
          xpts = p.xpoints;
          ypts = p.ypoints;
  
          vertex(xpts[0], ypts[0]);
          vertex(xpts[1], ypts[1]);
          vertex(xpts[2], ypts[2]);
          vertex(xpts[3], ypts[3]);
  
          if ((cr = crosses[i]) > 0) {
            if ((cr & 3)>0) {
              vertex(xpts[0]+w, ypts[0]);
              vertex(xpts[1]+w, ypts[1]);
              vertex(xpts[2]+w, ypts[2]);
              vertex(xpts[3]+w, ypts[3]);
  
              vertex(xpts[0]-w, ypts[0]);
              vertex(xpts[1]-w, ypts[1]);
              vertex(xpts[2]-w, ypts[2]);
              vertex(xpts[3]-w, ypts[3]);
            }
            if ((cr & 12)>0) {
              vertex(xpts[0], ypts[0]+h);
              vertex(xpts[1], ypts[1]+h);
              vertex(xpts[2], ypts[2]+h);
              vertex(xpts[3], ypts[3]+h);
  
              vertex(xpts[0], ypts[0]-h);
              vertex(xpts[1], ypts[1]-h);
              vertex(xpts[2], ypts[2]-h);
              vertex(xpts[3], ypts[3]-h);
            }
  
            // I have knowingly retained the small flaw of not
            // completely dealing with the corner conditions
            // (the case in which both of the above are true).
          }
        }
        endShape();
      }
    }
  }

  
  
  void updateGeometry() {
    Gesture J;
    for (int g=0; g<nGestures; g++) {
      if ((J=gestureArray[g]).exists) {
        if (g!=currentGestureID) {
          advanceGesture(J);
        } else if (!mousePressed || !inBox(mouseX,mouseY) || !mousePressedInBox){
          advanceGesture(J);
        }
      }
    }
  }
  
  void advanceGesture(Gesture gesture) {
    // Move a Gesture one step
    if (gesture.exists) { // check
      int nPts = gesture.nPoints;
      int nPts1 = nPts-1;
      Vec3f path[];
      float jx = gesture.jumpDx;
      float jy = gesture.jumpDy;
  
      if (nPts > 0) {
        path = gesture.path;
        for (int i = nPts1; i > 0; i--) {
          path[i].x = path[i-1].x;
          path[i].y = path[i-1].y;
        }
        path[0].x = path[nPts1].x - jx;
        path[0].y = path[nPts1].y - jy;
        gesture.compile();
      }
    }
  }
  
  void clearGestures() {
    for (int i = 0; i < nGestures; i++) {
      gestureArray[i].clear();
    }
  }
  
  void mousePressed() {
    if(inBox(mouseX,mouseY))
    {
      mousePressedInBox = true;
      currentGestureID = (currentGestureID+1) % nGestures;
      Gesture G = gestureArray[currentGestureID];
      G.clear();
      G.clearPolys();
      G.addPoint(mouseX, mouseY);
    }
  }
  
  void mouseDragged() {
    if (currentGestureID >= 0 && inBox(mouseX,mouseY) && mousePressedInBox) {
      Gesture G = gestureArray[currentGestureID];
      if (G.distToLast(mouseX, mouseY) > minMove) {
        G.addPoint(mouseX, mouseY);
        G.smooth();
        G.compile();
      }
    }
  }
  
  void mouseReleased(){
    mousePressedInBox = false;
  }
  
  void keyPressed() {
    if (key == '+' || key == '=') {
      if (currentGestureID >= 0) {
        float th = gestureArray[currentGestureID].thickness;
        gestureArray[currentGestureID].thickness = min(96, th+1);
        gestureArray[currentGestureID].compile();
      }
    } else if (key == '-') {
      if (currentGestureID >= 0) {
        float th = gestureArray[currentGestureID].thickness;
        gestureArray[currentGestureID].thickness = max(2, th-1);
        gestureArray[currentGestureID].compile();
      }
    } else if (key == ' ') {
      clearGestures();
    }
  }
  
  boolean inBox(int x_pos,int y_pos)
  {
    if(x_pos > x && x_pos < x+w && y_pos > y && y_pos < y+h)
    {
      return true;
    }
    return false;
  }


}
