# Orientation

---
## List of Functions
<table>
<tr><td><b>OTop</b>( thickness, offset )   <td>position children as top panel
<tr><td><b>OBottom</b>( thickness, offset )<td>position children as bottom panel
<tr><td><b>OFront</b>( thickness, offset ) <td>position children as front panel
<tr><td><b>OBack</b>( thickness, offset )  <td>position children as back panel
<tr><td><b>OLeft</b>( thickness, offset )  <td>position children as left panel
<tr><td><b>ORight</b>( thickness, offset ) <td>position children as right panel
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

---
## Sample Code
![photo](/images/orientation.png)
```
W   = 40; // width
D   = 50; // depth
H   = 80; // height
THK = 3;  // thickness of panel

Panel(W,D);

// panels default orientation
translate( [100,0,0] )
    BoxDefault();

// panels facing outwards
translate( [200,0,0] )
    Box( faceIn=false );

// panels facing inwards
translate( [300,0,0] )
    Box( faceIn=true );

module BoxDefault() {
    // less: THK*2, so no overlap
    OTop   (THK, H/2 ) color("green" ,0.5) Panel( W,D               ); // move up only
    OBottom(THK, H/2 ) color("red"   ,0.5) Panel( W,D               ); // move down only
    OFront (THK, D/2 ) color("blue"  ,0.5) Panel( W,        H-THK*2 ); // facing front
    OBack  (THK, D/2 ) color("yellow",0.5) Panel( W,        H-THK*2 ); // facing front
    OLeft  (THK, W/2 ) color("purple",0.6) Panel(   D-THK*2,H-THK*2 ); // facing right
    ORight (THK, W/2 ) color("tomato",0.7) Panel(   D-THK*2,H-THK*2 ); // facing left
    CubeExtents( W,D,H, color="red" );
}

module Box( faceIn ) {
    // less: THK*2, so no overlap
    OTop   (THK, H/2, faceIn=faceIn) color("green" ,0.5) Panel( W,D               );
    OBottom(THK, H/2, faceIn=faceIn) color("red"   ,0.5) Panel( W,D               );
    OFront (THK, D/2, faceIn=faceIn) color("blue"  ,0.5) Panel( W,        H-THK*2 );
    OBack  (THK, D/2, faceIn=faceIn) color("yellow",0.5) Panel( W,        H-THK*2 );
    OLeft  (THK, W/2, faceIn=faceIn) color("purple",0.6) Panel(   D-THK*2,H-THK*2 );
    ORight (THK, W/2, faceIn=faceIn) color("tomato",0.7) Panel(   D-THK*2,H-THK*2 );
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
