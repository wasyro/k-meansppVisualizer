class Button {
  float x;
  float y;
  float w;
  float h;

  Button(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }

  boolean isMouseOnButton() {
    if (x <= mouseX && mouseX <= x + w
       && y <= mouseY && mouseY <= y + h) {
      return true;
    } else {
      return false;
    }
  }

  void show() {
    rect(x, y, w, h);
  }
}
