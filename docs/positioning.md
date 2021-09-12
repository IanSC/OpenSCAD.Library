# Positioning
Routines to quickly position 2D elements on the edges of a rectagular canvas on the XY-plane.

---
## List of Functions
<table>
<tr><td><b>PTop</b>( canvas )    <td>position children on top of the canvas
<tr><td><b>PBottom</b>( canvas ) <td>position children at the bottom of the canvas, mirror of PTop()
<tr><td><b>PLeft</b>( canvas )   <td>position children on the left of the canvas
<tr><td><b>PRight</b>( canvas )  <td>position children on the right of the canvas, mirror of PLeft()
<tr><td><b>PFTop</b>( canvas )   <td>same as PTop() but flipped
<tr><td><b>PFBottom</b>( canvas )<td>same as PBottom() but flipped
<tr><td><b>PFLeft</b>( canvas )  <td>same as PLeft() but flipped
<tr><td><b>PFRight</b>( canvas ) <td>same as PRight() but flipped
<tr><td><b>MUp</b>( offset ) <td>move up
<tr><td><b>MDown</b>( offset ) <td>move down
<tr><td><b>MLeft</b>( offset ) <td>move left
<tr><td><b>MRight</b>( offset ) <td>move right
</table>

#### _PTop( canvas, leftRight )_
<table>
<tr><td>canvas       <td>height of canvas
<tr><td>leftRight = 0<td>left/right offset, right+
</table>

#### _PBottom( thickness, offset, leftRight, frontBack, faceIn )_
<table>
<tr><td>canvas       <td>height of canvas
<tr><td>leftRight = 0<td>left/right offset, right+
</table>

#### _PLeft( canvas, upDown )_
<table>
<tr><td>canvas    <td>width of canvas
<tr><td>upDown = 0<td>up/down offset, up+
</table>

#### _PRight( canvas, upDown )_
<table>
<tr><td>canvas    <td>width of canvas
<tr><td>upDown = 0<td>up/down offset, up+
</table>

#### _MUp( offset, leftRight )_
<table>
<tr><td>offset       <td>distance to move up
<tr><td>leftRight = 0<td>left/right offset, right+
</table>

#### _MDown( offset, leftRight )_
<table>
<tr><td>offset       <td>distance to move down
<tr><td>leftRight = 0<td>left/right offset, right+
</table>

#### _MLeft( offset, upDown )_
<table>
<tr><td>offset    <td>distance to move left
<tr><td>upDown = 0<td>up/down offset, up+
</table>

#### _MRight( offset, upDown )_
<table>
<tr><td>offset    <td>distance to move right
<tr><td>upDown = 0<td>up/down offset, up+
</table>

---
## Sample Code
![photo](/images/positioning.png)
```
cWidth  = 80;
cHeight = 100;

// normal top/left
// bottom/right - mirror
canvas();
target();
color("red")    PTop   (cHeight) target();
color("green")  PBottom(cHeight) target();
color("blue")   PLeft  (cWidth ) target();
color("orange") PRight (cWidth ) target();

// flipped top/left
// bottom/right - mirror
translate([120,0,0]) {
    canvas();
    target();
    color("red")    PFTop   (cHeight) target();
    color("green")  PFBottom(cHeight) target();
    color("blue")   PFLeft  (cWidth ) target();
    color("orange") PFRight (cWidth ) target();
}

// move only
translate([240,0,0]) {
    canvas();
    circle(5);
    color("red")    MUp   (20) circle(5);
    color("green")  MDown (20) circle(5);
    color("blue")   MLeft (20) circle(5);
    color("orange") MRight(20) circle(5);
}

module canvas() {
    color("gray")
    translate([0,0,-1])
    square([cWidth,cHeight],center=true);
    color("red") translate([0,0,1]) {
        square([cWidth,1],center=true);
        square([1,cHeight],center=true);
    }
}
module target() {
    linear_extrude(1)
    difference() {
        polygon([[-15,0],[15,0],[15,-15],[-15,-5]]);
        circle(3);
    }
}
```
