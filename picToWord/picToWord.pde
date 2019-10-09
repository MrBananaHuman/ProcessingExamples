PImage src;
int threshold = 250;
 
void setup(){
  // basic settings
  size(800, 600);
  textAlign(CENTER);
  background(255);
  fill(0);
 
  // load an image
  src = loadImage("image_crop.png");
  // resize
  src.resize(80, 60);
 
 
  // load piyels of source-image
  src.loadPixels();
 
  // iterate over image-pixels
  for(int i=0; i<src.pixels.length; i++ ){
    // get the color
    int col = src.pixels[i];
 
    // draw a word if pixels is darker than threshold
    if(brightness(col) < threshold){
      int x = i%src.width * 10;
      int y = i/src.width * 10 +10;
      text("s", x, y );
    }
  }
  src.updatePixels();
}

void draw(){
}
