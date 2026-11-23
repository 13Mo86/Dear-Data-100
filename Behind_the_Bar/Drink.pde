class DrinkMark {

  float x, y;
  float w, h;
  float rotation;

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
}
