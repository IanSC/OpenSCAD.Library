# Panel Notch

---
## List of Functions
<table>
<tr><td><b>NotchProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>Notch</b>( targetWidth, notches, profile )</td><td>generate 2D notch/holes for panel</td></tr>
<tr><td><b>NotchEdge</b>( targetWidth, notches, profile )</td><td>generate 2D notch/holes on panel edge</td></tr>
</table>

---
#### _NotchProfile( ... )_
<table>
<tr><td>panelThickness          <td>1A,2A<td>used for both notchHeight and holeHeight
<tr><td>notchHeight             <td>1B   <td>height of notches, if not specified will use panelThickness
<tr><td>holeHeight              <td>2B   <td>height of notch hole, if not specified will use panelThickness
<tr><td>notchWidthAllowance = 0 <td>        <td>adjustment of notch width, eg. make it smaller to fit notch holes
<tr><td>notchHeightAllowance = 0<td>        <td>adjustment of notch height, eg. make it shorter to avoid protruding out the other side when inserted
<tr><td>holeWidthAllowance = 0  <td>        <td>adjustment of hole width, eg. make it bigger to fit notches
<tr><td>holeHeightAllowance = 0 <td>        <td>adjustment of hole height, eg. make it bigger to fit notches
<tr><td>punchGap                <td>        <td>optional default parameters for Notch() and NotchEdge()
<tr><td>leftGap = 0             <td>        <td>... see Notch() and NotchEdge()
<tr><td>rightGap = 0            <td>        <td>...
<tr><td>fromEdge                <td>        <td>...
<tr><td>additive                <td>        <td>...
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>

#### _Notch( targetWidth, notches, profile )_
<table>
<tr><td>targetWidth     <td>&#10004;<td>length to put notches/holes on
<tr><td>notches         <td>&#10004;<td>number of notches/holes to generate
<tr><td>profile         <td>&#10004;<td>notch profile to use
<tr><td>punchGap = true <td>        <td>whether to punch out left/right gaps if specified
<tr><td>leftGap = 0     <td>        <td>margin on the left before notching
<tr><td>rightGap = 0    <td>        <td>margin on the right before notching
<tr><td>additive = false<td>        <td>generate additive notches or subtractive
<!--<tr><td>fromEdge = false<td>        <td>whether to put notches edge to edge instead of centered-->
</table>
&nbsp; &nbsp; &nbsp;punchGap, additive will override profile settings<br/>
&nbsp; &nbsp; &nbsp;leftGap, rightGap will be added to profile settings

#### _NotchEdge( targetWidth, notches, profile )_
<table>
<tr><td>targetWidth     <td>&#10004;<td>length to put notches/holes on
<tr><td>notches         <td>&#10004;<td>number of notches/holes to generate
<tr><td>profile         <td>&#10004;<td>notch profile to use
<tr><td>punchGap = true <td>        <td>whether to punch out left/right gaps if specified
<tr><td>leftGap = 0     <td>        <td>margin on the left before notching
<tr><td>rightGap = 0    <td>        <td>margin on the right before notching
<tr><td>additive = false<td>        <td>generate additive notches or subtractive
<!--<tr><td>notEdge = false <td>        <td>whether to put notches centered instead of edge to edge-->
</table>
&nbsp; &nbsp; &nbsp;punchGap, additive will override profile settings<br/>
&nbsp; &nbsp; &nbsp;leftGap, rightGap will be added to profile settings

---
## Data Structure
```
notch   = height         : 3
          widthAllowance : -1
          heightAllowance: 3
hole    = height         : 3
          widthAllowance : 1
          heightAllowance: 1
defaults= punchGap: <undef>
          leftGap : 10
          rightGap: 10
          fromEdge: <undef>
          additive: <undef>
```

---
## Sample Code 2D
![photo](/images/panel-notch-1.png)
```
nProfile1 = NotchProfile( panelThickness = 3 );
nProfile2 = NotchProfile( panelThickness = 3,
    notchWidthAllowance  = -1, holeWidthAllowance  = 1,
    notchHeightAllowance =  3, holeHeightAllowance = 1,
    leftGap = 10, rightGap = 10
);
kvEchoAligned(nProfile2);

// gray patches were punched out
translate([  0,  0,0]) demoM( 80,nProfile1,false,"gray")  Notch    ( 80,  2, nProfile1 );
translate([  0, 35,0]) demoM( 80,nProfile1,false,"gray")  NotchEdge( 80,  2, nProfile1 );
translate([  0, 60,0]) demoF( 80,                "gray")  Notch    ( 80, -2, nProfile1 );

// green patches were added
translate([ 90,  0,0]) demoM( 80,nProfile1,true ,"green") Notch    ( 80,  2, nProfile1, additive=true );
translate([ 90, 35,0]) demoM( 80,nProfile1,true ,"green") NotchEdge( 80,  2, nProfile1, additive=true );

// gray patches were punched out
translate([190,  0,0]) demoM(100,nProfile2,false,"gray")  Notch    (100,  2, nProfile2                 );
translate([190, 35,0]) demoM(100,nProfile2,false,"gray")  Notch    (100,  2, nProfile2, punchGap=false );
translate([190, 70,0]) demoM(100,nProfile2,false,"gray")  NotchEdge(100,  2, nProfile2                 );
translate([190,105,0]) demoM(100,nProfile2,false,"gray")  NotchEdge(100,  2, nProfile2, punchGap=false );
translate([190,130,0]) demoF(100,                "gray")  Notch    (100, -2, nProfile2                 );

module demoM(panelWidth,notchProfile,additive,color) {
    difference() {
        panelOnly(panelWidth,notchProfile,additive);
        children();
    }
    color(color) children();
}
module demoF(panelWidth,color) {
    difference() {
        square([panelWidth,20],center=true);
        children();
    }
    color(color) children();
}
module panelOnly(panelWidth,notchProfile,additive=false) {
    nHa = kvGet( notchProfile, "notch.heightAllowance" );
    if (additive || nHa<=0) // panel top at origin
        translate([0,-10,0]) square([panelWidth,20],center=true);
    else // move top of panel above origin by notchHeightAllowance
        translate([0,-10+nHa/2,0]) square([panelWidth,20+nHa],center=true);
}
```

---
## Sample Code
![photo](/images/panel-notch-2.png)
```
panelThickness = 3;
nProfile1 = NotchProfile( panelThickness = panelThickness );
nProfile2 = NotchProfile( panelThickness = panelThickness,
    notchWidthAllowance  = -1, holeWidthAllowance  = 1,
    notchHeightAllowance =  3, holeHeightAllowance = 1,
    leftGap = 10, rightGap = 10
);

// male/female
solid() malePanel2D(80,2,nProfile1);
color( "green", 0.5 )
    OBack( panelThickness )
    solid() femalePanel2D(80,2,nProfile1);

// male/male
translate( [0,50,0] ) {
    OTop(panelThickness)
        solid() malePanel2D(80,2,nProfile1);
    color( "green", 0.5 )
        OBack( panelThickness )
        solid() malePanelOutside2D(80,2,nProfile1,punchGap=false);
}

// male/female with adjustment/gaps
translate( [0,100,0] ) {
    solid() malePanel2D(100,2,nProfile2);
    color( "green", 0.5 )
        OBack( panelThickness )
        solid() femalePanel2D(100,2,nProfile2);
}
    
// male/male with adjustment/gaps
translate( [0,150,0] ) {
    OTop(panelThickness)
        solid() malePanel2D(100,2,nProfile2);
    color( "green", 0.5 )
        OBack( panelThickness )
        solid() malePanelOutside2D(100,2,nProfile2,punchGap=false);
}

module solid() linear_extrude(panelThickness,center=true) children();
module malePanel2D(panelWidth,notches,notchProfile,punchGap=true) {
    difference() {
        panelOnly(panelWidth,notchProfile);
        Notch(panelWidth,notches,notchProfile,punchGap=punchGap);
    }
}
module malePanelOutside2D(panelWidth,notches,notchProfile,punchGap=true) {
    difference() {
        panelOnly(panelWidth,notchProfile);
        NotchEdge(panelWidth,notches,notchProfile,punchGap=punchGap);
    }
}
module femalePanel2D(panelWidth,notches,notchProfile) {
    difference() {
        square([panelWidth,20],center=true);
        Notch(panelWidth,-notches,notchProfile);
    }
}
module panelOnly(panelWidth,notchProfile,additive=false) {
    nHa = kvGet( notchProfile, "notch.heightAllowance" );
    if (additive || nHa<=0) // panel top at origin
        translate([0,-10,0]) square([panelWidth,20],center=true);
    else // move top of panel above origin by notchHeightAllowance
        translate([0,-10+nHa/2,0]) square([panelWidth,20+nHa],center=true);
}
```

---
## Sample Code Assembly
![photo](/images/panel-notch-3.png)
```
W  = 80;  // width
D  = 50;  // depth
H  = 100; // height
T  = 3;   // panel thickness
S1 = 10;  // shelf1 position (from bottom)
S2 = 50;  // shelf2 position (from bottom)

SF1 = S1+T/2;   // shelf1 front panel height
SF2 = H-S2+T/2; // shelf2 front panel height

notchProfile = NotchProfile(panelThickness=T);

assembly();
translate([120,0,0])
rotate([0,0,180])
    assembly();

module assembly() {
    CubeExtents(W,D,H);

    // shelves
    color("LightGrey") OBottom(0,H/2-S1) solid() shelfBottom();
    color("LightGrey") OBottom(0,H/2-S2) solid() shelfBottom();
    
    // walls
    OLeft (T,W/2) solid()                   walls();
    ORight(T,W/2) solid() rotate([0,180,0]) walls();
    
    // shelves front panel
    color("gray") OFront(T,D/2,0,-H/2+SF1/2) solid() frontPanel1();
    color("gray") OFront(T,D/2,0, H/2-SF2/2) solid() frontPanel2();

    // back panel
    color("DarkGray")  OBack (T,D/2) solid() back();
}

module solid() linear_extrude(T,center=true) children();
module walls() {
    punch() {
        square([D,H],center=true);
        union() {                    
            MUp(S1) PBottom(H) Notch    (D,-2,notchProfile); // holes for shelf bottom
            MUp(S2) PBottom(H) Notch    (D,-2,notchProfile);
                    PRight(D)  NotchEdge(H,3,notchProfile);  // back panel
            // shelves front panel
            PLeft(D) NotchEdge(H,1,notchProfile,punchGap=false,rightGap=H-SF1);
            PLeft(D) NotchEdge(H,2,notchProfile,punchGap=false,leftGap =H-SF2);
        }
    }
}
module back() {
    punch() {
        square([W,H],center=true);
        union() {                    
                    PLeft(W)   Notch(H,3,notchProfile);  // walls
                    PRight(W)  Notch(H,3,notchProfile);
            MUp(S1) PBottom(H) Notch(W,-2,notchProfile); // shelves bottom
            MUp(S2) PBottom(H) Notch(W,-2,notchProfile);
        }
    }
}
module shelfBottom() {
    punch() {
        square([W,D],center=true);
        union() {                    
            PLeft(W)   Notch    (D,2,notchProfile); // walls
            PRight(W)  Notch    (D,2,notchProfile);
            PBottom(D) NotchEdge(W,2,notchProfile); // front
            PTop(D)    Notch    (W,2,notchProfile); // back
        }
    }
}
module frontPanel1() {
    punch() {
        square([W,SF1],center=true);
        union() {
            PLeft(W)  Notch(SF1,1,notchProfile); // walls
            PRight(W) Notch(SF1,1,notchProfile);
            PTop(SF1) Notch(W,2,notchProfile);   // front
        }
    }
}
module frontPanel2() {
    punch() {
        square([W,SF2],center=true);
        union() {                    
            PLeft(W)     Notch(SF2,2,notchProfile); // walls
            PRight(W)    Notch(SF2,2,notchProfile);
            PBottom(SF2) Notch(W,2,notchProfile);   // front
        }
    }
}

// to diagnose a part while designing,
// set debug to true and generate the part. ex:
//    debug=true;
//    walls();
debug=false;
module punch() {
    if (debug) {
        color("green",0.5) 
        difference() {
            children(0); children(1);
        }
        children(1);
    } else {
        difference() {
            children(0); children(1);
        }
    }
}
```