PShape field;
PShader shader_; 
PVector[] pylonePosition = new PVector[25]; 
PImage bg;
static Boolean togglePylone = true;

void setup(){
  frameRate(20);
  field = loadShape("hypersimple.obj");
  shader_ = loadShader("myFragmentShader.glsl", 
               "myVertexShader.glsl");
  size(1000, 1000, P3D);
  bg = loadImage("sky2.png");
  for(int i = 0; i < 25; i++){
  PVector randomXY = new PVector(int(random(-105, 107)), int(random(-108, 109)), 40);
  pylonePosition[i] = zFinder(int(randomXY.x), int(randomXY.y), field);
  }
  pylonePosition = chainSorted();
  
}

//Calcul intensif : on calcule les positions des pylones qu'une seule fois pour toute l'execution
PVector zFinder(int x, int y, PShape subject){
  PVector bestMatch = subject.getChild(0).getVertex(0);
  for(int i = 0; i < subject.getChildCount(); i++){ 
    for(int m = 0; m < subject.getChild(i).getVertexCount(); m++){
      if(subject.getChild(i).getVertex(m).dist(new PVector(x, y, subject.getChild(i).getVertex(m).z)) > bestMatch.dist(new PVector(x, y, bestMatch.z)))  continue;
      //else 
      bestMatch = subject.getChild(i).getVertex(m);
    }
  }
  return bestMatch;
}

//Trace une ligne courbé entre 2 points.
void drawLine(PVector start1, PVector end1){
    PVector startCopy = start1.copy();
    PVector endCopy = end1.copy();
    fill(0); // Couleur du pylône
    stroke(0); // Couleur de la bordure
    strokeWeight(3); // Épaisseur de la bordure
    float scaling = 0.1;
    float height_ = 70.0 * scaling;
    float size = 10.0 * scaling;
    float distance = startCopy.dist(endCopy);
    float bendingIntensity = distance / 150; //Valeur arbitraire. Plus le cable est long, plus l'effet de "torsion" est intense.
    PVector lastPoint = startCopy;
    float incrementer = distance / 40.0;
    PVector direction = endCopy.sub(startCopy).normalize().mult(incrementer);
    beginShape(LINES);
    //Un vecteur qui change systèmatiquement de valeur entre le point START et END trace la courbe.
    // Le vecteur dépend de nextPoint, ce dernier change de hauteur (z) selon sa distance entre le point se trouvant 
    //à (END + START)/2. Plus il est proche de celui-ci, plus il descend. nextPoint a comme valeur [START, END].
    for(float i = 0; i < distance - incrementer/2; i += incrementer){
      PVector nextPoint = lastPoint.copy().add(direction);
      nextPoint.z -= cos(i/distance * PI) * bendingIntensity;
      vertex(lastPoint.x  - size * 3, lastPoint.y -  size/2, lastPoint.z + height_);
      vertex(nextPoint.x  - size * 3, nextPoint.y - size/2, nextPoint.z + height_);
      
      vertex(lastPoint.x  + size * 3, lastPoint.y - size/2, lastPoint.z + height_);
      vertex(nextPoint.x  + size * 3, nextPoint.y - size/2, nextPoint.z + height_);
      lastPoint = nextPoint.copy();
    }
    
    endShape();
    
}

//Code dégueux qui n'est pas compliqué.
PShape createPylone(){ 
  int start = -10/2;
  int size = 10;
  int height_ = 70;
  PShape pylone = createShape();
  pylone.rotateX(-PI/2);
  pylone.beginShape(LINES);
  pylone.fill(35); // Couleur du pylône
  pylone.stroke(35); // Couleur de la bordure
  pylone.strokeWeight(150); // Épaisseur de la bordure
  //Support
  pylone.scale(0.1);
  pylone.vertex(start, 0, 0);
  pylone.vertex(start, - height_, 0);
  
  pylone.vertex(start + size, 0, 0);
  pylone.vertex(start + size, - height_, 0);
  
  pylone.vertex(start + size, 0, -size);
  pylone.vertex(start + size, - height_, -size);
  
  pylone.vertex(start , 0, -size);
  pylone.vertex(start , - height_, -size);
  
  for(int i = 0; i < height_ ; i += 5){ 
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

//Fonction qui tri une liste de "point" tels que pour chaque point A, le point B qui se trouve ensuite dans la liste est le point le plus proche de A. Ce point B doit aussi
//ne pas être déjà "lié" à un autre point A. 
PVector[] chainSorted(){
  PVector chainSorted[] = new PVector[25];
  for(int m = 0; m < 25; m++)chainSorted[m] = pylonePosition[m].copy();
  int indexShortest; 
  for(int analyzed = 0; analyzed < 25; analyzed++){
    indexShortest = analyzed + 1;
    // Lors de la recherche du point B, on ne considère pas les points qui peuvent potentiellement être B mais qui se trouve avant A dans la liste, car ils sont déjà "rangés". 
    for(int i = analyzed + 1; i < 25; i++){
      if(chainSorted[analyzed].dist(chainSorted[i]) > chainSorted[analyzed].dist(chainSorted[indexShortest])) continue;
      //else 
      indexShortest = i;
    }
    if(analyzed + 1 == 25){
      break;
    }
    //Échange les places entre les points
    PVector temps = chainSorted[analyzed + 1].copy();
    chainSorted[analyzed + 1] = chainSorted[indexShortest].copy();
    chainSorted[indexShortest] = temps.copy();
  }
  return chainSorted;
}

//Dessine le circuit de pylone : donc les pylones + les cables
void drawPyloneCircuit(){
  if(!togglePylone) return;
  PShape pylone = createPylone();
  pushMatrix();
    translate(pylonePosition[0].x, pylonePosition[0].y, pylonePosition[0].z);
    shape(pylone);
  popMatrix();
  for(int i = 0; i < 24; i++){
    drawLine(pylonePosition[i], pylonePosition[i + 1]);
    pushMatrix();
    translate(pylonePosition[i + 1].x, pylonePosition[i + 1].y, pylonePosition[i + 1].z);
    shape(pylone);
    popMatrix();
    
  
  }
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

//Calcule la direction observé par la caméra
void eyeUpdate(){
  mousePosition = new PVector(mouseX, mouseY);
  
  // La souris déplace la caméra : si la souris bouge d'une distance "négligeable", ne pas changer la direction observé
  if(abs(mousePosition.x - lastMousePosition.x) < 0.5 && abs(mousePosition.y - lastMousePosition.y) < 0.5 && abs(mousePosition.y - lastMousePosition.y) < 0.5){
    return;
  }
  
  //Calcule le vecteur entre la position actuel de la souris à sa dernière position enregistré : cela donne l'acceleration
  PVector mouseAcceleration = new PVector(mousePosition.x - lastMousePosition.x, mousePosition.y - lastMousePosition.y).normalize();
  lastMousePosition = mousePosition.copy(); //Enregistre la position, utile pour le prochain appel à eyeUpdate().
  
  // Nécessite de cliquer la souris pour faire déplacer
  if(!mousePressed) return;
  // Utile l'acceleration pour déplacer le point observé par la caméra
  eyeAngle.x += mouseAcceleration.x * mouseSensitivity; 
  eyeAngle.y += mouseAcceleration.y * mouseSensitivity;
  if(eyeAngle.y > PI/2) eyeAngle.y = PI/2; //Empêche l'utilisateur de se désorienter.
  else if(eyeAngle.y < -PI/2) eyeAngle.y = -PI/2;
  
  //Définit le vecteur qui décrit où regarde la caméra. 
  eyeVector.x = cos(eyeAngle.x);
  eyeVector.z = sin(eyeAngle.x);
  eyeVector.y = sin(eyeAngle.y);

}

void positionUpdate(){
  switch(key)
  {
    case 'e' :{
       togglePylone = !togglePylone;
       break;
    }
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
    case 'd' : { //Droite. On utile eyeAngle et on lui ajoute un quart de PI pour donner la normale de eyeVector : le nouveau vecteur permet de faire à droite la caméra
        PVector rightSide = new PVector(cos(eyeAngle.x + PI/2.0), 0, sin(eyeAngle.x + PI/2.0));
        coordinate.add(rightSide.mult(speed)); //Déjà normalisé
        break;
    }
    case 'a' : { //Gauche. Procédé similaire au déplacement à droite.
        PVector leftSide = new PVector(cos(eyeAngle.x - PI/2.0), 0, sin(eyeAngle.x - PI/2.0));
        coordinate.add(leftSide.mult(speed)); //Déjà normalisé
        break;
    }
    default : break;
  }



}

void draw(){
  float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
  perspective(PI/3.0, width/height, 1, cameraZ*10.0);
  eyeUpdate();
  if(keyPressed){
    positionUpdate();
  }
  background(bg);
  camera(coordinate.x, coordinate.y, coordinate.z,
         coordinate.x + eyeVector.x, coordinate.y +eyeVector.y,
         coordinate.z +eyeVector.z, 0, 1, 0);
  pushMatrix();
  translate(WIDTH_/2, HEIGHT_/2, 200);
  rotateX(PI/2);
  shape(field);
  drawPyloneCircuit();
  popMatrix();
  shader(shader_);
}
