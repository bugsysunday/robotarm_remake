  /**
 * ControlP5 Slider set value
 * changes the value of a slider on keyPressed
 *
 * by Andreas Schlegel, 2012
 * www.sojamo.de/libraries/controlP5
 *
 */
import static javax.swing.JOptionPane.*;
import controlP5.*;
import cc.arduino.*;
import processing.serial.*;
boolean start =false;
final boolean debug = true;

Serial myPort;        // The serial port

ControlP5 cp5;

Arduino arduino; 
//console
int c = 0;
Println console;
Textarea myTextarea;
String groundinput, secinput, tecinput, aboveinput, topinput, clawinput, smoothinput;

int myColorBackground = color(0,0,0);

//move smooth
int smomov=15;
int ground =90;
int sec = 90;
int tec = 90;
int above = 90;
int top =90;
int claw = 96;
int oground, osec, otec, oabove, otop, oclaw;
int s1ground,s1sec,s1tec,s1above,s1top,s1claw;
int s2ground,s2sec,s2tec,s2above,s2top,s2claw;
int s3ground,s3sec,s3tec,s3above,s3top,s3claw;
int s4ground,s4sec,s4tec,s4above,s4top,s4claw;
int pground=90;
int psec=90;
int ptec=90;
int pabove=90;
int ptop=90;
int pclaw=96;
int parkground=90;
int parksec=130;
int parktec=90;
int parkabove=90;
int parktop =90;
int parkclaw = 96;
void setup() {  
  size(600,400);
String COMx, COMlist = "";

println(Arduino.list());
PFont fontinput = createFont("arial",14);
  noStroke();
  cp5 = new ControlP5(this);
  cp5.enableShortcuts();
  frameRate(10);
  myTextarea = cp5.addTextarea("txt")
                  .setPosition(175, 75)
                  .setSize(210, 210)
                  .setFont(createFont("", 10))
                  .setLineHeight(14)
                  .setColor(color(200))
                  .setColorBackground(color(0, 100))
                  .setColorForeground(color(255, 100));
                 
  console = cp5.addConsole(myTextarea);
  
  


  cp5.addButton("getpos").setLabel("GET POS").setPosition(5,295).setSize(40,30).update();  
  cp5.addButton("con").setPosition(5,225).setSize(40,30);
  cp5.addButton("PARK").setPosition(5,260).setSize(40,30);
  cp5.addButton("parksave").setPosition(5,10).setSize(32,10).setLabel("S");
  cp5.addButton("set1").setPosition(5,90).setLabel("SET1").setSize(40,20);
  cp5.addButton("set1s").setPosition(45,90).setLabel("save").setSize(40,20).setVisible(false);  
  cp5.addButton("set1l").setPosition(85,90).setLabel("load").setSize(40,20).setVisible(false);  
  cp5.addButton("set2").setPosition(5,110).setLabel("SET2").setSize(40,20);
  cp5.addButton("set2s").setPosition(45,110).setLabel("save").setSize(40,20).setVisible(false);
  cp5.addButton("set2l").setPosition(85,110).setLabel("load").setSize(40,20).setVisible(false);   
  cp5.addButton("set3").setPosition(5,130).setLabel("SET3").setSize(40,20);
  cp5.addButton("set3s").setPosition(45,130).setLabel("save").setSize(40,20).setVisible(false);
  cp5.addButton("set3l").setPosition(85,130).setLabel("load").setSize(40,20).setVisible(false);
  cp5.addButton("set4").setPosition(5,150).setLabel("set4").setSize(40,20);
  cp5.addButton("set4s").setPosition(45,150).setLabel("save").setSize(40,20).setVisible(false);   
  cp5.addButton("set4l").setPosition(85,150).setLabel("load").setSize(40,20).setVisible(false);

  cp5.addButton("setmov").setPosition(5,60).setLabel("setmove").setSize(40,30);
  cp5.addSlider("smomov").setRange(0,100).setLabel("smooth steps").setValue(smomov).setPosition(45,60).setSize(255, 30).setVisible(false).getTriggerEvent();    

  
  cp5.addSlider("ground").setRange(154,40).setValue(ground).setNumberOfTickMarks(180).setPosition(75,365).setSize(470,30).getTriggerEvent();  
  cp5.addButton("setground").setPosition(5,365).setSize(30,30).setLabel("OK").setOn().setId(1);    
  cp5.addTextfield("groundinput").setPosition(40, 365).setLabel("ground").setSize(30, 30).setFont(fontinput);

  cp5.addSlider("sec").setRange(180,23).setValue(sec).setPosition(50,85).setSize(30,195).setVisible(true).getTriggerEvent(); 
  cp5.addTextfield("secinput").setPosition(50, 295).setLabel("").setSize(30, 30).setFont(fontinput);
  cp5.addButton("setsec").setPosition(50,330).setSize(30,30).setLabel("OK").setOn().setId(2);
 
  cp5.addSlider("tec").setRange(23,180).setValue(tec).setPosition(100,75).setSize(30,200).setVisible(true).getTriggerEvent();  
  cp5.addTextfield("tecinput").setLabel("").setPosition(100,290).setSize(30, 30).setFont(fontinput);
  cp5.addButton("settec").setPosition(100,325).setSize(30,30).setLabel("OK").setOn().setId(3);
 
  cp5.addSlider("above").setRange(150,8).setValue(above).setPosition(245,40).setSize(300,30).getTriggerEvent() ; 
  cp5.addTextfield("aboveinput").setPosition(210,40).setLabel("").setSize(30, 30).setFont(fontinput);
  cp5.addButton("setabove").setPosition(175,40).setSize(30,30).setLabel("OK").setOn().setId(4);
 
  cp5.addSlider("top").setRange(165,10).setValue(top).setPosition(285,5).setSize(295,30).getTriggerEvent(); 
  cp5.addTextfield("topinput").setPosition(250, 5).setSize(30, 30).setLabel("").setFont(fontinput);
  cp5.addButton("setop").setPosition(215,5).setSize(30,30).setLabel("OK").setOn().setId(5);
 
  cp5.addSlider("claw").setRange(96,150).setValue(claw).setPosition(550,110).setSize(30,180).getTriggerEvent();  
  cp5.addTextfield("clawinput").setPosition(550, 305).setSize(30, 30).setLabel("").setFont(fontinput);
  cp5.addButton("setclaw").setPosition(550,340).setSize(30,30).setLabel("OK").setOn().setId(6);
 
  cp5.addButton("setall").setPosition(5,330).setSize(40,30).setLabel("OK all").setOn().setId(7); 
     addMouseWheelListener();
     
       try {
    if(debug) printArray(Serial.list());
    int i = Arduino.list().length;
    if (i != 0) {
      if (i >= 2) {
        // need to check which port the inst uses -
        // for now we'll just let the user decide
        for (int j = 0; j < i;) {
          COMlist += char(j+'a') + " = " + Serial.list()[j];
          if (++j < i) COMlist += ",  ";
        }
        COMx = showInputDialog("Which COM port is correct? (a,b,..):\n"+COMlist);
        if (COMx == null) exit();
        if (COMx.isEmpty()) exit();
        i = int(COMx.toLowerCase().charAt(0) - 'a') + 1;
      }
      String portName = Arduino.list()[i-1];
      if(debug) println(portName);
      arduino = new Arduino(this, portName, 57600); // change baud rate to your liking
    // arduino.bufferUntil('\n'); // buffer until CR/LF appears, but not required..
    }
    else {
      showMessageDialog(frame,"Device is not connected to the PC");
      exit();
    }
  }
  catch (Exception e)
  { //Print the type of error
    showMessageDialog(frame,"COM port is not available (may\nbe in use by another program)");
    println("Error:", e);
    exit();
  }
  
 //    arduino = new Arduino(this, Arduino.list()[1], 57600);
//   arduino = new Arduino(this, "COM4", 57600);
// arduino = new Arduino(this, Arduino.list()[0], 57600);
 // arduino = new Arduino(this, "/dev/tty.usbmodem1421", 57600);
      arduino.pinMode(5,  Arduino.SERVO); //ground
      arduino.pinMode(6,  Arduino.SERVO);// sec
      arduino.pinMode(7,  Arduino.SERVO);// tec
      arduino.pinMode(8,  Arduino.SERVO); //above
      arduino.pinMode(9,  Arduino.SERVO); //top
      arduino.pinMode(4,  Arduino.SERVO); //claw
   
 }

void controlEvent(ControlEvent theEvent) {
  switch(theEvent.getController().getId()) {
    case(1):  
    oground=ground;
    if(groundinput==null)
      ground=(int)cp5.getController("ground").getValue();
    else
      {
      groundinput= (String)cp5.getController("groundinput").getStringValue();
      ground=int(groundinput);
      }
    ground++;
    cp5.getController("ground").setUpdate(true);
    cp5.getController("ground").setValue(ground);
    text(groundinput, 360,180);
    print("switch ground ;");
    println(ground);
    println(oground);
    draw();
    break;
    
    case(2):
    osec=sec;
    if(secinput==null)
      sec=(int)cp5.getController("sec").getValue();
    else    
      {  
      secinput= (String)cp5.getController("secinput").getStringValue();
      sec= int(secinput);
      }
    cp5.getController("sec").setUpdate(true);
    cp5.getController("sec").setValue(sec);
    draw();
    //println(theEvent.getController().getStringValue());
    break;
    
    case(3):
    otec=tec;   
   if(tecinput==null)
      tec=(int)cp5.getController("tec").getValue();
    else
      {
      tecinput = (String)cp5.getController("tecinput").getStringValue();   
      tec = int(tecinput); 
      }   
    cp5.getController("tec").setUpdate(true);
    cp5.getController("tec").setValue(tec);
    draw();
    break;
    
    case(4):
    oabove=above;    
    if(aboveinput==null)
      above=(int)cp5.getController("above").getValue();
    else
      {
      aboveinput = (String)cp5.getController("aboveinput").getStringValue();   
      above = int(aboveinput);  
      }      
    cp5.getController("above").setUpdate(true);
    cp5.getController("above").setValue(above);
    draw();   
    break;
    
    case(5):
    otop=top;
    if(topinput==null)
      top=(int)cp5.getController("top").getValue();
    else    
      {  
      secinput= (String)cp5.getController("topinput").getStringValue();
      top= int(topinput);
      }
    cp5.getController("top").setUpdate(true);
    cp5.getController("top").setValue(top);
    draw();
    break;
    
    case(6):
    oclaw=claw;
    if(clawinput==null)
      claw=(int)cp5.getController("claw").getValue();
    else
      { 
      clawinput = (String)cp5.getController("clawinput").getStringValue();   
      claw = int(clawinput);
      }
    cp5.getController("claw").setUpdate(true);
    cp5.getController("claw").setValue(claw);
    draw();
    break;
//update all
    case(7):
    oground=ground;
    osec=sec;
    otec =tec;
    oabove=above;
    otop=top;
    oclaw=claw;
    if(groundinput==null)
      ground=(int)cp5.getController("ground").getValue();
    else
      {
      groundinput= (String)cp5.getController("groundinput").getStringValue();
      ground=int(groundinput);
      ground++;
      }
      
    if(secinput==null)
      sec=(int)cp5.getController("sec").getValue();
    else    
      {  
      secinput= (String)cp5.getController("secinput").getStringValue();
      sec= int(secinput);
      }
      
    if(tecinput==null)
      tec=(int)cp5.getController("tec").getValue();
    else
      {
      tecinput = (String)cp5.getController("tecinput").getStringValue();   
      tec = int(tecinput); 
      }
      
    if(aboveinput==null)
      above=(int)cp5.getController("above").getValue();
    else
      {
      aboveinput = (String)cp5.getController("aboveinput").getStringValue();   
      above = int(aboveinput);  
      }

    if(topinput==null)
      top=(int)cp5.getController("top").getValue();
    else
      {      
      topinput = (String)cp5.getController("topinput").getStringValue();   
      top = int(topinput);  
      }  
      
    if(clawinput==null)
      claw=(int)cp5.getController("claw").getValue();
    else
      { 
      clawinput = (String)cp5.getController("clawinput").getStringValue();   
      claw = int(clawinput);
      }
     
    cp5.getController("ground").setUpdate(true);
    cp5.getController("ground").setValue(ground);
    cp5.getController("sec").setUpdate(true);
    cp5.getController("sec").setValue(sec);
    cp5.getController("tec").setUpdate(true);
    cp5.getController("tec").setValue(tec);
    cp5.getController("above").setUpdate(true);
    cp5.getController("above").setValue(above);
    cp5.getController("top").setUpdate(true);
    cp5.getController("top").setValue(top);
    cp5.getController("claw").setUpdate(true);
    cp5.getController("claw").setValue(claw);
    draw();
    break;

    default: break;
  }
}



void draw() {
  background(myColorBackground);
 
    
if(pground != ground || psec !=sec || ptec !=tec || pabove != above || pclaw != claw)
    println(oground +"\t" + osec +"\t"+ otec+ "\t" +oabove+"\t" + otop + "\t"+ oclaw +"\t");
if (start==true)
{
if (ground> oground)
  {
  int bet =ground -oground;
  for(int q =0;q<bet;q++)
        {
        oground++;
        arduino.servoWrite(5,oground); 
        cp5.getController("ground").setUpdate(true);
        cp5.getController("ground").setValue(oground);
        println(oground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
        }
  }
if(ground<oground)
  {
   int wet = oground -ground;
   for(int a= 0;a<wet;a++)
      {
      oground--;
      arduino.servoWrite(5,oground); 
      cp5.getController("ground").setUpdate(true);
      cp5.getController("ground").setValue(oground);
      println(oground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
      delay(smomov);
      }
   }
if (sec> osec)
  {
  int bet =sec -osec;
  for(int q =0;q<bet;q++)
        {
        osec++;
        arduino.servoWrite(6,osec); 
        cp5.getController("sec").setUpdate(true);
        cp5.getController("sec").setValue(osec);
        println(ground +"\t" + osec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
        }
  }
if(sec<osec)
  {
   int wet = osec -sec;
   for(int a= 0;a<wet;a++)
      {
      osec--;
      arduino.servoWrite(6,osec); 
      cp5.getController("sec").setUpdate(true);
      cp5.getController("sec").setValue(osec);
      println(ground +"\t" + osec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
      delay(smomov);
      }
   }   
if (tec> otec)
  {
  int bet =tec -otec;
  for(int q =0;q<bet;q++)
        {
        otec++;
        arduino.servoWrite(7,otec); 
        cp5.getController("tec").setUpdate(true);
        cp5.getController("tec").setValue(otec);
        println(ground +"\t" + sec +"\t"+ otec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
        }
  }
if(tec < otec)
  {
   int wet = otec -tec;
   for(int a= 0;a<wet;a++)
      {
      otec--;
      arduino.servoWrite(7,otec); 
      cp5.getController("tec").setUpdate(true);
      cp5.getController("tec").setValue(otec);
      println(ground +"\t" + sec +"\t"+ otec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
      delay(smomov);
      }
   }  
if (above> oabove)
  {
  int bet =above -oabove;
  for(int q =0;q<bet;q++)
        {
        oabove++;
        arduino.servoWrite(8,oabove); 
        cp5.getController("above").setUpdate(true);
        cp5.getController("above").setValue(oabove);
        println(ground +"\t" + sec +"\t"+ tec+ "\t" +oabove+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
        }
  }
if(above < oabove)
  {
   int wet = oabove -above;
   for(int a= 0;a<wet;a++)
      {
      oabove--;
      arduino.servoWrite(8,oabove); 
      cp5.getController("above").setUpdate(true);
      cp5.getController("above").setValue(oabove);
      println(ground +"\t" + sec +"\t"+ tec+ "\t" +oabove+"\t" + top + "\t"+ claw +"\t");
      delay(smomov);
      }
   } 
if (top> otop)
  {
  int bet =top -otop;
  for(int q =0;q<bet;q++)
        {
        otop++;
        arduino.servoWrite(9,otop); 
        cp5.getController("top").setUpdate(true);
        cp5.getController("top").setValue(otop);
        println(ground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + otop + "\t"+ claw +"\t");
        delay(smomov);
        }
  }
if(top < otop)
  {
   int wet = otop -top;
   for(int a= 0;a<wet;a++)
      {
      otop--;
      arduino.servoWrite(9,otop); 
      cp5.getController("top").setUpdate(true);
      cp5.getController("top").setValue(otop);
      println(ground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + otop + "\t"+ claw +"\t");
      delay(smomov);
      }
   }  
if (claw> oclaw)
  {
  int bet =claw -oclaw;
  for(int q =0;q<bet;q++)
        {
        oclaw++;
        arduino.servoWrite(4,oclaw); 
        cp5.getController("claw").setUpdate(true);
        cp5.getController("claw").setValue(oclaw);
        println(ground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ oclaw +"\t");
        delay(smomov);
        }
  }
if(claw < oclaw)
  {
   int wet = oclaw -claw;
   for(int a= 0;a<wet;a++)
      {
      oclaw--;
      arduino.servoWrite(4,oclaw); 
      cp5.getController("claw").setUpdate(true);
      cp5.getController("claw").setValue(oclaw);
      println(ground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ oclaw +"\t");
      delay(smomov);
      }
   }  


pground=ground;
psec=sec;
ptec=tec;
pabove=above;
ptop=top;
pclaw=claw;
 
}
else
{
println("First start");
oground=ground;
osec=sec;
otec=tec;
oabove=above;
otop=top;
oclaw=claw;
cp5.getController("ground").setUpdate(true);
cp5.getController("ground").setValue(ground);
cp5.getController("sec").setUpdate(true);
cp5.getController("sec").setValue(sec);
cp5.getController("tec").setUpdate(true);
cp5.getController("tec").setValue(tec);
cp5.getController("above").setUpdate(true);
cp5.getController("above").setValue(above);
cp5.getController("top").setUpdate(true);
cp5.getController("top").setValue(top);
cp5.getController("claw").setUpdate(true);
cp5.getController("claw").setValue(claw);
start=true;    
}
}


public void getpos(int theValue) 
{
print("ground:");
println(ground);
print("setground:");
println(ground);
print("sec:");
println(sec);
print("tec:");
println(tec);
print("above:");
println(above);
print("top:");
println(top);
print("claw:");
println(claw);}
/*
public void setground(int theValue)
{
ground = groundi;
cp5.getController("ground").setUpdate(true);
cp5.getController("ground").show();
draw();
}

public void setground()
{
groundinput=(String)cp5.getController("groundinput").getStringValue();
ground=int(groundinput);
cp5.getController("ground").setUpdate(true);
cp5.getController("ground").setValue(ground);
print("ground: ");
println(ground);
draw();
}*/

public void PARK() 
{
ground=parkground;
cp5.getController("ground").setUpdate(true);
cp5.getController("ground").setValue(ground);
delay(1000);
sec =parksec;
cp5.getController("sec").setUpdate(true);
cp5.getController("sec").setValue(sec);
delay(1000);
tec=parktec;
cp5.getController("tec").setUpdate(true);
cp5.getController("tec").setValue(tec);
delay(1000);
above =parkabove;
cp5.getController("above").setUpdate(true);
cp5.getController("above").setValue(above);
delay(1000);
top =parktop;
cp5.getController("top").setUpdate(true);
cp5.getController("top").setValue(top);
delay(1000);
claw =parkclaw;
cp5.getController("claw").setUpdate(true);
cp5.getController("claw").setValue(claw);
}

public void setmov ()
{
if(true==cp5.getController("smomov").isVisible())
   {
      cp5.getController("smomov").setVisible(false);
            cp5.getController("sec").setVisible(true);
      cp5.getController("tec").setVisible(true);

   }
else
    {
    cp5.getController("smomov").setVisible(true);
      cp5.getController("sec").setVisible(false);
      cp5.getController("tec").setVisible(false);

  }
println("Smooth steps changed to " +smomov);
}

public void set1 ()
{
if(true==cp5.getController("set1s").isVisible())
   {
      cp5.getController("set1s").setVisible(false);
      cp5.getController("set1l").setVisible(false);
      cp5.getController("sec").setVisible(true);
      cp5.getController("tec").setVisible(true);

   }
else
    {
    cp5.getController("set1s").setVisible(true);
    cp5.getController("set1l").setVisible(true);
      cp5.getController("sec").setVisible(false);
      cp5.getController("tec").setVisible(false);

    }
println("SET1 loaded \n" + "ground: "+s1ground+"sec: "+s1sec+ "tec: "+s1tec+ "above: "+s1above+ "top: "+s1top+"claw: "+s1claw );
}

public void set1s()
{
s1ground =(int)cp5.getController("ground").getValue();
s1sec =(int)cp5.getController("sec").getValue();
s1tec =(int)cp5.getController("tec").getValue();
s1above =(int)cp5.getController("above").getValue();
s1top =(int)cp5.getController("top").getValue();
s1claw =(int)cp5.getController("claw").getValue();
}

public void set1l ( )
{
ground=s1ground;
sec=s1sec;
tec=s1tec;
above=s1above;
top=s1top;
claw=s1claw;
cp5.getController("ground").setUpdate(true);
cp5.getController("ground").setValue(ground);
cp5.getController("sec").setUpdate(true);
cp5.getController("sec").setValue(sec);
cp5.getController("tec").setUpdate(true);
cp5.getController("tec").setValue(tec);
cp5.getController("above").setUpdate(true);
cp5.getController("above").setValue(above);
cp5.getController("top").setUpdate(true);
cp5.getController("top").setValue(top);
cp5.getController("claw").setUpdate(true);
cp5.getController("claw").setValue(claw);
}

public void set2 ()
{
if(true==cp5.getController("set2s").isVisible())
   {
      cp5.getController("set2s").setVisible(false);
      cp5.getController("set2l").setVisible(false);
      cp5.getController("sec").setVisible(true);
      cp5.getController("tec").setVisible(true);


   }
else
    {
      cp5.getController("set2s").setVisible(true);
      cp5.getController("set2l").setVisible(true);
      cp5.getController("sec").setVisible(false);
      cp5.getController("tec").setVisible(false);
  
  }  
}
public void set2s ()
{
s2ground =(int)cp5.getController("ground").getValue();
s2sec =(int)cp5.getController("sec").getValue();
s2tec =(int)cp5.getController("tec").getValue();
s2above =(int)cp5.getController("above").getValue();
s2top =(int)cp5.getController("top").getValue();
s2claw =(int)cp5.getController("claw").getValue();
}

public void set2l ( )
{
ground=s2ground;
sec=s2sec;
tec=s2tec;
above=s2above;
top=s2top;
claw=s2claw;
cp5.getController("ground").setUpdate(true);
cp5.getController("ground").setValue(ground);
cp5.getController("sec").setUpdate(true);
cp5.getController("sec").setValue(sec);
cp5.getController("tec").setUpdate(true);
cp5.getController("tec").setValue(tec);
cp5.getController("above").setUpdate(true);
cp5.getController("above").setValue(above);
cp5.getController("top").setUpdate(true);
cp5.getController("top").setValue(top);
cp5.getController("claw").setUpdate(true);
cp5.getController("claw").setValue(claw);
}

public void set3 ()
{
   println("SET3");
   if(true==cp5.getController("set3s").isVisible())
   {
      cp5.getController("set3s").setVisible(false);
      cp5.getController("set3l").setVisible(false);
      cp5.getController("sec").setVisible(true);
      cp5.getController("tec").setVisible(true);

   }
else
    {
    cp5.getController("set3s").setVisible(true);
    cp5.getController("set3l").setVisible(true);
    cp5.getController("sec").setVisible(false);
    cp5.getController("tec").setVisible(false);
  }
}

public void set3s ()
{
s3ground =(int)cp5.getController("ground").getValue();
s2sec =(int)cp5.getController("sec").getValue();
s3tec =(int)cp5.getController("tec").getValue();
s3above =(int)cp5.getController("above").getValue();
s3top =(int)cp5.getController("top").getValue();
s3claw =(int)cp5.getController("claw").getValue();
}

public void set3l ( )
{
ground=s3ground;
sec=s3sec;
tec=s3tec;
above=s3above;
top=s3top;
claw=s3claw;
cp5.getController("ground").setUpdate(true);
cp5.getController("ground").setValue(ground);
cp5.getController("sec").setUpdate(true);
cp5.getController("sec").setValue(sec);
cp5.getController("tec").setUpdate(true);
cp5.getController("tec").setValue(tec);
cp5.getController("above").setUpdate(true);
cp5.getController("above").setValue(above);
cp5.getController("top").setUpdate(true);
cp5.getController("top").setValue(top);
cp5.getController("claw").setUpdate(true);
cp5.getController("claw").setValue(claw);
}

public void set4 ()
{
println("SET4");
if(true==cp5.getController("set4s").isVisible())
   {
      cp5.getController("set4s").setVisible(false);
      cp5.getController("set4l").setVisible(false);
      cp5.getController("sec").setVisible(true);
      cp5.getController("tec").setVisible(true);
   }
else
    {
    cp5.getController("set4s").setVisible(true);
    cp5.getController("set4l").setVisible(true);
    cp5.getController("sec").setVisible(false);
    cp5.getController("tec").setVisible(false);
  }
}

public void set4s ()
{
s4ground =(int)cp5.getController("ground").getValue();
s4sec =(int)cp5.getController("sec").getValue();
s4tec =(int)cp5.getController("tec").getValue();
s4above =(int)cp5.getController("above").getValue();
s4top =(int)cp5.getController("top").getValue();
s4claw =(int)cp5.getController("claw").getValue();
}

public void set4l ( )
{
ground=s4ground;
sec=s4sec;
tec=s4tec;
above=s4above;
top=s4top;
claw=s4claw;
cp5.getController("ground").setUpdate(true);
cp5.getController("ground").setValue(ground);
cp5.getController("sec").setUpdate(true);
cp5.getController("sec").setValue(sec);
cp5.getController("tec").setUpdate(true);
cp5.getController("tec").setValue(tec);
cp5.getController("above").setUpdate(true);
cp5.getController("above").setValue(above);
cp5.getController("top").setUpdate(true);
cp5.getController("top").setValue(top);
cp5.getController("claw").setUpdate(true);
cp5.getController("claw").setValue(claw);
}



// mouse wheel slider bewegen
void addMouseWheelListener() {
  frame.addMouseWheelListener(new java.awt.event.MouseWheelListener() {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent e) {
      cp5.setMouseWheelRotation(e.getWheelRotation());
    }
  }
  );
}