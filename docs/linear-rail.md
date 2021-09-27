# Linear Rails

---
## List of Functions
<table>
<tr><td><b>LinearRailHolderSHFProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>LinearRailHolderSHF</b>( profile )</td><td>generate holder</td></tr>
<tr><td><b>LinearRailHolderSHFPanelHole</b>( profile, omitCenterHole, enlargeShaft, enlargeBolt )</td><td>generate 2D holes for panel mounting</td></tr>



<tr><td><b>LinearRailHolderSKProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>LinearRailHolderSK</b>( profile )</td><td>generate holder</td></tr>
<tr><td><b>LinearRailHolderSKPanelHole</b>( profile, enlargeBolt )</td><td>generate 2D holes for panel mounting</td></tr>
</table>

---
#### _LinearRailHolderSHFProfile( ... )_
<table>
<tr><td>model             <td>        <td>user defined model name
<tr><td>shaftDiameter     <td>&#10004;<td>shaft diameter
<tr><td>boltDiameter = 5  <td>        <td>size of bolts
<tr><td>boltDistance      <td>&#10004;<td>bolt to bolt distance
<tr><td>thickness = 10    <td>        <td>thickness of the holder
<tr><td>width             <td>        <td>overall width
<tr><td>centerRingDiameter<td>        <td>diameter of ring around shaft
<tr><td>baseHeight        <td>        <td>shaft center to base bottom
<tr><td>baseWidth         <td>        <td>width of base
<tr><td>slit = 1          <td>        <td>clamp slit width on base
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>

#### _LinearRailHolderSHF( profile )_
<table>
<tr><td>profile<td>&#10004;<td>rail holder profile to display
</table>

#### _LinearRailHolderSHFPanelHole( profile )_
<table>
<tr><td>profile              <td>&#10004;<td>rail holder profile to generate panel holes for
<tr><td>omitCenterHole = true<td>        <td>skip hole for center shaft
<tr><td>enlargeShaft = 1     <td>        <td>increase hole size for center shaft
<tr><td>enlargeBolt = 1      <td>        <td>increase hole size for bolts
</table>

#### _LinearRailHolderSKProfile( ... )_
<table>
<tr><td>model             <td>        <td>user defined model name
<tr><td>shaftDiameter     <td>&#10004;<td>shaft diameter
<tr><td>shaftHeight       <td>&#10004;<td>distance from floor to shaft center

<tr><td>boltDiameter = 5  <td>        <td>size of bolts
<tr><td>boltDistance      <td>&#10004;<td>bolt to bolt distance
<tr><td>thickness = 10    <td>        <td>thickness of the holder
<tr><td>width             <td>        <td>width of shaft holder
<tr><td>height            <td>        <td>overall height
<tr><td>baseWidth         <td>        <td>width of base
<tr><td>baseHeight        <td>        <td>height of base
<tr><td>slit = 1          <td>        <td>clamp slit width
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>

#### _LinearRailHolderSK( profile )_
<table>
<tr><td>profile<td>&#10004;<td>rail holder profile to display
</table>

#### _LinearRailHolderSKPanelHole( profile )_
<table>
<tr><td>profile              <td>&#10004;<td>rail holder profile to generate panel holes for
<tr><td>enlargeBolt = 1      <td>        <td>increase hole size for bolts
</table>

---
## Data Structure
```
type         : "linear rail holder SHF"
model        : "SHF8"
shaftDiameter: 8
bolt         = diameter: 5
               distance: 34
body         = width       : 43
               ringDiameter: 13
               thickness   : 10
base         = width : 20
               height: 14
               slit  : 1
```
```
type : "linear rail holder SK"
model: "SK8"
shaft= diameter: 8
       height  : 20
bolt = diameter: 5
       distance: 32
body = width    : 18
       height   : 33
       thickness: 15
       slit     : 1
base = width : 41
       height: 5
```

---
## Sample Code
![photo](/images/linear-rail.png)

```
profile = LinearRailHolderSHFProfile(
    model              = "SHF8",
    shaftDiameter      = 8,
    boltDistance       = 34,
    width              = 34+5+2+2, // overall width
    centerRingDiameter = 8+5,
    baseHeight         = 14,       // shaft center to base bottom
    baseWidth          = 20,
    slit               = 1    
);
profileAuto = LinearRailHolderSHFProfile(
    model         = "SHF8-auto",
    shaftDiameter = 8,
    boltDistance  = 34
);

LinearRailHolderSHF( profile );
kvEchoAligned( profile );

translate([0,40,0])
    LinearRailHolderSHF( profileAuto );

translate([0,-40,-3])
linear_extrude(3)
difference() {
    square([70,25],center=true);
    LinearRailHolderSHFPanelHole( profile );
}
```
```
profileAuto = LinearRailHolderSKProfile(
    model         = "SK8-auto",
    shaftDiameter = 8,
    shaftHeight   = 20,
    boltDistance  = 32
);
profile = LinearRailHolderSKProfile(
    model = "SK8",
    shaftDiameter = 8,
    shaftHeight   = 20, // floor to shaft center
    boltDiameter  = 5, 
    boltDistance  = 32,
    width         = 18,
    height        = 33, // overall height
    thickness     = 15,
    baseWidth     = 41,
    baseHeight    = 5,
    slit          = 1
);

LinearRailHolderSKProfile( profile );
kvEchoAligned( profile );

translate([0,40,0])
    LinearRailHolderSKProfile( profileAuto );

translate([0,-40,-3])
linear_extrude(3)
difference() {
    square([70,25],center=true);
    LinearRailHolderSKPanelHole( profile );
}

shaftHeight = kvGet(profile, "shaft.height" );
color("green")
translate([0,20,shaftHeight])
rotate([90,0,0])
    cylinder(100,d=8,center=true);
```
