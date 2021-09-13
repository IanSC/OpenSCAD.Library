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
<tr><td>panelThickness          <td>&#10004;1<td>used for both notchHeight and holeHeight
<tr><td>notchHeight             <td>&#10004;2<td>height of notches, if not specified will use panelThickness
<tr><td>holeHeight              <td>&#10004;2<td>height of notch hole, if not specified will use panelThickness
<tr><td>notchWidthAllowance = 0 <td>         <td>adjustment of notch width, eg. make it smaller to fit notch hole width
<tr><td>notchHeightAllowance = 0<td>         <td>adjustment of notch height, eg. make it shorter to avoid protruding out the other side when inserted
<tr><td>holeWidthAllowance = 0  <td>         <td>adjustment of hole width, eg. make it bigger to fit notch width
<tr><td>holeHeightAllowance = 0 <td>         <td>adjustment of hole height, eg. make it bigger to fit notch height
<tr><td>punchGap                <td>         <td>optional default parameters for Notch() and NotchEdge()
<tr><td>leftGap = 0             <td>         <td>... see Notch() and NotchEdge()
<tr><td>rightGap = 0            <td>         <td>...
<tr><td>fromEdge                <td>         <td>...
<tr><td>additive                <td>         <td>...
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
profile1 = NotchProfile( panelThickness = 3 );
profile2 = NotchProfile( panelThickness = 3,
    notchWidthAllowance  = -1, holeWidthAllowance  = 1,
    notchHeightAllowance =  3, holeHeightAllowance = 1,
    leftGap = 10, rightGap = 10
);
kvEchoAligned(profile2);

// gray patches were punched out
translate([  0,  0,0]) demoM( 80,profile1,"gray")  Notch    (  80,  2, profile1 );
translate([  0, 35,0]) demoM( 80,profile1,"gray")  NotchEdge(  80,  2, profile1 );
translate([  0, 60,0]) demoF( 80,         "gray")  Notch    (  80, -2, profile1 );

// green patches were added
translate([ 90,  0,0]) demoM( 80,profile1,"green") Notch    (  80,  2, profile1, additive=true  );
translate([ 90, 35,0]) demoM( 80,profile1,"green") NotchEdge(  80,  2, profile1, additive=true  );

// gray patches were punched out
translate([190,  0,0]) demoM(100,profile2,"gray")  Notch    ( 100,  2, profile2                 );
translate([190, 35,0]) demoM(100,profile2,"gray")  Notch    ( 100,  2, profile2, punchGap=false );
translate([190, 70,0]) demoM(100,profile2,"gray")  NotchEdge( 100,  2, profile2                 );
translate([190,105,0]) demoM(100,profile2,"gray")  NotchEdge( 100,  2, profile2, punchGap=false );
translate([190,130,0]) demoF(100,         "gray")  Notch    ( 100, -2, profile2                 );

module demoM(width,profile,color) {
    color("red") translate([0,0,1]) square([width,0.5],center=true); // origin
    difference() {
        union() {
            translate([0,-10,0]) square([width,20],center=true); // panel top at origin
            nHa=kvGet(profile,"notch.heightAllowance");
            if (nHa>0) // notchHeightAllowance above origin
                translate([0,nHa/2-0.5,0]) square([width,nHa+1],center=true);
        }
        children();
    }
    color(color) children();
}
module demoF(width,color) {
    color("red") translate([0,0,1]) square([width,0.5],center=true); // origin
    difference() {
        square([width,20],center=true);
        children();
    }
    color(color) children();
}
```

---
## Sample Code
![photo](/images/panel-notch-2.png)
```
panelThickness = 3;
profile1 = NotchProfile( panelThickness = panelThickness );
profile2 = NotchProfile( panelThickness = panelThickness,
    notchWidthAllowance  = -1, holeWidthAllowance  = 1,
    notchHeightAllowance =  3, holeHeightAllowance = 1,
    leftGap = 10, rightGap = 10
);

// *** MALE/FEMALE ***
translate([0,0,0]) {
    solid() malePanel(80,profile1)
    
    /* ▶ */     Notch( 80, 2, profile1 );
    
    OBack(panelThickness) color("green",0.5) solid() femalePanel(80)
    
    /* ▶ */     Notch( 80, -2, profile1 );
}

// *** MALE/MALE BROMANCE ***
translate([0,50,0]) {
    OTop(panelThickness) solid() malePanel(80,profile1)
    
    /* ▶ */     Notch( 80, 2, profile1 );
    
    OBack(panelThickness) color("green",0.5) solid() malePanel(80,profile1)
        
    /* ▶ */     NotchEdge( 80, 2, profile1, punchGap=false );
}

// *** MALE/FEMALE WITH ADJUSTMENTS ***
translate([0,100,0]) {
    solid() malePanel(100,profile2)
    
    /* ▶ */     Notch( 100, 2, profile2 );
    
    OBack(panelThickness) color("green",0.5) solid() femalePanel(100)
    
    /* ▶ */     Notch( 100, -2, profile2 );
}
    
// *** MALE/MALE BROMANCE WITH ADJUSTMENTS ***
translate([0,150,0]) {
    OTop(panelThickness) solid() malePanel(100,profile2)
    
    /* ▶ */     Notch( 100, 2, profile2 );
    
    OBack(panelThickness) color("green",0.5) solid() malePanel(100,profile2)
    
    /* ▶ */     NotchEdge( 100, 2, profile2, punchGap=false );
}

module solid() linear_extrude(panelThickness,center=true) children();

module malePanel(width,profile) {
    difference() {
        union() {
            translate([0,-10,0]) square([width,20],center=true); // panel top at origin
            nHa=kvGet(profile,"notch.heightAllowance");
            if (nHa>0) // notchHeightAllowance above origin
                translate([0,nHa/2-0.5,0]) square([width,nHa+1],center=true);
        }
        children();
    }
}
module femalePanel(width) {
    difference() {
        square([width,20],center=true);
        children();
    }
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

profile = NotchProfile(panelThickness=T);

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
            MUp(S1) PBottom(H) Notch    (D,-2,profile); // holes for shelf bottom
            MUp(S2) PBottom(H) Notch    (D,-2,profile);
                    PRight(D)  NotchEdge(H,3,profile);  // back panel
            // shelves front panel
            PLeft(D) NotchEdge(H,1,profile,punchGap=false,rightGap=H-SF1);
            PLeft(D) NotchEdge(H,2,profile,punchGap=false,leftGap =H-SF2);
        }
    }
}
module back() {
    punch() {
        square([W,H],center=true);
        union() {                    
                    PLeft(W)   Notch(H,3,profile);  // walls
                    PRight(W)  Notch(H,3,profile);
            MUp(S1) PBottom(H) Notch(W,-2,profile); // shelves bottom
            MUp(S2) PBottom(H) Notch(W,-2,profile);
        }
    }
}
module shelfBottom() {
    punch() {
        square([W,D],center=true);
        union() {                    
            PLeft(W)   Notch    (D,2,profile); // walls
            PRight(W)  Notch    (D,2,profile);
            PBottom(D) NotchEdge(W,2,profile); // front
            PTop(D)    Notch    (W,2,profile); // back
        }
    }
}
module frontPanel1() {
    punch() {
        square([W,SF1],center=true);
        union() {
            PLeft(W)  Notch(SF1,1,profile); // walls
            PRight(W) Notch(SF1,1,profile);
            PTop(SF1) Notch(W,2,profile);   // front
        }
    }
}
module frontPanel2() {
    punch() {
        square([W,SF2],center=true);
        union() {                    
            PLeft(W)     Notch(SF2,2,profile); // walls
            PRight(W)    Notch(SF2,2,profile);
            PBottom(SF2) Notch(W,2,profile);   // front
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
