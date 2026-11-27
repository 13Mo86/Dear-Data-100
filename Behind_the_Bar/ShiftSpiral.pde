
class ShiftSpiral {

  float x, y;
  float maxRadius;
  float chaos;

  float rotation = 0;
  float rotationSpeed;

  int total;
  int busyness;

  String date;

  ArrayList<PVector> points = new ArrayList<PVector>();

  // Constructor
  ShiftSpiral(float x, float y,
    int total, int busyness,
    float regionWidth,
    float regionHeight,
    String date) {

    this.x = x;
    this.y = y;

    this.total = total;
    this.busyness = busyness;
    this.date = date;

    // More drinks = larger spiral
    maxRadius = map(total, 0, 500, 5, 65);

    float radiusLimit =
      min(regionWidth, regionHeight) * 0.38;

    maxRadius = constrain(maxRadius, 5, radiusLimit);

    // Busier shifts = more irregular spirals
    chaos = map(busyness, 1, 5, 1, 12);

    // Busier shifts rotate faster
    rotationSpeed = map(busyness, 1, 5, 0.01, 0.08);

    createPoints();
  }


  // Calculate the spiral shape once
  void createPoints() {

    for (float a = 0; a < 5 * TWO_PI; a += 0.05) {

      float r = map(a, 0, 5 * TWO_PI,
        0, maxRadius);

      float px = cos(a) * r
        + map(noise(a * 0.5 + x),
        0, 1, -chaos, chaos);

      float py = sin(a) * r
        + map(noise(a * 0.5 + y),
        0, 1, -chaos, chaos);

      points.add(new PVector(px, py));
    }
  }


  // Draw the spiral
  void display() {

    noFill();

    stroke(25, 55, 65, 170);
    strokeWeight(2.5);

    pushMatrix();

    translate(x, y);
    rotate(rotation);

    beginShape();

    for (PVector point : points) {
      vertex(point.x, point.y);
    }

    endShape();

    popMatrix();
  }


  // Update rotation
  void update() {

    rotation = (rotation + rotationSpeed) % TWO_PI;
  }


  // Check whether the mouse is near the spiral
  boolean isHovered() {

    float dx = mouseX - x;
    float dy = mouseY - y;

    if (dist(mouseX, mouseY, x, y) >
      maxRadius + chaos * 2 + 4) {
      return false;
    }

    float localX = dx * cos(rotation)
      + dy * sin(rotation);

    float localY = -dx * sin(rotation)
      + dy * cos(rotation);

    for (PVector point : points) {

      if (dist(localX, localY, point.x, point.y) < 4) {
        return true;
      }
    }

    return false;
  }


  // Display shift information
  void showTooltip() {

    drawTooltip(
      "Shift: " + date
      + "\nTotal drinks: " + total
      + "\nBusyness: " + busyness + "/5"
      );
  }
}


// CATEGORY COLOURS

color categoryColour(String category) {

  if (category.equalsIgnoreCase("Cocktail")) {
    return color(235, 75, 30);
  } else if (category.equalsIgnoreCase("Wine")) {
    return color(110, 25, 65);
  } else if (category.equalsIgnoreCase("Beer")) {
    return color(245, 175, 35);
  } else if (category.equalsIgnoreCase("Mocktail")) {
    return color(65, 110, 85);
  } else if (category.equalsIgnoreCase("Soft Drink")) {
    return color(35, 65, 110);
  }

  return color(80, 80, 80);
}


// FIND DRINK CATEGORY

String findCategory(String drinkName) {

  for (TableRow row : catalogue.rows()) {

    if (row.getString(0).trim()
      .equalsIgnoreCase(drinkName.trim())) {

      return row.getString(1).trim();
    }
  }

  return "Unknown";
}
