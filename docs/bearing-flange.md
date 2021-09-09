# Flange Bearing

---
## List of Functions
<table>
<tr><td><b>FlangeBearingProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>FlangeBearing</b>( profile )</td><td>generate flange bearing</td></tr>
<tr><td><b>FlangeBearingPanelHoles</b>( profile )</td><td>generate 2D holes for panel mounting</td></tr>
</table>

---
#### _FlangeBearingProfile( ... )_
<table>
<tr><td>model           <td>        <td>user defined model name
<tr><td>shaftDiameter   <td>&#10004;<td>shaft diameter
<tr><td>boltDiameter = 5<td>        <td>size of bolts
<tr><td>boltDistance    <td>&#10004;<td>bolt to bolt distance
<tr><td>boltCount = 2   <td>        <td>number of bolts, 2 or 4 only
<tr><td>height          <td>&#10004;<td>height of central part
<tr><td>ringHeight      <td>        <td>height of ring around the center
<tr><td>baseHeight      <td>        <td>thickness of base
<tr><td>width           <td>        <td>overall width
<tr><td>depth           <td>        <td>overall depth
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>

#### _FlangeBearing( profile )_
<table>
<tr><td>profile<td>&#10004;<td>flange bearing profile to display
</table>

#### _FlangeBearingPanelHoles( profile )_
<table>
<tr><td>profile<td>&#10004;<td>flange bearing profile to generate panel holes for
</table>
</details>

---
## Data Structure
```
type         : "flange bearing"
model        : "FB-100"
shaftDiameter: 10
bolt         = diameter: 5
               distance: 50
               count   : 4
width        : 100
depth        : 80
height       = center: 32
               ring  : 25
               base  : 10
```

---
## Sample Code
![photo](/images/bearing-flange.png)
```
profile2a = FlangeBearingProfile(
    shaftDiameter =  8,
    boltDistance  = 37,
    height        = 12 );
PartAndPanel() {
    FlangeBearing( profile2a );
    FlangeBearingPanelHole( profile2a );
}

profile2b = FlangeBearingProfile(
    shaftDiameter =  10,
    boltDiameter  =   5, 
    boltDistance  =  80,
    boltCount     =   2, 
    height        =  20,
    width         = 100,
    depth         =  60 );
translate( [150,0,0] )
PartAndPanel() {
    FlangeBearing( profile2b );
    FlangeBearingPanelHole( profile2b, enlargeBolt=3 );
}

profile4a = FlangeBearingProfile( 
    shaftDiameter =  8,
    boltDistance  = 37,
    boltCount     =  4, 
    height        = 12 );
translate( [300,0,0] )
PartAndPanel() {
    FlangeBearing( profile4a );
    FlangeBearingPanelHole( profile4a, omitCenterHole=false, enlargeShaft=5 );
}

profile4b = FlangeBearingProfile(
    shaftDiameter =  10,
    boltDiameter  =   5,
    boltDistance  =  50,
    boltCount     =   4, 
    height        =  32,
    ringHeight    =  25, 
    baseHeight    =  10,
    width         = 100,
    depth         =  80 );
translate( [450,0,0] )
PartAndPanel() {
    FlangeBearing( profile4b );
    FlangeBearingPanelHole( profile4b );
}

kvEchoAligned( profile4b );

module PartAndPanel() {
    children(0);
    translate( [0,-100,0] )
        linear_extrude( 3 )
        difference() {
            square( [120,100], center=true );
            children(1);
        }
}
```
