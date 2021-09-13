# Panel T-Nut Cage

---
## List of Functions
<table>
<tr><td><b>TNutCageProfile</b>( ... )</td><td>create profile
<tr><td><b>TNutCage</b>( profile )</td><td>generate 2D bolt/nut capture slots
<tr><td><b>TNutCagePanelHole</b>( profile )</td><td>generate 2D hole for perpendicular connected panel
<tr><td><b>TNutCages</b>( targetWidth, count, profile )</td><td>repeat several TNutCage() or TNutCagePanelHole() along targetWidth
</table>

---
#### _TNutCageProfile( ... )_
<table>
<tr><td>connectedPanelThickness  <td>&#10004; <td>default thickness of panel to be connected
<tr><td>boltProfile              <td>&#10004;1<td>provides boltDiameter and boltLength
<tr><td>nutProfile               <td>&#10004;1<td>provides nutDiameter, nutThickness and boltDiameter
<tr><td>boltDiameter             <td>&#10004;2<td>bolt diameter for slot
<tr><td>boltLength               <td>&#10004;2<td>bolt length for slot
<tr><td>nutDiameter              <td>&#10004;2<td>capture nut hole diameter
<tr><td>nutThickness             <td>&#10004;2<td>capture nut hole thickness
<tr><td>nutEdgeGap               <td>         <td>distance from panel edge to nut capture slot
<tr><td>boltDiameterAllowance = 0<td>         <td>adjustment for bolt diameter slot
<tr><td>boltLengthAllowance = 0  <td>         <td>adjustment for bolt length slot
<tr><td>nutDiameterAllowance = 0 <td>         <td>adjustment for captured nut hole diameter
<tr><td>nutThicknessAllowance = 0<td>         <td>adjustment for captured nut hole thickness
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>

#### _TNutCage( profile, connectedPanelThickness )_
<table>
<tr><td>profile                <td>&#10004;<td>profile to generate
<tr><td>connectedPanelThickness<td>        <td>override connected panel thickness in profile
</table>

#### _TNutCagePanelHole( profile, allowance )_
<table>
<tr><td>profile      <td>&#10004;<td>profile to generate hole for connecting perpendicular panel
<tr><td>allowance = 0<td>        <td>enlarge/reduce generated hole
</table>

#### _TNutCages( targetWidth, count, profile, connectedPanelThickness, holeAllowance )_
<table>
<tr><td>targetWidth            <td>&#10004;<td>width to generate for
<tr><td>count                  <td>&#10004;<td>number of repetitions:<br/>
                                               (+) number of bolt/nut cage<br/>
                                               (-) number of holes for connected panel
<tr><td>profile                <td>&#10004;<td>profile to use
<tr><td>connectedPanelThickness<td>        <td>override connected panel thickness in profile
<tr><td>allowance = 0          <td>        <td>enlarge/reduce generated hole
</table>

---
## Data Structure
```
connectedPanelThickness: 3
bolt                   = effDiameter: 4
                         effLength  : 20.5
nut                    = effDiameter       : 6
                         thickness         : 3
                         thicknessAllowance: 1
                         edgeGap           : 8
```

---
## Sample Code 2D
![photo](/images/panel-tnut-1.png)
```
panelThickness =  3;
boltDiameter   =  3; nutDiameter  = 5;
boltLength     = 20; nutThickness = 3;
nutEdgeGap     =  8;

// SIMPLE PROFILE
profile1 = TNutCageProfile(
    connectedPanelThickness = panelThickness,
    boltDiameter = boltDiameter, nutDiameter  = nutDiameter,
    boltLength   = boltLength,   nutThickness = nutThickness,
    nutEdgeGap   = nutEdgeGap
);

// PROFILE WITH ALLOWANCES
profile2 = TNutCageProfile(
    connectedPanelThickness = panelThickness,
    boltDiameter = boltDiameter, nutDiameter  = nutDiameter,
    boltLength   = boltLength,   nutThickness = nutThickness,
    nutEdgeGap   = nutEdgeGap,
    // allowance from physical sizes...
    boltDiameterAllowance = 2,
    boltLengthAllowance   = 1,
    nutDiameterAllowance  = 2,
    nutThicknessAllowance = 2
);

// *** BASIC ***
translate([0,0,0]) {
    malePanel(20)
    
    /* ▶ */     TNutCage( profile1 );
    
    femalePanel(20,panelThickness,boltDiameter)
    
    /* ▶ */     TNutCagePanelHole( profile1 );
    
    translate([0,panelThickness,0]) dummyBolt();
    translate([0,-nutEdgeGap,0]) dummyNut();
}

// *** OVERRIDE CONNECTED PANEL THICKNESS ***
translate([30,0,0]) {
    THK=5;
    malePanel(20)

    /* ▶ */     TNutCage( profile1, connectedPanelThickness=THK );
    
    femalePanel(20,THK,boltDiameter)
    
    /* ▶ */     TNutCagePanelHole( profile1 );
    
    translate([0,THK,0]) dummyBolt();
    translate([0,-nutEdgeGap,0]) dummyNut();
}

// *** WITH BOLT/NUT ALLOWANCES ***
    translate([60,0,0]) {
    malePanel(20)
    
    /* ▶ */     TNutCage( profile2 );
    
    femalePanel(20,panelThickness,boltDiameter)
    
    /* ▶ */     TNutCagePanelHole( profile2, allowance=2 );
    
    translate([0,panelThickness,0]) dummyBolt();
    translate([0,-nutEdgeGap,0]) dummyNut();
}

// *** MULTIPLE SLOTS ***
translate([120,0,0]) {
    malePanel(100)
    
    /* ▶ */     TNutCages( 100, 3, profile2 );
    
    femalePanel(100,panelThickness,boltDiameter)
    
    /* ▶ */     TNutCages( 100, -3, profile2 );
    
    patternRepeater(100,3) {
        translate([0,panelThickness,0]) dummyBolt();
        translate([0,-nutEdgeGap,0]) dummyNut();
        color("red") translate([0,20,0]) circle(d=boltDiameter);
    }
}

module malePanel(width) {
    difference() {
        translate([0,-10,0]) square([width,20],center=true);
        children();
    }
}
module femalePanel(width,thickness,boltDiameter) {
    color("SteelBlue") translate([0,thickness/2,0])
        square([width,thickness],center=true);
    translate([0,20,0]) {
        color("SteelBlue") difference() {
            square([width,10],center=true);
            children();
        }
        color("red") circle(d=boltDiameter);
    }
}
module dummyBolt() {
    color("red") {
        translate([0,-boltLength/2,1]) square([boltDiameter,boltLength],center=true);
        translate([-boltDiameter,0,1]) square([boltDiameter*2,3]);
    }
}
module dummyNut() {
    color("green") translate([0,-nutThickness/2,2])
        square([nutDiameter,nutThickness],center=true);
}
```

---
## Sample Code
![photo](/images/panel-tnut-2.png)
```
panelThickness = 3;

// SIMPLE PROFILE
profile1 = TNutCageProfile(
    connectedPanelThickness = panelThickness,
    boltLength   = 15, nutDiameter  = 5,
    boltDiameter =  3, nutThickness = 3,
    nutEdgeGap   =  5
);

// PROFILE FROM PHYSICAL BOLT/NUT
boltProfile = BoltProfile(
    shaftDiameter =  3,
    length        = 20,
    headDiameter  =  5,
    headThickness =  3 );
nutProfile = NutProfile(
    boltDiameter = 3,
    nutDiameter  = 5,
    thickness    = 3 );
profile2 = TNutCageProfile(
    connectedPanelThickness = panelThickness,
    boltProfile             = boltProfile,
    nutProfile              = nutProfile,
    nutEdgeGap              = 8,   // panel edge to captured nut
    boltDiameterAllowance   = 1,   // allowance from physical sizes...
    boltLengthAllowance     = 0.5,
    nutDiameterAllowance    = 1,
    nutThicknessAllowance   = 1
);
kvEchoAligned(profile2);

// ...possibly extract from another module
edgeGap     =kvGet(profile2,"nut.edgeGap");
nutThickness=kvGet(profile2,"nut.thickness");

// *** BASIC ***
translate([0,0,0]) {
    panelMale()
    
    /* ▶ */     TNutCage( profile1 );
    
    translate( [0,panelThickness/2,0] ) rotate( [90,0,0] ) panelFemale(panelThickness)
    
    /* ▶ */     TNutCagePanelHole( profile1 );
}

// *** WITH BOLTS/NUTS ***
// - see "nuts-bolts.scad"
translate([50,0,0]) //rotate([0,0,180]) 
    {
    rotate( [-90,0,0] ) color( "lightgray" ) {
        translate( [0,0,panelThickness] )
            Bolt(boltProfile);
        translate([0,0,-edgeGap-nutThickness]) rotate([0,0,30])
            Nut(nutProfile);
    }
    panelMale()
    
    /* ▶ */     TNutCage( profile2 );
    
    translate([0,panelThickness/2,0]) rotate([90,0,0]) panelFemale(panelThickness)
    
    /* ▶ */     TNutCagePanelHole( profile2 );
}

// *** ORIENTATION HELPERS ***
// - see "orientation.scad"
translate([100,0,0]) {
    THK=8;
    OFront(THK,faceIn=true) color( "lightgray" ) {
        OBottom(THK)
            Bolt(boltProfile);
        OBottom(THK,edgeGap+THK+nutThickness) rotate([0,0,30])
            Nut(nutProfile);
    }
    panelMale()
    
    /* ▶ */     TNutCage( profile2, connectedPanelThickness=THK );
    
    OFront(THK) panelFemale(THK)
    
    /* ▶ */     TNutCagePanelHole( profile2, allowance=2 );
}

module panelMale() {
    linear_extrude(panelThickness,center=true)
    difference() {
        translate([0,-10,0]) square([20,20],center=true); // panel top at origin
        children();
    }
}
module panelFemale(thickness) {
    color("SteelBlue",0.5)
    linear_extrude(thickness,center=true)
    difference() {
        square([20,20],center=true);
        children();
    }
}
```

---
## Sample Code Assembly
![photo](/images/panel-tnut-3.png)
```
W  = 80;        // width
D  = 50;        // depth
H  = 100;       // height
T  = 3;         // panel thickness
S1 = 10;        // shelf1 position (from bottom)
S2 = 50;        // shelf2 position (from bottom)

SF1 = S1+T/2;   // shelf1 front panel height
SF2 = H-S2+T/2; // shelf2 front panel height

EXT = 5;        // extension to place bolts

boltProfile = BoltProfile(
    shaftDiameter =  1,
    length        = 10,
    headDiameter  =  3,
    headThickness =  1 );
nutProfile = NutProfile(
    boltDiameter = 1,
    nutDiameter  = 3,
    thickness    = 1 );

profile = TNutCageProfile(
    connectedPanelThickness = T,
    boltProfile             = boltProfile,
    nutProfile              = nutProfile,
    nutEdgeGap              = 4,   // panel edge to captured nut
    boltDiameterAllowance   = 1,   // allowance from physical sizes...
    boltLengthAllowance     = 0.5,
    nutDiameterAllowance    = 1,
    nutThicknessAllowance   = 1
);

// ...possibly extract from another module
edgeGap     =kvGet(profile,"nut.edgeGap");
nutThickness=kvGet(profile,"nut.thickness");

assembly();
translate([120,0,0])
rotate([0,0,180])
    assembly();

showBolts=true;

module assembly() {
        CubeExtents(W,D,H);

    // shelves
    color("LightGrey") OBottom(0,H/2-S1) solid()      shelfBottom();
    color("LightGrey") OBottom(0,H/2-S2) solid()      shelfBottom();
    if (showBolts)     OBottom(0,H/2-S1,faceIn=false) shelfBottomBolts();
    if (showBolts)     OBottom(0,H/2-S2)              shelfBottomBolts();
    
    // walls
                    OLeft (T,W/2) solid()                       walls();
                    ORight(T,W/2) solid() rotate([0,180,0])     walls();
    if (showBolts) OLeft (T,W/2)                               wallBolts();
    if (showBolts) ORight(T,W/2, faceIn=false) mirror([0,0,1]) wallBolts();
    
    // shelves front panel
    color("gray")  OFront(T,D/2,0,-H/2+SF1/2) solid() frontPanel1();
    color("gray")  OFront(T,D/2,0, H/2-SF2/2) solid() frontPanel2();
    if (showBolts) OFront(T,D/2,0,-H/2+SF1/2)         frontPanel1Bolts();
    if (showBolts) OFront(T,D/2,0, H/2-SF2/2)         frontPanel2Bolts();

    // back panel
    color("DarkGray") OBack(T,D/2) solid() back();
    if (showBolts)    OBack(T,D/2)         backBolts();
}

module solid() linear_extrude(T,center=true) children();
module boltNut() {
    color("SandyBrown") {
        translate([0,0,T/2]) Bolt(boltProfile);
        translate([0,0,-T/2-nutThickness-edgeGap]) Nut(nutProfile);
    }
}
// *** WALLS ***        
module walls() {
    left  = -T;
    right = +EXT;
    effD  = D+left+right;
    punch() {
        MRight((-left+right)/2)
        square([effD,H],center=true);
        union() {                    
            MUp(S1)    PBottom(H) TNutCages(D,-2,profile); // holes for shelf bottom
            MUp(S2)    PBottom(H) TNutCages(D,-2,profile);
            MLeft(T/2) PRight(D)  TNutCages(H,-3,profile); // back panel
            // shelves front panel
            MDown(H/2-S1/2) MLeft(left) PLeft(D) TNutCages(SF1,1,profile);
            MUp  (H/2-S2/2) MLeft(left) PLeft(D) TNutCages(SF2,2,profile);
        }
    }
}
module wallBolts() {
    // those with negative (-) count in walls() are holes, plug with bolts
    // while testing, show only:
    // - wallBolts();
    // - solid() walls();
    MUp(S1)    PBottom(H) patternRepeater(D,2) boltNut();
    MUp(S2)    PBottom(H) patternRepeater(D,2) boltNut();
    MLeft(T/2) PRight(D)  patternRepeater(H,3) boltNut();
}        
// *** BACK ***
module back() {
    effW=W-2*T;
    punch() {
        square([effW,H],center=true);
        union() {                    
                    PLeft(effW)  TNutCages(H, 3,profile); // walls
                    PRight(effW) TNutCages(H, 3,profile);
            MUp(S1) PBottom(H)   TNutCages(W,-2,profile); // shelves bottom
            MUp(S2) PBottom(H)   TNutCages(W,-2,profile);
        }
    }
}
module backBolts() {
    MUp(S1) PBottom(H) patternRepeater(W,2) boltNut();
    MUp(S2) PBottom(H) patternRepeater(W,2) boltNut();
}
// *** SHELVES BOTTOM ***
module shelfBottom() {
    top    = -T;
    bottom = +EXT;
    effD   = D+top+bottom;
    effW   = W-2*T;
    punch() {
        MDown((-top+bottom)/2)
        square([effW,effD],center=true);
        union() {                    
            MRight(T) PLeft(W)  TNutCages(D, 2,profile);  // walls
            MLeft(T)  PRight(W) TNutCages(D, 2,profile);
            MUp(bottom-T) PBottom(D) TNutCages(W,-2,profile); // front
            MDown(-top) PTop(D) TNutCages(W, 2,profile);  // back
        }
    }
}
module shelfBottomBolts() {
    bottom = +EXT;
    MUp(bottom-T) PBottom(D) patternRepeater(W,2) boltNut();
}        
// *** SHELVES FRONT ***
module frontPanel1() {
    effW  =W+EXT*2;
    top   =-T;
    effSF1=SF1+top;
    punch() {
        MDown(-top/2)
        square([effW,effSF1],center=true);
        union() {
            MRight(T/2) MUp(top/4)    PLeft(W)     TNutCages(SF1,-1,profile); // walls
            MLeft (T/2) MUp(top/4)    PRight(W)    TNutCages(SF1,-1,profile);
                        MDown(-top/2) PTop(effSF1) TNutCages(W  , 2,profile); // front
        }
    }
}
module frontPanel1Bolts() {
    top   =-T;
    MRight(T/2) MUp(top/4) PLeft( W) patternRepeater(SF1,1) boltNut();
    MLeft (T/2) MUp(top/4) PLeft(-W) patternRepeater(SF1,1) boltNut();
}
module frontPanel2() {
    effW  =W+EXT*2;
    bottom=-T;
    effSF2=SF2+bottom;
    punch() {
        MUp(-bottom/2)
        square([effW,effSF2],center=true);
        union() {                    
            MRight(T/2) MDown(bottom/4) PLeft(W)        TNutCages(SF2,-2,profile); // walls
            MLeft (T/2) MDown(bottom/4) PRight(W)       TNutCages(SF2,-2,profile);
                        MUp(-bottom/2)  PBottom(effSF2) TNutCages(W  , 2,profile); // front
        }
    }
}
module frontPanel2Bolts() {
    bottom=-T;
    MRight(T/2) MDown(bottom/4) PLeft( W) patternRepeater(SF2,2) boltNut();
    MLeft (T/2) MDown(bottom/4) PLeft(-W) patternRepeater(SF2,2) boltNut();
}       

// to diagnose a part while designing,
// set debug to true and generate the part. ex:
//    debug=true;
//    walls();
//debug=true;
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
