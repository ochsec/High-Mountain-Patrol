color c1, c2, window;

void setup()
{
  size(24, 15);
  background(255, 0);
  c1 = color(#7FB7BE);
  c2 = color(#DACC3E);
  window = color(#D3F3EE);
  stroke(c1);
  fill(c1);
  rectMode(CORNER);
  rect(5, 3, 16, 7);
  rect(0, 3, 5, 5);
  rect(5, 0, 10, 3);
  rect(4, 1, 11, 2);
  stroke(window);
  fill(window);
  rect(9, 1, 5, 2);
  stroke(c2);
  fill(c2);
  ellipseMode(CORNER);
  ellipse(2, 5, 10, 10);
  ellipse(14, 5, 10, 10);
}