# Timing Pulley
base code from: [https://www.thingiverse.com/thing:16627](https://www.thingiverse.com/thing:16627) by droftarts
this version is still suitable for 3D printing

---
## List of Functions
|||
|-|:-|
| TimingPulleyProfile               | create profile
| TimingPulley                      | generate timing pulley
| TimingPulleyConnected             | generate connected timing pulleys
| TimingPulleyCenterDistance        | calculate distance between pulleys
| TimingPulleyCenterDistanceByModel | calculate distance between pulleys
| TimingPulleyDiameter              | calculate diameter of pulley
<!--
<table>
<tr><td colspan="2"><h4>Timing Pulley</h4>
</h4></td></tr>
<tr><td><b>TimingPulleyProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>TimingPulley</b>( profile )</td><td>generate timing pulley</td></tr>
<tr><td><b>TimingPulleyConnected</b>( profile1, profile2, beltLength )</td><td>generate connected timing pulleys</td></tr>
<tr><td><b>TimingPulleyCenterDistance</b>( profile1, profile2, beltLength )</td><td>center to center distance between 2 pulleys</td></tr>
<tr><td><b>TimingPulleyCenterDistanceByModel</b>( model, tooth1, tooth2, beltLength )</td><td>center to center distance between 2 pulleys</td></tr>
<tr><td><b>TimingPulleyDiameter</b>( model, toothCount )</td><td>calculate diameter of pulley</td></tr>
</table>
-->

---
#### _TimingPulleyProfile( ... )_
||||
|-|-|:-|
| model                 | &nbsp;   | user defined model name
| toothModel            | &#10004; | pulley type, eg. "T5", "GT2 2mm"...
| toothCount            | &#10004; | number of teeth
| beltWidth             | &#10004; | thickness of notched cylinder
| shaftDiameter         | &#10004; | shaft diameter
| topFlangeInfo         | &nbsp;   | list [ radiusOffset, taperedHeight, flatHeight ]
| bottomFlangeInfo      | &nbsp;   | list [ radiusOffset, taperedHeight, flatHeight ]
| hubInfo               | &nbsp;   | list [ diameter, height ]
| nutInfo               | &nbsp;   | list [ "hex" or "square", boltDiameter, nutDiameter, thickness ]
| captiveNutsInfo       | &nbsp;   | list [ nutCount, angleBetweenNuts, offsetFromShaft ]
| toothWidthTweak = 0.2 | &nbsp;   | adjustments to fine tune 3D printing...
| toothDepthTweak = 0   | &nbsp;   | ... see source timingPulleyNotchedCylinderCore()
| **_return_**          |          | KVTree profile

_Available Tooth Models for 3D Printing and Display:_
&nbsp; &nbsp; &nbsp;MXL, 40DP, XL, L
&nbsp; &nbsp; &nbsp;T2.5, T5, T10
&nbsp; &nbsp; &nbsp;AT5
&nbsp; &nbsp; &nbsp;HTD 3mm, HTD 5mm, HTD 8mm
&nbsp; &nbsp; &nbsp;GT2 2mm, GT2 3mm, GT2 5mm

_Additional for Display Only:_
&nbsp; &nbsp; &nbsp;H
&nbsp; &nbsp; &nbsp;AT10
&nbsp; &nbsp; &nbsp;HTD 14mm
<!--
<table>
<tr><td colspan="3"><h4>TimingPulleyProfile( ... )
<tr><td>model                <td>        <td>user defined model name
<tr><td>toothModel           <td>&#10004;<td>pulley type, eg. "T5", "GT2 2mm"...
<tr><td>toothCount           <td>&#10004;<td>number of teeth
<tr><td>beltWidth            <td>&#10004;<td>thickness of notched cylinder
<tr><td>shaftDiameter        <td>&#10004;<td>shaft diameter
<tr><td>topFlangeInfo        <td>        <td>list [ radiusOffset, taperedHeight, flatHeight ]
<tr><td>bottomFlangeInfo     <td>        <td>list [ radiusOffset, taperedHeight, flatHeight ]
<tr><td>hubInfo              <td>        <td>list [ diameter, height ]
<tr><td>nutInfo              <td>        <td>list [ "hex" or "square", boltDiameter, nutDiameter, thickness ]
<tr><td>captiveNutsInfo      <td>        <td>list [ nutCount, angleBetweenNuts, offsetFromShaft ]
<tr><td>toothWidthTweak = 0.2<td>        <td>adjustments to fine tune 3D printing...
<tr><td>toothDepthTweak = 0  <td>        <td>... see source timingPulleyNotchedCylinderCore()
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>
-->

#### _TimingPulley( profile )_
||||
|-|-|:-|
|model|&#10004;|user defined model name
<!--
<table>
<tr><td colspan="3"><h4>TimingPulley( profile )
<tr><td>profile<td>&#10004;<td>timing pulley profile to display
</table>
-->

#### _TimingPulleyConnected( profile1, profile2, beltLength )_
||||
|-|-|:-|
| profile1        | &#10004; | timing pulley profile 1
| profile2        | &#10004; | timing pulley profile 2
| beltLength      | &#10004; | length of belt to use
| beltWidth       | &nbsp;   | width of belt
| beltThickness=2 | &nbsp;   | thickness of belt for display
| reversed=false  | &nbsp;   | reverse 2nd pulley (hub of other side)
| omitTeeth=false | &nbsp;   | omit teeth notches for display performance
| showBelt=true   | &nbsp;   | display connecting belt
<!--
<table>
<tr><td colspan="3"><h4>TimingPulleyConnected( profile1, profile2, beltLength )
<tr><td>profile1       <td>&#10004;<td>timing pulley profile 1
<tr><td>profile2       <td>&#10004;<td>timing pulley profile 2
<tr><td>beltLength     <td>&#10004;<td>length of belt to use
<tr><td>beltWidth      <td>        <td>width of belt
<tr><td>beltThickness=2<td>        <td>thickness of belt for display
<tr><td>reversed=false <td>        <td>reverse 2nd pulley (hub of other side)
<tr><td>omitTeeth=false<td>        <td>omit notches for display performance
<tr><td>showBelt=true  <td>        <td>show or hide connecting belt
</table>
-->

#### _TimingPulleyCenterDistance( profile1, profile2, beltLength )_
<table>
<tr><td>profile1  <td>&#10004;<td>timing pulley profile 1
<tr><td>profile2  <td>&#10004;<td>timing pulley profile 2
<tr><td>beltLength<td>&#10004;<td>length of belt to use
<tr><td colspan="2"><b><i>return<td>distance between centers
</table>

#### _TimingPulleyCenterDistanceByModel( model, toothCount1, toothCount2, beltLength )_
<table>
<tr><td>model      <td>&#10004;<td>pulley type, eg. "T5", "GT2 2mm"...
<tr><td>toothCount1<td>&#10004;<td>number of teeth of pulley 1
<tr><td>toothCount2<td>&#10004;<td>number of teeth of pulley 2
<tr><td>beltLength <td>&#10004;<td>length of belt to use
<tr><td colspan="2"><b><i>return<td>distance between centers
</table>

#### _TimingPulleyDiameter( model, toothCount )_
<table>
<tr><td>model     <td>&#10004;<td>pulley type, eg. "T5", "GT2 2mm"...
<tr><td>toothCount<td>&#10004;<td>number of teeth of pulley 1
<tr><td colspan="2"><b><i>return<td>diameter of pulley
</table>

---
## Data Structure
```
type         : "timing pulley"
model        : "pushy-101"
toothModel   : "GT2 2mm"
toothCount   : 60
beltWidth    : 12
shaftDiameter: 6
height       = total       : 33
               beltCenter  : 24
               belt        : 12
               topFlange   : 3
               bottomFlange: 3
               hub         : 15
topFlange    = offset     : 3
               height     : 3
               taperHeight: 1
               flatHeight : 2
bottomFlange = offset     : 3
               height     : 3
               taperHeight: 1
               flatHeight : 2
hub          = diameter: 20
               height  : 15
nut          = shape       : "hex"
               boltDiameter: 3.2
               nutDiameter : 5.7
               thickness   : 2.7
captiveNuts  = count           : 3
               angleBetweenNuts: 120
               offsetFromShaft : 1.2
tweak        = toothWidth: 0.2
               toothDepth: 0
```

---
## Sample Code
![photo](/images/timing-pulley.png)
```
profile1 = TimingPulleyProfile(

    toothModel         = "GT2 2mm",
    toothCount         =   60,
    beltWidth          =   12,
    shaftDiameter      =    6,
    topFlangeInfo    = [    3,   // offset notched cylinder diameter
                            1,   // tapered height
                            2    // flat height
                       ],
    bottomFlangeInfo = [    3,
                            1,
                            2
                       ],
    hubInfo          = [   20,   // diameter
                           15    // height
                       ],         
    nutInfo          = [ "hex",  // hex or square
                            3.2, // bolt diameter
                            5.7, // nut diameter
                            2.7  // thickness
                       ],
    captiveNutsInfo  = [    3,   // number of nuts
                          120,   // angle between nuts
                            1.2  // offset from shaft (NOT offset from center)
                       ],
    toothWidthTweak    =    0.2, // fine tune teeth for 3D printing
    toothDepthTweak    =    0
    );

translate( [0,0,0] )
    TimingPulley( profile1, omitTeeth=true );

// 3-D PRINTING (detailed but slow)
translate( [75,0,0] )
    TimingPulley( profile1, for3DPrinting=true, autoFlip=true );

// CONNECTED PULLEYS
profile2 = TimingPulleyProfile(
    toothModel="GT2 2mm",
    toothCount=16, beltWidth=12,
    shaftDiameter=6,
    topFlangeInfo=[3,1,2], bottomFlangeInfo=[3,1,2],
    hubInfo=[20,15] );

beltLength=200;
center2center = TimingPulleyCenterDistance( profile1, profile2, beltLength );
s1 = kvGet(profile1,"shaftDiameter" );
s2 = kvGet(profile2,"shaftDiameter" );

translate( [150,0,0] ) {
    TimingPulleyConnected( profile1, profile2, beltLength, beltWidth=10, reversed=true );            
                                     translate( [0,0,30] ) cylinder( 100, d=s1, center=true );
    translate( [center2center,0,0] ) translate( [0,0,30] ) cylinder( 100, d=s2, center=true );
}

// COMPUTATIONS
echo( TimingPulleyDiameter( "AT5", 64 ) );
echo( TimingPulleyDiameter( "AT5", 20 ) );
echo( TimingPulleyCenterDistanceByModel( "AT5", 64, 20, 700 ) );

kvEchoAligned( profile1 );
```
