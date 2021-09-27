//
// ORIENTATION
// by ISC 2021-09
//
// routines to easily position panels in 3D
//
//     OTop(),  OBottom(),  OFront(),  OBack(),  OLeft(),  ORight()
//     OFTop(), OFBottom(), OFFront(), OFBack(), OFLeft(), OFRight()
//

include <utility.scad>

//
// DEMO
//

    // run me!!!
    //Orientation_Demo();
    //translate([-100,0,0])
    //    Orientation_Demo_Basic();
    
    module Orientation_Demo_Basic() {
        // shows default positioning of panels
        
        W   = 50; // width
        D   = 50; // depth
        H   = 50; // height
        THK = 3;  // thickness of panel
        
        OTop   (THK) color( "orange"    ) cube([ W,D  ,THK ],center=true);
        OBottom(THK) color( "gold"      ) cube([ W,D  ,THK ],center=true);
        OFront (THK) color( "steelblue" ) cube([ W,  H,THK ],center=true);
        OBack  (THK) color( "red"       ) cube([ W,  H,THK ],center=true);
        OLeft  (THK) color( "green"     ) cube([   D,H,THK ],center=true);
        ORight (THK) color( "violet"    ) cube([   D,H,THK ],center=true);
    }

    module Orientation_Demo() {
        
        $fn=20;
        
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
        translate( [100,100,0] ) {
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
 
    }

//
// ORIENTATION
//    

    module OMove( rightLeft=0, frontBack=0, upDown=0 ) {
        translate( [rightLeft,frontBack,upDown] )
            children();
    }

    // these are intended for making panels for enclosures
    // so point of view, is as if the user is inside the box/house

    module OTop( thickness=0, offset=0, leftRight=0, frontBack=0, faceIn=false ) {
        // panel drawn on X/Y axis centered at 0
        // when placed on top, just lift up the same as drawn
        // drawn face is outside the enclosure, default to face outwards
        // +offset ==> move HIGHER
        // -offset ==> move LOWER
        translate( [leftRight,frontBack,offset] )
        translate( [0,0,-thickness/2] )
        if ( faceIn )
            rotate( [0,180,0] ) children();
        else
            children();
    }

    module OFTop( thickness=0, offset=0, leftRight=0, frontBack=0, faceIn=true ) {
        OTop( thickness, offset, leftRight, frontBack, faceIn ) children();
    }
    
    module OBottom( thickness=0, offset=0, leftRight=0, frontBack=0, faceIn=true ) {
        // panel drawn on X/Y axis centered at 0
        // when moved downward, natural orientation is the same as drawn
        // as if looking at the floor, so default is to face inward
        // +offset ==> move LOWER
        // -offset ==> move HIGHER
        translate( [leftRight,frontBack,-offset] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }

    module OFBottom( thickness=0, offset=0, leftRight=0, frontBack=0, faceIn=false ) {
        OBottom( thickness, offset, leftRight, frontBack, faceIn ) children();
    }

    module OFront( thickness=0, offset=0, leftRight=0, upDown=0, faceIn=false ) {
        // panel drawn on X/Y axis centered at 0
        // when positioned, put on the front as if viewing the front of house from outside
        // oriented same was as drawn, default to facing outwards
        // +offset ==> move towards FRONT
        // -offset ==> move BACKWARDS
        translate( [leftRight,-offset,upDown] )
        rotate( [90,0,0] )
        translate( [0,0,-thickness/2] )
        if ( faceIn )
            rotate( [0,180,0] ) children();
        else
            children();
    }

    module OFFront( thickness=0, offset=0, leftRight=0, frontBack=0, faceIn=true ) {
        OFront( thickness, offset, leftRight, frontBack, faceIn ) children();
    }

    module OBack( thickness=0, offset=0, leftRight=0, upDown=0, faceIn=true ) {
        // panel drawn on X/Y axis centered at 0
        // when positioned, put on the back as if viewing wall to backdoor
        // oriented same drawn, default to facing inwards
        // +offset ==> move BACKWARDS
        // -offset ==> move towards FRONT
        translate( [leftRight,offset,upDown] )
        rotate( [90,0,0] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }

    module OFBack( thickness=0, offset=0, leftRight=0, frontBack=0, faceIn=false ) {
        OBack( thickness, offset, leftRight, frontBack, faceIn ) children();
    }

    module OLeft( thickness=0, offset=0, frontBack=0, upDown=0, faceIn=true ) {
        // drawn X/Y axis centered by user
        // when positioned, put on the left as if viewing left wall
        // oriented same was as drawn, default to facing inwards
        // +offset ==> move LEFT
        // -offset ==> move RIGHT
        translate( [-offset,frontBack,upDown] )
        rotate( [90,0,90] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }

    module OFLeft( thickness=0, offset=0, leftRight=0, frontBack=0, faceIn=false ) {
        OLeft( thickness, offset, leftRight, frontBack, faceIn ) children();
    }

    module ORight( thickness=0, offset=0, frontBack=0, upDown=0, faceIn=true ) {
        // panel drawn on X/Y axis centered at 0
        // when positioned, put on the right as if viewing right wall
        // oriented same was as drawn, default to facing inwards
        // +offset ==> move RIGHT
        // -offset ==> move LEFT
        translate( [offset,frontBack,upDown] )
        rotate( [90,0,-90] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }

    module OFRight( thickness=0, offset=0, leftRight=0, frontBack=0, faceIn=false ) {
        ORight( thickness, offset, leftRight, frontBack, faceIn ) children();
    }
