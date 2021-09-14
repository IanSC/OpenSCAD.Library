# Panel T-Nut Cage Notched
Create combination of T-Nut and notches on panels.

---
## List of Functions
<table>
<tr><td><b>TNutCageNotched_M</b>( targetWidth, notches, tnutProfile, notchProfile )</td><td>generate 2D bolt/nut capture and notches
<tr><td><b>TNutCageNotched_F</b>( targetWidth, notches, tnutProfile, notchProfile )</td><td>generate 2D hole for perpendicular connected panel
<tr><td><b>TNutCageNotched</b>( targetWidth, notches, tnutProfile, notchProfile )</td><td>switch between M and F versions by changing +/- on notches
</table>

---
#### _TNutCageNotched_M( targetWidth, notches, tnutProfile, notchProfile, leftGap, rightGap )_
<table>
<tr><td>targetWidth <td>&#10004;<td>width to generate for
<tr><td>notches=0   <td>&#10004;<td>number of notches (with t-nuts in between)
<tr><td>tnutProfile <td>&#10004;<td>T-Nut profile from TNutCageProfile()
<tr><td>notchProfile<td>&#10004;<td>notch profile from NotchProfile()
<tr><td>leftGap=0   <td>        <td>additional margin on the left before notching
<tr><td>rightGap=0  <td>        <td>additional margin on the right before notching
</table>

#### _TNutCageNotched_F( targetWidth, notches, tnutProfile, notchProfile, leftGap, rightGap )_
Create holes to partner with TNutCageNotched_M()
<table>
<tr><td>targetWidth <td>&#10004;<td>width to generate for
<tr><td>notches=0   <td>&#10004;<td>number of holes (with t-nuts in between)
<tr><td>tnutProfile <td>&#10004;<td>T-Nut profile from TNutCageProfile()
<tr><td>notchProfile<td>&#10004;<td>notch profile from NotchProfile()
<tr><td>leftGap=0   <td>        <td>additional margin on the left before notching
<tr><td>rightGap=0  <td>        <td>additional margin on the right before notching
</table>

#### _TNutCageNotched( targetWidth, notches, tnutProfile, notchProfile, leftGap, rightGap )_
<table>
<tr><td>targetWidth <td>&#10004;<td>width to generate for
<tr><td>notches=0   <td>&#10004;<td>number of repetitions:<br/>
                                    (+) number of notches, use _TNutCageNotched_M()<br/>
                                    (-) number of holes for connected panel, use _TNutCageNotched_F()
<tr><td>tnutProfile <td>&#10004;<td>T-Nut profile from TNutCageProfile()
<tr><td>notchProfile<td>&#10004;<td>notch profile from NotchProfile()
<tr><td>leftGap=0   <td>        <td>additional margin on the left before notching
<tr><td>rightGap=0  <td>        <td>additional margin on the right before notching
</table>

---
## Sample Code
![photo](/images/panel-tnut-notched-1.png)
```
panelThickness = 3;

// NOTCH PROFILE
notchProfile = NotchProfile(
    panelThickness = panelThickness,
    notchWidthAllowance  = 0, holeWidthAllowance  = 1,
    notchHeightAllowance = 0, holeHeightAllowance = 1
);

// T-NUT PROFILE
boltProfile = BoltProfile(
    shaftDiameter = 3,
    length        = 15,
    headDiameter  = 5,
    headThickness = 3 );
nutProfile = NutProfile(
    boltDiameter = 3,
    nutDiameter  = 5,
    thickness    = 3 );
tnutProfile = TNutCageProfile(
    connectedPanelThickness = panelThickness,
    boltProfile             = boltProfile,
    nutProfile              = nutProfile,
    nutEdgeGap              = 8,   // panel edge to captured nut
    boltDiameterAllowance   = 1,   // allowance from physical sizes
    boltLengthAllowance     = 0.5,
    nutDiameterAllowance    = 1,
    nutThicknessAllowance   = 1
);

// ...possibly extract from another module
edgeGap     =kvGet(tnutProfile,"nut.edgeGap");
nutThickness=kvGet(tnutProfile,"nut.thickness");

// *** SINGLE T-NUT ***
translate([0,0,0]) {
    OFFront(panelThickness,panelThickness) color( "lightgray" ) {
        OBottom(panelThickness)
            Bolt(boltProfile);
        OBottom(panelThickness,edgeGap+panelThickness+nutThickness) rotate([0,0,30])
            Nut(nutProfile);
    }
    malePanel(30,notchProfile)
    
        /* ▶ */     TNutCageNotched_M( 30, 0, tnutProfile, notchProfile );
        
    OBack(panelThickness) femalePanel(30)
    
        /* ▶ */     TNutCageNotched_F( 30, 0, tnutProfile, notchProfile );
}

// *** MULTIPLE T-NUTS 1 ***
translate([60,0,0]) rotate([0,0,180]) {
    OFFront(panelThickness,panelThickness) color( "lightgray" ) {
        notchRepeaterOutside(50,1) {
            OBottom(panelThickness)
                Bolt(boltProfile);
            OBottom(panelThickness,edgeGap+panelThickness+nutThickness) rotate([0,0,30])
                Nut(nutProfile);
        }
    }
    malePanel(50,notchProfile)
    
        /* ▶ */     TNutCageNotched( 50, 1, tnutProfile, notchProfile );
        
    OBack(panelThickness) femalePanel(50)
    
        /* ▶ */     TNutCageNotched( 50, -1, tnutProfile, notchProfile );
}

// *** MULTIPLE T-NUTS 2 ***
translate([150,0,0]) {
    OFFront(panelThickness,panelThickness) color( "lightgray" ) {
        notchRepeaterOutside(80,3) {
            OBottom(panelThickness)
                Bolt(boltProfile);
            OBottom(panelThickness,edgeGap+panelThickness+nutThickness) rotate([0,0,30])
                Nut(nutProfile);
        }
    }
    malePanel(80,notchProfile)
    
        /* ▶ */     TNutCageNotched( 80, 3, tnutProfile, notchProfile );
        
    OBack(panelThickness) femalePanel(80)
    
        /* ▶ */     TNutCageNotched( 80, -3, tnutProfile, notchProfile );
}

module malePanel(width,notchProfile) {
    linear_extrude(panelThickness,center=true)
    difference() {
        union() {
            translate([0,-10,0]) square([width,20],center=true); // panel top at origin
            nHa=kvGet(notchProfile,"notch.heightAllowance");
            if (nHa>0) // notchHeightAllowance above origin
                translate([0,nHa/2-0.5,0]) square([width,nHa+1],center=true);
        }
        children();
    }
}
module femalePanel(width) {
    color( "green", 0.7 )
    linear_extrude(panelThickness,center=true)
    difference() {
        square([width,20],center=true);
        children();
    }
}
```

---
## Sample Code Assembly
![photo](/images/panel-tnut-notched-2.png)
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

// NOTCH PROFILE
notchProfile = NotchProfile(
    panelThickness = T,
    notchWidthAllowance  = 0, holeWidthAllowance  = 1,
    notchHeightAllowance = 0, holeHeightAllowance = 1
);

// T-NUT PROFILE
boltProfile = BoltProfile(
    shaftDiameter =  1,
    length        = 8,
    headDiameter  =  3,
    headThickness =  1 );
nutProfile = NutProfile(
    boltDiameter = 1,
    nutDiameter  = 3,
    thickness    = 1 );
tnutProfile = TNutCageProfile(
    connectedPanelThickness = T,
    boltProfile             = boltProfile,
    nutProfile              = nutProfile,
    nutEdgeGap              = 3,   // panel edge to captured nut
    boltDiameterAllowance   = 1,   // allowance from physical sizes...
    boltLengthAllowance     = 0.5,
    nutDiameterAllowance    = 1,
    nutThicknessAllowance   = 1
);

// ...possibly extract from another module
edgeGap     =kvGet(tnutProfile,"nut.edgeGap");
nutThickness=kvGet(tnutProfile,"nut.thickness");

assembly();
translate([120,0,0])
rotate([0,0,180])
    assembly();

showBolts=true;

module assembly() {
    CubeExtents(W,D,H);

    // shelves
    color("LightGrey") OBottom (0,H/2-S1) solid() shelfBottom();
    color("LightGrey") OBottom (0,H/2-S2) solid() shelfBottom();
    if (showBolts)     OFBottom(0,H/2-S1)         shelfBottomBolts();
    if (showBolts)     OBottom (0,H/2-S2)         shelfBottomBolts();
    
    // walls
                    OLeft  (T,W/2) solid()                   walls();
                    ORight (T,W/2) solid() rotate([0,180,0]) walls();
    if (showBolts) OLeft  (T,W/2)                           wallBolts();
    if (showBolts) OFRight(T,W/2) mirror([0,0,1])           wallBolts();
    
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
    right = +EXT;
    effD  = D+right;
    punch() {
        MRight(right/2)
        square([effD,H],center=true);
        union() {                    
            MUp(S1)    PBottom(H) TNutCageNotched(D,-2,tnutProfile,notchProfile,5,5); // holes for shelf bottom
            MUp(S2)    PBottom(H) TNutCageNotched(D,-2,tnutProfile,notchProfile,5,5);
            MLeft(T/2) PRight(D)  TNutCageNotched(H,-3,tnutProfile,notchProfile); // back panel
            // shelves front panel
            MUp  (H/2-SF2/2) PLeft(D) TNutCageNotched_M(SF2,2,tnutProfile,notchProfile,5,5);
            // for bottom, single t-nut, trim panel
            MDown(H/2-SF1/2,T) PLeft(D) TNutCage_M(tnutProfile);
            MDown(H/2-SF1/2,T/2) PLeft(D) square([SF1,T],center=true);
        }
    }
}
module wallBolts() {
    // those with negative (-) count in walls() are holes, plug with bolts
    // while testing, show only:
    // - wallBolts();
    // - solid() walls();
    MUp(S1)    PBottom(H) notchRepeaterOutside(D-5-5,2) boltNut();
    MUp(S2)    PBottom(H) notchRepeaterOutside(D-5-5,2) boltNut();
    MLeft(T/2) PRight(D)  notchRepeaterOutside(H,3)     boltNut();
}        
// *** BACK ***
module back() {
    punch() {
        square([W,H],center=true);
        union() {                    
                    PLeft(W)   TNutCageNotched(H, 3,tnutProfile,notchProfile);       // walls
                    PRight(W)  TNutCageNotched(H, 3,tnutProfile,notchProfile);
            MUp(S1) PBottom(H) TNutCageNotched(W,-2,tnutProfile,notchProfile,10,10); // shelves bottom
            MUp(S2) PBottom(H) TNutCageNotched(W,-2,tnutProfile,notchProfile,10,10);
        }
    }
}
module backBolts() {
    MUp(S1) PBottom(H) notchRepeaterOutside(W-10-10,2) boltNut();
    MUp(S2) PBottom(H) notchRepeaterOutside(W-10-10,2) boltNut();
}
// *** SHELVES BOTTOM ***
module shelfBottom() {
    bottom = +EXT;
    effD   = D+bottom;
    punch() {
        MDown(bottom/2)
        square([W,effD],center=true);
        union() {
                        PLeft(W)   TNutCageNotched(D, 2,tnutProfile,notchProfile,5,5);   // walls   
                        PRight(W)  TNutCageNotched(D, 2,tnutProfile,notchProfile,5,5);
            MUp(T/2) PBottom(D) TNutCageNotched(W,-2,tnutProfile,notchProfile);       // front 
                        PTop(D)    TNutCageNotched(W, 2,tnutProfile,notchProfile,10,10); // back
        }
    }
}
module shelfBottomBolts() {
    bottom = +EXT;
    MUp(bottom-T) PBottom(D) notchRepeaterOutside(W,2) boltNut();
}        
// *** SHELVES FRONT ***
module frontPanel1() {
    effW=W+EXT*2;
    punch() {
        square([effW,SF1],center=true);
        union() {
            MRight(T/2) PLeft(W)  TNutCage_F     (tnutProfile);                   // walls
            MLeft (T/2) PRight(W) TNutCage_F     (tnutProfile);
                        PTop(SF1) TNutCageNotched (W,2,tnutProfile,notchProfile); // front
        }
    }
}
module frontPanel1Bolts() {
    top   =-T;
    MRight(T/2) PLeft( W) notchRepeaterOutside(SF1,0) boltNut();
    MLeft (T/2) PLeft(-W) notchRepeaterOutside(SF1,0) boltNut();
}
module frontPanel2() {
    effW=W+EXT*2;
    punch() {
        square([effW,SF2],center=true);
        union() {                    
            MRight(T/2) PLeft(W)     TNutCageNotched(SF2,-2,tnutProfile,notchProfile,5,5); // walls
            MLeft (T/2) PRight(W)    TNutCageNotched(SF2,-2,tnutProfile,notchProfile,5,5);
                        PBottom(SF2) TNutCageNotched(W  , 2,tnutProfile,notchProfile);     // front
        }
    }
}
module frontPanel2Bolts() {
    MRight(T/2) PLeft( W) notchRepeaterOutside(SF2-5-5,2) boltNut();
    MLeft (T/2) PLeft(-W) notchRepeaterOutside(SF2-5-5,2) boltNut();
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
