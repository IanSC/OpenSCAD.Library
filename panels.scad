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

include <KVTree.scad>
//include <nuts-bolts.scad>
//include <orientation.scad>

//
// DEMO
//

    // run me !!!
    $vpr = [0,0,0]; Notches_Demo(show2D=true);

    Notches_Demo();
//    translate( [80,0,0] )
//        TNutCage_Example();
//    translate( [200,0,0] )
//        TNutCageNotched_Example( 30, 0 );  // no notch, will put notches on side of bolt cage
//    translate( [300,0,0] )
//        TNutCageNotched_Example( 100, 3 ); // put 3 notches

    module Notches_Demo(show2D=false) {
        
        include <orientation.scad>
        
        panelThickness = 3;

        notchProfile1 = NotchProfile(
            panelThickness = panelThickness
        );
        notchProfile2 = NotchProfile(
            panelThickness = panelThickness,
            notchWidthAllowance = -1,
            notchHeightAllowance = 3,
            holeWidthAllowance = 1,
            holeHeightAllowance = 1,
            leftGap = 10,
            rightGap = 10
        );        
        
        if (show2D) {
            
                                malePanel2D  (80,2,notchProfile1,                                   demo=true);
            translate([0,15,0]) femalePanel2D(80,2,notchProfile1,                                   demo=true);
            translate([0,50,0]) malePanel2D  (80,2,notchProfile1,outside=true,leaveGapMaterial=true,demo=true);
            
            translate([90,0,0]) {
                                    malePanelAdditive2D(80,2,notchProfile1,             demo=true);
                translate([0,25,0]) malePanelAdditive2D(80,2,notchProfile1,outside=true,demo=true);
            }
            
            translate([190,0,0]) {
                                    malePanel2D  (100,2,notchProfile2,                                   demo=true);
                translate([0,18,0]) femalePanel2D(100,2,notchProfile2,                                   demo=true);
                translate([0,53,0]) malePanel2D  (100,2,notchProfile2,outside=true,leaveGapMaterial=true,demo=true);
            }
            
        } else {
            
            // male/female
            solid() malePanel2D(80,2,notchProfile1);
            color( "green", 0.5 )
                OBack( panelThickness )
                solid() femalePanel2D(80,2,notchProfile1);

            // male/male
            translate( [0,50,0] ) {
                OTop(panelThickness)
                    solid() malePanel2D(80,2,notchProfile1);
                color( "green", 0.5 )
                    OBack( panelThickness )
                    solid() malePanel2D(80,2,notchProfile1,outside=true,leaveGapMaterial=true);
            }
        
            // male/female with adjustment/gaps
            translate( [0,100,0] ) {
                solid() malePanel2D(100,2,notchProfile2);
                color( "green", 0.5 )
                    OBack( panelThickness )
                    solid() femalePanel2D(100,2,notchProfile2);
            }
            
            // male/male with adjustment/gaps
            translate( [0,150,0] ) {
                OTop(panelThickness)
                    solid() malePanel2D(100,2,notchProfile2);
                color( "green", 0.5 )
                    OBack( panelThickness )
                    solid() malePanel2D(100,2,notchProfile2,outside=true,leaveGapMaterial=true);
            }
        }
        
        module solid() linear_extrude(panelThickness,center=true) children();        
        module malePanelAdditive2D(panelWidth,notches,notchProfile,outside=false,demo=false) {
            // union notches
            if (!demo) {
                // panel top at origin
                translate([0,-10,0]) square([panelWidth,20],center=true);
                Notches_M_add(panelWidth,notches,notchProfile,outside);
            } else {
                difference() {
                    translate([0,-10,0]) square([panelWidth,20],center=true);
                    Notches_M_add(panelWidth,notches,notchProfile,outside);
                }
                if(demo) color("green") Notches_M_add(panelWidth,notches,notchProfile,outside);
            }
        }
        module malePanel2D(panelWidth,notches,notchProfile,outside=false,leaveGapMaterial=false,demo=false) {
            // remove areas to create notches
            nHa = kvGet( notchProfile, "notch.heightAllowance" );
            // if notchHeightAllowance is +, move panel above origin
            // so female part can still be anchored on the origin
            eff = (nHa>0)?nHa:0;
            difference() {
                // original panel top at origin
                translate([0,-10+nHa/2,0]) square([panelWidth,20+nHa],center=true);
                Notches_M(panelWidth,notches,notchProfile,outside,leaveGapMaterial );
            }
            if(demo) color("red") Notches_M(panelWidth,notches,notchProfile,outside,leaveGapMaterial); // show what was removed
        }        
        module femalePanel2D(panelWidth,notches,notchProfile,demo=false) {
            difference() {
                square([panelWidth,20],center=true);
                Notches_F(panelWidth,notches,notchProfile);
            }            
            if(demo) color("red") Notches_F(panelWidth,notches,notchProfile); // show what was removed
        }
    }
    
//    module Notches_2D_Demo() {
//
////        panelWidth     = 100;
//        panelThickness = 3;
////        notches        = 2;
//
//        notchProfile1 = NotchProfile(
//            panelThickness = panelThickness
//        );
//        
////        Notches_M( panelWidth, notches, notchProfile1 );
//        
//                            malePanel  (80,2,notchProfile1);
//        translate([0,15,0]) femalePanel(80,2,notchProfile1);
//        translate([0,50,0]) malePanel  (80,2,notchProfile1,outside=true,leaveGapMaterial=true);
//        
//        translate([90,0,0]) {
//                                malePanelAdditive(80,2,notchProfile1);
//            translate([0,25,0]) malePanelAdditive(80,2,notchProfile1,outside=true);
//        }
//        
//        notchProfile2 = NotchProfile(
//            panelThickness = panelThickness,
//            notchWidthAllowance = -1,
//            notchHeightAllowance = 3,
//            holeWidthAllowance = 1,
//            holeHeightAllowance = 1,
//            leftGap = 10,
//            rightGap = 10
//        );
//        
//        translate([190,0,0]) {
//                                malePanel  (100,2,notchProfile2);
//            translate([0,18,0]) femalePanel(100,2,notchProfile2);
//            translate([0,53,0]) malePanel  (100,2,notchProfile2,outside=true,leaveGapMaterial=true);
//        }
//        
//        module malePanelAdditive(panelWidth,notches,notchProfile,outside=false) {
//            // union notches            
//            difference() {
//                // panel top at origin
//                translate( [0,-10,0] ) square( [panelWidth,20], center = true );
//                Notches_M_add( panelWidth, notches, notchProfile,outside );
//            }
//            color("green") Notches_M_add( panelWidth, notches, notchProfile,outside );
//        }
//        module malePanel(panelWidth,notches,notchProfile,outside=false,leaveGapMaterial=false) {
//            // remove areas to create notches
//            nHa = kvGet( notchProfile, "notch.heightAllowance" );
//            // if notchHeightAllowance is +, move panel above origin
//            // so female part can still be anchored on the origin
//            eff = (nHa>0)?nHa:0;
//            difference() {
//                // original panel top at origin
//                translate( [0,-10+nHa/2,0] ) square( [panelWidth,20+nHa], center = true );
//                Notches_M( panelWidth, notches, notchProfile, outside, leaveGapMaterial );
//            }
//            color("red") Notches_M( panelWidth, notches, notchProfile, outside, leaveGapMaterial );
//        }        
//        module femalePanel(panelWidth,notches,notchProfile) {
//            difference() {
//                square( [panelWidth,20], center = true );
//                Notches_F( panelWidth, notches, notchProfile );
//            }
//            color("red") Notches_F( panelWidth, notches, notchProfile );
//        }
//    }
    
    
    module TNutCage_Example() {
        $fn=20;
        
        panelThickness = 3;
        
        // PANELS ONLY
        
        tnutProfile1 = TNutCageProfile(
            panelThickness = panelThickness,
            boltLength   = 15,
            boltDiameter = 3,
            nutDiameter  = 5,
            nutThickness = 3,
            nutEdgeGap   = 8
        );        
        translate( [60,0,0] ) {
            //color( "yellow" )
            panelMale( tnutProfile1 );
            translate( [0,panelThickness/2,0] )
                rotate( [90,0,0] )
                panelFemale( tnutProfile1 );
        }
        
        // PANELS WITH NUTS AND BOLTS
        // - see "nuts-bolts.scad"
        
        boltProfile = BoltProfile(
            shaftDiameter = 3,
            length        = 15,
            headDiameter  = 5,
            headThickness = 3 );
        nutProfile = NutProfile(
            boltDiameter = 3,
            nutDiameter  = 5,
            thickness    = 3 );

        tnutProfile2 = TNutCageProfile(
            panelThickness = panelThickness,
            boltProfile    = boltProfile,
            nutProfile     = nutProfile,
            nutEdgeGap           =8,
            boltDiameterAllowance=0,   // allowance from physical sizes
            boltLengthAllowance  =0.5,
            nutDiameterAllowance =1,
            nutThicknessAllowance=1
        );

        // ...possibly extract from another module
        edgeGap=kvGet(tnutProfile2,"nut.edgeGap");
        
        translate( [30,0,0] ) {
            panelMale( tnutProfile2 );
            translate( [0,panelThickness/2,0] )
            rotate( [-90,0,0] ) {
                color( "lightgray" ) {
                    translate( [0,0,panelThickness/2] )
                        Bolt(boltProfile);
                    translate([0,0,-edgeGap-panelThickness/2])
                        Nut(nutProfile);
                }
                panelFemale(tnutProfile2);
            }
        }
        
        // USING ORIENTATION HELPERS
        // - see "orientation.scad"
        
        panelMale( tnutProfile2 );
        OFront(panelThickness,faceIn=true) {
            color( "lightgray" ) {
                OBottom(panelThickness)
                    Bolt(boltProfile);
                OBottom(panelThickness,edgeGap+panelThickness)
                    Nut(nutProfile);
            }
            panelFemale( tnutProfile2 );
        }
        
        module panelMale(profile) {
            //color( "green", 0.5 )
            linear_extrude(panelThickness,center=true)
            difference() {
                // panel top at origin
                translate( [0,-10,0] ) square( [20,20], center = true );
                TNutCage_M( profile );
            }
        }
        
        module panelFemale(profile) {
            color( "green", 0.5 )
            linear_extrude(panelThickness,center=true)
            difference() {
                square( [20,20], center = true );
                TNutCage_F( profile );
            }
        }
        
    }

    module TNutCageNotched_Example( panelWidth, notches = 0 ) {
        $fn = 20;
        //panelWidth     = 100;
        panelThickness = 3;

        notchProfile = NotchProfile(
            panelThickness = panelThickness,
            // notchHeight = panelThickness,
            holeWidthAllowance = 0,
            holeHeightAllowance = 0,
            notchWidthAllowance = 0,
            leftGap = 10,
            rightGap = 10
        );

        boltProfile = BoltProfile(
            shaftDiameter = 3,
            length        = 15,
            headDiameter  = 5,
            headThickness = 3 );
        nutProfile = NutProfile(
            boltDiameter = 3,
            nutDiameter  = 5,
            thickness    = 3 );

        tnutProfile = TNutCageProfile(
            panelThickness = panelThickness,
            boltProfile    = boltProfile,
            nutProfile     = nutProfile,
            nutEdgeGap           =8,
            boltDiameterAllowance=1,   // allowance from physical sizes
            boltLengthAllowance  =0.5,
            nutDiameterAllowance =1,
            nutThicknessAllowance=1
        );

        // male
        //color( "red", 1.5 )
        linear_extrude(panelThickness,center=true)
        difference() {
            translate( [0,-10,0] ) square( [panelWidth,20], center = true );
            TNutCageNotched_M( panelWidth, tnutProfile, notchProfile, notches );
        }
        //color( "red" ) TNutCageNotched_M( panelWidth, tnutProfile, notchProfile, notches ); // for demo
        // female
        translate( [0,-panelThickness/2,0] )
        rotate( [90,0,0] ) {
            color( "green", 0.5 )
            linear_extrude(panelThickness,center=true)
            difference() {
                translate( [0,0,0] ) square( [panelWidth,20], center = true );
                TNutCageNotched_F( panelWidth, tnutProfile, notchProfile, notches );
            }
            //color( "red" ) TNutCageNotched_F( panelWidth, tnutProfile, notchProfile, notches ); // for demo
        }
    }

//
// NOTCH
//

    // FEMALE:
    //  +-------------------+
    //  |   +---+   +---+   |   
    //  |   |   |   |   |   |   holeHeight + holeHeightAllowance
    //  |   +---+   +---+   |
    //  +-------------------+
    //           -->|   |<-- computed holeWidth + holeWidthAllowance
    //
    //
    // MALE:     -->|   |<-- computed notchWidth + notchWidthAllowance
    //      +---+   +---+
    //      |   |   |   |        notchHeight + nothHeightAllowance
    //  +---+   +---+   +---+
    //  |                   |

    function NotchProfile(
        panelThickness,              // set only this to default notch notchHeight, holeHeight
        notchHeight,                 // height of notch, usually same as panel thickness
        holeHeight,                  // height of holes, usually same as panel thickness
        notchWidthAllowance = -0.25, // allowance when creating notches, - smaller
        notchHeightAllowance = 0,
        holeWidthAllowance = 0.25,   // allowance when creating holes, + bigger
        holeHeightAllowance = 0.5,
        leftGap = 0,                 // clearance on sides excluded from notches
        rightGap = 0
    ) = let(
        eNotchHeight = (notchHeight==undef)?panelThickness:notchHeight,
        eHoleHeight = (holeHeight==undef)?panelThickness:holeHeight,
        e1=ErrorIf(eNotchHeight==undef, "notchHeight or panelThickness required" ),
        e2=ErrorIf(eHoleHeight==undef, "holeHeight or panelThickness required" )
    ) KVTree([
        "notch", KVTree([ "height", eNotchHeight, "widthAllowance", notchWidthAllowance, "heightAllowance", notchHeightAllowance ]),
        "notchHeight", notchHeight,
        "hole", KVTree([ "height", eHoleHeight, "widthAllowance", holeWidthAllowance, "heightAllowance", holeHeightAllowance ]),
        "gap", KVTree([ "left", leftGap, "right", rightGap ])
    ]);

    module Notches_M_add( targetWidth, notches, notchProfile, outside=false ) {
        // for union() to other parts
        
        overlap = 1; // extra at the bottom for clean union
        
        notchHeight = kvGet( notchProfile, "notch.height" );
        gapLeft     = kvGet( notchProfile, "gap.left" );
        gapRight    = kvGet( notchProfile, "gap.right" );
        nWa = kvGet( notchProfile, "notch.widthAllowance" );
        nHa = kvGet( notchProfile, "notch.heightAllowance" );
        
        width = targetWidth-gapLeft-gapRight;
        div = notches*2+1;
        notchSize = width/div;
        
        if (outside)
            translate( [gapLeft/2-gapRight/2,notchHeight/2+nHa/2-overlap/2,0] )
            notchRepeaterOutside( width, notches )
                square( [notchSize+nWa,notchHeight+nHa+overlap], center=true );
        else
            translate( [gapLeft/2-gapRight/2,notchHeight/2+nHa/2-overlap/2,0] )
            notchRepeaterInside( width, notches )
                square( [notchSize+nWa,notchHeight+nHa+overlap], center=true );
    }
    
    module Notches_M( targetWidth, notches, notchProfile, outside=false, leaveGapMaterial=false ) {
        // for difference() from other parts
        
        overlap = 1; // extra on top for clean punch
        
        notchHeight = kvGet( notchProfile, "notch.height" );
        gapLeft     = kvGet( notchProfile, "gap.left" );
        gapRight    = kvGet( notchProfile, "gap.right" );
        nWa = kvGet( notchProfile, "notch.widthAllowance" );
        nHa = kvGet( notchProfile, "notch.heightAllowance" );
        
        width = targetWidth-gapLeft-gapRight;        
        div = notches*2+1;
        notchSize = width/div;
        
        // notchHeightAllowance >= 0, higher notches
        //    assume user has positioned panel +heightAllowance above the origin
        //       for easier positioning with female panel, eg. female still at origin
        //    increase cutting depth
        //    move pattern up by heightAllowance
        // notchHeightAllowance < 0, lower notches
        //    use same cutting depth without allowance
        //    remove strip on top of the whole panel, female still at origin
        eHeight=(nHa>=0)?notchHeight+nHa:notchHeight;
        yOffset=(nHa>=0)?nHa            :0          ;
        translate( [0,yOffset,0] ) {
            // we are punching so reverse allowance and notch position
            if (outside)
                translate( [gapLeft/2-gapRight/2,-eHeight/2+overlap/2,0] )
                notchRepeaterInside( width, notches )
                    square( [notchSize-nWa,eHeight+overlap], center=true );
            else
                translate( [gapLeft/2-gapRight/2,-eHeight/2+overlap/2,0] )
                notchRepeaterOutside( width, notches )
                    square( [notchSize-nWa,eHeight+overlap], center=true );
            if ( !leaveGapMaterial ) {
                if (gapLeft!=0)
                    translate( [-targetWidth/2-overlap,-eHeight,0] )
                    square( [gapLeft+overlap,eHeight+overlap] );
                if (gapRight!=0)
                    translate( [-gapRight+targetWidth/2,-eHeight,0] )
                    square( [gapRight+overlap,eHeight+overlap] );
            }
        }
    }
    
    module Notches_F( targetWidth, notches, notchProfile ) {
        
        holeHeight  = kvGet( notchProfile, "hole.height" );
        //gapTotal    = kvGet( notchProfile, "gap.total" );
        gapLeft     = kvGet( notchProfile, "gap.left" );
        gapRight    = kvGet( notchProfile, "gap.right" );
        widthAllowance  = kvGet( notchProfile, "hole.widthAllowance" );
        heightAllowance = kvGet( notchProfile, "hole.heightAllowance" );
        
        // notchProfile = [ notchHeight, widthAllowance, heightAllowance ];   
//        notchHeight     = notchProfile[0];
//        widthAllowance  = notchProfile[1];
//        heightAllowance = notchProfile[2];
        width = targetWidth-gapLeft-gapRight; 
        div = notches*2+1;
        notchSize = width/div;
        
        translate( [gapLeft/2-gapRight/2,0,0] )
        notchRepeaterInside( width, notches )
            square( [notchSize+widthAllowance,holeHeight+heightAllowance], center=true );
    }

    //
    // REPEATERS
    //
    
    module notchRepeaterInside( targetWidth, notches ) {
        //    ###   ###
        // +--   ---   --+
        // |             |
        // ex. notchRepeaterInside( width, notches )
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
        // ex. notchRepeaterOutside( width, notches )
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

    function TNutCageProfile(
        panelThickness=0,
        boltProfile,
        nutProfile,
        boltLength,
        boltDiameter,
        nutDiameter,
        nutThickness,
        nutEdgeGap,
        boltDiameterAllowance=0,
        boltLengthAllowance=0,
        nutDiameterAllowance =0,
        nutThicknessAllowance=0
    ) = let(
        //echo(nutProfile),
        //echo(kvSearchLax( nutProfile,  "nutDiameter" )),
        eBoltLength   = SELECT( boltLength,   kvSearchLax( boltProfile, "length"      ) ),
        eBoltDiameter = SELECT( boltDiameter, kvSearchLax( boltProfile, "diameter"    ), kvSearchLax( nutProfile, "boltDiameter" ) ),
        eNutDiameter  = SELECT( nutDiameter,  kvSearchLax( nutProfile,  "nutDiameter" ) ),
        eNutThickness = SELECT( nutThickness, kvSearchLax( nutProfile,  "thickness"   ) ),
        e1=ErrorIf(eBoltLength  ==undef, "boltLength or boltProfile required" ),
        e2=ErrorIf(eBoltDiameter==undef, "boltDiameter, boltProfile or nutProfile required" ),
        e3=ErrorIf(eNutDiameter ==undef, "nutDiameter or nutProfile required" ),
        e4=ErrorIf(eNutThickness==undef, "nutThickness or nutProfile required" ),
        e5=ErrorIf(nutEdgeGap   ==undef, "nutEdgeGap required" )
    ) KVTree([
        "panelThickness", panelThickness,
        "bolt", KVTree([ "diameter", eBoltDiameter+boltDiameterAllowance, "length", eBoltLength+boltLengthAllowance ]),
        //    "allowance", KVTree([ "diameter", boltDiameterAllowance ]) ]),
        "nut",  KVTree([ "diameter", eNutDiameter+nutDiameterAllowance,  
            "thickness", eNutThickness, "thicknessAllowance", nutThicknessAllowance,
            "edgeGap", nutEdgeGap ])
        //    "allowance", KVTree([ "diameter", nutDiameterAllowance, "thickness", nutThicknessAllowance ]) ])
    ]);

    module TNutCage_M( tnutProfile ) {

        overlap=1; // extra on top for clean punch
        boltProfile =kvGet(tnutProfile,"bolt");
        nutProfile  =kvGet(tnutProfile,"nut");
        panelThickness=kvGet(tnutProfile,"panelThickness");
        boltDiameter=kvGet(boltProfile,"diameter" );
        boltLength  =kvGet(boltProfile,"length"   )-panelThickness;
        nutDiameter =kvGet(nutProfile, "diameter" );
        nutThickness=kvGet(nutProfile, "thickness");
        nutThicknessAllowance=kvGet(nutProfile, "thicknessAllowance");
        nutEdgeGap  =kvGet(nutProfile, "edgeGap"  );
        
        translate( [0,-boltLength/2+overlap/2,0] )
            square( [boltDiameter,boltLength+overlap], center=true );
        translate( [0,-nutEdgeGap-nutThickness/2+panelThickness,0] )
            square( [nutDiameter,nutThickness+nutThicknessAllowance], center=true );
    }  

    module TNutCage_F( tnutProfile, allowance=0 ) {
        boltDiameter=kvGet(tnutProfile,"bolt.diameter");
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
        
//        // ex. TNutCageNotched_M( 100, [ [ "nut", "modeo", "hex", 3.2, 5.7, 2.7 ], 10, 5 ], 3, 2 );
//        
//        // notchProfile = [ notchHeight, widthAllowance, heightAllowance ];
//        notchHeight       = notchProfile[0];
//        //widthAllowance  = notchProfile[1];
//        //heightAllowance = notchProfile[2];
        
        notchHeight = kvGet( notchProfile, "notch.height" );

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

//            // tnutProfile  = [ nutProfile, boltLength, edgeGap ];
//            nutProfile   = tnutProfile[0];
//            //boltLength = tnutProfile[1];
//            //edgeGap    = tnutProfile[2];
//            
//            // nutProfile = [ "nut", "model", hex|square, boltDiameter, nutFaceSize, nutThickness ]
//            //boltDiameter = nutProfile[3];
//            nutFaceSize    = nutProfile[4];
//            //nutThickness = nutProfile[5];

            //boltProfile =kvGet(tnutProfile,"bolt");
            nutProfile  =kvGet(tnutProfile,"nut");
            //panelThickness=kvGet(tnutProfile,"panelThickness");
            //boltDiameter=kvGet(boltProfile,"diameter" );
            //boltLength  =kvGet(boltProfile,"length"   )-panelThickness;
            nutDiameter =kvGet(nutProfile, "diameter" );
            //nutThickness=kvGet(nutProfile, "thickness");
            //nutThicknessAllowance=kvGet(nutProfile, "thicknessAllowance");
            //nutEdgeGap  =kvGet(nutProfile, "edgeGap"  );
        
            notchWidth = (targetWidth - nutDiameter)/6;
            offset = targetWidth/2-notchWidth/2;
            
            overlap = 1;
            translate( [0,-notchHeight,0] )
                TNutCage_M( tnutProfile );
            translate( [0,-notchHeight/2+overlap/2,0] ) {
                translate( [-offset-0.5,0,0] )
                    square( [notchWidth+1,notchHeight+overlap], center=true );
                square( [nutDiameter+notchWidth*2,notchHeight+overlap], center=true );
                translate( [offset+0.5,0,0] )
                    square( [notchWidth+1,notchHeight+overlap], center=true );
            }
        } else {
            //
            // MULTIPLE NOTCHES AND T-NUT CAGES
            //
            
            gapLeft     = kvGet( notchProfile, "gap.left" );
            gapRight    = kvGet( notchProfile, "gap.right" );
            width = targetWidth-gapLeft-gapRight; 

            // notch
            Notches_M( targetWidth, notches, notchProfile );
            // T-nut
            translate( [0,-notchHeight,0] )
                notchRepeaterOutside( width, notches )
                TNutCage_M( tnutProfile );
        }

    }   

    module TNutCageNotched_F( targetWidth, tnutProfile, notchProfile, notches = 0 ) {
        // ex. TNutCageNotched_F( 30, [ [ "hex", 3.2, 5.7, 2.7 ], 10, 5 ], [ 1, 3 ] );
        
        if ( notches <= 0 ) {
            //
            // SINGLE T-NUT HOLE (but put notch holes on both sides)
            //

//            // tnutProfile  = [ nutProfile, boltLength, edgeGap ];
//            nutProfile = tnutProfile[0];
//            //boltLength = tnutProfile[1];
//            //edgeGap    = tnutProfile[2];
//            
//            // nutProfile = [ "nut", "model", hex|square, boltDiameter, nutFaceSize, nutThickness ]
//            //boltDiameter = nutProfile[3];
//            nutFaceSize  = nutProfile[4];
//            //nutThickness = nutProfile[5];
//            
//            // notchProfile = [ widthAllowance, notchHeight ];
//            //widthAllowance = notchProfile[0];
//            //notchHeight    = notchProfile[1];
//
//            // notchProfile = [ notchHeight, widthAllowance, heightAllowance ];
//            notchHeight     = notchProfile[0];
//            widthAllowance  = notchProfile[1];
//            heightAllowance = notchProfile[2];

            //boltProfile =kvGet(tnutProfile,"bolt");
            nutProfile  =kvGet(tnutProfile,"nut");
            //panelThickness=kvGet(tnutProfile,"panelThickness");
            //boltDiameter=kvGet(boltProfile,"diameter" );
            //boltLength  =kvGet(boltProfile,"length"   )-panelThickness;
            nutDiameter =kvGet(nutProfile, "diameter" );
            //nutThickness=kvGet(nutProfile, "thickness");
            //nutThicknessAllowance=kvGet(nutProfile, "thicknessAllowance");
            //nutEdgeGap  =kvGet(nutProfile, "edgeGap"  );
            
            holeHeight  = kvGet( notchProfile, "hole.height" );
            //gapTotal    = kvGet( notchProfile, "gap.total" );
            gapLeft     = kvGet( notchProfile, "gap.left" );
            gapRight    = kvGet( notchProfile, "gap.right" );
            widthAllowance  = kvGet( notchProfile, "hole.widthAllowance" );
            heightAllowance = kvGet( notchProfile, "hole.heightAllowance" );
            
            notchWidth = (targetWidth - nutDiameter)/6;
            offset = nutDiameter/2+notchWidth*1.5;
            
            TNutCage_F( tnutProfile );
            translate( [-offset,0,0] )
                square( [notchWidth+widthAllowance,holeHeight+heightAllowance], center=true );
            translate( [offset,0,0] )
                square( [notchWidth+widthAllowance,holeHeight+heightAllowance], center=true );

        } else {
            //
            // MULTIPLE NOTCH HOLES AND T-NUT HOLES
            //
            
            gapLeft     = kvGet( notchProfile, "gap.left" );
            gapRight    = kvGet( notchProfile, "gap.right" );
            width = targetWidth-gapLeft-gapRight; 

            // notch
            Notches_F( targetWidth, notches, notchProfile );
            // T-nut
            notchRepeaterOutside( width, notches )
                TNutCage_F( tnutProfile );
        }
    }
