//
// ORIENTATION
// by ISC 2021
//
// routines to easily position panels
//

include <utility.scad>

//
// DEMO
//

    // run me!!!
    //Orientation_Demo_Basic();
    translate( [0,100,0] )
        Orientation_Demo();
    
    module Orientation_Demo_Basic() {
        // shows default positioning of panels
        
        W   = 50; // width
        D   = 50; // depth
        H   = 50; // height
        THK = 3;  // thickness of panel
        
        OTop   (THK) color( "green"  ) cube([ W,D  ,THK ],center=true);
        OBottom(THK) color( "red"    ) cube([ W,D  ,THK ],center=true);
        OFront (THK) color( "blue"   ) cube([ W,  H,THK ],center=true);
        OBack  (THK) color( "yellow" ) cube([ W,  H,THK ],center=true);
        OLeft  (THK) color( "purple" ) cube([   D,H,THK ],center=true);
        ORight (THK) color( "tomato" ) cube([   D,H,THK ],center=true);
    }

    module Orientation_Demo() {
        
        $fn=20;
        
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
            OTop   (THK, 0  , 0  , H/2) color("green" ,0.5) Panel( W,D   );             // move up only
            OBottom(THK, 0  , 0  , H/2) color("red"   ,0.5) Panel( W,D   );             // move down only
            OFront (THK, 0  , D/2, 0  ) color("blue"  ,0.5) Panel( W,  H-THK*2 );       // facing front
            OBack  (THK, 0  , D/2, 0  ) color("yellow",0.5) Panel( W,  H-THK*2 );       // facing front
            OLeft  (THK, W/2, 0  , 0  ) color("purple",0.6) Panel(   D-THK*2,H-THK*2 ); // facing right
            ORight (THK, W/2, 0  , 0  ) color("tomato",0.7) Panel(   D-THK*2,H-THK*2 ); // facing left
            CubeExtents( W,D,H, color="red" );
        }

        module Box( faceIn ) {
            OTop   (THK, 0  , 0  , H/2, faceIn) color("green" ,0.5) Panel( W,D   );
            OBottom(THK, 0  , 0  , H/2, faceIn) color("red"   ,0.5) Panel( W,D   );
            OFront (THK, 0  , D/2, 0  , faceIn) color("blue"  ,0.5) Panel( W,  H-THK*2 );
            OBack  (THK, 0  , D/2, 0  , faceIn) color("yellow",0.5) Panel( W,  H-THK*2 );
            OLeft  (THK, W/2, 0  , 0  , faceIn) color("purple",0.6) Panel(   D-THK*2,H-THK*2 );
            ORight (THK, W/2, 0  , 0  , faceIn) color("tomato",0.7) Panel(   D-THK*2,H-THK*2 );
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

    module OTop( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=false ) {
        // panel drawn on X/Y axis centered at 0
        // when placed on top, just lift up the same as drawn
        // drawn face is outside the enclosure, default to face outwards
        // +upDown ==> move HIGHER
        // -upDown ==> move LOWER
        translate( [leftRight,frontBack,upDown] )
        translate( [0,0,-thickness/2] )
        if ( faceIn )
            rotate( [0,180,0] ) children();
        else
            children();
    }
    
    module OBottom( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=true ) {
        // panel drawn on X/Y axis centered at 0
        // when moved downward, natural orientation is the same as drawn
        // as if looking at the floor, so default is to face inward
        // +upDown ==> move LOWER
        // -upDown ==> move HIGHER
        translate( [leftRight,frontBack,-upDown] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }


    module OFront( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=false ) {
        // panel drawn on X/Y axis centered at 0
        // when positioned, put on the front as if viewing the front of house from outside
        // oriented same was as drawn, default to facing outwards
        // +frontBack ==> move towards FRONT
        // -frontBack ==> move BACKWARDS
        translate( [leftRight,-frontBack,upDown] )
        rotate( [90,0,0] )
        translate( [0,0,-thickness/2] )
        if ( faceIn )
            rotate( [0,180,0] ) children();
        else
            children();
    }

    module OBack( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=true ) {
        // panel drawn on X/Y axis centered at 0
        // when positioned, put on the back as if viewing wall to backdoor
        // oriented same drawn, default to facing inwards
        // +frontBack ==> move BACKWARDS
        // -frontBack ==> move towards FRONT
        translate( [leftRight,frontBack,upDown] )
        rotate( [90,0,0] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }

    module OLeft( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=true ) {
        // drawn X/Y axis centered by user
        // when positioned, put on the left as if viewing left wall
        // oriented same was as drawn, default to facing inwards
        // +leftRight ==> move LEFT
        // -leftRight ==> move RIGHT
        translate( [-leftRight,frontBack,upDown] )
        rotate( [90,0,90] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }

    module ORight( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=true ) {
        // panel drawn on X/Y axis centered at 0
        // when positioned, put on the right as if viewing right wall
        // oriented same was as drawn, default to facing inwards
        // +rightLeft ==> move RIGHT
        // -leftRight ==> move LEFT
        translate( [leftRight,frontBack,upDown] )
        rotate( [90,0,-90] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }
