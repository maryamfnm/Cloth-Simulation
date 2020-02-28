float floor = 700;
float restLen = 30;
float[][][] position = new float[15][15][3];
PImage img;
float[] accX = new float[300];
float[] accY = new float[300];
float[] springForceX = new float[300];
float[] springForceY = new float[300];
float p = 1.225, c_d = 1, velx_air=2, vely_air=2, velz_air=1 ;
float sphereX = 382, sphereY =209, sphereZ =200,sphereR = 50, radius = 5;
float mass = 3, gravity = 1, k = 10, kv =10;
int numVX = 15;
int numVY = 15;
float[][][] forces = new float[15][15][3];
float[][][] velocity = new float[15][15][3];

Camera camera;
void setup() {
  size(1000, 1000, P3D);
  camera = new Camera();
  surface.setTitle("Cloth Simulation");
  img = loadImage("texture2.jpg");
  for (int i=0; i < 15; i++){
    for (int j = 0; j < 15; j++){  
      
      if (i == 0){
        if (j == 0){
          position[i][j][0] = 380;
          position[i][j][2] = 150 ;
        }
        else {
          position[i][j][0] = position[i][j-1][0] ;//+ restLen;
          position[i][j][2] = position[i][j-1][2] + restLen ;
        }
        position[i][j][1] = 50;
        
        
      } else if (j==0 && i>0){
        position[i][j][0] = 180;
        position[i][j][1] = position[i-1][j][1] ;//+ restLen;
        position[i][j][2] = position[i-1][j][2] + restLen;
      }
      else {
        position[i][j][0] = position[i][j-1][0] ;//+ restLen;
        position[i][j][1] = position[i-1][j][1] ;//+ restLen;
        position[i][j][2] = position[i][j-1][2] + restLen;
      }
      velocity[i][j][0]= 0.0;
      velocity[i][j][1]= 0.0;
      velocity[i][j][2]= 0.0;
    }
  }
  
}

void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}

void update(float dt){
  for(int i = 0; i < numVX; i++ ){
    accX[i] = 0;
    accY[i] = 0;
  }
  for (int i = 0; i < numVX ; i++){ //<>//
    for (int j=0; j< numVY; j++) {
     force(i, j,dt);
    }
  }
  for (int i = 0; i < numVX ; i++){
    for (int j=0; j< numVY; j++) {
     position[i][j][0] += velocity[i][j][0]*dt;      // Update positions x
     position[i][j][2] += velocity[i][j][2]*dt;
     
      if((i == 0 && j == 0) || (i == 0 && j == numVY-1) || (i ==0 && (0<j && j<numVY-1))){  // Update positions y
        position[i][j][1] += 0;
      } else {
        position[i][j][1] += (/*gravity*dt +*/ velocity[i][j][1])*dt;
      } 
      
      PVector clothPos = new PVector(position[i][j][0],position[i][j][1],position[i][j][2]);
      PVector spherePos = new PVector(sphereX,sphereY,sphereZ);
      PVector v = new PVector(velocity[i][j][0],velocity[i][j][1],velocity[i][j][2]);
      
      float distance = dist(position[i][j][0],position[i][j][1],position[i][j][2],sphereX,sphereY,sphereZ);
      
      if (distance < sphereR+0.09){
        PVector sphereNormal = new PVector(-(spherePos.x+ - clothPos.x), -(spherePos.y - clothPos.y),-(spherePos.z - clothPos.z)); //sphere normal //<>//
        PVector normalized = sphereNormal.normalize(); 
        float vn = v.dot(normalized);
        PVector bounce = new PVector(1.5*vn*normalized.x, 1.5*vn*normalized.y, 1.5*vn*normalized.z);
        println("spehresPos: " + spherePos.x + "  " + spherePos.y + "  " + spherePos.z);
        println("clothPos: " + clothPos.x + "  " + clothPos.y + "  " + clothPos.z);
        v.sub(bounce);
        PVector newNormal = new PVector(sphereNormal.x*(0.1 + sphereR - distance), sphereNormal.y*(0.1 + sphereR - distance),sphereNormal.z*(0.1 + sphereR - distance));
        clothPos.add(newNormal); // move out
        
      }
      if (position[i][j][1]+radius > floor){      // Collision detection with ground
        velocity[i][j][1] *= -.9;
        position[i][j][1] = floor - radius;
      }
    }
  }
}

PVector drag(PVector[] pos){          // calculating drag force
      PVector r2_r1 = pos[1].sub(pos[0]);
      PVector r3_r1 = pos[2].sub(pos[0]);
      PVector cross_product_vector = r2_r1.cross(r3_r1);
      float len = sqrt(cross_product_vector.x*cross_product_vector.x + cross_product_vector.y*cross_product_vector.y + cross_product_vector.z*cross_product_vector.z);
      PVector normalVec = cross_product_vector.div(len);
      float a_zero = 0.5*(len);
      
      float vel_x = (pos[0].x + pos[1].x + pos[2].x)/3;
      float vel_y = (pos[0].y + pos[1].y + pos[2].y)/3;
      float vel_z = (pos[0].z + pos[1].z + pos[2].z)/3;
      PVector total_velocity = new PVector(vel_x - velx_air, vel_y - vely_air, vel_z - velz_air);
      float vn = normalVec.x*total_velocity.x + normalVec.y*total_velocity.y + normalVec.z*total_velocity.z;
      float normVelocity = sqrt(total_velocity.x*total_velocity.x + total_velocity.y*total_velocity.y + total_velocity.z*total_velocity.z);
      float area = a_zero*(vn/normVelocity);
      
      PVector Aerodynamic_Force = new PVector((-0.5*p*(normVelocity*normVelocity)*c_d*area)*normalVec.x,
                                              (-0.5*p*(normVelocity*normVelocity)*c_d*area)*normalVec.y,
                                              (-0.5*p*(normVelocity*normVelocity)*c_d*area)*normalVec.z); 
      return Aerodynamic_Force;
}

void calculate_force(float dragForce,int i, int j, int n, int m, float dt){      // Calculate the force and velocity for each mass 
      float sx, sy, sz;
      sx = (position[i][j][0] - position[n][m][0]);
      sy = (position[i][j][1] - position[n][m][1]);
      sz = (position[i][j][2] - position[n][m][2]);
      float stringLength = sqrt(sx*sx + sy*sy + sz*sz);
      float vx = (velocity[i][j][0]*sx/stringLength - velocity[n][m][0]*sx/stringLength);
      float vy = (velocity[i][j][1]*sy/stringLength - velocity[n][m][1]*sy/stringLength);
      float vz = (velocity[i][j][2]*sz/stringLength - velocity[n][m][2]*sz/stringLength);
      float projVel = vx + vy + vz;
      float dampForce = -kv*(projVel);
      float F_X = (-k*(stringLength - restLen) + dampForce + dragForce)*sx/stringLength;
      float F_Y = (-k*(stringLength - restLen) + dampForce + dragForce)*sy/stringLength;
      float F_Z = (-k*(stringLength - restLen) + dampForce + dragForce)*sz/stringLength;
      float[] F = new float[3];
      F[0] = F_X;  F[1] = F_Y; F[2] = F_Z;
      
      float accX = (0.5*F_X)/mass;
      float accY = gravity  + (0.5*F_Y)/mass;
      float accZ = (0.5*F_Z)/mass;
      velocity[i][j][0] += accX*dt;
      velocity[i][j][1] += accY*dt;
      velocity[i][j][2] += accZ*dt;
}

void force(int i, int j, float dt){
      // first Column
      if (j == 0  && (i>0 && i<(numVX-1))){
       PVector t1_r1 = new PVector(i, j);
       PVector t1_r2 = new PVector(i-1, j);
       PVector t1_r3 = new PVector(i, j+1);
       PVector[] position_vertecies_1 = {t1_r1, t1_r2, t1_r3};
       PVector drag1 = drag(position_vertecies_1);
       float d1 = (drag1.x + drag1.y + drag1.z)/3;
       
       PVector t2_r1 = new PVector(i, j);
       PVector t2_r2 = new PVector(i+1, j);
       PVector t2_r3 = new PVector(i, j+1);
       PVector[] position_vertecies_2 = {t2_r1, t2_r2, t2_r3};
       PVector drag2 = drag(position_vertecies_2);
       float d2 = (drag2.x + drag2.y+ drag1.z)/3;
       
       calculate_force(d1,i,j,i-1,j,dt);
       calculate_force(d2,i,j,i+1,j,dt); 
       calculate_force(d1+d2,i,j,i,j+1,dt);
      } 
      // right border
      else if (j == numVY-1 && (i>0 && i<numVX-1 )){
        PVector t1_r1 = new PVector(i, j);
        PVector t1_r2 = new PVector(i-1, j);
        PVector t1_r3 = new PVector(i, j-1);
        PVector[] position_vertecies_1 = {t1_r1, t1_r2, t1_r3};
        PVector drag1 = drag(position_vertecies_1);
        float d1 = (drag1.x + drag1.y + drag1.z)/3;
       
        PVector t2_r1 = new PVector(i, j);
        PVector t2_r2 = new PVector(i+1, j);
        PVector t2_r3 = new PVector(i, j-1);
        PVector[] position_vertecies_2 = {t2_r1, t2_r2, t2_r3};
        PVector drag2 = drag(position_vertecies_2);
        float d2 = (drag2.x + drag2.y + drag1.z)/3;
        
        calculate_force(d1,i,j,i-1,j,dt);
        calculate_force(d2,i,j,i+1,j,dt);
        calculate_force(d1+d2,i,j,i,j-1,dt);
      } 
      // right bottom corner
      else if(j == numVY-1 && i == numVX-1){
        PVector t1_r1 = new PVector(i, j);
        PVector t1_r2 = new PVector(i-1, j);
        PVector t1_r3 = new PVector(i, j-1);
        PVector[] position_vertecies_1 = {t1_r1, t1_r2, t1_r3};
        PVector drag1 = drag(position_vertecies_1);
        float d1 = (drag1.x + drag1.y + drag1.z)/3;
       
        calculate_force(d1,i,j,i-1,j,dt);
        calculate_force(d1,i,j,i,j-1,dt);
      }
      //bottom border
      else if((j>0 && j<numVY-1) && i == numVX-1){
        PVector t1_r1 = new PVector(i, j);
        PVector t1_r2 = new PVector(i-1, j);
        PVector t1_r3 = new PVector(i, j-1);
        PVector[] position_vertecies_1 = {t1_r1, t1_r2, t1_r3};
        PVector drag1 = drag(position_vertecies_1);
        float d1 = (drag1.x + drag1.y+ drag1.z)/3;
       
        PVector t2_r1 = new PVector(i, j);
        PVector t2_r2 = new PVector(i-1, j);
        PVector t2_r3 = new PVector(i, j+1);
        PVector[] position_vertecies_2 = {t2_r1, t2_r2, t2_r3};
        PVector drag2 = drag(position_vertecies_2);
        float d2 = (drag2.x + drag2.y+ drag1.z)/3;
        calculate_force(d1+d2,i,j,i-1,j,dt);
        calculate_force(d2,i,j,i,j+1,dt);
        calculate_force(d1,i,j,i,j-1,dt);
      }
      // bottom left corner
      else if(j == 0 && i == numVX-1){
        PVector t1_r1 = new PVector(i, j);
        PVector t1_r2 = new PVector(i-1, j);
        PVector t1_r3 = new PVector(i, j+1);
        PVector[] position_vertecies_1 = {t1_r1, t1_r2, t1_r3};
        PVector drag1 = drag(position_vertecies_1);
        float d1 = (drag1.x + drag1.y+ drag1.z)/3;
        calculate_force(d1,i,j,i-1,j,dt);
        calculate_force(d1,i,j,i,j+1,dt);
      }
      // rest of the nodes
      else if ((j>0 && j<numVY-1) && (i>0 && i< numVX-1)){
        PVector t1_r1 = new PVector(i, j);
        PVector t1_r2 = new PVector(i+1, j);
        PVector t1_r3 = new PVector(i, j-1);
        PVector[] position_vertecies_1 = {t1_r1, t1_r2, t1_r3};
        PVector drag1 = drag(position_vertecies_1);
        float d1 = (drag1.x + drag1.y+ drag1.z)/3;
       
        PVector t2_r1 = new PVector(i, j);
        PVector t2_r2 = new PVector(i+1, j);
        PVector t2_r3 = new PVector(i, j+1);
        PVector[] position_vertecies_2 = {t2_r1, t2_r2, t2_r3};
        PVector drag2 = drag(position_vertecies_2);
        float d2 = (drag2.x + drag2.y+ drag1.z)/3;
        
        PVector t3_r1 = new PVector(i, j);
        PVector t3_r2 = new PVector(i-1, j);
        PVector t3_r3 = new PVector(i, j-1);
        PVector[] position_vertecies_3 = {t3_r1, t3_r2, t3_r3};
        PVector drag3 = drag(position_vertecies_3);
        float d3 = (drag3.x + drag3.y+ drag1.z)/3;
        
        PVector t4_r1 = new PVector(i, j);
        PVector t4_r2 = new PVector(i-1, j);
        PVector t4_r3 = new PVector(i, j+1);
        PVector[] position_vertecies_4 = {t4_r1, t4_r2, t4_r3};
        PVector drag4 = drag(position_vertecies_4);
        float d4 = (drag4.x + drag4.y+ drag1.z)/3;
         
        calculate_force(d1+d2,i,j,i+1,j,dt);
        calculate_force(d2+d4,i,j,i,j+1,dt);
        calculate_force(d1+d3,i,j,i,j-1,dt);
        calculate_force(d3+d4,i,j,i-1,j,dt);
      }
}

void draw() {
    background(255,255,255);
    for (int i = 0; i < 10; i++){
      update(1/(3.0*frameRate));
    }
    noLights();
    
    camera.Update( 1.0/frameRate );
 
    noFill();
    noStroke();  
    for (int i = 0; i < numVX-1; i++){
      
      for (int j= 0; j < numVY-1; j++){
          pushMatrix();
          textureMode(NORMAL);
          beginShape(QUAD);
          texture(img);
          float u1 = map(i, 0, numVX, 0, 1);
          float v1 = map(j+1, 0, numVY, 0, 1);
          float u2 = map(i+1, 0, numVX, 0, 1);
          float v2 = map(j, 0, numVY, 0, 1);
          vertex(position[i][j][0],position[i][j][1],position[i][j][2], u1,v2);
          vertex(position[i][j+1][0],position[i][j+1][1], position[i][j+1][2],u1,v1);
          vertex(position[i+1][j+1][0],position[i+1][j+1][1], position[i+1][j+1][2],u2,v1);
          vertex(position[i+1][j][0],position[i+1][j][1], position[i+1][j][2],u2,v2);
          endShape();
          popMatrix();
      }
    }
    stroke(0);
    translate(sphereX,sphereY,sphereZ);
    fill(0, 163, 102);
    sphere(sphereR); 
}
    
