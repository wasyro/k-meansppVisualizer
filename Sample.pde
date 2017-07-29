class Sample {
  float x;
  float y;
  float diameter = 15;
  int cluster;
  float prob;
  boolean isCentroid;

  // constructor
  Sample(float _x, float _y) {
    x = _x;
    y = _y;
    prob = 0;
    isCentroid = false;
  }

  void show() {
    ellipseMode(CENTER);
    ellipse(x, y, diameter, diameter);
  }
}
