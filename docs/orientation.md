# Orientation
Routines to quickly position panels on the face of a box.

---
## List of Functions
<table>
<tr><td><b>OTop</b>( thickness, offset )   <td>position children as top panel
<tr><td><b>OBottom</b>( thickness, offset )<td>position children as bottom panel
<tr><td><b>OFront</b>( thickness, offset ) <td>position children as front panel
<tr><td><b>OBack</b>( thickness, offset )  <td>position children as back panel
<tr><td><b>OLeft</b>( thickness, offset )  <td>position children as left panel
<tr><td><b>ORight</b>( thickness, offset ) <td>position children as right panel
<tr><td><b>OFTop</b>( thickness, offset )   <td>same as OTop() but flipped
<tr><td><b>OFBottom</b>( thickness, offset )<td>same as OBottom() but flipped
<tr><td><b>OFFront</b>( thickness, offset ) <td>same as OFront() but flipped
<tr><td><b>OFBack</b>( thickness, offset )  <td>same as OBack() but flipped
<tr><td><b>OFLeft</b>( thickness, offset )  <td>same as OLeft() but flipped
<tr><td><b>OFRight</b>( thickness, offset ) <td>same as ORight() but flipped
</table>

#### _OTop( thickness, offset, leftRight, frontBack, faceIn )_
<table>
<tr><td>thickness     <td>panel thickness
<tr><td>offset = 0    <td>up/down offset, UP+
<tr><td>leftRight = 0 <td>left/right offset, right+
<tr><td>frontBack = 0 <td>front/back offset, back+
<tr><td>faceIn = false<td>whether panel is to face inwards or outwards the "box"
</table>

#### _OBottom( thickness, offset, leftRight, frontBack, faceIn )_
<table>
<tr><td>thickness    <td>panel thickness
<tr><td>offset = 0   <td>up/down offset, DOWN+
<tr><td>leftRight = 0<td>left/right offset, right+
<tr><td>frontBack = 0<td>front/back offset, back+
<tr><td>faceIn = true<td>whether panel is to face inwards or outwards the "box"
</table>

#### _OFront( thickness, offset, leftRight, upDown, faceIn )_
<table>
<tr><td>thickness     <td>panel thickness
<tr><td>offset = 0    <td>front/back offset, FRONT+
<tr><td>leftRight = 0 <td>left/right offset, right+
<tr><td>upDown = 0    <td>up/down offset, up+
<tr><td>faceIn = false<td>whether panel is to face inwards or outwards the "box"
</table>

#### _OBack( thickness, offset, leftRight, upDown, faceIn )_
<table>
<tr><td>thickness    <td>panel thickness
<tr><td>offset = 0   <td>front/back offset, BACK+
<tr><td>leftRight = 0<td>left/right offset, right+
<tr><td>upDown = 0   <td>up/down offset, up+
<tr><td>faceIn = true<td>whether panel is to face inwards or outwards the "box"
</table>

#### _OLeft( thickness, offset, frontBack, upDown, faceIn )_
<table>
<tr><td>thickness    <td>panel thickness
<tr><td>offset = 0   <td>left/right offset, LEFT+
<tr><td>frontBack = 0<td>front/back offset, back+
<tr><td>upDown = 0   <td>up/down offset, up+
<tr><td>faceIn = true<td>whether panel is to face inwards or outwards the "box"
</table>

#### _ORight( thickness, offset, frontBack, upDown, faceIn )_
<table>
<tr><td>thickness    <td>panel thickness
<tr><td>offset = 0   <td>left/right offset, RIGHT+
<tr><td>frontBack = 0<td>front/back offset, back+
<tr><td>upDown = 0   <td>up/down offset, up+
<tr><td>faceIn = true<td>whether panel is to face inwards or outwards the "box"
</table>

#### _OF\<direction\>( thickness, offset, frontBack, upDown, faceIn )_
same as similarly named version but faceIn is reversed
eg. OTop( faceIn=false ), OFTop( faceIn=true ), ...

---
## Sample Code
![photo](/images/orientation.png)
```
// NATURAL POSITIONING
axis();
Panel(50,50);
color("steelblue") OFront (THK,50) Panel(50,50);
color("red")       OBack  (THK,50) Panel(50,50);
color("green")     OLeft  (THK,50) Panel(50,50);
color("violet")    ORight (THK,50) Panel(50,50);
color("orange")    OTop   (THK,50) Panel(50,50);
color("gold")      OBottom(THK,50) Panel(50,50);

// FLIP OF NATURAL
translate( [100,0,0] ) {
    axis();
    Panel(50,50);
    color("steelblue") OFFront (THK,50) Panel(50,50);
    color("red")       OFBack  (THK,50) Panel(50,50);
    color("green")     OFLeft  (THK,50) Panel(50,50);
    color("violet")    OFRight (THK,50) Panel(50,50);
    color("orange")    OFTop   (THK,50) Panel(50,50);
    color("gold")      OFBottom(THK,50) Panel(50,50);
}

W   = 40; // width
D   = 50; // depth
H   = 80; // height
THK =  3; // thickness of panel

// panels facing outwards
translate( [210,0,0] )
    Box( faceIn=false );

// panels facing inwards
translate( [300,0,0] )
    Box( faceIn=true );

module axis() {
    color("red") {
        cube([100,1,1],center=true);
        cube([1,100,1],center=true);
        cube([1,1,100],center=true);
    }
}

module Box( faceIn ) {
    // less: THK*2, so no overlap
    OBottom(THK, H/2, faceIn=faceIn) color("gold"     ) Panel( W,D               );
    OLeft  (THK, W/2, faceIn=faceIn) color("green"    ) Panel(   D-THK*2,H-THK*2 );
    OBack  (THK, D/2, faceIn=faceIn) color("red"      ) Panel( W,        H-THK*2 );
    OTop   (THK, H/2, faceIn=faceIn) color("orange"   ) Panel( W,D               );
    ORight (THK, W/2, faceIn=faceIn) color("violet"   ) Panel(   D-THK*2,H-THK*2 );
    OFront (THK, D/2, faceIn=faceIn) color("steelblue") Panel( W,        H-THK*2 );
    CubeExtents( W,D,H, color="red" );
}

module Panel( width,height ) {
    linear_extrude( THK, center=true )
    difference() {
        square( [width,height], center=true );
        {
            translate( [width*.25,-height*.25,0] )
                square( [width/4,height/4], center=true );
            translate( [-width*.25,-height*.25,0] )
                circle( d=width/4 );
            translate( [0,height*.25,0] )
                text("H3LLO",size=6,halign="center",valign="center");
        }
    }
}
```
