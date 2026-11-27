
class DrinkMark {

  float x, y;
  float w, h;
  float rotation;
  float rotationSpeed;

  color drinkColour;

  String name;
  String category;
  String date;

  int busyness;

  // Constructor
  DrinkMark(float x, float y,
    float w, float h,
    float rotation,
    color drinkColour,
    String name,
    String category,
    String date,
    int busyness) {

    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.rotation = rotation;

    this.drinkColour = drinkColour;

    this.name = name;
    this.category = category;
    this.date = date;
    this.busyness = busyness;

    // Busier shifts rotate faster
    rotationSpeed = map(busyness, 1, 5, 0.01, 0.08);
  }


  // Draw the oval
  void display() {

    fill(drinkColour, 150);
    noStroke();

    pushMatrix();

    translate(x, y);
    rotate(rotation);

    ellipse(0, 0, w, h);

    popMatrix();
  }


  // Update rotation
  void update() {

    rotation = (rotation + rotationSpeed) % TWO_PI;
  }


  // Check whether the mouse is over the oval
  boolean isHovered() {

    float dx = mouseX - x;
    float dy = mouseY - y;

    float localX = dx * cos(rotation)
      + dy * sin(rotation);

    float localY = -dx * sin(rotation)
      + dy * cos(rotation);

    float radiusX = w / 2;
    float radiusY = h / 2;

    return sq(localX / radiusX)
      + sq(localY / radiusY) <= 1;
  }


  // Display drink information
  void showTooltip() {

    drawTooltip(
      "Drink: " + name
      + "\nCategory: " + category
      + "\nDate: " + date
      + "\nBusyness: " + busyness + "/5"
      );
  }
}
