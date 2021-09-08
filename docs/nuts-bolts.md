# Nuts and Bolts

---
## List of Functions
<table>
<tr><td><b>BoltProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>Bolt</b>( profile )</td><td>generate bolt</td></tr>
<tr><td><b>BoltPanelHole</b>( profile )</td><td>generate 2D holes for panel mounting</td></tr>
<tr><td><b>NutProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>Nut</b>( profile )</td><td>generate nut</td></tr>
</table>

---
#### _BoltProfile( ... )_
<table>
<tr><td>model           <td>        <td>user defined model name
<tr><td>shape = "hex"   <td>        <td>shape of head: "hex", "square" or "round"
<tr><td>feature = "none"<td>        <td>feature on head: "none", "minus", "plus" or "hex"
<tr><td>shaftDiameter   <td>&#10004;<td>shaft diameter
<tr><td>length          <td>&#10004;<td>length, exclusing head
<tr><td>headDiameter    <td>&#10004;<td>head diameter
<tr><td>headThickness   <td>&#10004;<td>head thickness
<tr><td colspan="2"><b><i>return    <td>KVTree profile
</table>

#### _Bolt( profile )_
<table>
<tr><td>profile<td>&#10004;<td>bolt profile to display
</table>

#### _BoltPanelHole( profile )_
<table>
<tr><td>profile<td>&#10004;<td>bolt profile to generate panel holes for
</table>

#### _NutProfile( ... )_
<table>
<tr><td>model        <td>        <td>user defined model name
<tr><td>shape = "hex"<td>        <td>shape of head: "hex", "square" or "round"
<tr><td>boltDiameter <td>&#10004;<td>inside diameter
<tr><td>nutDiameter  <td>&#10004;<td>outside diameter
<tr><td>thickness    <td>&#10004;<td>thickness
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>

#### _Nut( profile )_
<table>
<tr><td>profile<td>&#10004;<td>nut profile to display
</table>
</details>

---
## Data Structure
```
type: "bolt"
model: "esV"
diameter: 5
length: 20
head =
   shape: "hex"
   diameter: 10
   thickness: 3
   feature: "none"
```
```
type: "nut"
model: "ella"
shape: "hex"
boltDiameter: 5
nutDiameter: 8
thickness: 3"
```

---
## Sample Code
![photo](/images/nuts-bolts.png)

```
profile = BoltProfile(
    shape         = "hex",  // "hex" | "square" | "round" 
    feature       = "none", // "none" | "minus" | "plus" | "hex"
    shaftDiameter = 5,
    length        = 20,
    headDiameter  = 10,
    headThickness = 3 );
Bolt( profile );

translate( [0,-15,0] )
    linear_extrude( 3 )
    difference() {
        square( [10,10], center=true );
        BoltPanelHole( profile );
    }

translate( [30,0,0] ) {
                          featureVariation( "hex" );
    translate( [20,0,0] ) featureVariation( "square" );
    translate( [40,0,0] ) featureVariation( "round" );
}

translate( [0,-40,0] ) {
    nut1 = NutProfile( shape="hex",    boltDiameter=5, nutDiameter=8, thickness=3 );
    nut2 = NutProfile( shape="square", boltDiameter=5, nutDiameter=8, thickness=3 );
    nut3 = NutProfile( shape="round",  boltDiameter=5, nutDiameter=8, thickness=3 );
                          Nut( nut1 );
    translate( [10,0,0] ) Nut( nut2 );
    translate( [20,0,0] ) Nut( nut3 );
}

module featureVariation( shape ) {
    b1 = BoltProfile( shape=shape, shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
    Bolt( b1 );
    translate( [0,15,0] ) {
        b2 = BoltProfile( shape=shape, feature="minus", shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
        Bolt( b2 );
    }
    translate( [0,30,0] ) {
        b3 = BoltProfile( shape=shape, feature="plus", shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
        Bolt( b3 );
    }
    translate( [0,45,0] ) {
        b4 = BoltProfile( shape=shape, feature="hex", shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
        Bolt( b4 );
    }
}
```
