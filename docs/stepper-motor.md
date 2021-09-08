# Stepper Motor

---
## List of Functions
<table>
<tr><td><b>StepperMotorProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>StepperMotor</b>( profile )</td><td>generate stepper motor</td></tr>
<tr><td><b>StepperMotorPanelHole</b>( profile )</td><td>generate 2D holes for panel mounting</td></tr>
</table>

---
#### _StepperMotorProfile( ... )_
<table>
<tr><td>model              <td>        <td>user defined model name
<tr><td>nemaModel          <td>1A      <td>use info from NEMA model (unless overridden)
<tr><td>bodyDiameter       <td>1B      <td>width and depth of the motor
<tr><td>bodyLength         <td>1B      <td>length excluding shafts and cylinders
<tr><td>shaftDiameter      <td>1B      <td>shaft diameter
<tr><td>shaftLength        <td>1B      <td>shaft length
<tr><td>boltProfile        <td>2A      <td>use info from bolt profile (unless overridden)
<tr><td>boltDiameter       <td>2B      <td>bolt diameter
<tr><td>boltLength         <td>2B      <td>bolt length
<tr><td>boltToBoltDistance <td>&#10004;<td>distance between bolts
<tr><td>frontCylinder      <td>        <td>list [ diameter, height ]
<tr><td>backCylinder       <td>        <td>list [ diameter, height ]
<tr><td>flangeThickness    <td>        <td>list [ upper height, lower height ]
<tr><td>bodyTaper          <td>        <td>taper on body between flanges
<tr><td>overallTaper       <td>        <td>taper on motor body
<tr><td>backShaftLength = 0<td>        <td>length of shaft at the back
<tr><td>panelHoleDiameter  <td>        <td>size of center hole for panel mounting the motor
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>

#### _StepperMotor( profile )_
<table>
<tr><td>profile<td>&#10004;<td>stepper motor profile to display
</table>

#### _StepperMotorPanelHole( profile )_
<table>
<tr><td>profile<td>&#10004;<td>stepper motor profile to generate panel holes for
</table>

---
## Data Structure
```
type: "stepper motor"
model: "Wantai 57BYGH420-2"
nema: ""
bodyDiameter: 56.4
length =
   all: 77
   body: 57.6
   bodyOnly: 56
   frontCylinder: 1.6
   backCylinder: 0
   shaft: 19.4
   backShaft: 0
   frontFlange: 4.8
   backFlange: 0
shaft =
   diameter: 6.35
   length: 19.4
backShaft =
   diameter: 6.35
   length: 0
bolt =
   diameter: 5
   length: 10
   distance: 47.14
panelHole: 8.35
frontCylinder =
   diameter: 38.1
   length: 1.6
backCylinder =
   diameter: 0
   length: 0
taper =
   overall: 2.82
   body: 1
```

---
## Sample Code
![photo](/images/stepper-motor.png)
```
profile1 = StepperMotorProfile( nemaModel="NEMA17" );
PartAndPanel() {
    StepperMotor( profile1 );
    StepperMotorPanelHoles( profile1 );
};

// custom size
// https://www.sparkfun.com/products/13656 ==> Wantai 57BYGH420-2
// https://www.openimpulse.com/blog/wp-content/uploads/wpsc/downloadables/57BYGH420-Stepper-Motor-Datasheet.pdf
profile2 = StepperMotorProfile(
    model           = "Wantai 57BYGH420-2",
    bodyDiameter    = 56.4,
    bodyLength      = 56,
    shaftDiameter   = 6.35,
    shaftLength     = 21-1.6,
    boltDiameter    = 5,
    boltLength      = 10,
    boltDistance    = 47.14,
    frontCylinder   = [ 38.1, 1.6 ], // diameter, height
    flangeThickness = [  4.8,   0 ], // upper, lower
    bodyTaper       = 1 );
translate( [100,0,0] )
PartAndPanel() {
    StepperMotor( profile2 );
    StepperMotorPanelHoles( profile2, enlargeBolt=3 );
};
kvEcho( profile2 );

// with gear, bolts on gear
profile3 = StepperMotorProfile(
    nemaModel     = "NEMA23",
    boltDistance  = 20,
    frontCylinder = [40,20]
);
translate( [200,0,0] )
PartAndPanel() {
    StepperMotor( profile3 );
    StepperMotorPanelHoles( profile3 );
};
    
// with gear, bolts on body, back cylinder and shaft
// bigger panel hole
profile4 = StepperMotorProfile(
    nemaModel          = "NEMA23",
    boltDiameter       = 8,
    boltLength         = 25+8,    // go below frontCylinderLength
    boltDistance       = 38,
    frontCylinder      = [40,25],
    backCylinder       = [40,20],
    panelHoleDiameter  = 40+2,    // larger than frontCylinderDiameter
    backShaftLength    = 20 );
translate( [300,0,0] ) {
    // position to upper flange
    translate( [0,0, kvGet(profile4,"length.frontCylinder")] )
        StepperMotor( profile4 );
    translate( [0,-100,0] ) PanelOnly()
        StepperMotorPanelHoles( profile4 );
}

// position to lower shaft
translate( [400,0,0] ) {
    translate( [0,0,kvGet(profile3,"length.body")] )
        StepperMotor( profile3 );
}

// position to bottom of body, excluding lower cylinder
translate( [500,0,0] ) {
    translate( [0,0,kvGet(profile4,"length.body")-kvGet(profile4,"length.backCylinder")] )
        StepperMotor( profile4 );
}

module PartAndPanel() {
    children(0);
    translate( [0,-100,0] )
        PanelOnly() children(1);
}
module PanelOnly() {
    linear_extrude( 3 )
    difference() {
        square( [60,60], center=true );
        children();
    }
}
```
