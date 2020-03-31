PGraphics pg;
float r;
int colrl=3;//37;
int colrm=7;//257;
IntList colors = new IntList();
int [] myPix;
int q=1;
float ra;
int ri;
float scale=1;//8.0/3.0;

void setup() {
  fullScreen(P2D);
  background(#FF00FF);
  //frameRate(640/scale/scale/9.0);
  frameRate(30);
  r=sqrt(pixelWidth*pixelWidth+pixelHeight*pixelHeight)/2.0;
  ri=floor(r/scale+0.5);
  ra=atan2(scale, r)*pixelWidth/32;
  myPix = new int[ri*(ri+1)/2];
  pg = createGraphics(ri, ri, P2D);
  pg.beginDraw();
  pg.background(0x00FF00FF);
  pg.endDraw();
  colorMode(HSB, 360, 100, 100);
  for (int i=0; i<colrl; i++) {
    float a=180;
    float h=sqrt(random(a*a, (a+200)*(a+200)))%360;
    float s=random(0, 60);
    float b=random(60, 90);
    colors.append(color(h, s, b, 192));
  }
  colors.sort();
  for (int i=0; i<myPix.length; i++)
    myPix[i]=0;
}

void drawEighth() {
  pg.beginDraw();
  pg.loadPixels();
  float angle=atan2(scale, r);
  float a=0;
  //println(r*tan(angle));
  boolean once = false;
  int idx2=0;
  for (int i=0; i<ri&&a<=QUARTER_PI; a+=angle, i=floor(ri*tan(a)))
  {
    for (int j=0; j<ri; j++)
    {
      int x=j*i/ri;
      int idx=myPix.length - (j+1)*(j+2)/2+x;
      if(!once&&myPix[idx]==0) {
        once=true;
        idx2=idx;
      }
      if (once)
        myPix[idx]=myPix[idx]+1;
      //      if (myPix[idx]!=0&&q%colrl!=0)
      pg.pixels[x+ri*(ri-j-1)]=colors.get(myPix[idx]%colrl);
    }
  }
  if(once) {
    colrm=myPix[idx2]+1;
  }
  pg.updatePixels();
  pg.endDraw();
  colorMode(HSB, 360, 100, 100);
  float al; float h; float s; float b;
  if (colrl<colrm) {
    colrl++;
    al=180;
    h=sqrt(random(al*al, (al+200)*(al+200)))%360;
    s=random(0, 60);
    b=random(60, 90);
    colors.append(color(h,s,b,192));
  }
  int breathe = floor(random(-1,1)+0.5);
  if(breathe<0)
    breathe=colors.size()+breathe;
  //for(int i=0; i<abs(breathe); i++)
  //{
    al=180;
    h=sqrt(random(al*al, (al+200)*(al+200)))%360;
    s=random(0, 60);
    b=random(60, 90);
    //if(breathe<0)
      //colors.reverse();
    colors.remove(0);//floor(random(0,colors.size()/2)+0.5));
    colors.append(color(h,s,b,192));
    //if(breathe<0)
      //colors.reverse();
  //}
  //colors.shuffle();
}

void draw() {
  //if (q%floor(60.0/7)==0)
    drawEighth();
  pushMatrix();
  translate(pixelWidth/2.0, pixelHeight/2.0);
  scale(1, -1);
  rotate(-q*ra/2.0);
  for (int i=0; i<4; i++)
  {
    scale(1, -1);
    image(pg, 0, -r,r,r);
    scale(-1, 1);
    image(pg, 0, -r,r,r);
    rotate(HALF_PI);
  }
  rotate(q*ra-17*q*ra*7/16);
  stroke(0xC0A8306C);
  strokeWeight(scale);
  for (float i=0; i<r; i=(i+scale/16.0)*0.99997) {
    line(r-i, r-i, r-i-6+2*scale, r-i-4);
    rotate(-ra/16);
  }
  strokeWeight(1);
  popMatrix();
  //colors.sort();
  q++;
}
