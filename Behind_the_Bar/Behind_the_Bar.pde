
Table drinks;
Table catalogue;

int preferredColumns = 5;

void setup() {
  size(900, 800);

  drinks = loadTable("Drinks.csv", "header");
  catalogue = loadTable("catalogue.csv", "header");

  println("Catalogue entries: " + catalogue.getRowCount());
  println("Rows loaded: " + drinks.getRowCount());
  println("Aperol Spritz category: " + findCategory("Aperol Spritz"));

  noLoop();
}

void draw() {
  background(145, 35, 30);
  randomSeed(86);

  // Count completed shifts
  int shiftCount = 0;

  for (TableRow row : drinks.rows()) {
    println("CSV row: " + row.getString(0)
      + " | Total: " + row.getInt("Total Drinks"));
    String date = row.getString(0);

    if (date != null && !date.trim().isEmpty()
      && row.getInt("Total Drinks") > 0) {
      shiftCount++;
    }
  }

  // Automatically calculate the grid
  int columns = max(1, ceil(sqrt(shiftCount)));
  int rows = max(1, ceil((float) shiftCount / columns));

  float regionWidth = width / (float) columns;
  float regionHeight = height / (float) rows;

  println("Completed shifts: " + shiftCount);
  println("Grid: " + columns + " columns, " + rows + " rows");

  // Draw individual drinks
  int totalDrinks = 0;
  int shiftIndex = 0;

  for (TableRow row : drinks.rows()) {

    // Skip empty shifts
    if (row.getInt("Total Drinks") <= 0) {
      continue;
    }

    int busyness = constrain(row.getInt(1), 1, 5);

    println("Shift " + (shiftIndex + 1) + " busyness: " + busyness);

    // Calculate this shift's position
    int column = shiftIndex % columns;
    int line = shiftIndex / columns;

    float regionX = column * regionWidth;
    float regionY = line * regionHeight;

    // Go through each drink type
    for (int col = 2; col < drinks.getColumnCount(); col++) {

      String drinkName = drinks.getColumnTitle(col);

      if (drinkName.equals("Total Drinks")) {
        break;
      }

      int quantity = row.getInt(col);

      if (quantity > 0) {

        String category = findCategory(drinkName);
        color drinkColour = categoryColour(category);

        // Draw one brushstroke for every drink sold
        for (int i = 0; i < quantity; i++) {

          float x = regionX + random(regionWidth);
          float y = regionY + random(regionHeight);

          // Scale brushstrokes to fit the grid
          float scale = min(
            regionWidth / 180.0,
            regionHeight / 400.0
            );

          // Busier shifts produce larger brushstrokes
          float maxWidth = map(busyness, 1, 5, 40, 120) * scale;
          float maxHeight = map(busyness, 1, 5, 10, 45) * scale;

          float w = random(15 * scale, maxWidth);
          float h = random(5 * scale, maxHeight);

          // Busier shifts have more varied rotations
          float rotationRange = map(
            busyness, 1, 5, 0.2, TWO_PI
            );

          fill(drinkColour, 150);
          noStroke();

          pushMatrix();
          translate(x, y);
          rotate(random(-rotationRange / 2, rotationRange / 2));
          ellipse(0, 0, w, h);
          popMatrix();

          totalDrinks++;
        }
      }
    }

    shiftIndex++;
  }

  println("Total drinks: " + totalDrinks);

  // Main spiral
  noFill();
  stroke(25, 55, 65);
  strokeWeight(7);

  beginShape();

  for (float a = 0; a < 5 * TWO_PI; a += 0.05) {

    float r = 4 * a;

    float x = 330 + cos(a) * r
      + map(noise(a * 0.5), 0, 1, -12, 12);

    float y = 370 + sin(a) * r
      + map(noise(a * 0.5 + 100), 0, 1, -12, 12);

    vertex(x, y);
  }

  endShape();
}

// Assign colours to drink categories
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

// Find the category of a drink
String findCategory(String drinkName) {

  for (TableRow row : catalogue.rows()) {

    if (row.getString(0).trim().equalsIgnoreCase(drinkName.trim())) {
      return row.getString(1).trim();
    }
  }

  return "Unknown";
}
