Table drinks;
void setup() {
  size(900, 800);
  drinks = loadTable("Drinks.csv", "header");
  println("Rows loaded: " + drinks.getRowCount());
  noLoop();
}

void draw() {
  background(145, 35, 30);

  // Colourful, overlapping brush marks
  int totalDrinks = 0;

  for (TableRow row : drinks.rows()) {
    for (int col = 2; col < drinks.getColumnCount(); col++) {
      if (drinks.getColumnTitle(col).equals("Total Drinks")) {
        break;
      }

      totalDrinks += row.getInt(col);
    }
  }

  println("Total drinks: " + totalDrinks);

  for (int i = 0; i < totalDrinks; i++) {
    float x = random(width);
    float y = random(height);
    float w = random(15, 90);
    float h = random(5, 30);

    fill(random(160, 255), random(40, 160), 20, 110);
    noStroke();

    pushMatrix();
    translate(x, y);
    rotate(random(TWO_PI));
    ellipse(0, 0, w, h);
    popMatrix();
  }

  // Main spiral
  noFill();
  stroke(25, 55, 65);
  strokeWeight(7);

  beginShape();

  for (float a = 0; a < 5 * TWO_PI; a += 0.05) {
    float r = 4 * a;
    float x = 330 + cos(a) * r + map(noise(a * 0.5), 0, 1, -12, 12);
    float y = 370 + sin(a) * r + map(noise(a * 0.5 + 100), 0, 1, -12, 12);

    vertex(x, y);
  }

  endShape();
}
