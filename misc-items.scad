//
// SVBONY SV406P SPOTTING SCOPE
//

    module SpottingScope() {
        translate( [-15,0,60] ) {
            translate( [220,0,0] )
                rotate( [0,-90,0] )
                cylinder( 220, 50, 35 );
            translate( [0,0,0] )
                rotate( [0,-90,0] )
                cylinder( 370-220, 35, 50 );
            translate( [-160,0,90] )
                rotate( [0,-45,0] )
                translate( [0,0,-100] )
                cylinder( h=140, r=25 );
            translate( [0,0,-30] )    
                cube( [20,30,60], center=true );
            translate( [15,0,-60+5] )    
                cube( [70,40,10], center=true );
            *#translate( [30,0,0] )
                cube( [370,100,120], center=true );
            *#translate( [0,0,40] )
                cube( [430,100,200], center=true );
        }
    }

//
// BUTTON
//

    // run me !!!
    //Button_Example();

    module Button_Example() {
        // profile = [ "button", "model", 16, "red", [14,1],[18,2],[16,12],[10,6] ]
        profile = ButtonBuildProfile(
            model             = "M123",
            holeSize          = 16,
            presserColor      = "red",
            presserRing   = [ 14,  1 ],
            panelRing     = [ 18,  2 ],
            bodyRing      = [ 16, 12 ],
            connectorRing = [ 10,  6 ]
        );
        difference() {
            square( [50,50], center=true );
            ButtonHole( profile );
        }
        translate( [0,0,20] )
            Button( profile );
    }

    function ButtonBuildProfile(
        model,
        holeSize,
        presserColor, // "red"
        presserRing,  // [ diameter, height ]
        panelRing,    // [ diameter, height ]
        bodyRing,     // [ diameter, height ]
        connectorRing // [ diameter, height ]
    ) = [
        "button",
        model,
        holeSize,
        presserColor,
        presserRing,
        panelRing,
        bodyRing,
        connectorRing
    ];

    module Button( buttonDef ) {
        // ex. Button( [ "button", "model", 16, "red", [14,1],[18,2],[16,12],[10,6] ] );
        holeSize      = buttonDef[2];
        presserColor  = buttonDef[3]; // "red"
        presserRing   = buttonDef[4]; // [ diameter, height ]
        panelRing     = buttonDef[5]; // [ diameter, height ]
        bodyRing      = buttonDef[6]; // [ diameter, height ]
        connectorRing = buttonDef[7]; // [ diameter, height ]
        color( presserColor ) translate( [0,0,panelRing[1]] ) 
            cylinder( h=presserRing[1], d=presserRing[0] );
        cylinder( h=panelRing[1], d=panelRing[0] );
        translate( [0,0,-bodyRing[1]] ) {
            cylinder( h=bodyRing[1], d=bodyRing[0] );
            translate( [0,0,-connectorRing[1]] )
                cylinder( h=connectorRing[1], d=connectorRing[0] );
        }         
    }

    module ButtonHole( buttonDef, holeAllowance=1 ) {
        holeSize = buttonDef[2];
        circle( d=holeSize+holeAllowance );
    }

//
// PCB
//

    // run me !!!
    //CircuitBoard_Example();

    module CircuitBoard_Example() {
        pcbDef = [ 44, 60, 8, 37, 52 ];
        difference() {
            square( [80,80], center=true );
            CircuitBoardHole( pcbDef, 3 );
        }
        translate( [0,0,20] )
            CircuitBoard( pcbDef );
    }

    function CircuitBoardBuildProfile(
        model,
        width,
        length,
        height,
        boltWidthGap,  // center to center bolt distance along width
        boltLengthGap  // center to center bolt distance along length
    ) = [
        "pcb", model, width, length, height, boltWidthGap, boltLengthGap
    ];

    module CircuitBoard( profile ) {

        // ex, CircuitBoard( [ 44, 60, 8, 37, 52 ] );

        width         = profile[2];
        length        = profile[3];
        height        = profile[4];
        boltWidthGap  = profile[5];
        boltLengthGap = profile[6];

        pcbThickness = 2;
        translate( [0,0,height] )
            translate([0,0,-pcbThickness/2])
            cube( [width,length,pcbThickness], center=true );

        translate([ boltWidthGap/2, boltLengthGap/2,0]) hexagon(5,height-pcbThickness);
        translate([-boltWidthGap/2, boltLengthGap/2,0]) hexagon(5,height-pcbThickness);
        translate([ boltWidthGap/2,-boltLengthGap/2,0]) hexagon(5,height-pcbThickness);
        translate([-boltWidthGap/2,-boltLengthGap/2,0]) hexagon(5,height-pcbThickness);
        module hexagon( size, height ) {
            boxWidth = size/1.75;
            translate([0,0,height/2])
            for (r = [-60, 0, 60]) rotate([0,0,r]) cube([boxWidth, size, height], true);
        }
    }

    module CircuitBoardHole( pcbDef, holeSize ) {
        boltWidthGap  = pcbDef[3];
        boltLengthGap = pcbDef[4];
        translate([ boltWidthGap/2, boltLengthGap/2,0]) circle( holeSize );
        translate([-boltWidthGap/2, boltLengthGap/2,0]) circle( holeSize );
        translate([ boltWidthGap/2,-boltLengthGap/2,0]) circle( holeSize );
        translate([-boltWidthGap/2,-boltLengthGap/2,0]) circle( holeSize );
    }
    
//
// JOY STICK
//

    // run me!!!
    //JoyStick();

    module JoyStick() {
        width  = 65;
        length = 97;
        height = 40;
        
        translate( [0,0,-1.5] )
            cube( [length,width,3], center=true );
        translate( [0,0,-height/2] )
            cube( [length-20,width-20,height], center=true );
        stickHeight = 48;
        sphere = 36;
        cylinder( stickHeight, r=5 );
        color( "pink" )
        translate( [0,0,stickHeight+sphere/2] )
            sphere( d=sphere );
    }
