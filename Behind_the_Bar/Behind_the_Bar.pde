
import java.util.ArrayList;

Table drinks;
Table catalogue;

ArrayList<DrinkMark> marks = new ArrayList<DrinkMark>();
ArrayList<ShiftSpiral> spirals = new ArrayList<ShiftSpiral>();

DrinkMark hoveredDrink;
ShiftSpiral hoveredSpiral;

void setup() {
  size(900, 800);

  drinks = loadTable("Drinks.csv", "header");
  catalogue = loadTable("catalogue.csv", "header");

  randomSeed(86);
  noiseSeed(86);

  createArtwork();

  frameRate(60);
}

void draw() {
  background(145, 35, 30);

  hoveredDrink = null;
  hoveredSpiral = null;

  // Find hovered spiral
  for (int i = spirals.size() - 1; i >= 0; i--) {
    ShiftSpiral spiral = spirals.get(i);

    if (spiral.isHovered()) {
      hoveredSpiral = spiral;
      break;
    }
  }

  // Find hovered drink
  if (hoveredSpiral == null) {

    for (int i = marks.size() - 1; i >= 0; i--) {
      DrinkMark mark = marks.get(i);

      if (mark.isHovered()) {
        hoveredDrink = mark;
        break;
      }
    }
  }

  // Draw and animate drinks
  for (DrinkMark mark : marks) {

    if (mark == hoveredDrink) {
      mark.update();
    }

    mark.display();
  }

  // Draw and animate spirals
  for (ShiftSpiral spiral : spirals) {

    if (spiral == hoveredSpiral) {
      spiral.update();
    }

    spiral.display();
  }

  // Display information above the artwork
  if (hoveredDrink != null) {
    hoveredDrink.showTooltip();
  }

  if (hoveredSpiral != null) {
    hoveredSpiral.showTooltip();
  }
}


// CREATE OBJECTS FROM CSV DATA

void createArtwork() {

  int shiftCount = 0;

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

    // Create one object per individual drink
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

    // Create one spiral per shift
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


// DISPLAY TOOLTIP

void drawTooltip(String information) {

  pushStyle();

  textSize(13);
  textAlign(LEFT, TOP);

  String[] lines = split(information, '\n');

  float boxWidth = 0;

  for (String line : lines) {
    boxWidth = max(boxWidth, textWidth(line));
  }

  boxWidth += 24;

  float boxHeight = lines.length * 19 + 20;

  float boxX = constrain(mouseX + 15,
    5, max(5, width - boxWidth - 5));

  float boxY = constrain(mouseY + 15,
    5, max(5, height - boxHeight - 5));

  noStroke();
  fill(20, 230);

  rectMode(CORNER);
  rect(boxX, boxY, boxWidth, boxHeight, 6);

  fill(255);

  for (int i = 0; i < lines.length; i++) {
    text(lines[i], boxX + 12, boxY + 10 + i * 19);
  }

  popStyle();
}
