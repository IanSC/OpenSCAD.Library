//
// PANELS
// by ISC 2021
//
//     boltProfile = BoltBuildProfile( ... ) - create profile helper
//     Bolt( boltProfile )                   - draw 3D
//     BoltHole( boltProfile  )              - draw 2D
//
//     nutProfile = NutBuildProfile( ... )   - create profile helper
//     Nut( nutProfile )                     - draw 3D
//

    // run me !!!
    //Notches_Example();
    //translate( [80,0,0] )
    //    TNutCage_Example();
    //translate( [120,0,0] )
    //    TNutCageNotched_Example( 30, 0 );  // no notch, will put notches on side of bolt cage
    //translate( [200,0,0] )
    //    TNutCageNotched_Example( 100, 3 ); // put 3 notches

    module Notches_Example() {

        panelWidth     = 100;
        panelThickness = 3;
        notches        = 2;

        //notchWidthAllowance  = 1;
        //notchHeightAllowance = 1;
        notchProfile = NotchBuildProfile(
            notchHeight=panelThickness,
            widthAllowance=1, heightAllowance=1 );

        // male add to panel
        translate( [0,10,0] ) rotate( [0,0,180] ) {
            difference() {
                translate( [0,-10,0] ) square( [panelWidth,20], center = true );
                Notches_M_add( panelWidth, notches, notchProfile );
            }
            color( "red" ) Notches_M_add( panelWidth, notches, notchProfile ); // for demo
        }
        // male subtract from panel
        translate( [0,-5,0] ) {
            difference() {
                translate( [0,-10,0] ) square( [panelWidth,20], center = true );
                Notches_M( panelWidth, notches, notchProfile );
            }
            color( "red" ) Notches_M( panelWidth, notches, notchProfile ); // for demo
        }
        // female subtract from panel
        rotate( [90,0,0] ) {        
            difference() {
                translate( [0,0,0] ) square( [panelWidth,20], center = true );
                Notches_F( panelWidth, notches, notchProfile );
            }
            color( "red" ) Notches_F( panelWidth, notches, notchProfile ); // for demo
        }
    }
    
    module TNutCage_Example() {
        nutProfile = [ "nut", "M3", "hex", 3.2, 5.7, 2.7 ];
        boltLength = 10;
        edgeGap = 5;
        tnutProfile  = [ nutProfile, boltLength, edgeGap ];

        // male    
        difference() {
            translate( [0,-10,0] ) square( [20,20], center = true );
            TNutCage_M( tnutProfile );
        }
        color( "red" ) TNutCage_M( tnutProfile ); // for demo
        // female    
        translate( [0,5,0] )
        rotate( [90,0,0] ) {        
            difference() {
                translate( [0,0,0] ) square( [20,20], center = true );
                TNutCage_F( tnutProfile );
            }
            color( "red" ) TNutCage_F( tnutProfile ); // for demo
        }
    }

    module TNutCageNotched_Example( panelWidth, notches = 0 ) {

        //panelWidth     = 100;
        panelThickness = 3;

        nutProfile  = [ "nut", "model", "hex", 3.2, 5.7, 2.7 ];
        boltLength  = 10;
        edgeGap     = 5;
        tnutProfile = [ nutProfile, boltLength, edgeGap ];
        
        notchWidthAllowance  = 1;
        notchHeightAllowance = 1;
        notchProfile         = [ panelThickness, notchWidthAllowance, notchHeightAllowance ];

        // male    
        difference() {
            translate( [0,-10,0] ) square( [panelWidth,20], center = true );
            TNutCageNotched_M( panelWidth, tnutProfile, notchProfile, notches );
        }
        color( "red" ) TNutCageNotched_M( panelWidth, tnutProfile, notchProfile, notches ); // for demo
        // female    
        translate( [0,5,0] )
        rotate( [90,0,0] ) {        
            difference() {
                translate( [0,0,0] ) square( [panelWidth,20], center = true );
                TNutCageNotched_F( panelWidth, tnutProfile, notchProfile, notches );
            }
            color( "red" ) TNutCageNotched_F( panelWidth, tnutProfile, notchProfile, notches ); // for demo
        }
    }

//
// NOTCH
//

    //  +-------------------+
    //  |   +---+   +---+   |   female
    //  |   |   |   |   |   |
    //  |   +---+   +---+   |
    //  +-------------------+
    //
    //      +---+   +---+
    //      |   |   |   |
    //  +---+   +---+   +---+    male
    //  |                   |

    function NotchBuildProfile(
        notchHeight = 3,
        widthAllowance = 0.5,
        heightAllowance = 0.5
    ) = [
        notchHeight,     // height of notch, usually same as panel thickness
        widthAllowance,  // extra width when creating holes
        heightAllowance  // extra height when creating holes
    ];

    module Notches_M_add( targetWidth, notches, notchProfile ) {
        // for union() to other parts
        // extra 1mm at the bottom for clean union

        // notchProfile = [ notchHeight, widthAllowance, heightAllowance ];   
        notchHeight       = notchProfile[0];
        //widthAllowance  = notchProfile[1];
        //heightAllowance = notchProfile[2];

        div = notches*2+1;
        notchSize = targetWidth/div;
        notchRepeaterInside( targetWidth, notches )
            translate( [0,notchHeight/2-0.5,0] )
            square( [notchSize,notchHeight+1], center=true );
    }

    module Notches_M( targetWidth, notches, notchProfile ) {
        // for difference() from other parts
        // extra 1mm on top for clean punch

        // notchProfile = [ notchHeight, widthAllowance, heightAllowance ];   
        notchHeight       = notchProfile[0];
        //widthAllowance  = notchProfile[1];
        //heightAllowance = notchProfile[2];

        div = notches*2+1;
        notchSize = targetWidth/div;
        notchRepeaterOutside( targetWidth, notches )
            translate( [0,-notchHeight/2+0.5,0] )
            square( [notchSize,notchHeight+1], center=true );
    }
    
    module Notches_F( targetWidth, notches, notchProfile ) {
        // notchProfile = [ notchHeight, widthAllowance, heightAllowance ];   
        notchHeight     = notchProfile[0];
        widthAllowance  = notchProfile[1];
        heightAllowance = notchProfile[2];
        
        div = notches*2+1;
        notchSize = targetWidth/div;
        notchRepeaterInside( targetWidth, notches )
            square( [notchSize+widthAllowance,notchHeight+heightAllowance], center=true );
    }

    //
    // REPEATERS
    //
    
    module notchRepeaterInside( targetWidth, notches ) {
        //    ###   ###
        // +--   ---   --+
        // |             |
        // ex. notchRepeaterMale( width, notches )
        //        notchExtendOut( width, extendSize, notches );
        div = notches*2+1;
        notchSize = targetWidth/div;
        translate( [-(notches-1)*notchSize,0,0] )
        //translate( [-targetWidth/2+notchSize*1.5,0,0] )
        for (i = [0:notches-1]) {
            translate( [i*notchSize*2,0,0] )
            children();
        }        
    }

    module notchRepeaterOutside( targetWidth, notches ) {
        // ###   ###   ###
        // |  ---   ---  |
        // |             |
        // ex. notchRepeaterFemale( width, notches )
        //        notchPunchInward( width, inwardSize, notches );
        div = notches*2+1;
        notchSize = targetWidth/div;
        translate( [-notches*notchSize,0,0] )
        //translate( [-targetWidth/2+notchSize*0.5,0,0] )
        for (i = [0:notches]) {
            translate( [i*notchSize*2,0,0] )
            children();
        }                
    }

//
// T-NUT CAGE
//
    
    // TOP VIEW (P1)
    //     |         +---+        - - - - - - - - - -
    //     |         |   |                          ^
    //     +---------+   +-----+  ---               |
    //                         |  screwDiameter     nutWidth
    //     +---------+   +-----+  ---               |
    //     |         |   |                          v
    //     |         +---+        - - - - - - - - - -
    //        
    //     |<- gap ->|   |<-- nutThickness
    //     |<-- screwLength -->|
    //
    // SIDE VIEW:
    //     |P2|
    //     |  |              P1 connected to P2
    //     |  |              P1 (male)   will capture the bolt with a nut
    //   ##|  +---@------    P2 (female) has a hole for the bolt
    //   ##|##|###@##  P1    ### - bolt
    //   ##|  +---@-------   @@@ - nut
    //     |  |
    //     +--+
    //
    // technically, P1 is more female :)

    function TNutCageBuildProfile(
        nutProfile = [],
        boltLength = 0.5,
        edgeGap = 0.5
    ) = [
        nutProfile, // nut profile
        boltLength, // extra width when creating holes
        edgeGap     // extra height when creating holes
    ];
    
    module TNutCage_M( tnutProfile ) {
        // extra 1mm on top for clean punch
        
        // ex. TNutCage( [ [ "nut", "mod "hex", 3.2, 5.7, 2.7 ], 10, 5 ] );
        
        // tnutProfile  = [ nutProfile, boltLength, edgeGap ];
        nutProfile = tnutProfile[0];
        boltLength = tnutProfile[1];
        edgeGap    = tnutProfile[2];
        
        // nutProfile = [ "nut", "model", hex|square, boltDiameter, nutFaceSize, nutThickness ]
        boltDiameter = nutProfile[3];
        nutFaceSize  = nutProfile[4];
        nutThickness = nutProfile[5];
        
        translate( [0,-boltLength/2+0.5,0] )
            square( [boltDiameter,boltLength+1], center=true );
        translate( [0,-edgeGap-nutThickness/2,0] )
            square( [nutFaceSize,nutThickness], center=true );
    }    
    
    module TNutCage_F( tnutProfile, allowance=1 ) {
        // ex. TNutHole( [ [ "nut", "model", "hex", 3.2, 5.7, 2.7 ], 10, 5 ] );
        // tnutProfile  = [ nutProfile, boltLength, edgeGap ];
        // nutProfile = [ hex|square, boltDiameter, nutFaceSize, nutThickness ]
        // ex. M3_NUT = [ "hex", 3.2, 5.7, 2.7 ];
        boltDiameter = tnutProfile[0][3];
        circle( d=boltDiameter+allowance );
    }
    
//
// NOTCHES WITH T-NUT
//

    //  +-------------------+
    //  |   +---+   +---+   |   female
    //  | O |   | O |   | O |   O = holes
    //  |   +---+   +---+   |
    //  +-------------------+
    //
    //      +---+   +---+
    //      |   |   |   |
    //  +-#-+   +-#-+   +-#-+   male
    //  | #       #       # |   # = bolts
    //  | #       #       # |
    //
    //  note: if notches=0, a single t-nut cage and 2 small notches will be made
    //
    //   +-----------------+
    //   |  +--+     +--+  |    female
    //   |  |  |  O  |  |  |    O = hole
    //   |  +--+     +--+  |
    //   +-----------------+
    //
    //      +--+     +--+
    //      |  |     |  |
    //   +--+  +--#--+  +--+    male
    //   |        #        |    # = bolts
    //   |        #        |

    module TNutCageNotched_M( targetWidth, tnutProfile, notchProfile, notches = 0 ) {
        // extra 1mm on top for clean punch
        
        // ex. TNutCageNotched_M( 100, [ [ "nut", "modeo", "hex", 3.2, 5.7, 2.7 ], 10, 5 ], 3, 2 );
        
        // notchProfile = [ notchHeight, widthAllowance, heightAllowance ];
        notchHeight       = notchProfile[0];
        //widthAllowance  = notchProfile[1];
        //heightAllowance = notchProfile[2];

        if ( notches <= 0 ) {
            //
            // SINGLE T-NUT CAGE (but put notches on both sides)
            //

            //       +-+     +-+ 
            //       | |     | |   <-- add notches
            //     +-+ +--#--+ +-+
            //     |      #      |
            //     |      #      |
            //     |     ###     |
            //     |      #      |
            //     |             |
            //  -->|             |<-- targetWidth

            // tnutProfile  = [ nutProfile, boltLength, edgeGap ];
            nutProfile   = tnutProfile[0];
            //boltLength = tnutProfile[1];
            //edgeGap    = tnutProfile[2];
            
            // nutProfile = [ "nut", "model", hex|square, boltDiameter, nutFaceSize, nutThickness ]
            //boltDiameter = nutProfile[3];
            nutFaceSize    = nutProfile[4];
            //nutThickness = nutProfile[5];
            
            notchWidth = (targetWidth - nutFaceSize)/6;
            offset = targetWidth/2-notchWidth/2;
            
            punchOverlap = 1;
            translate( [0,-notchHeight,0] )
                TNutCage_M( tnutProfile );
            translate( [0,-notchHeight/2+punchOverlap/2,0] ) {
                translate( [-offset-0.5,0,0] )
                    square( [notchWidth+1,notchHeight+punchOverlap], center=true );
                square( [nutFaceSize+notchWidth*2,notchHeight+punchOverlap], center=true );
                translate( [offset+0.5,0,0] )
                    square( [notchWidth+1,notchHeight+punchOverlap], center=true );
            }
        } else {
            //
            // MULTIPLE NOTCHES AND T-NUT CAGES
            //

            // notch
            Notches_M( targetWidth, notches, notchProfile );
            // T-nut
            translate( [0,-notchHeight,0] )
                notchRepeaterOutside( targetWidth, notches )
                TNutCage_M( tnutProfile );
        }

    }
    
    module TNutCageNotched_F( targetWidth, tnutProfile, notchProfile, notches = 0 ) {
        // ex. TNutCageNotched_F( 30, [ [ "hex", 3.2, 5.7, 2.7 ], 10, 5 ], [ 1, 3 ] );
        
        if ( notches <= 0 ) {
            //
            // SINGLE T-NUT HOLE (but put notch holes on both sides)
            //

            // tnutProfile  = [ nutProfile, boltLength, edgeGap ];
            nutProfile = tnutProfile[0];
            //boltLength = tnutProfile[1];
            //edgeGap    = tnutProfile[2];
            
            // nutProfile = [ "nut", "model", hex|square, boltDiameter, nutFaceSize, nutThickness ]
            //boltDiameter = nutProfile[3];
            nutFaceSize  = nutProfile[4];
            //nutThickness = nutProfile[5];
            
            // notchProfile = [ widthAllowance, notchHeight ];
            //widthAllowance = notchProfile[0];
            //notchHeight    = notchProfile[1];

            // notchProfile = [ notchHeight, widthAllowance, heightAllowance ];   
            notchHeight     = notchProfile[0];
            widthAllowance  = notchProfile[1];
            heightAllowance = notchProfile[2];            
            
            notchWidth = (targetWidth - nutFaceSize)/6;
            offset = nutFaceSize/2+notchWidth*1.5;
            TNutCage_F( tnutProfile );
            translate( [-offset,0,0] )
                square( [notchWidth+widthAllowance,notchHeight+heightAllowance], center=true );
            translate( [offset,0,0] )
                square( [notchWidth+widthAllowance,notchHeight+heightAllowance], center=true );

        } else {
            //
            // MULTIPLE NOTCH HOLES AND T-NUT HOLES
            //

            // notch
            Notches_F( targetWidth, notches, notchProfile );
            // T-nut
            notchRepeaterOutside( targetWidth, notches )
                TNutCage_F( tnutProfile );
        }
    }
