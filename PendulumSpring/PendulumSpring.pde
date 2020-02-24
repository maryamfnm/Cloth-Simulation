void setup() {
  size(800, 800, P3D);
  surface.setTitle("Ball on Spring!");
  
}

float floor = 400;
float restLen = 30;

float ballX1 = 180, ballX2 = ballX1 + restLen, ballX3 = ballX2 + restLen, ballX4 = ballX3 + restLen, ballX5 = ballX4 + restLen;
float ballY1 = 150, ballY2 = 150 , ballY3 = 150, ballY4 = 150, ballY5 = 150;

float ballX6 = 180, ballX7 = ballX6 + restLen, ballX8 = ballX7 + restLen, ballX9 = ballX8 + restLen, ballX10 = ballX9 + restLen;
float ballY6 = ballY1 + restLen , ballY7 = ballY2 + restLen , ballY8 = ballY3 + restLen, ballY9 = ballY4 + restLen, ballY10 = ballY5 + restLen;

float ballX11 = 180, ballX12 = ballX11 + restLen, ballX13 = ballX12 + restLen, ballX14 = ballX13 + restLen, ballX15 = ballX14 + restLen;
float ballY11 = ballY6 + restLen, ballY12 = ballY7 + restLen , ballY13 = ballY8 + restLen, ballY14 = ballY9 + restLen, ballY15 = ballY10 + restLen;

float ballX16 = 180, ballX17 = ballX16 + restLen, ballX18 = ballX17 + restLen, ballX19 = ballX18 + restLen, ballX20 = ballX19 + restLen;
float ballY16 = ballY11 + restLen, ballY17 = ballY12 + restLen , ballY18 = ballY13 + restLen, ballY19 = ballY14 + restLen, ballY20 = ballY15 + restLen;

float ballX21 = 180, ballX22 = ballX21 + restLen, ballX23 = ballX22 + restLen, ballX24 = ballX23 + restLen, ballX25 = ballX24 + restLen;
float ballY21 = ballY16 + restLen, ballY22 = ballY17 + restLen , ballY23 = ballY18 + restLen, ballY24 = ballY19 + restLen, ballY25 = ballY20 + restLen;

float radius = 5;
float anchorX = 200;
float anchorY = ballY1 - restLen;

float mass = 5;
float gravity = 2;
float k = 1; //1 1000
float kv = 1;

float[][][] position = {{{ballX1,ballY1}, {ballX2,ballY2},{ballX3,ballY3},{ballX4,ballY4},{ballX5,ballY5}},
                        {{ballX6,ballY6}, {ballX7,ballY7},{ballX8,ballY8},{ballX9,ballY9},{ballX10,ballY10}},
                        {{ballX11,ballY11}, {ballX12,ballY12},{ballX13,ballY13},{ballX14,ballY14},{ballX15,ballY15}},
                        {{ballX16,ballY16}, {ballX17,ballY17},{ballX18,ballY18},{ballX19,ballY19},{ballX20,ballY20}},
                        {{ballX21,ballY21}, {ballX22,ballY22},{ballX23,ballY23},{ballX24,ballY24},{ballX25,ballY25}}};
float[][] meshGrid;
float[][][] velocity = {{{0,0}, {0,0},{0,0},{0,0},{0,0}},
                        {{0,0}, {0,0},{0,0},{0,0},{0,0}},
                        {{0,0}, {0,0},{0,0},{0,0},{0,0}},
                        {{0,0}, {0,0},{0,0},{0,0},{0,0}},
                        {{0,0}, {0,0},{0,0},{0,0},{0,0}}};
float[] accX = new float[300];
float[] accY = new float[300];
float[] springForceX = new float[300];
float[] springForceY = new float[300];

int numVX = 5;
int numVY = 5;

void update(float dt){
  for(int i = 0; i < numVX; i++ ){
    
    accX[i] = 0;
    accY[i] = 0;
  }
  for (int i = 0; i < numVX ; i++){
    for (int j=0; j< numVY; j++) {
      println("i: " + i + " j: " + j); //<>//
      float[] force_direction = force(i, j,dt);
      float stringF = force_direction[0];
      float dirX = force_direction[1];    // direction of the force - X
      float dirY = force_direction[2];    // direction of the force - Y
      
      float dampF=0, projVelTotal=0;        // Line 53 to 64 is implementing dampening functionality
      float vel_x ,vel_y;
      /*if (i == 0 && (j >= 0 && j <=numVY-1)) {
          projVelTotal = 0; 
      }
      
      // left border
      else if (j == 0  && (i>0 && i<(numVX-1))){
          float vx1, vy1, vx2, vy2, vx3, vy3;
          vx1 = (velocity[i][j][0]*dirX - velocity[i-1][j][0]*dirX);
          vy1 = (velocity[i][j][1]*dirY - velocity[i-1][j][1]*dirY);
          float projVel_1 = vx1 + vy1;
          float damp1 = -kv*(projVel_1);
          
          vx2 = (velocity[i][j][0]*dirX - velocity[i+1][j][0]*dirX);
          vy2 = (velocity[i][j][1]*dirY - velocity[i+1][j][1]*dirY);
          float projVel_2 = vx2 + vy2;
          float damp2 = -kv*(projVel_2);
          
          vx3 = (velocity[i][j][0]*dirX - velocity[i][j+1][0]*dirX);
          vy3 = (velocity[i][j][1]*dirY - velocity[i][j+1][1]*dirY);
          float projVel_3 = vx3 + vy3;
          float damp3 = -kv*(projVel_3);
          
          dampF = damp1 + damp2 + damp3;
        } 
        // right border
        else if (j == numVY-1 && (i>0 && i<numVX-1 )){
          float vx1, vy1, vx2, vy2, vx3, vy3;
          vx1 = (velocity[i][j][0]*dirX - velocity[i-1][j][0]*dirX);
          vy1 = (velocity[i][j][1]*dirY - velocity[i-1][j][1]*dirY);
          float projVel_1 = vx1 + vy1;
          float damp1 = -kv*(projVel_1);
          
          vx2 = (velocity[i][j][0]*dirX - velocity[i+1][j][0]*dirX);
          vy2 = (velocity[i][j][1]*dirY - velocity[i+1][j][1]*dirY);
          float projVel_2 = vx2 + vy2;
          float damp2 = -kv*(projVel_2);
          
          vx3 = (velocity[i][j][0]*dirX - velocity[i][j-1][0]*dirX);
          vy3 = (velocity[i][j][1]*dirY - velocity[i][j-1][1]*dirY);
          float projVel_3 = vx3 + vy3;
          float damp3 = -kv*(projVel_3);
          
          dampF = damp1 + damp2 + damp3;
        } 
        // right bottom corner
        else if(j == numVY-1 && i == numVX-1){
          float vx1, vy1, vx2, vy2;
          vx1 = (velocity[i][j][0]*dirX - velocity[i-1][j][0]*dirX);
          vy1 = (velocity[i][j][1]*dirY - velocity[i-1][j][1]*dirX);
          float projVel_1 = vx1 + vy1;
          float damp1 = -kv*(projVel_1);
          
          vx2 = (velocity[i][j][0]*dirX - velocity[i][j-1][0]*dirX);
          vy2 = (velocity[i][j][1]*dirY - velocity[i][j-1][1]*dirX);
          float projVel_2 = vx2 + vy2;
          float damp2 = -kv*(projVel_2);
          
          dampF = damp1 + damp2;
        }
        //bottom border
        else if((j>0 && j<numVY-1) && i == numVX-1){
          float vx1, vy1, vx2, vy2, vx3, vy3;
          vx1 = (velocity[i][j][0]*dirX - velocity[i-1][j][0]*dirX);
          vy1 = (velocity[i][j][1]*dirY - velocity[i-1][j][1]*dirY);
          float projVel_1 = vx1 + vy1;
          float damp1 = -kv*(projVel_1);
          
          vx2 = (velocity[i][j][0]*dirX - velocity[i][j+1][0]*dirX);
          vy2 = (velocity[i][j][1]*dirY - velocity[i][j+1][1]*dirY);
          float projVel_2 = vx2 + vy2;
          float damp2 = -kv*(projVel_2);
          
          vx3 = (velocity[i][j][0]*dirX - velocity[i][j-1][0]*dirX);
          vy3 = (velocity[i][j][1]*dirY - velocity[i][j-1][1]*dirY);
          float projVel_3 = vx3 + vy3;
          float damp3 = -kv*(projVel_3);
          
          dampF = damp1 + damp2 + damp3;
              
        }
        // bottom left corner
        else if(j == 0 && i == numVX-1){
          float vx1, vy1, vx2, vy2;
          vx1 = (velocity[i][j][0]*dirX - velocity[i-1][j][0]*dirX);
          vy1 = (velocity[i][j][1]*dirY - velocity[i-1][j][1]*dirY);
          float projVel_1 = vx1 + vy1;
          float damp1 = -kv*(projVel_1);
          
          vx2 = (velocity[i][j][0]*dirX - velocity[i][j+1][0]*dirX);
          vy2 = (velocity[i][j][1]*dirY - velocity[i][j+1][1]*dirY);
          float projVel_2 = vx2 + vy2;
          float damp2 = -kv*(projVel_2);
          
          dampF = damp1 + damp2;
        } 
        
        // rest of the nodes
        else if ((j>0 && j<numVY-1) && (i>0 && i< numVX-1)){
          float vx1, vy1, vx2, vy2, vx3, vy3, vx4,vy4;
          vx1 = (velocity[i][j][0]*dirX - velocity[i+1][j][0]*dirX);
          vy1 = (velocity[i][j][1]*dirY - velocity[i+1][j][1]*dirY);
          float projVel_1 = vx1 + vy1;
          float damp1 = -kv*(projVel_1);
          
          vx2 = (velocity[i][j][0]*dirX - velocity[i][j+1][0]*dirX);
          vy2 = (velocity[i][j][1]*dirY - velocity[i][j+1][1]*dirY);
          float projVel_2 = vx2 + vy2;
          float damp2 = -kv*(projVel_2);
          
          vx3 = (velocity[i][j][0]*dirX - velocity[i][j-1][0]*dirX);
          vy3 = (velocity[i][j][1]*dirY - velocity[i][j-1][1]*dirY);
          float projVel_3 = vx3 + vy3;
          float damp3 = -kv*(projVel_3);
          
          vx4 = (velocity[i][j][0]*dirX - velocity[i-1][j][0]*dirX);
          vy4 = (velocity[i][j][1]*dirY - velocity[i-1][j][1]*dirY);
          float projVel_4 = vx4 + vy4;
          float damp4 = -kv*(projVel_4);
        
          dampF = damp1 + damp2 + damp3 + damp4;
        }*/
      
      //dampF = -kv*(projVelTotal);
      
      //springForceX[i] = (stringF+dampF)*dirX;      // Calculate Spring Forces for x and y 
      //springForceY[i] = (stringF+dampF)*dirY;
      
      //println("springForceX[i]: " + springForceX[i]);
      //println("springForceY[i]: " + springForceY[i]);
      //println("-----------------");
      
      // update velocity
      /*if(i == 0 && (j >= 0 && j <=numVY-1)){
        accY[i] = 0;
        accX[i] = 0;
      }
      else {
        accY[i] =  gravity + (0.5*springForceY[i])/mass;  //<>//
        accX[i] = 0.5*springForceX[i]/mass;
      }
    
      velocity[i][j][0] += accX[i]*dt;
      velocity[i][j][1] += accY[i]*dt;*/
     
      //accX[i] = 0;
      //accY[i] = 0.0;
      
      println("velocity[i][j][0]: " + velocity[i][j][1]);
      position[i][j][0] += velocity[i][j][0]*dt;      // Update positions
      position[i][j][1] += ( gravity*dt + velocity[i][j][1])*dt;
     
     //float distance = dist(position[i][j][0],position[i][j][1],ballXPos,ballYPos);
            //<>//
      if (position[i][j][1]+radius > floor){      // Collision detection with ground
        velocity[i][j][1] *= -.9;
        position[i][j][1] = floor - radius;
      }
      
    }
  }
}

float[] force(int i, int j, float dt){
      float F = 0, directionX = 0, directionY = 0;
      //top left corner
      if(i == 0 && j == 0) {
        float sx1, sy1, sx2, sy2;
        sx1 = (position[i][j][0] - position[i][j+1][0]);
        sy1 = (position[i][j][1] - position[i][j+1][1]);
        float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
        float F1 = k*(stringLen1 - restLen); 
     
        sx2 = (position[i][j][0] - position[i+1][j][0]);
        sy2 = (position[i][j][1] - position[i+1][j][1]);
        float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
        float F2 = k*(stringLen2 - restLen); 
        
        directionX = sx1/stringLen1 + sx2/stringLen2; 
        directionY = sy1/stringLen1 + sy2/stringLen2;
        
        F = F1 + F2;    //<>//
      }
      // first Column
      else if (j == 0  && (i>0 && i<(numVX-1))){
        float sx1, sy1, sx2, sy2, sx3, sy3;
        sx1 = (position[i][j][0] - position[i-1][j][0]); //<>//
        sy1 = (position[i][j][1] - position[i-1][j][1]);
        
        float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
        vx3 = (velocity[i][j][0]*sx1/stringLen1 - velocity[i][j-1][0]*sx1/stringLen1);
        vy3 = (velocity[i][j][1]*dirY - velocity[i][j-1][1]*dirY);
          float projVel_3 = vx3 + vy3;
          float damp3 = -kv*(projVel_3);
        float F1 = - k*(stringLen1 - restLen) ; 
        
        float accY1 = (0.5*F1)/mass; 
        float accX1 = (0.5*F1)/mass;
        
    
        velocity[i][j][0] += accX1*dt*sx1/stringLen1;
        velocity[i][j][1] += accY1*dt*sy1/stringLen1;
        
        velocity[i-1][j][0] -= accX1*dt*sx1/stringLen1;
        velocity[i-1][j][1] -= accY1*dt*sy1/stringLen1;
        
        
        sx2 = (position[i][j][0] - position[i+1][j][0]);
        sy2 = (position[i][j][1] - position[i+1][j][1]);
        float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
        float F2 = k*(stringLen2 - restLen); 
        float accY2 = (0.5*F2)/mass; 
        float accX2 = (0.5*F2)/mass;
        
    
        velocity[i][j][0] += accX2*dt*sx2/stringLen2;
        velocity[i][j][1] += accY2*dt*sy2/stringLen2;
        
        velocity[i+1][j][0] -= accX2*dt*sx2/stringLen2;
        velocity[i+1][j][1] -= accY2*dt*sy2/stringLen2;
        
        
        sx3 = (position[i][j][0] - position[i][j+1][0]);
        sy3 = (position[i][j][1] - position[i][j+1][1]);
        
        
        float stringLen3 = sqrt(sx3*sx3 + sy3*sy3);
        float F3 = k*(stringLen3 - restLen); 
        
        float accY3 = (0.5*F3)/mass; 
        float accX3 = (0.5*F3)/mass;
        
    
        velocity[i][j][0] += accX3*dt*sx3/stringLen3;
        velocity[i][j][1] += accY3*dt*sy3/stringLen3;
        
        velocity[i][j+1][0] -= accX3*dt*sx3/stringLen3;
        velocity[i][j+1][1] -= accY3*dt*sy3/stringLen3;
        
        //directionX = sx1/stringLen1 + sx2/stringLen2 + sx3/stringLen3; 
        //directionY = sy1/stringLen1 + sy2/stringLen2 + sx3/stringLen3;
        
        //F = F1 + F2 + F3;   
        println("F: " + F);
        println("****************************");
            
      } 
      // right border
      else if (j == numVY-1 && (i>0 && i<numVX-1 )){
        float sx1, sy1, sx2, sy2, sx3, sy3;
        sx1 = (position[i][j][0] - position[i-1][j][0]);
        sy1 = (position[i][j][1] - position[i-1][j][1]);
        float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
        float F1 = -k*(stringLen1 - restLen); 
        float accY1 = (0.5*F1)/mass; 
        float accX1 = (0.5*F1)/mass;
        
    
        velocity[i][j][0] += accX1*dt*sx1/stringLen1;
        velocity[i][j][1] += accY1*dt*sy1/stringLen1;
        
        velocity[i-1][j][0] -= accX1*dt*sx1/stringLen1;
        velocity[i-1][j][1] -= accY1*dt*sy1/stringLen1;
        
        sx2 = (position[i][j][0] - position[i+1][j][0]);
        sy2 = (position[i][j][1] - position[i+1][j][1]);
        float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
        float F2 = k*(stringLen2 - restLen); 
        
        float accY2 = (0.5*F2)/mass; 
        float accX2 = (0.5*F2)/mass;
        
    
        velocity[i][j][0] += accX2*dt*sx2/stringLen2;
        velocity[i][j][1] += accY2*dt*sy2/stringLen2;
        
        velocity[i+1][j][0] -= accX2*dt*sx2/stringLen2;
        velocity[i+1][j][1] -= accY2*dt*sy2/stringLen2;
        
        sx3 = (position[i][j][0] - position[i][j-1][0]);
        sy3 = (position[i][j][1] - position[i][j-1][1]);
        float stringLen3 = sqrt(sx3*sx3 + sy3*sy3);
        float F3 = -k*(stringLen3 - restLen); 
        float accY3 = (0.5*F3)/mass; 
        float accX3 = (0.5*F3)/mass;
        
    
        velocity[i][j][0] += accX3*dt*sx3/stringLen3;
        velocity[i][j][1] += accY3*dt*sy3/stringLen3;
        
        velocity[i][j-1][0] -= accX3*dt*sx3/stringLen3;
        velocity[i][j-1][1] -= accY3*dt*sy3/stringLen3;
        
        /*directionX = sx1/stringLen1 + sx2/stringLen2 + sx3/stringLen3; 
        directionY = sy1/stringLen1 + sy2/stringLen2 + sx3/stringLen3;
        
        F = F1 + F2 + F3;*/
            
      } 
      // right top corner
      else if(j == numVY-1 && i == 0){
        float sx1, sy1, sx2, sy2;
        sx1 = (position[i][j][0] - position[i][j-1][0]);
        sy1 = (position[i][j][1] - position[i][j-1][1]);
        float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
        float F1 = -k*(stringLen1 - restLen); 
        
        /*float accY1 = (0.5*F1)/mass; 
        float accX1 = (0.5*F1)/mass;
        
    
        velocity[i][j][0] += accX1*dt*sx1/stringLen1;
        velocity[i][j][1] += accY1*dt*sy1/stringLen1;
        
        velocity[i][j-1][0] -= accX1*dt*sx1/stringLen1;
        velocity[i][j-1][1] -= accY1*dt*sy1/stringLen1;*/
        
        sx2 = (position[i][j][0] - position[i+1][j][0]);
        sy2 = (position[i][j][1] - position[i+1][j][1]);
        float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
        float F2 = k*(stringLen2 - restLen); 
        
        /*float accY2 = (0.5*F2)/mass; 
        float accX2 = (0.5*F2)/mass;
        
    
        velocity[i][j][0] += accX2*dt*sx2/stringLen2;
        velocity[i][j][1] += accY2*dt*sy2/stringLen2;
        
        velocity[i+1][j][0] -= accX2*dt*sx2/stringLen2;
        velocity[i+1][j][1] -= accY2*dt*sy2/stringLen2;*/
        
        /*directionX = sx1/stringLen1 + sx2/stringLen2; 
        directionY = sy1/stringLen1 + sy2/stringLen2;
        
        F = F1 + F2; */
          
      }
      // right bottom corner
      else if(j == numVY-1 && i == numVX-1){
        float sx1, sy1, sx2, sy2;
        sx1 = (position[i][j][0] - position[i-1][j][0]);
        sy1 = (position[i][j][1] - position[i-1][j][1]);
        float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
        float F1 = -k*(stringLen1 - restLen); 
        float accY1 = (0.5*F1)/mass; 
        float accX1 = (0.5*F1)/mass;
        
    
        velocity[i][j][0] += accX1*dt*sx1/stringLen1;
        velocity[i][j][1] += accY1*dt*sy1/stringLen1;
        
        velocity[i-1][j][0] -= accX1*dt*sx1/stringLen1;
        velocity[i-1][j][1] -= accY1*dt*sy1/stringLen1;
        
        sx2 = (position[i][j][0] - position[i][j-1][0]);
        sy2 = (position[i][j][1] - position[i][j-1][1]);
        float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
        float F2 = -k*(stringLen2 - restLen);
        
        float accY2 = (0.5*F2)/mass; 
        float accX2 = (0.5*F2)/mass;
        
    
        velocity[i][j][0] += accX2*dt*sx2/stringLen2;
        velocity[i][j][1] += accY2*dt*sy2/stringLen2;
        
        velocity[i][j-1][0] -= accX2*dt*sx2/stringLen2;
        velocity[i][j-1][1] -= accY2*dt*sy2/stringLen2;
        
        /*directionX = sx1/stringLen1 + sx2/stringLen2; 
        directionY = sy1/stringLen1 + sy2/stringLen2;
        
        F = F1 + F2; */
            
      }
      //bottom border
      else if((j>0 && j<numVY-1) && i == numVX-1){
        float sx1, sy1, sx2, sy2, sx3, sy3;
        sx1 = (position[i][j][0] - position[i-1][j][0]);
        sy1 = (position[i][j][1] - position[i-1][j][1]);
        float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
        float F1 = -k*(stringLen1 - restLen); 
        
        float accY1 = (0.5*F1)/mass; 
        float accX1 = (0.5*F1)/mass;
        
    
        velocity[i][j][0] += accX1*dt*sx1/stringLen1;
        velocity[i][j][1] += accY1*dt*sy1/stringLen1;
        
        velocity[i-1][j][0] -= accX1*dt*sx1/stringLen1;
        velocity[i-1][j][1] -= accY1*dt*sy1/stringLen1;
        
        sx2 = (position[i][j][0] - position[i][j+1][0]);
        sy2 = (position[i][j][1] - position[i][j+1][1]);
        float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
        float F2 = k*(stringLen2 - restLen); 
        
        float accY2 = (0.5*F2)/mass; 
        float accX2 = (0.5*F2)/mass;
        
    
        velocity[i][j][0] += accX2*dt*sx2/stringLen2;
        velocity[i][j][1] += accY2*dt*sy2/stringLen2;
        
        velocity[i][j+1][0] -= accX2*dt*sx2/stringLen2;
        velocity[i][j+1][1] -= accY2*dt*sy2/stringLen2;
        
        sx3 = (position[i][j][0] - position[i][j-1][0]);
        sy3 = (position[i][j][1] - position[i][j-1][1]);
        float stringLen3 = sqrt(sx3*sx3 + sy3*sy3);
        float F3 = -k*(stringLen3 - restLen); 
       
        
        float accY3 = (0.5*F3)/mass; 
        float accX3 = (0.5*F3)/mass;
        
    
        velocity[i][j][0] += accX3*dt*sx3/stringLen3;
        velocity[i][j][1] += accY3*dt*sy3/stringLen3;
        
        velocity[i][j-1][0] -= accX3*dt*sx3/stringLen3;
        velocity[i][j-1][1] -= accY3*dt*sy3/stringLen3;
        
       /* directionX = sx1/stringLen1 + sx2/stringLen2 + sx3/stringLen3; 
         directionY = sy1/stringLen1 + sy2/stringLen2 + sx3/stringLen3;
        F = F1 + F2 + F3;*/
            
      }
      // bottom left corner
      else if(j == 0 && i == numVX-1){
        float sx1, sy1, sx2, sy2;
        sx1 = (position[i][j][0] - position[i-1][j][0]);
        sy1 = (position[i][j][1] - position[i-1][j][1]);
        float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
        float F1 = -k*(stringLen1 - restLen); 
        
        float accY1 = (0.5*F1)/mass; 
        float accX1 = (0.5*F1)/mass;
        
    
        velocity[i][j][0] += accX1*dt*sx1/stringLen1;
        velocity[i][j][1] += accY1*dt*sy1/stringLen1;
        
        velocity[i-1][j][0] -= accX1*dt*sx1/stringLen1;
        velocity[i-1][j][1] -= accY1*dt*sy1/stringLen1;
        
        sx2 = (position[i][j][0] - position[i][j+1][0]);
        sy2 = (position[i][j][1] - position[i][j+1][1]);
        float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
        float F2 = k*(stringLen2 - restLen); 
        float accY2 = (0.5*F2)/mass; 
        float accX2 = (0.5*F2)/mass;
        
    
        velocity[i][j][0] += accX2*dt*sx2/stringLen2;
        velocity[i][j][1] += accY2*dt*sy2/stringLen2;
        
        velocity[i][j+1][0] -= accX2*dt*sx2/stringLen2;
        velocity[i][j+1][1] -= accY2*dt*sy2/stringLen2;
        
        /*directionX = sx1/stringLen1 + sx2/stringLen2; 
        directionY = sy1/stringLen1 + sy2/stringLen2;
        
        F = F1 + F2; */
            
      } 
      // top boder
      else if((j>0 && j<numVY-1) && i == 0){
        float sx1, sy1, sx2, sy2, sx3, sy3;
        sx1 = (position[i][j][0] - position[i+1][j][0]);
        sy1 = (position[i][j][1] - position[i+1][j][1]);
        float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
        float F1 = k*(stringLen1 - restLen); 
        /*float accY1 = (0.5*F1)/mass; 
        float accX1 = (0.5*F1)/mass;
        
    
        velocity[i][j][0] += accX1*dt*sx1/stringLen1;
        velocity[i][j][1] += accY1*dt*sy1/stringLen1;
        
        velocity[i+1][j][0] -= accX1*dt*sx1/stringLen1;
        velocity[i+1][j][1] -= accY1*dt*sy1/stringLen1;*/
        
        sx2 = (position[i][j][0] - position[i][j+1][0]);
        sy2 = (position[i][j][1] - position[i][j+1][1]);
        float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
        float F2 = k*(stringLen2 - restLen); 
        /*float accY2 = (0.5*F2)/mass; 
        float accX2 = (0.5*F2)/mass;
        velocity[i][j][0] += accX2*dt*sx2/stringLen2;
        velocity[i][j][1] += accY2*dt*sy2/stringLen2;
        
        velocity[i][j+1][0] -= accX2*dt*sx2/stringLen2;
        velocity[i][j+1][1] -= accY2*dt*sy2/stringLen2;*/
        
        sx3 = (position[i][j][0] - position[i][j-1][0]);
        sy3 = (position[i][j][1] - position[i][j-1][1]);
        float stringLen3 = sqrt(sx3*sx3 + sy3*sy3);
        float F3 = -k*(stringLen3 - restLen); 
        /*float accY3 = (0.5*F3)/mass; 
        float accX3 = (0.5*F3)/mass;
        
    
        velocity[i][j][0] += accX3*dt*sx3/stringLen3;
        velocity[i][j][1] += accY3*dt*sy3/stringLen3;
        
        velocity[i][j-1][0] -= accX3*dt*sx3/stringLen3;
        velocity[i][j-1][1] -= accY3*dt*sy2/stringLen3;*/
        
        /*directionX = sx1/stringLen1 + sx2/stringLen2 + sx3/stringLen3; 
        directionY = sy1/stringLen1 + sy2/stringLen2 + sx3/stringLen3;
        
        F = F1 + F2 + F3;*/
           
      } 
      // rest of the nodes
      else if ((j>0 && j<numVY-1) && (i>0 && i< numVX-1)){
        float sx1, sy1, sx2, sy2, sx3, sy3, sx4,sy4;
        sx1 = (position[i][j][0] - position[i+1][j][0]);
        sy1 = (position[i][j][1] - position[i+1][j][1]);
        //println("sx1: " + sx1 + " sy1: " + sy1);
        
        float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
        float F1 = k*(stringLen1 - restLen); 
        
        float accY1 = (0.5*F1)/mass; 
        float accX1 = (0.5*F1)/mass;
        
    
        velocity[i][j][0] += accX1*dt*sx1/stringLen1;
        velocity[i][j][1] += accY1*dt*sy1/stringLen1;
        
        velocity[i+1][j][0] -= accX1*dt*sx1/stringLen1;
        velocity[i+1][j][1] -= accY1*dt*sy1/stringLen1;
        
        sx2 = (position[i][j][0] - position[i][j+1][0]);
        sy2 = (position[i][j][1] - position[i][j+1][1]);
        //println("sx2: " + sx2 + " sy2: " + sy2);
        
        float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
        float F2 = k*(stringLen2 - restLen); 
        
        float accY2 = (0.5*F2)/mass; 
        float accX2 = (0.5*F2)/mass;
        
    
        velocity[i][j][0] += accX2*dt*sx2/stringLen2;
        velocity[i][j][1] += accY2*dt*sy2/stringLen2;
        
        velocity[i][j+1][0] -= accX2*dt*sx2/stringLen2;
        velocity[i][j+1][1] -= accY2*dt*sy2/stringLen2;
        
        sx3 = (position[i][j][0] - position[i][j-1][0]);
        sy3 = (position[i][j][1] - position[i][j-1][1]);
        //println("sx3: " + sx3 + " sy3: " + sy3);
        
        float stringLen3 = sqrt(sx3*sx3 + sy3*sy3);
        float F3 = -k*(stringLen3 - restLen);
        
        float accY3 = (0.5*F2)/mass; 
        float accX3 = (0.5*F2)/mass;
        
    
        velocity[i][j][0] += accX3*dt*sx3/stringLen3;
        velocity[i][j][1] += accY3*dt*sy3/stringLen3;
        
        velocity[i][j-1][0] -= accX3*dt*sx3/stringLen3;
        velocity[i][j-1][1] -= accY3*dt*sy3/stringLen3;
        
        sx4 = (position[i][j][0] - position[i-1][j][0]);
        sy4 = (position[i][j][1] - position[i-1][j][1]);
        //println("sx4: " + sx4 + " sy4: " + sy4);
        
        //println("**********************************");
        
        float stringLen4 = sqrt(sx4*sx4 + sy4*sy4);
        float F4 = -k*(stringLen4 - restLen); 
        float accY4 = (0.5*F4)/mass; 
        float accX4 = (0.5*F4)/mass;
        
    
        velocity[i][j][0] += accX4*dt*sx4/stringLen4;
        velocity[i][j][1] += accY4*dt*sy4/stringLen4;
        
        velocity[i-1][j][0] -= accX4*dt*sx4/stringLen4;
        velocity[i-1][j][1] -= accY4*dt*sy4/stringLen4;
        
        /*directionX = sx1/stringLen1 + sx2/stringLen2 + sx3/stringLen3 + sx4/stringLen4; 
        directionY = sy1/stringLen1 + sy2/stringLen2 + sx3/stringLen3 + sx4/stringLen4;
        
        F = F1 + F2 + F3 + F4;*/
            
      }
      float[] result = new float[3];
      result[0] = F;
      result[1] = directionX;
      result[2] = directionY;
      
      return result;
}

void draw() {
    background(255,255,255);
    for (int i = 0; i < 10; i++){
      update(1/(1.0*frameRate));
    }
    fill(0,0,0); 
    for (int i = 0; i < numVX; i++){
      for (int j= 0; j < numVY; j++){
          pushMatrix();
          
          //top left corner
          if(i == 0 && j == 0) {
                line(position[i][j][0],position[i][j][1], position[i][j+1][0],position[i][j+1][1]);
                line(position[i][j][0],position[i][j][1], position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);
          } 
          // first Column
          else if (j == 0  && (i>0 && i<(numVX-1))){
                line(position[i-1][j][0],position[i-1][j][1],position[i][j][0],position[i][j][1]);
                line(position[i][j][0],position[i][j][1],position[i][j+1][0],position[i][j+1][1]);
                line(position[i][j][0],position[i][j][1],position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);
          } 
          // right border
          else if (j == numVY-1 && (i>0 && i<numVX-1 )){
                line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                line(position[i][j][0],position[i][j][1],position[i-1][j][0],position[i-1][j][1]);
                line(position[i][j][0],position[i][j][1],position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);
          } 
          // right top corner
          else if(j == numVY-1 && i == 0){
                line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                line(position[i][j][0],position[i][j][1],position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);
          }
          // right bottom corner
          else if(j == numVY-1 && i == numVX-1){
                line(position[i][j][0],position[i][j][1],position[i-1][j][0],position[i-1][j][1]);
                line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);
          }
          //bottom border
          else if((j>0 && j<numVY-1) && i == numVX-1){
                line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                line(position[i][j][0],position[i][j][1],position[i][j+1][0],position[i][j+1][1]);
                line(position[i][j][0],position[i][j][1],position[i-1][j][0],position[i-1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);
          }
          // bottom left corner
          else if(j == 0 && i == numVY-1){
                line(position[i][j][0],position[i][j][1],position[i-1][j][0],position[i-1][j][1]);
                line(position[i][j][0],position[i][j][1],position[i][j+1][0],position[i][j+1][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);
          } 
          // top boder
          else if((j>0 && j<numVY-1) && i == 0){
                line(position[i][j][0],position[i][j][1],position[i][j+1][0],position[i][j+1][1]);
                line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                line(position[i][j][0],position[i][j][1],position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);
          } 
          else if ((j>0 && j<numVY-1) && (i>0 && i< numVX-1)){
                // rest of the nodes
                line(position[i][j][0],position[i][j][1],position[i][j-1][0],position[i][j-1][1]);
                line(position[i][j][0],position[i][j][1],position[i][j+1][0],position[i][j+1][1]);
                line(position[i][j][0],position[i][j][1],position[i-1][j][0],position[i-1][j][1]);
                line(position[i][j][0],position[i][j][1],position[i+1][j][0],position[i+1][j][1]);
                translate(position[i][j][0],position[i][j][1]);
                sphere(radius);
            
          }
            
          popMatrix();
      }
    }
}
