float floor = 700;
float restLen = 30;
float[][][] position = new float[10][10][2];
PImage img, tile;
float[] accX = new float[300];
float[] accY = new float[300];
float[] springForceX = new float[300];
float[] springForceY = new float[300];

void setup() {
  size(800, 800, P3D);
  surface.setTitle("Ball on Spring!");
  /*img = loadImage("~/Phisics-Simulation/PendulumSpring/texture.jpg");
  noStroke();
  tile = createImage(img.width/300, img.height/300, RGB);*/
  for (int i=0; i < 10; i++){
    for (int j = 0; j < 10; j++){  
      if (i == 0){
        if (j == 0){
          position[i][j][0] = 180;
        }
        else {
          position[i][j][0] = position[i][j-1][0] + restLen;
        }
        position[i][j][1] = 150;
      } else if (j==0 && i>0){
        position[i][j][0] = 180;
        position[i][j][1] = position[i-1][j][1] + restLen;
      }
      else {
        position[i][j][0] = position[i][j-1][0] + restLen;
        position[i][j][1] = position[i-1][j][1] + restLen;
      }
    }
  }
  
}



/*float ballX1 = 180, ballX2 = ballX1 + restLen, ballX3 = ballX2 + restLen, ballX4 = ballX3 + restLen, ballX5 = ballX4 + restLen;
float ballY1 = 150, ballY2 = 150 , ballY3 = 150, ballY4 = 150, ballY5 = 150;

float ballX6 = 180, ballX7 = ballX6 + restLen, ballX8 = ballX7 + restLen, ballX9 = ballX8 + restLen, ballX10 = ballX9 + restLen;
float ballY6 = ballY1 + restLen , ballY7 = ballY2 + restLen , ballY8 = ballY3 + restLen, ballY9 = ballY4 + restLen, ballY10 = ballY5 + restLen;

float ballX11 = 180, ballX12 = ballX11 + restLen, ballX13 = ballX12 + restLen, ballX14 = ballX13 + restLen, ballX15 = ballX14 + restLen;
float ballY11 = ballY6 + restLen, ballY12 = ballY7 + restLen , ballY13 = ballY8 + restLen, ballY14 = ballY9 + restLen, ballY15 = ballY10 + restLen;

float ballX16 = 180, ballX17 = ballX16 + restLen, ballX18 = ballX17 + restLen, ballX19 = ballX18 + restLen, ballX20 = ballX19 + restLen;
float ballY16 = ballY11 + restLen, ballY17 = ballY12 + restLen , ballY18 = ballY13 + restLen, ballY19 = ballY14 + restLen, ballY20 = ballY15 + restLen;

float ballX21 = 180, ballX22 = ballX21 + restLen, ballX23 = ballX22 + restLen, ballX24 = ballX23 + restLen, ballX25 = ballX24 + restLen;
float ballY21 = ballY16 + restLen, ballY22 = ballY17 + restLen , ballY23 = ballY18 + restLen, ballY24 = ballY19 + restLen, ballY25 = ballY20 + restLen;
*/
float radius = 5;
float anchorX = 200;
//float anchorY = ballY1 - restLen;

float mass = 5;
float gravity = 20;
float k = 100; //1 1000
float kv = 5;

/*float[][][] position = {{{ballX1,ballY1}, {ballX2,ballY2},{ballX3,ballY3},{ballX4,ballY4},{ballX5,ballY5}},
                        {{ballX6,ballY6}, {ballX7,ballY7},{ballX8,ballY8},{ballX9,ballY9},{ballX10,ballY10}},
                        {{ballX11,ballY11}, {ballX12,ballY12},{ballX13,ballY13},{ballX14,ballY14},{ballX15,ballY15}},
                        {{ballX16,ballY16}, {ballX17,ballY17},{ballX18,ballY18},{ballX19,ballY19},{ballX20,ballY20}},
                        {{ballX21,ballY21}, {ballX22,ballY22},{ballX23,ballY23},{ballX24,ballY24},{ballX25,ballY25}}};

float[][][] velocity = {{{0,0}, {0,0},{0,0},{0,0},{0,0}},
                        {{0,0}, {0,0},{0,0},{0,0},{0,0}},
                        {{0,0}, {0,0},{0,0},{0,0},{0,0}},
                        {{0,0}, {0,0},{0,0},{0,0},{0,0}},
                        {{0,0}, {0,0},{0,0},{0,0},{0,0}}};
*/                       
float[][][] velocity = {{{0,0}, {0,0},{0,0},{0,0},{0,0},{0,0}, {0,0},{0,0},{0,0},{0,0}},
{{0,0}, {0,0},{0,0},{0,0},{0,0},{0,0}, {0,0},{0,0},{0,0},{0,0}},
{{0,0}, {0,0},{0,0},{0,0},{0,0},{0,0}, {0,0},{0,0},{0,0},{0,0}},
{{0,0}, {0,0},{0,0},{0,0},{0,0},{0,0}, {0,0},{0,0},{0,0},{0,0}},
{{0,0}, {0,0},{0,0},{0,0},{0,0},{0,0}, {0,0},{0,0},{0,0},{0,0}},
{{0,0}, {0,0},{0,0},{0,0},{0,0},{0,0}, {0,0},{0,0},{0,0},{0,0}},
{{0,0}, {0,0},{0,0},{0,0},{0,0},{0,0}, {0,0},{0,0},{0,0},{0,0}},
{{0,0}, {0,0},{0,0},{0,0},{0,0},{0,0}, {0,0},{0,0},{0,0},{0,0}},
{{0,0}, {0,0},{0,0},{0,0},{0,0},{0,0}, {0,0},{0,0},{0,0},{0,0}},
{{0,0}, {0,0},{0,0},{0,0},{0,0},{0,0}, {0,0},{0,0},{0,0},{0,0}}};


int numVX = 10;
int numVY = 10;

void update(float dt){
  for(int i = 0; i < numVX; i++ ){
    
    accX[i] = 0;
    accY[i] = 0;
  }
  for (int i = 0; i < numVX ; i++){
    for (int j=0; j< numVY; j++) {
      force(i, j,dt); //<>//
      position[i][j][0] += velocity[i][j][0]*dt;      // Update positions //<>//
      
      //if((i == 0 && j == 0) || (i == 0 && j == numVY-1) || (i ==0 && (0<j && j<numVY-1))){
        //position[i][j][1] += 0;
      //} else {
        position[i][j][1] += (gravity*dt + velocity[i][j][1])*dt;
      //}
       //<>//
      if (position[i][j][1]+radius > floor){      // Collision detection with ground
        velocity[i][j][1] *= -.9;
        position[i][j][1] = floor - radius;
      }
    }
  }
}
void calculate_force_velocity(int i, int j, int n, int m, float dt, int coefficient){
      coefficient = 1;
      float sx, sy;
      sx = (position[i][j][0] - position[n][m][0]);
      sy = (position[i][j][1] - position[n][m][1]);
      float stringLength = sqrt(sx*sx + sy*sy);
      float vx = (velocity[i][j][0]*sx/stringLength - velocity[n][m][0]*sx/stringLength);
      float vy = (velocity[i][j][1]*sy/stringLength - velocity[n][m][1]*sy/stringLength);
      float projVel = vx + vy;
      float dampForce = -kv*(projVel);
      float F = -k*coefficient*(stringLength - restLen) + dampForce;
      float acc = (0.5*F)/mass;
      velocity[i][j][0] += acc*dt*sx/stringLength;
      velocity[i][j][1] += acc*dt*sy/stringLength;
      velocity[n][m][0] -= acc*dt*sx/stringLength;
      velocity[n][m][1] -= acc*dt*sy/stringLength;
     
}

void force(int i, int j, float dt){
      //top left corner
      if(i == 0 && j == 0) {
        calculate_force_velocity(i,j,i+1,j,dt,-1);
        calculate_force_velocity(i,j,i,j+1,dt,-1);
        //velocity[i][j][0] = 0;
        //velocity[i][j][1] = 0; //<>//
      }
      // first Column
      else if (j == 0  && (i>0 && i<(numVX-1))){
        calculate_force_velocity(i,j,i-1,j,dt,1); //<>//
        calculate_force_velocity(i,j,i+1,j,dt,-1); 
        calculate_force_velocity(i,j,i,j+1,dt,-1);     
      } 
      // right border
      else if (j == numVY-1 && (i>0 && i<numVX-1 )){
        calculate_force_velocity(i,j,i-1,j,dt,1);
        calculate_force_velocity(i,j,i+1,j,dt,-1);
        calculate_force_velocity(i,j,i,j-1,dt,1); 
      } 
      // right top corner
      else if(j == numVY-1 && i == 0){
        calculate_force_velocity(i,j,i+1,j,dt,-1);
        calculate_force_velocity(i,j,i,j-1,dt,1);
        //velocity[i][j][0] = 0;
        //velocity[i][j][1] = 0;
      }
      // right bottom corner
      else if(j == numVY-1 && i == numVX-1){
        calculate_force_velocity(i,j,i-1,j,dt,1);
        calculate_force_velocity(i,j,i,j-1,dt,1);
      }
      //bottom border
      else if((j>0 && j<numVY-1) && i == numVX-1){
        calculate_force_velocity(i,j,i-1,j,dt,1);
        calculate_force_velocity(i,j,i,j+1,dt,-1);
        calculate_force_velocity(i,j,i,j-1,dt,1);
      }
      // bottom left corner
      else if(j == 0 && i == numVX-1){
        calculate_force_velocity(i,j,i-1,j,dt,1);
        calculate_force_velocity(i,j,i,j+1,dt,-1);
      } 
      // top boder
      else if((j>0 && j<numVY-1) && i == 0){
        calculate_force_velocity(i,j,i+1,j,dt,-1);
        calculate_force_velocity(i,j,i,j+1,dt,-1);
        calculate_force_velocity(i,j,i,j-1,dt,1);
        //velocity[i][j][0] = 0;
        //velocity[i][j][1] = 0;
      } 
      // rest of the nodes
      else if ((j>0 && j<numVY-1) && (i>0 && i< numVX-1)){
        calculate_force_velocity(i,j,i+1,j,dt,-1);
        calculate_force_velocity(i,j,i,j+1,dt,-1);
        calculate_force_velocity(i,j,i,j-1,dt,1);
        calculate_force_velocity(i,j,i-1,j,dt,1);
      }
}

void draw() {
    background(255,255,255);
    for (int i = 0; i < 10; i++){
      update(1/(1.0*frameRate));
    }
    
    noFill(); 
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < numVX; i++){
      for (int j= 0; j < numVY; j++){
          pushMatrix();
          
          //top left corner
          if(i == 0 && j == 0) {
                /*line(position[i][j][0],position[i][j][1], position[i][j+1][0],position[i][j+1][1]);
                line(position[i][j][0],position[i][j][1], position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                //sphere(radius);*/
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j+1][0],position[i][j+1][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i+1][j][0],position[i+1][j][1]);
                
          } 
          // first Column
          else if (j == 0  && (i>0 && i<(numVX-1))){
                /*line(position[i-1][j][0],position[i-1][j][1],position[i][j][0],position[i][j][1]);
                line(position[i][j][0],position[i][j][1],position[i][j+1][0],position[i][j+1][1]);
                line(position[i][j][0],position[i][j][1],position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                //sphere(radius);*/
                vertex(position[i-1][j][0],position[i-1][j][1]);
                vertex(position[i][j][0],position[i][j][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j+1][0],position[i][j+1][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i+1][j][0],position[i+1][j][1]);
                
          } 
          // right border
          else if (j == numVY-1 && (i>0 && i<numVX-1 )){
                /*line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                line(position[i][j][0],position[i][j][1],position[i-1][j][0],position[i-1][j][1]);
                line(position[i][j][0],position[i][j][1],position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);*/
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j-1][0],position[i][j-1][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i-1][j][0],position[i-1][j][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i+1][j][0],position[i+1][j][1]);
          } 
          // right top corner
          else if(j == numVY-1 && i == 0){
                /*line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                line(position[i][j][0],position[i][j][1],position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                /*sphere(radius);*/
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j-1][0],position[i][j-1][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i+1][j][0],position[i+1][j][1]);
          }
          // right bottom corner
          else if(j == numVY-1 && i == numVX-1){
                /*line(position[i][j][0],position[i][j][1],position[i-1][j][0],position[i-1][j][1]);
                line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                translate(position[i][j][0],position[i][j][1]);
                /*sphere(radius);*/
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i-1][j][0],position[i-1][j][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j-1][0],position[i][j-1][1]);
          }
          //bottom border
          else if((j>0 && j<numVY-1) && i == numVX-1){
                /*line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                line(position[i][j][0],position[i][j][1],position[i][j+1][0],position[i][j+1][1]);
                line(position[i][j][0],position[i][j][1],position[i-1][j][0],position[i-1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                /*sphere(radius);*/
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j-1][0],position[i][j-1][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j+1][0],position[i][j+1][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i-1][j][0],position[i-1][j][1]);
          }
          // bottom left corner
          else if(j == 0 && i == numVY-1){
                /*line(position[i][j][0],position[i][j][1],position[i-1][j][0],position[i-1][j][1]);
                line(position[i][j][0],position[i][j][1],position[i][j+1][0],position[i][j+1][1]);
                translate(position[i][j][0],position[i][j][1]);
                /*sphere(radius);*/
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i-1][j][0],position[i-1][j][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j+1][0],position[i][j+1][1]);
                
          } 
          // top boder
          else if((j>0 && j<numVY-1) && i == 0){
                /*line(position[i][j][0],position[i][j][1],position[i][j+1][0],position[i][j+1][1]);
                line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                line(position[i][j][0],position[i][j][1],position[i+1][j][0],position[i+1][j][1]);*/
                //beginShape(TRIANGLE_STRIP);
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j+1][0],position[i][j+1][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j-1][0],position[i][j-1][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i+1][j][0],position[i+1][j][1]);
                //endShape();
                //translate(position[i][j][0],position[i][j][1]);
                //sphere(radius);
          } 
          else if ((j>0 && j<numVY-1) && (i>0 && i< numVX-1)){
                // rest of the nodes
                /*line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                line(position[i][j][0],position[i][j][1],position[i][j+1][0],position[i][j+1][1]);
                line(position[i][j][0],position[i][j][1],position[i-1][j][0],position[i-1][j][1]);
                line(position[i][j][0],position[i][j][1],position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);*/
                /*textureMode(NORMAL);*/
                
                //texture(tile);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j-1][0],position[i][j-1][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i][j+1][0],position[i][j+1][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i-1][j][0],position[i-1][j][1]);
                
                vertex(position[i][j][0],position[i][j][1]);
                vertex(position[i+1][j][0],position[i+1][j][1]);
            
          }
            
          popMatrix();
      }
    }
    endShape();
}
