import processing.pdf.*; 

void setup() {
  size(900, 850);
  background(255);
  noLoop();
  beginRecord(PDF, "Venn_Diagram_statistics.pdf"); 
}

void draw() {
  int transparency = 100;
  
  // Both Emergence
  int d1 = 430;
  fill(255, 255, 0, transparency);  // fill(R, G, B, transparency);
  ellipse(310, 300, d1, d1);
  
  // Both Convergence
  int d2 = 380;
  fill(255, 0, 0, transparency); 
  ellipse(620, 300, d2, d2);
  
  // Both Local Coalescense
  int d3 = 320;
  fill(0, 0, 255, transparency); 
  ellipse(500, 590, d3, d3); 
  
  // Add text
  fill(0);
  // Create the font which exists in the computer
  PFont f = createFont("Franklin Gothic Heavy", 1, true);
  
  // =================================================================
  f = createFont("Arial Black", 1, true);
  // Load the font or it cannot be functional. The second parameter is the font size.
  textFont(f, 25);
  fill(0, 255, 0);
  text("one of polarities", 200, 40);
  text("emerging (52)", 235, 70); //Total A
  
  fill(255, 0, 0);
  text("one of polarities", 520, 70);
  text("converging (28)", 540, 100); //Total B
  
  fill(0, 0, 255);
  text("one of polarities", 380, 780);
  text("locally coalescent (14)", 360, 810); //Total C
    
  // ==================================================================
  fill(0);
  text("both the polarities", 150, 280);
  text("emerging (35)", 180, 310); //AA
 
  text("both the polarities", 540, 280);
  text("converging (5)", 560, 310); //BB
   
  text("both the polarities", 380, 590);
  text("locally", 440, 620);
  text("coalescent (6)", 400, 650); //CC
  
  // ==================================================================
  fill(0, 0, 255);  // B
  text("16", 460, 300); //AB
  
  fill(0, 255, 0);  // G
  text("1", 410, 480); //AC
  
  fill(255, 255, 0); // Y
  text("7", 550, 470); //BC
  
  endRecord();
}
