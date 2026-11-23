import java.util.ArrayList;

Table drinks;
Table catalogue;

ArrayList<DrinkMark> marks = new ArrayList<DrinkMark>();
ArrayList<ShiftSpiral> spirals = new ArrayList<ShiftSpiral>();

void setup() {
  size(900, 800);

  drinks = loadTable("Drinks.csv", "header");
  catalogue = loadTable("catalogue.csv", "header");

  randomSeed(86);
  noiseSeed(86);

  createArtwork();

  noLoop();
}

void draw() {
  background(145, 35, 30);

  // Draw every individual drink
  for (DrinkMark mark : marks) {
    mark.display();
  }

  // Draw every shift spiral
  for (ShiftSpiral spiral : spirals) {
    spiral.display();
  }
}


// CREATE OBJECTS FROM CSV DATA

void createArtwork() {

  int shiftCount = 0;

  // Count completed shifts
  for (TableRow row : drinks.rows()) {

    String date = row.getString(0);

    if (date != null &&
      !date.trim().isEmpty() &&
      row.getInt("Total Drinks") > 0) {
      shiftCount++;
    }
  }

  int columns = max(1, ceil(sqrt(shiftCount)));
  int rows = max(1, ceil((float)shiftCount / columns));

  float regionWidth = width / (float)columns;
  float regionHeight = height / (float)rows;

  int shiftIndex = 0;
  int totalDrinks = 0;

  for (TableRow row : drinks.rows()) {

    String date = row.getString(0);
    int shiftTotal = row.getInt("Total Drinks");

    // Ignore empty rows and Excel totals
    if (date == null ||
      date.trim().isEmpty() ||
      shiftTotal <= 0) {
      continue;
    }

    int busyness = constrain(row.getInt(1), 1, 5);

    int column = shiftIndex % columns;
    int line = shiftIndex / columns;

    float regionX = column * regionWidth;
    float regionY = line * regionHeight;

    float scale = min(regionWidth / 180.0,
      regionHeight / 400.0);

    // Create one DrinkMark per drink sold
    for (int col = 2; col < drinks.getColumnCount(); col++) {

      String drinkName = drinks.getColumnTitle(col);

      if (drinkName.equals("Total Drinks")) {
        break;
      }

      int quantity = row.getInt(col);

      if (quantity <= 0) {
        continue;
      }

      String category = findCategory(drinkName);
      color drinkColour = categoryColour(category);

      for (int i = 0; i < quantity; i++) {

        float x = regionX + random(regionWidth);
        float y = regionY + random(regionHeight);

        float maxWidth = map(busyness, 1, 5, 40, 120) * scale;
        float maxHeight = map(busyness, 1, 5, 10, 45) * scale;

        float w = random(15 * scale, maxWidth);
        float h = random(5 * scale, maxHeight);

        float rotationRange = map(busyness, 1, 5,
          0.2, TWO_PI);

        float rotation = random(-rotationRange / 2,
          rotationRange / 2);

        DrinkMark mark = new DrinkMark(
          x, y, w, h, rotation,
          drinkColour, drinkName,
          category, date, busyness
          );

        marks.add(mark);
        totalDrinks++;
      }
    }

    // Create one spiral for each shift
    float spiralX = regionX + regionWidth / 2;
    float spiralY = regionY + regionHeight / 2;

    ShiftSpiral spiral = new ShiftSpiral(
      spiralX, spiralY, shiftTotal,
      busyness, regionWidth,
      regionHeight, date
      );

    spirals.add(spiral);

    println("Shift " + (shiftIndex + 1)
      + " | Date: " + date
      + " | Busyness: " + busyness
      + " | Drinks: " + shiftTotal);

    shiftIndex++;
  }

  println("Completed shifts: " + shiftCount);
  println("Total drinks drawn: " + totalDrinks);
}
