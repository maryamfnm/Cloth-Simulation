 //<>// //<>// //<>//
//Ball on Spring (damped)
//CSCI 5611 Thread Sample Code


void setup() {
  size(400, 400, P3D);
  surface.setTitle("Ball on Spring!");
  
}

float floor = 400;
float restLen = 30;
float ballX1 = 180, ballX2 = 170, ballX3 = 160, ballX4 = 150, ballX5 = 140;
float ballY1 = 110, ballY2 = ballY1 + restLen , ballY3 = ballY2 + restLen, ballY4 = ballY3 + restLen, ballY5 = ballY4 + restLen;
float radius = 5;
float anchorX = 200;
float anchorY = ballY1 - restLen;

float mass = 4;
float gravity = 5;
float k = 10; //1 1000
float kv = 100;

float[][] position = {{ballX1,ballY1}, {ballX2,ballY2},{ballX3,ballY3},{ballX4,ballY4},{ballX5,ballY5}};
float[][] velocity = {{0,0}, {0,0},{0,0}, {0,0},{0,0}};
float[] accX = new float[300];
float[] accY = new float[300];
float[] springForceX = new float[300];
float[] springForceY = new float[300];

int numV = 5;

void update(float dt){
  for(int i = 0; i < numV; i++ ){
    accX[i] = 0;
    accY[i] = 0;
  }
  for (int i = 0; i < numV ; i++){
      float sx, sy;
      if (i == 0) {
        sx = (position[i][0] - anchorX);
        sy = (position[i][1] - anchorY);
      } else {
        sx = position[i][0] - position[i-1][0];
        sy = position[i][1] - position[i-1][1];
      } 
      float stringLen = sqrt(sx*sx + sy*sy);
      float stringF = -k*(stringLen - restLen);   // Calculating the force
      float dirX = sx/stringLen;    // direction of the force - X
      float dirY = sy/stringLen;    // direction of the force - Y
      
      float dampF, projVelTotal;        // Line 53 to 64 is implementing dampening functionality
      if (i == 0) {
          float vel_x = velocity[i][0]*dirX;    // if the ball is the first ball that is connected to the hook
          float vel_y = velocity[i][1]*dirY;
          projVelTotal = vel_x + vel_y;
          
      } else {
          float vel_x = velocity[i][0]*dirX - velocity[i-1][0]*dirX;
          float vel_y = velocity[i][1]*dirY - velocity[i-1][1]*dirY;
          projVelTotal = vel_x + vel_y;
      }
      dampF = -kv*(projVelTotal);
      
      springForceX[i] = (stringF+dampF)*dirX;      // Calculate Spring Forces for x and y 
      springForceY[i] = (stringF+dampF)*dirY;

      if(i == numV-1){
        accY[i] = gravity + (0.5*springForceY[i])/mass; 
        accX[i] = springForceX[i]/mass;
      } else {
        accY[i] = gravity + 0.5*springForceY[i]/mass -  0.5*springForceY[i+1]/mass; 
        accX[i] = (0.5*springForceX[i]/mass) - (0.5*springForceX[i+1]/mass);
      }
      velocity[i][0] += accX[i]*dt;
      velocity[i][1] += accY[i]*dt;
      
      accX[i] = 0;
      accY[i] = 0.0;
      position[i][0] += velocity[i][0]*dt;      // Update positions
      position[i][1] += velocity[i][1]*dt;
     
            //<>//
      if (position[i][1]+radius > floor){      // Collision detection with ground
        velocity[i][1] *= -.9;
        position[i][1] = floor - radius;
      }
      
    }
}

void draw() {
  background(255,255,255);
  for (int i = 0; i < 10; i++){
    update(1/(1.0*frameRate));
  }
  fill(0,0,0); 
  for (int i = 0; i < numV; i++){
    pushMatrix();
    if(i == 0) {
      line(anchorX,anchorY,position[i][0],position[i][1]);
      translate(position[i][0],position[i][1]);
      sphere(radius);
    } 
    else {
      line(position[i-1][0],position[i-1][1],position[i][0],position[i][1]);
      translate(position[i][0],position[i][1]);
      sphere(radius);
    }
    popMatrix();
  }
  
}
