import de.voidplus.leapmotion.*;

LeapMotion leap;

ArrayList<MovingNode> nodes;
float maxDistance = 50;
float dx = 10;
float dy = 10;
float maxNeighbors = 10;
float backgroundColor = 180;

float glovalX = 0;
float glovalY = 0;

Boolean drawMode = true;

int finger_size = 0;

void setup()
{
  fullScreen();
  background(200);
  nodes = new ArrayList<MovingNode>();
  leap = new LeapMotion(this);
}
void draw()
{ 
  background(200);

  if(nodes.size() < 10){
      send(width/2, 0, 0, 0);
  }
  /*
  for(Hand hand : leap.getHands()){
    Finger finger = hand.getFrontFinger();
    PVector fingerPosition = finger.getPosition();
    finger_size = int(fingerPosition.z);
    fill(127);
    ellipse(fingerPosition.x, fingerPosition.y*1.2, finger_size, finger_size); 
    glovalX = fingerPosition.x;
    glovalY = fingerPosition.y;
    
  } 
  */
  glovalX = mouseX;
  glovalY = mouseY;
  finger_size = 20;
  ellipse(glovalX, glovalY, finger_size, finger_size); 
  
  for(int i=0; i<nodes.size(); i++)
  {
    MovingNode currentNode = nodes.get(i);
    currentNode.setNumNeighbors( countNumNeighbors(currentNode,maxDistance) );
  }
  
  for(int i=0; i<nodes.size(); i++)
  {
    MovingNode currentNode = nodes.get(i);
    if(currentNode.x > width || currentNode.x < 0 || currentNode.y > height)
    {
      nodes.remove(currentNode);
    }
  }
  
  for(int i = 0; i < nodes.size(); i++){
    MovingNode currentNode = nodes.get(i);
    for(int j=0; j<currentNode.neighbors.size(); j++)
    {
      MovingNode neighborNode = currentNode.neighbors.get(j);
      float lineColor = currentNode.calculateLineColor(neighborNode,maxDistance);
      stroke(lineColor, lineColor, lineColor);
      line(currentNode.x,currentNode.y,neighborNode.x,neighborNode.y);
    }
    currentNode.display();
  }
  
  
  
  
}

void addNewNode(float xPos, float yPos, float dx, float dy)
{

  MovingNode node = new MovingNode(xPos+dx,yPos+dy);
  
  node.setNumNeighbors( countNumNeighbors(node,maxDistance) );
  
  if(node.numNeighbors < maxNeighbors){
    nodes.add(node);
  }
}

void rectInitialImage(){
  for(int i = width/2-150; i < width/2+150; i+=25){
      for(int j = -300; j < 0; j+=25){
          addNewNode(i,j, 0, 0);
      }
    }
}

void circleInitialImage(float posX, float posY, float velX, float velY){
  float radius=150;
  int numPoints=130;
  float angle=TWO_PI/(float)numPoints;
  for(int i=0;i<numPoints;i++){
    addNewNode(posX + radius*sin(angle*i) + random(-30, 30), radius*cos(angle*i) - 220 + random(-30, 30), 0, 0);
  } 
}

int countNumNeighbors(MovingNode nodeA, float maxNeighborDistance)
{
  int numNeighbors = 0;
  nodeA.clearNeighbors();
  
  for(int i = 0; i < nodes.size(); i++)
  {
    MovingNode nodeB = nodes.get(i);
    float distance = sqrt((nodeA.x-nodeB.x)*(nodeA.x-nodeB.x) + (nodeA.y-nodeB.y)*(nodeA.y-nodeB.y));
    if(distance < maxNeighborDistance)
    {
      numNeighbors++;
      nodeA.addNeighbor(nodeB);
    }
  }
  return numNeighbors;
}

boolean isInnerMouse(float posx, float posy, int boundary){
  if(posx > glovalX - boundary && posx < glovalX + boundary){
    if(posy > glovalY - boundary && posy < glovalY + boundary){
      return true;
    }
  }
  return false;
}

void receive(String msg){
  
  String[] data = split(msg, ",");
  
  if(data.length>=5 && parseInt(data[0]) == 0 ){
    circleInitialImage(float(data[1]), float(data[2]), float(data[3]), float(data[4]));
  }
  
}

void send(float posX, float posY, float velX, float velY){
  String msg = 0 + "," + posX + "," + ( posY>=height?0:height ) + "," + velX + "," + velY;
  receive(msg);
}
class MovingNode
{
  float x;
  float y;
  int numNeighbors;
  ArrayList<MovingNode> neighbors;
  float lineColor;
  float nodeWidth = 3;
  float nodeHeight = 3;
  float fillColor = 50;
  float lineColorRange = 180;
  
  float xVel=0;
  public float yVel=0;
  float xAccel=0;
  float yAccel=0;
  
  float accelValue = 0.02;

  MovingNode(float xPos, float yPos)
  {
    x = xPos;
    y = yPos;
    numNeighbors = 0;
    neighbors = new ArrayList<MovingNode>();
  }
  
  void display()
  {
    move();
    
    noStroke();
    fill(fillColor);
    ellipse(x,y,nodeWidth,nodeHeight);
  }
  
  void move()
  {
    if(isInnerMouse(x, y, finger_size)) {
      xAccel = random(-1,1);
      yAccel = random(-1,1);
    } else {
      xAccel = 0;
      yAccel = random(0,accelValue);
    }
    
    xVel += xAccel;
    yVel += yAccel;
    
    x += xVel;
    y += yVel;
  }
  
  void addNeighbor(MovingNode node)
  {
    neighbors.add(node);
  }
  
  void setNumNeighbors(int num)
  {
    numNeighbors = num;
  }
  
  void clearNeighbors()
  {
    neighbors = new ArrayList<MovingNode>();
  }
  
  float calculateLineColor(MovingNode neighborNode, float maxDistance)
  {
    float distance = sqrt((x-neighborNode.x)*(x-neighborNode.x) + (y-neighborNode.y)*(y-neighborNode.y));
    lineColor = (distance/maxDistance)*lineColorRange;
    return lineColor;
  }
    
}
class Node
{
  float x;
  float y;
  int numNeighbors;
  ArrayList<Node> neighbors;
  float lineColor;
  float nodeWidth = 3;
  float nodeHeight = 3;
  float fillColor = 50;
  float lineColorRange = 100; //160

  Node(float xPos, float yPos)
  {
    x = xPos;
    y = yPos;
    numNeighbors = 0;
    neighbors = new ArrayList<Node>();
  }
  
  void display()
  {
    noStroke();
    fill(fillColor);
    ellipse(x,y,nodeWidth,nodeHeight);
  }
  
  void addNeighbor(Node node)
  {
    neighbors.add(node);
  }
  
  void setNumNeighbors(int num)
  {
    numNeighbors = num;
  }
  
  void clearNeighbors()
  {
    neighbors = new ArrayList<Node>();
  }
  
  float calculateLineColor(Node neighborNode, float maxDistance)
  {
    float distance = sqrt((x-neighborNode.x)*(x-neighborNode.x) + (y-neighborNode.y)*(y-neighborNode.y));
    lineColor = (distance/maxDistance)*lineColorRange;
    return lineColor;
  }
    
}
