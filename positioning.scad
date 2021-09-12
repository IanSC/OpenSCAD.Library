//
// POSITIONING.SCAD
// by ISC 2021
//
// routing to position 2D elements
// used by Notch library
//
//    PTop(), PBottom(), PLeft(), PRight()
//    PFTop(), PFBottom(), PFLeft(), PFRight()
//    MUp(), MDown(), MLeft(), MRight()

//
// POSITIONING 2-D
//

    // run me!!!
    //Positioning_Demo();

    module Positioning_Demo() {

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
    }

    module PTop(canvas,leftRight=0) {
        // move up
        translate([leftRight,canvas/2,0]) children();
    }
    module PFTop(canvas,leftRight=0) {
        // move up
        // flip left/right
        translate([leftRight,canvas/2,0]) rotate([180,0,180]) children();
    }
    module PBottom(canvas,leftRight=0) {
        // move down
        // mirror of PTop()
        translate([leftRight,-canvas/2,0])
        rotate([180,0,0])
        children();
    }
    module PFBottom(canvas,leftRight=0) {
        // move down
        // mirror of PFTop()
        translate([leftRight,-canvas/2,0]) rotate([0,0,180]) children();
    }
    module PLeft(canvas,upDown=0) {
        // rotate CCW to left
        translate([-canvas/2,upDown,0]) rotate([0,0,90]) children();
    }
    module PFLeft(canvas,upDown=0) {
        // rotate CCW to left
        // up/down flip
        translate([-canvas/2,upDown,0]) rotate([0,0,-90]) rotate([180,0,0]) children();
    }
    module PRight(canvas,upDown=0) {
        // move right
        // mirror of PLeft();
        translate([canvas/2,upDown,0]) rotate([0,0,90]) rotate([180,0,0]) children();
    }
    module PFRight(canvas,upDown=0) {
        // move right
        // mirror of PFLeft();
        translate([canvas/2,upDown,0]) rotate([0,0,-90]) children();
    }
    
    module MUp(offset,leftRight=0) {
        translate([leftRight,offset,0]) children();
    }
    module MDown(offset,leftRight=0) {
        translate([leftRight,-offset,0]) children();
    }
    module MLeft(offset,upDown=0) {
        translate([-offset,upDown,0]) children();
    }
    module MRight(offset,upDown=0) {
        translate([offset,upDown,0]) children();
    }