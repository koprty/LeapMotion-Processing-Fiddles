//Developed by Lise Ho
//adapted from examples from https://github.com/heuermh/leap-motion-processing
/*
Adapted from: 
    Leap Motion library for Processing.
    Copyright (c) 2012-2015 held jointly by the individual authors.
*/

/*
This files renders two hands and corresponding fingers sensed by the Leap Motion. 
*/
import java.util.Map;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentHashMap;

import com.leapmotion.leap.Bone;
import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.HandList;
import com.leapmotion.leap.Tool;
import com.leapmotion.leap.Vector;
import com.leapmotion.leap.processing.LeapMotion;

LeapMotion leapMotion;

ConcurrentMap<Integer, Integer> fingerColors;
ConcurrentMap<Integer, Integer> toolColors;
ConcurrentMap<Integer, Integer> handColors;
ConcurrentMap<Integer, Vector> fingerPositions;
ConcurrentMap<Integer, Vector> bonePositions;
ConcurrentMap<Integer, Vector> toolPositions;
ConcurrentMap<Integer, Vector> handPositions;
int[] backColors;
int[] change;
int i = 0;
void setup()
{
  size(800,450);
  background(20);
  frameRate(60);
  ellipseMode(CENTER);

  leapMotion = new LeapMotion(this);
  fingerColors = new ConcurrentHashMap<Integer, Integer>();
  toolColors = new ConcurrentHashMap<Integer, Integer>();
    handColors = new ConcurrentHashMap<Integer, Integer>();
  fingerPositions = new ConcurrentHashMap<Integer, Vector>();
  toolPositions = new ConcurrentHashMap<Integer, Vector>();
    handPositions = new ConcurrentHashMap<Integer,Vector>();
      bonePositions = new ConcurrentHashMap<Integer, Vector>();
      backColors = new int[3];
      change = new int[3];
      change[0] = 2;
      change[1] = 2;
      change[2] = 2;
}
color backgroundC()
{
  if (backColors[i] <= 10){
      change[i] = 2;
      backColors[i] += change[i];
    }else if (backColors[i] >= 220){
      change[i] = -2;
      backColors[i] += change[i];
      if (i == 2){
        i=0;
      }else{
        i+=1;
      }
    }else{
      backColors[i] += change[i];
    }
  return color(backColors[0],backColors[1],backColors[2]);
}
void draw()
{
  fill(backgroundC());
  rect(0, 0, width, height);
  for (Map.Entry entry : toolPositions.entrySet())
  {
    Integer toolId = (Integer) entry.getKey();
    Vector position = (Vector) entry.getValue();
    fill(toolColors.get(toolId));
    noStroke();
    ellipse(leapMotion.leapToSketchX(position.getX()), leapMotion.leapToSketchY(position.getY()), 24.0, 24.0);
  }
  for (Map.Entry entry : handPositions.entrySet())
  {
    Integer handId = (Integer) entry.getKey();
    Vector position = (Vector) entry.getValue();
    fill(192,23,12);
    noStroke();
    float handX = leapMotion.leapToSketchX(position.getX());
    float handY = leapMotion.leapToSketchY(position.getY());
    
    ellipse(handX, handY, 24.0, 24.0);
    
   for (Map.Entry Fentry : fingerPositions.entrySet()){
    Integer fingerId = (Integer) Fentry.getKey();
      Vector Fposition = (Vector) Fentry.getValue();
    
    //fill(fingerColors.get(fingerId));
    int handFid = fingerColors.get(fingerId);
    noStroke();
    float Fx = leapMotion.leapToSketchX(Fposition.getX());
    float Fy = leapMotion.leapToSketchY(Fposition.getY());
    fill(handColors.get(handFid));
    ellipse(Fx,Fy, 24.0, 24.0);
    if (handFid == handId){
      stroke(126);
      strokeWeight(4);
      line(handX,handY, Fx, Fy);
      }
   }
   /*
  for (Map.Entry Fentry : bonePositions.entrySet()){
    //Integer boneId = (Integer) Fentry.getKey();
     Vector Fposition = (Vector) Fentry.getValue();
    
    color s = color(40,40,40);
    fill(s);
    noStroke();
    float Fx = leapMotion.leapToSketchX(Fposition.getX());
    float Fy = leapMotion.leapToSketchY(Fposition.getY());
    ellipse(Fx,Fy, 5.0, 5.0);
    
   }
   */
  }
}

void onFrame(final Controller controller)
{
  Frame frame = controller.frame();
  handPositions.clear();
  fingerPositions.clear();
  for (Hand hand : frame.hands()){
    int handId = hand.id();
    color hc = color(random(0, 255), random(0, 255), random(0, 255));
    handColors.putIfAbsent(handId,hc);
    handPositions.put(handId, hand.stabilizedPalmPosition());
    for (Finger finger : hand.fingers()){
      
      int boneId = -1;
       for(Bone.Type boneType : Bone.Type.values()) {
          Bone bone = finger.bone(boneType);
          boneId = boneId + 1;
          bonePositions.put(boneId,bone.center());
        }
        
       int fingerId = finger.id();
      //color c = color(random(0, 255), random(0, 255), random(0, 255));
      fingerColors.putIfAbsent(fingerId, handId);
      fingerPositions.put(fingerId, finger.tipPosition());
    }
  }
  
  /*
  for (Finger finger : frame.fingers())
  {
    int fingerId = finger.id();
    color c = color(random(0, 255), random(0, 255), random(0, 255));
    fingerColors.putIfAbsent(fingerId, c);
    fingerPositions.put(fingerId, finger.tipPosition());
  }
  */
  
  toolPositions.clear();
  for (Tool tool : frame.tools())
  {
    int toolId = tool.id();
    color c = color(random(0, 255), random(0, 255), random(0, 255));
    toolColors.putIfAbsent(toolId, c);
    toolPositions.put(toolId, tool.tipPosition());
  }
  
  
}