  
import processing.net.*; 
Client myClient; 
String dataIn; 
Table ACtable;
float myLat,myLong;
PImage img;
float Scalerx,Scalery;
int Pointx[]={0,0,0},Pointy[]={0,0,0};
float PointLong[]={0,0,0},PointLat[]={0,0,0};
float Offsetx,Offsety;
float x,y;
int imgwidth,imgheight;

void setup() { 
  size(800, 600); 
  frameRate(30);
  noSmooth();
  background(0);
    String file = "atc_lon-tma";
    //String file = "atc_lhr_apt";
    img = loadImage(file+"/"+file+".jpg");
    imgwidth =img.width;
    imgheight =img.height;
    String lines[] = loadStrings(file+"/"+file+".clb");
    for (int p=0;p<lines.length;p++){
      String line[] = split(lines[p],',');
      Offsetx=30;Offsety=250;
      Pointx[p]=int(line[2]);
      Pointy[p]=int(line[3]);
      PointLat[p]=float(line[6])+(float(line[7]))/60;
      PointLong[p]=float(line[9])+float(line[10])/60;
      if (line[8].equals("S")==true) {PointLat[p] = -PointLat[p];}
      if (line[11].equals("W")==true) {PointLong[p]=-PointLong[p];}
      
    }
  
 
  // Connect to the local machine at port 30003.
  // This example will not run if you haven't
  // previously started a server on this port.
  myClient = new Client(this, "192.168.0.11", 30003); 
  //myClient = new Client(this, "localhost", 30003);
  //Setup Table of Aircraft
  ACtable = new Table();
  ACtable.addColumn("ICAO");
  ACtable.addColumn("Lat");
  ACtable.addColumn("Long");
  ACtable.addColumn("LastSeen");
  ACtable.addColumn("CallSign");
  ACtable.addColumn("Altitude");
  ACtable.addColumn("Track");
  ACtable.addColumn("GS");
  ACtable.addColumn("VR");
  ACtable.addColumn("Squawk");
} 
 
void draw() { 
  
    int MSG,Altitude,VR,GS,Track,Squawk;
    String ICAO,CallSign;
    float Lat,Long,RLat,RLong,GLat,GLong,Scaler;
    Scaler =1;
    //Convert Long/Lat to x-y scaler
    Scalerx=((Pointx[1]-Pointx[0])/(PointLong[1]-PointLong[0]))*1/Scaler;
    Scalery=((Pointy[2]-Pointy[0])/(PointLat[2]-PointLat[0]))*1/Scaler;
  if (myClient.available() > 0) { 
    dataIn = myClient.readStringUntil(10); 
    
    String[] columns = split(dataIn,','); 
    try {
    MSG=int(columns[1]);
    ICAO=(columns[4]);
  } catch (NullPointerException e) {
    // Null pointer error
    e.printStackTrace(); 
    MSG=0;ICAO="0";
  } 
TableRow row;
 row = ACtable.findRow(ICAO,"ICAO");
 if (row == (null)) {row=ACtable.addRow();}
   // Get Long/Lat
 if (MSG == 2| MSG == 3){
   Lat= float(columns[14]);
   Long = float(columns[15]);
   row.setFloat("Lat",Lat);
   row.setFloat("Long",Long);
 }
 // Get Call Sign
 if (MSG == 1){
   CallSign=columns[10]; 
   row.setString("CallSign",CallSign);
 }
 // Get Altitude
 if (MSG == 2| MSG == 3|MSG == 5| MSG == 6 |MSG ==7){
   Altitude=int(columns[11]);
   row.setInt("Altitude",Altitude);
 }
 // Get Ground Speed and Track
 if (MSG == 2|MSG == 4){
   GS=int(columns[12]);
   Track=int(columns[13]);
   row.setInt("GS",GS);
   row.setInt("Track",Track);
   
 }
 Get Vertical Speed
 if (MSG == 4){ 
 VR =int(columns[16]);
 row.setInt("VR",VR);}
 Get Squawk Code
 if (MSG == 6){ 
 Squawk =int(columns[17]);
 row.setInt("Squawk",Squawk);}
 // Get 24Bit Code
   row.setString("ICAO",ICAO);
   //Last seen
   row.setInt("LastSeen",minute());
  }
  background(10);
 clear();
 // Display Chart 
  image(img, -Offsetx, -Offsety,Scaler*imgwidth,Scaler*imgheight);
 
 //Display Aircraft and Details
 for (int i=0;i<ACtable.getRowCount();i++){
   TableRow row=ACtable.getRow(i);
   Lat=row.getFloat("Lat");
   Long=row.getFloat("Long");
   ICAO=row.getString("ICAO");
   CallSign=row.getString("CallSign");
   VR=row.getInt("VR");
   
   Track=row.getInt("Track");
   GS=row.getInt("GS");
   Squawk=row.getInt("Squawk");
   Altitude=row.getInt("Altitude");
   int LastSeen=minute()-row.getInt("LastSeen");
   //println(ICAO);
   stroke(153);
   ellipse (600,300, 5,5);
   textSize(12);
   y=((PointLat[0]-Lat)*-Scalery)+(Pointy[0]-Offsety);
   x=((PointLong[0]-Long)*-Scalerx)+(Pointx[0]-Offsetx);
   fill(150,155,0);
   point(x,y);
   if (CallSign == (null)) CallSign="?";
   text(CallSign+" "+Squawk,x,y-10);
   if (LastSeen>1) ACtable.removeRow(i);
   textSize(9);
   text(Altitude+"ft "+LastSeen,x,y);
   String Sig;
   Sig="";
   if (VR>0){Sig="U";}
   text(Sig+VR+"ft "+GS+"kt "+Track+"Deg",x,y+10);
   
   
 }
 /*
  float LHRLat = 51.4775,LHRLong = -0.4614;
  float LGWLat = 51.1481,LGWLong = -0.1903;
  float EGLFLat= 51.275833,EGLFLong = -0.776332;
 for (int u=0;u<3;u++){
   
   
   //fill(150,155,0);
   //ellipse(Pointx[u],Pointy[u],10,50);
   //fill(0,0,255);
   //y=((PointLat[0]-PointLat[u])*-Scalery)+(Pointy[0]-Offsety);
   //x=((PointLong[0]-PointLong[u])*-Scalerx)+(Pointx[0]-Offsetx);
   //ellipse(x,y,20,20);
   //fill(0,255,0);
   fill(125,20,25);   
   y=((PointLat[0]-EGLFLat)*-Scalery)+Pointy[0]-Offsety;
   x=((PointLong[0]-EGLFLong)*-Scalerx)+Pointx[0]-Offsetx;
   ellipse(x,y,10,10);
   fill(0,250,255);   
   y=((PointLat[0]-LHRLat)*-Scalery)+Pointy[0]-Offsety;
   x=((PointLong[0]-LHRLong)*-Scalerx)+Pointx[0]-Offsetx;
   ellipse(x,y,10,10);
   y=((PointLat[0]-LGWLat)*-Scalery)+Pointy[0]-Offsety;
   x=((PointLong[0]-LGWLong)*-Scalerx)+Pointx[0]-Offsetx;
   ellipse(x,y,10,10);
  text(Scalerx+" "+Scalery,20,20);
  text(x+" "+y,20,30);
 }
  */
 
  
  }

