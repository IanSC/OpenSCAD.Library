//------------------
// orientation.scad
//------------------
// by Ian Co 2021
//
// routines to easily position panels
//

//
// EXAMPLE
//

    // run me!!!
    //Orientation_Example();    
    //translate( [0,100,0] )
    //    Orientation_Basic();
    
    module Orientation_Basic() {
        OFront(3,0,0,0,false) color( "green" )
            cube( [50,50,3], center=true );        
        OBack(3,0,0,0,false) color( "red" )
            cube( [50,50,3], center=true );
        OLeft(3,0,0,0,false) color( "blue" )
            cube( [50,50,3], center=true );        
        ORight(3,0,0,0,false) color( "yellow" )
            cube( [50,50,3], center=true );
        OTop(3,0,0,0,false) color( "violet" )
            cube( [50,50,3], center=true );        
        OBottom(3,0,0,0,false) color( "orange" )
            cube( [50,50,3], center=true );
    }

    module Orientation_Example() {
        
        $fn=20;
        
        width     = 20;
        depth     = 30;
        height    = 40;
        thickness = 3;
        
        translate( [-40,0,0] )
            Panel(width,depth,3);

        // panels facing outwards
        Box( faceIn=false );
        
        // panels facing inwards
        translate( [50,0,0] )
            Box( faceIn=true );

        module Box( faceIn ) {
            OBottom(thickness,0,0,0,faceIn)
                Panel( width,depth,thickness );
            OTop(thickness,0,0,height,faceIn)
                Panel( width,depth,thickness );
            OLeft(thickness,width/2,0,height/2,faceIn)
                Panel( depth,height,thickness );
            ORight(thickness,width/2,0,height/2,faceIn)
                Panel( depth,height,thickness );
            OFront(thickness,0,depth/2,height/2,faceIn)
                Panel( width,height,thickness );
            OBack(thickness,0,depth/2,height/2,faceIn)
                Panel( width,height,thickness );
            color( "red" )
                translate( [0,0,height/2] )
                BoxExtents( width,depth,height );
        }

        module Panel( width,height,thickness ) {
            linear_extrude( thickness, center=true )
            difference() {
                square( [width,height], center=true );
                {
                    translate( [width*.25,height*.25,0] )
                        square( [width/4,height/4], center=true );
                    translate( [-width*.25,-height*.25,0] )
                        circle( d=width/4 );
                }
            }
        }
        
    }

    module BoxExtents( width, depth, height ) {
        size = 1;
        w = (width+size)/2;
        d = (depth+size)/2;
        h = (height+size)/2;
        translate([ w, d, h]) cube([size,size,size],center=true);
        translate([ w, d,-h]) cube([size,size,size],center=true);
        translate([ w,-d, h]) cube([size,size,size],center=true);
        translate([ w,-d,-h]) cube([size,size,size],center=true);
        translate([-w, d, h]) cube([size,size,size],center=true);
        translate([-w, d,-h]) cube([size,size,size],center=true);
        translate([-w,-d, h]) cube([size,size,size],center=true);
        translate([-w,-d,-h]) cube([size,size,size],center=true);
    }

//
// ORIENTATION
//    

    module OMove( rightLeft=0, frontBack=0, upDown=0 ) {
        translate( [rightLeft,frontBack,upDown] )
            children();
    }

    module OBottom( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=true ) {
        // face the same way as drawn, so default face inward
        // upDown ==> go LOWER
        translate( [leftRight,frontBack,-upDown] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }

    module OTop( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=false ) {
        // usually just lift up, so default facing outwards
        // upDown ==> go HIGHER
        translate( [leftRight,frontBack,upDown] )
        translate( [0,0,-thickness/2] )
        if ( faceIn )
            rotate( [0,180,0] ) children();
        else
            children();
    }

    module OLeft( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=true ) {
        // usually viewing from inside the "box", so default face inwards
        // leftRight ==> go LEFT
        translate( [-leftRight,frontBack,upDown] )
        rotate( [90,0,90] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }

    module ORight( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=true ) {
        // usually viewing from inside the "box", so default face inwards
        // rightLeft ==> go RIGHT
        translate( [leftRight,frontBack,upDown] )
        rotate( [90,0,-90] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();
    }

    module OFront( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=false ) {
        // usually viewing as drawn, so default face outwards
        // frontBack ==> go FRONT
        translate( [leftRight,-frontBack,upDown] )
        rotate( [90,0,0] )
        translate( [0,0,-thickness/2] )
        if ( faceIn )
            rotate( [0,180,0] ) children();    
        else
            children();
    }

    module OBack( thickness=0, leftRight=0, frontBack=0, upDown=0, faceIn=true ) {
        // usually viewing as drawn, so default face inwards
        // frontBack ==> go BACK
        translate( [leftRight,frontBack,upDown] )
        rotate( [90,0,0] )
        translate( [0,0,thickness/2] )
        if ( faceIn )
            children();
        else
            rotate( [0,180,0] ) children();    
    }

