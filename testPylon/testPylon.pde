void setup(){
  frameRate(20);
  size(1000, 1000, P3D);
}

void drawLine(PVector start, PVector end){
    fill(0); // Couleur du pylône
    stroke(0); // Couleur de la bordure
    strokeWeight(5); // Épaisseur de la bordure
    int height_ = 70;
    int size = 10;
    float distance = start.dist(end);
    float bendingIntensity = distance / 300; //Valeur arbitraire
    PVector lastPoint = start;
    float incrementer = distance / 40;
    PVector direction = end.sub(start).normalize().mult(incrementer);
    beginShape(LINES);
    for(float i = 0; i < distance; i += incrementer){
      PVector nextPoint = lastPoint.copy().add(direction);
      nextPoint.y += cos(i/distance * PI) * bendingIntensity;
      vertex(lastPoint.x + 3 * size, lastPoint.y - height_, lastPoint.z - size/2);
      vertex(nextPoint.x + 3 * size, nextPoint.y - height_, nextPoint.z - size/2);
      
      vertex(lastPoint.x - 3 * size, lastPoint.y - height_, lastPoint.z - size/2);
      vertex(nextPoint.x - 3 * size, nextPoint.y - height_, nextPoint.z - size/2);
      lastPoint = nextPoint.copy();
    }
    
    endShape();
}


PShape createPylone(){ //Code dégueux 
  int start = -10/2;
  int size = 10;
  int height_ = 70;
  PShape pylone = createShape();
  pylone.beginShape(LINES);
  pylone.fill(75); // Couleur du pylône
  pylone.stroke(75); // Couleur de la bordure
  pylone.strokeWeight(8); // Épaisseur de la bordure
  //Support steel beam
  pylone.vertex(start, 0, 0);
  pylone.vertex(start, - height_, 0);
  
  pylone.vertex(start + size, 0, 0);
  pylone.vertex(start + size, - height_, 0);
  
  pylone.vertex(start + size, 0, -size);
  pylone.vertex(start + size, - height_, -size);
  
  pylone.vertex(start , 0, -size);
  pylone.vertex(start , - height_, -size);
  
  for(int i = 0; i < height_ ; i += 5){ //Severe mental damage
    pylone.vertex(start, -i, 0);
    pylone.vertex(start + size, -i - 5, 0);
    pylone.vertex(start, -i - 5, 0);
    pylone.vertex(start + size, -i, 0);
    
    pylone.vertex(start + size, -i, 0);
    pylone.vertex(start + size, -i - 5, -size);
    pylone.vertex(start + size, -i - 5, 0);
    pylone.vertex(start + size, -i, -size);
    
    pylone.vertex(start, -i, 0);
    pylone.vertex(start, -i - 5, -size);
    pylone.vertex(start, -i - 5, 0);
    pylone.vertex(start, -i, -size);
    
    pylone.vertex(start, -i, -size);
    pylone.vertex(start + size, -i - 5, -size);
    pylone.vertex(start, -i - 5, -size);
    pylone.vertex(start + size, -i, -size);
  }
  
  //La partie haute du pylone
  pylone.vertex(start, -height_, 0);
  pylone.vertex(0, -height_ - 5, -size/2);
  
  pylone.vertex(start, -height_, -size);
  pylone.vertex(0, -height_ - 5, -size/2);
  
  pylone.vertex(start + size, -height_, 0);
  pylone.vertex(0, -height_ - 5, -size/2);
  
  pylone.vertex(start + size, -height_, -size);
  pylone.vertex(0, -height_ - 5, -size/2);
  
  pylone.vertex(start, -height_, 0);
  pylone.vertex(start, -height_, -size);
  
  pylone.vertex(start + size, -height_, 0);
  pylone.vertex(start + size, -height_, -size);
  
  pylone.vertex(start, -height_, -size);
  pylone.vertex(start + size, -height_, -size);
  
  pylone.vertex(start + size, -height_, 0);
  pylone.vertex(start, -height_, 0);
  
  //Les "bras"
  pylone.vertex(start, -height_, 0);
  pylone.vertex(start - size * 3, -height_, -size/2);
  pylone.vertex(start, -height_, -size);
  pylone.vertex(start - size * 3, -height_, -size/2);
  
  pylone.vertex(start, -height_ + 5, 0);
  pylone.vertex(start - size * 3, -height_, -size/2);
  pylone.vertex(start, -height_ + 5, -size);
  pylone.vertex(start - size * 3, -height_, -size/2);
  
  pylone.vertex(start + size, -height_, 0);
  pylone.vertex(start + 4 * size, -height_, -size/2);
  pylone.vertex(start + size, -height_, -size);
  pylone.vertex(start + 4 * size, -height_, -size/2);
  
  pylone.vertex(start + size, -height_ + 5, 0);
  pylone.vertex(start + 4 * size, -height_, -size/2);
  pylone.vertex(start + size, -height_ + 5, -size);
  pylone.vertex(start + 4 * size, -height_, -size/2);
  
  
  
  
  pylone.endShape();
  return pylone;

}



static int WIDTH_ = 1000; 
static int HEIGHT_ = 1000; 
static PVector coordinate = new PVector(WIDTH_/2, HEIGHT_/2, 0);

static final int speed = 10; 
static final int cameraRadius = 5; 
static final float mouseSensitivity = PI/30.0; 
static PVector eyeAngle = new PVector(PI/2, 0); // x|z , z|y 
static PVector eyeVector = new PVector(coordinate.x, coordinate.y, coordinate.z).normalize();
static PVector lastMousePosition = new PVector(0, 0);
static PVector mousePosition = new PVector(0, 0);

void eyeUpdate(){
  mousePosition = new PVector(mouseX, mouseY);
  if(abs(mousePosition.x - lastMousePosition.x) < 0.5 && abs(mousePosition.y - lastMousePosition.y) < 0.5 && abs(mousePosition.y - lastMousePosition.y) < 0.5){
    return;
  }
  
  PVector mouseAcceleration = new PVector(mousePosition.x - lastMousePosition.x, mousePosition.y - lastMousePosition.y).normalize();
  lastMousePosition = mousePosition.copy();

  if(!mousePressed) return;
  eyeAngle.x += mouseAcceleration.x * mouseSensitivity; 
  eyeAngle.y += mouseAcceleration.y * mouseSensitivity;
  if(eyeAngle.y > PI/2) eyeAngle.y = PI/2; //Empêche l'utilisateur de se désorienter.
  else if(eyeAngle.y < -PI/2) eyeAngle.y = -PI/2;
  
  
  eyeVector.x = cos(eyeAngle.x);
  eyeVector.z = sin(eyeAngle.x);
  eyeVector.y = sin(eyeAngle.y);

}

void positionUpdate(){
  switch(key)
  {
    case 'w' :{ //Avant
        PVector forward = new PVector(eyeVector.x * speed, eyeVector.y * speed, eyeVector.z * speed);
        coordinate.add(forward);
        break;
    }
    case 's' : { //Derrière
        PVector backward = new PVector(eyeVector.x * -speed, eyeVector.y * -speed, eyeVector.z * -speed);
        coordinate.add(backward);
        break;
    }
    case 'd' : { //Droite
        PVector rightSide = new PVector(cos(eyeAngle.x + PI/2.0), 0, sin(eyeAngle.x + PI/2.0));
        coordinate.add(rightSide.mult(speed)); //Déjà normalisé
        break;
    }
    case 'a' : { //Gauche
        PVector leftSide = new PVector(cos(eyeAngle.x - PI/2.0), 0, sin(eyeAngle.x - PI/2.0));
        coordinate.add(leftSide.mult(speed)); //Déjà normalisé
        break;
    }
    default : break;
  }



}

PShape pylon;

void draw(){
  fill(255, 0, 0);
  stroke(59);
  //box(200); //centersphere
  
  //shader(shader_);
  float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
  perspective(PI/3.0, width/height, 1, cameraZ*10.0);
  eyeUpdate();
  if(keyPressed){
    positionUpdate();
  }
  background(255);
  camera(coordinate.x, coordinate.y, coordinate.z,
         coordinate.x + eyeVector.x, coordinate.y +eyeVector.y,
         coordinate.z +eyeVector.z, 0, 1, 0);
  pushMatrix();
  translate(WIDTH_/2, HEIGHT_/2, 200);
  pylon = createPylone();
  PVector c1 = new PVector(WIDTH_/2, HEIGHT_/2, 200);
  PVector c2 = new PVector(WIDTH_/2 + 240, HEIGHT_/2, 200 + 100);
  shape(pylon);
  popMatrix();
  pushMatrix();
  translate(WIDTH_/2 + 240, HEIGHT_/2, 200 + 100);
  PShape pylon2 = createPylone();
  shape(pylon);
  popMatrix();
  drawLine(c1, c2);
}
