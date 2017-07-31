class Centroid {
  float x;
  float y;
  float size = 15;
  int cluster;

  // constructor
  Centroid(float _x, float _y, int _cluster) {
    x = _x;
    y = _y;
    cluster = _cluster;
  }

  void moveTo(float xTarget, float yTarget) {
    float xVelocity = (xTarget - x) / 5.0;
    float yVelocity = (yTarget - y) / 5.0;
    
    x += xVelocity;
    y += yVelocity;
  }

  void show() {
    rectMode(CENTER);
    rect(x, y, size, size);
    rectMode(CORNER);
  }
}
