color ELLIPSE_COLOR = color(0);
color LINE_COLOR = color(0, 100);
color PGRAPHICS_COLOR = color(0); 
int LINE_LENGTH = 25;
boolean reverseDrawing = true;

PGraphics pg;
PFont font;
ArrayList<OneChr> chrs = new ArrayList<OneChr>();

void setup() {
  size(1000, 1000, JAVA2D);
  background(200);
  smooth();
  //font = loadFont("Arial-BoldMT-48.vlw");
  //blendMode(ADD);
  
  // create and draw to PPraphics (see Getting Started > UsingPGraphics example)
  pg = createGraphics(width, height, JAVA2D);
  pg.beginDraw();
//  pg.textFont(font);
  pg.textSize(125);// was 200
  pg.textAlign(CENTER, CENTER);
  pg.fill(PGRAPHICS_COLOR);
  pg.text("Hello world!", pg.width/2, pg.height/2); 
  pg.endDraw();

}

void draw() {
  frameRate(1000);
  fill(255);
  stroke(0);
  textAlign(CENTER, CENTER);
 
  if(chrs.size() < 3000){
  for (int i=0; i<60; i++) {
    float x = random(width);
    float y = random(height);
    color c = pg.get( int(x), int(y) );
    if ( c == PGRAPHICS_COLOR ) {
      chrs.add( new OneChr(x,y,1) );      
    }
  }
  }
  for( OneChr oc: chrs){
    oc.updateMe();
  }
  
}

class OneChr {
  float x, y;
  float myRotate;
  float myBrightness, glowSpeed, glowOffs;
  int mySize;
  char myChr; 

  OneChr(float _x, float _y, float gS) {
    x = _x;
    y = _y;
    glowSpeed = gS;
    myBrightness = 0;
    glowOffs = random(40) * -1;

    int radi = floor(random(4));
    myRotate = ( HALF_PI * radi);
    float sizeFactor = random(2);
    mySize = ( int( max(5, (pow( sizeFactor , 2)))) ); 
    //was max 10, 1 allows for tiny characters //was sizeFactor 5, 10 allows huge letters
    myChr = char( int(random(33, 126)));
  }

  void updateMe() {
    noStroke();
    fill(100, max( myBrightness + glowOffs , 0));
    pushMatrix();
    translate(x, y);
    int radi = floor(random(4));
    rotate( myRotate );
    textSize( mySize );

    text( myChr, 0, 0);
    popMatrix();
    
    myBrightness += glowSpeed;
    myBrightness = min(myBrightness, (255+ (-1 * glowOffs)) );
  }
}
