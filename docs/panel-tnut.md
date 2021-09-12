# Panel T-Nut Cage

---
## List of Functions
<table>
<tr><td><b>TNutCageProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>TNutCage</b>( profile )</td><td>generate 2D bolt/nut capture slots</td></tr>
<tr><td><b>TNutCagePanelHole</b>( profile )</td><td>generate 2D hole for perpendicular connected panel</td></tr>
</table>

---
#### _TNutCageProfile( ... )_
<table>
<tr><td>panelThickness           <td>&#10004; <td>panel thickness for
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

#### _TNutCage( profile )_
<table>
<tr><td>profile<td>&#10004;<td>profile to generate
</table>

#### _TNutCagePanelHole( profile, allowance )_
<table>
<tr><td>profile      <td>&#10004;<td>profile to generate hole for connecting perpendicular panel
<tr><td>allowance = 0<td>        <td>enlarge/reduce generated hole
</table>

---
## Data Structure
```
panelThickness: 3
bolt          = effDiameter: 4
                effLength  : 15.5
nut           = effDiameter       : 6
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

profile1 = TNutCageProfile(
    panelThickness = panelThickness,
    boltDiameter = boltDiameter, nutDiameter  = nutDiameter,
    boltLength   = boltLength,   nutThickness = nutThickness,
    nutEdgeGap   = nutEdgeGap
);

translate([0,0,0]) {
malePanel()

/*▶*/   TNutCage( profile1 );

femalePanel(panelThickness,boltDiameter)

/*▶*/   TNutCagePanelHole( profile1 );

translate([0,panelThickness,0]) dummyBolt();
translate([0,-nutEdgeGap,0]) dummyNut();
}

// override panel thickness
translate([50,0,0]) {
THK=5;
malePanel()

/*▶*/   TNutCage( profile1, panelThickness=THK );

femalePanel(THK,boltDiameter)

/*▶*/   TNutCagePanelHole( profile1 );

translate([0,THK,0]) dummyBolt();
translate([0,-nutEdgeGap,0]) dummyNut();
}

profile2 = TNutCageProfile(
    panelThickness = panelThickness,
    boltDiameter = boltDiameter, nutDiameter  = nutDiameter,
    boltLength   = boltLength,   nutThickness = nutThickness,
    nutEdgeGap   = nutEdgeGap,
    // allowance from physical sizes...
    boltDiameterAllowance = 1,
    boltLengthAllowance   = 0.5,
    nutDiameterAllowance  = 1,
    nutThicknessAllowance = 1
);

// allowance on bolt/nuts
// adjust hole size
translate([100,0,0]) {
malePanel()

/*▶*/   TNutCage( profile2 );

femalePanel(panelThickness,boltDiameter)

/*▶*/   TNutCagePanelHole( profile2, allowance=2 );

translate([0,panelThickness,0]) dummyBolt();
translate([0,-nutEdgeGap,0]) dummyNut();
}

module malePanel() {
    difference() {
        translate([0,-10,0]) square([20,20],center=true);
        children();
    }
}
module femalePanel(thickness,boltDiameter) {
    color("SteelBlue") translate([0,thickness/2,0])
        square([25,thickness],center=true);
    translate([0,20,0]) {
        color("SteelBlue") difference() {
            square([25,10],center=true);
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

// PANELS ONLY

profile1 = TNutCageProfile(
    panelThickness = panelThickness,
    boltLength   = 15, nutDiameter  = 5,
    boltDiameter =  3, nutThickness = 3,
    nutEdgeGap   =  5
);
panelMale()

/*▶*/   TNutCage(profile1);

translate( [0,panelThickness/2,0] ) rotate( [90,0,0] ) panelFemale(panelThickness)

/*▶*/   TNutCagePanelHole(profile1);

// PANELS WITH NUTS AND BOLTS
// - see "nuts-bolts.scad"

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
    panelThickness        = panelThickness,
    boltProfile           = boltProfile,
    nutProfile            = nutProfile,
    nutEdgeGap            = 8,   // panel edge to captured nut
    boltDiameterAllowance = 1,   // allowance from physical sizes...
    boltLengthAllowance   = 0.5,
    nutDiameterAllowance  = 1,
    nutThicknessAllowance = 1
);
kvEchoAligned(profile2);

// ...possibly extract from another module
edgeGap     =kvGet(profile2,"nut.edgeGap");
nutThickness=kvGet(profile2,"nut.thickness");

translate([50,0,0]) //rotate([0,0,180]) 
{
rotate( [-90,0,0] ) color( "lightgray" ) {
    translate( [0,0,panelThickness] )
        Bolt(boltProfile);
    translate([0,0,-edgeGap-nutThickness]) rotate([0,0,30])
        Nut(nutProfile);
}
panelMale()

/*▶*/   TNutCage(profile2);

translate([0,panelThickness/2,0]) rotate([90,0,0]) panelFemale(panelThickness)

/*▶*/   TNutCagePanelHole(profile2);
}

// USING ORIENTATION HELPERS
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

/*▶*/   TNutCage(profile2,panelThickness=THK);

OFront(THK) panelFemale(THK)

/*▶*/   TNutCagePanelHole(profile2,allowance=2);
}

module panelMale() {
    linear_extrude(panelThickness,center=true)
    difference() { // panel top at origin
        translate( [0,-10,0] ) square( [20,20], center = true );
        children();
    }
}
module panelFemale(thickness) {
    color("SteelBlue",0.5)
    linear_extrude(thickness,center=true)
    difference() {
        square( [20,20], center = true );
        children();
    }
}
```
