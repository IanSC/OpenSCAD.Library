//
// PANEL-TNUT
// by ISC 2021
//
//     TNutCageProfile( ... )                                                           - create profile
//     TNutCage_M( profile, connectedPanelThickness )                                   - draw 2D bolt/nut capture slots
//     TNutCage_F( profile, allowance )                                                 - draw 2D hole for perpendicular panel
//     TNutCages( targetWidth, count, profile, connectedPanelThickness, holeAllowance ) - repeated bolt/nut capture slots
//

include <KVTree.scad>

//
// DEMO
//

    // run me !!!
    //$vpr=[0,0,0]; TNutCage_Demo_2D();
    //TNutCage_Demo();
    //TNutCage_Assembly_Demo();

    module TNutCage_Demo_2D() {
        include <nuts-bolts.scad>
        include <orientation.scad>
        $fn=20;
        
        panelThickness =  3;
        boltDiameter   =  3; nutDiameter  = 5;
        boltLength     = 20; nutThickness = 3;
        nutEdgeGap     =  8;
        
        // SIMPLE PROFILE
        profile1 = TNutCageProfile(
            connectedPanelThickness = panelThickness,
            boltDiameter = boltDiameter, nutDiameter  = nutDiameter,
            boltLength   = boltLength,   nutThickness = nutThickness,
            nutEdgeGap   = nutEdgeGap
        );
        
        // PROFILE WITH ALLOWANCES
        profile2 = TNutCageProfile(
            connectedPanelThickness = panelThickness,
            boltDiameter = boltDiameter, nutDiameter  = nutDiameter,
            boltLength   = boltLength,   nutThickness = nutThickness,
            nutEdgeGap   = nutEdgeGap,
            // allowance from physical sizes...
            boltDiameterAllowance = 2,
            boltLengthAllowance   = 1,
            nutDiameterAllowance  = 2,
            nutThicknessAllowance = 2
        );
        
        // *** BASIC ***
        translate([0,0,0]) {
            malePanel(20)
            
            /* ▶ */     TNutCage_M( profile1 );
            
            femalePanel(20,panelThickness,boltDiameter)
            
            /* ▶ */     TNutCage_F( profile1 );
            
            translate([0,panelThickness,0]) dummyBolt();
            translate([0,-nutEdgeGap,0]) dummyNut();
        }
        
        // *** OVERRIDE CONNECTED PANEL THICKNESS ***
        translate([30,0,0]) {
            THK=5;
            malePanel(20)

            /* ▶ */     TNutCage_M( profile1, connectedPanelThickness=THK );
            
            femalePanel(20,THK,boltDiameter)
            
            /* ▶ */     TNutCage_F( profile1 );
            
            translate([0,THK,0]) dummyBolt();
            translate([0,-nutEdgeGap,0]) dummyNut();
        }
        
        // *** WITH BOLT/NUT ALLOWANCES ***
            translate([60,0,0]) {
            malePanel(20)
            
            /* ▶ */     TNutCage_M( profile2 );
            
            femalePanel(20,panelThickness,boltDiameter)
            
            /* ▶ */     TNutCage_F( profile2, allowance=2 );
            
            translate([0,panelThickness,0]) dummyBolt();
            translate([0,-nutEdgeGap,0]) dummyNut();
        }
        
        // *** MULTIPLE SLOTS ***
        translate([130,0,0]) {
            malePanel(100)
            
            /* ▶ */     TNutCage( 100, 3, profile2 );
            
            femalePanel(100,panelThickness,boltDiameter)
            
            /* ▶ */     TNutCage( 100, -3, profile2 );
            
            patternRepeater(100,3) {
                translate([0,panelThickness,0]) dummyBolt();
                translate([0,-nutEdgeGap,0]) dummyNut();
                color("red") translate([0,20,0]) circle(d=boltDiameter);
            }
        }
        
        module malePanel(width) {
            difference() {
                translate([0,-10,0]) square([width,20],center=true);
                children();
            }
        }
        module femalePanel(width,thickness,boltDiameter) {
            color("SteelBlue") translate([0,thickness/2,0])
                square([width,thickness],center=true);
            translate([0,20,0]) {
                color("SteelBlue") difference() {
                    square([width,10],center=true);
                    children();
                }
                color("red") circle(d=boltDiameter);
            }
        }
        module dummyBolt() {
            color("red") {
                translate([0,-boltLength/2,1]) square([boltDiameter,boltLength],center=true);
                translate([-boltDiameter,0,1]) square([boltDiameter*2,3]);
            }
        }
        module dummyNut() {
            color("green") translate([0,-nutThickness/2,2])
                square([nutDiameter,nutThickness],center=true);
        }
    }

    module TNutCage_Demo() {
        include <nuts-bolts.scad>
        include <orientation.scad>
        $fn=20;
        
        panelThickness = 3;

        // SIMPLE PROFILE
        profile1 = TNutCageProfile(
            connectedPanelThickness = panelThickness,
            boltLength   = 15, nutDiameter  = 5,
            boltDiameter =  3, nutThickness = 3,
            nutEdgeGap   =  5
        );
        
        // PROFILE FROM PHYSICAL BOLT/NUT
        boltProfile = BoltProfile(
            shaftDiameter =  3,
            length        = 20,
            headDiameter  =  5,
            headThickness =  3 );
        nutProfile = NutProfile(
            boltDiameter = 3,
            nutDiameter  = 5,
            thickness    = 3 );
        profile2 = TNutCageProfile(
            connectedPanelThickness = panelThickness,
            boltProfile             = boltProfile,
            nutProfile              = nutProfile,
            nutEdgeGap              = 8,   // panel edge to captured nut
            boltDiameterAllowance   = 1,   // allowance from physical sizes...
            boltLengthAllowance     = 0.5,
            nutDiameterAllowance    = 1,
            nutThicknessAllowance   = 1
        );
        kvEchoAligned(profile2);

        // ...possibly extract from another module
        edgeGap     =kvGet(profile2,"nut.edgeGap");
        nutThickness=kvGet(profile2,"nut.thickness");
        
        // *** BASIC ***
        translate([0,0,0]) {
            panelMale()
            
            /* ▶ */     TNutCage_M( profile1 );
            
            translate( [0,panelThickness/2,0] ) rotate( [90,0,0] ) panelFemale(panelThickness)
            
            /* ▶ */     TNutCage_F( profile1 );
        }
        
        // *** WITH BOLTS/NUTS ***
        // - see "nuts-bolts.scad"
        translate([50,0,0]) //rotate([0,0,180]) 
            {
            rotate([-90,0,0]) color( "lightgray" ) {
                translate( [0,0,panelThickness] )
                    Bolt(boltProfile);
                translate([0,0,-edgeGap-nutThickness]) rotate([0,0,30])
                    Nut(nutProfile);
            }
            panelMale()
            
            /* ▶ */     TNutCage_M( profile2 );
            
            translate([0,panelThickness/2,0]) rotate([90,0,0]) panelFemale(panelThickness)
            
            /* ▶ */     TNutCage_F( profile2 );
        }
        
        // *** ORIENTATION HELPERS ***
        // - see "orientation.scad"
        translate([100,0,0]) {
            THK=8;
            OFFront(THK) color( "lightgray" ) {
                OBottom(THK)
                    Bolt(boltProfile);
                OBottom(THK,edgeGap+THK+nutThickness) rotate([0,0,30])
                    Nut(nutProfile);
            }
            panelMale()
            
            /* ▶ */     TNutCage_M( profile2, connectedPanelThickness=THK );
            
            OFront(THK) panelFemale(THK)
            
            /* ▶ */     TNutCage_F( profile2, allowance=2 );
        }
        
        module panelMale() {
            linear_extrude(panelThickness,center=true)
            difference() {
                translate([0,-10,0]) square([20,20],center=true); // panel top at origin
                children();
            }
        }
        module panelFemale(thickness) {
            color("SteelBlue",0.5)
            linear_extrude(thickness,center=true)
            difference() {
                square([20,20],center=true);
                children();
            }
        }
    }

    module TNutCage_Assembly_Demo() {
        include <nuts-bolts.scad>
        include <positioning.scad>
        include <orientation.scad>
        $fn=20;
        
        W  = 80;        // width
        D  = 50;        // depth
        H  = 100;       // height
        T  = 3;         // panel thickness
        S1 = 10;        // shelf1 position (from bottom)
        S2 = 50;        // shelf2 position (from bottom)

        SF1 = S1+T/2;   // shelf1 front panel height
        SF2 = H-S2+T/2; // shelf2 front panel height
        
        EXT = 5;        // extension to place bolts
        
        boltProfile = BoltProfile(
            shaftDiameter =  1,
            length        = 10,
            headDiameter  =  3,
            headThickness =  1 );
        nutProfile = NutProfile(
            boltDiameter = 1,
            nutDiameter  = 3,
            thickness    = 1 );

        profile = TNutCageProfile(
            connectedPanelThickness = T,
            boltProfile             = boltProfile,
            nutProfile              = nutProfile,
            nutEdgeGap              = 4,   // panel edge to captured nut
            boltDiameterAllowance   = 1,   // allowance from physical sizes...
            boltLengthAllowance     = 0.5,
            nutDiameterAllowance    = 1,
            nutThicknessAllowance   = 1
        );

        // ...possibly extract from another module
        edgeGap     =kvGet(profile,"nut.edgeGap");
        nutThickness=kvGet(profile,"nut.thickness");
        
        assembly();
        translate([120,0,0])
        rotate([0,0,180])
            assembly();
        
        showBolts=true;
        
        module assembly() {
            CubeExtents(W,D,H);

            // shelves
            color("LightGrey") OBottom (0,H/2-S1) solid() shelfBottom();
            color("LightGrey") OBottom( 0,H/2-S2) solid() shelfBottom();
            if (showBolts)     OFBottom(0,H/2-S1)         shelfBottomBolts();
            if (showBolts)     OBottom (0,H/2-S2)         shelfBottomBolts();
            
            // walls
                           OLeft  (T,W/2) solid()                   walls();
                           ORight (T,W/2) solid() rotate([0,180,0]) walls();
            if (showBolts) OLeft  (T,W/2)                           wallBolts();
            if (showBolts) OFRight(T,W/2) mirror([0,0,1])           wallBolts();
            
            // shelves front panel
            color("gray")  OFront(T,D/2,0,-H/2+SF1/2) solid() frontPanel1();
            color("gray")  OFront(T,D/2,0, H/2-SF2/2) solid() frontPanel2();
            if (showBolts) OFront(T,D/2,0,-H/2+SF1/2)         frontPanel1Bolts();
            if (showBolts) OFront(T,D/2,0, H/2-SF2/2)         frontPanel2Bolts();

            // back panel
            color("DarkGray") OBack(T,D/2) solid() back();
            if (showBolts)    OBack(T,D/2)         backBolts();
        }
        
        module solid() linear_extrude(T,center=true) children();
        module boltNut() {
            color("SandyBrown") {
                translate([0,0,T/2]) Bolt(boltProfile);
                translate([0,0,-T/2-nutThickness-edgeGap]) Nut(nutProfile);
            }
        }
        // *** WALLS ***        
        module walls() {
            left  = -T;
            right = +EXT;
            effD  = D+left+right;
            punch() {
                MRight((-left+right)/2)
                square([effD,H],center=true);
                union() {                    
                    MUp(S1)    PBottom(H) TNutCage(D,-2,profile); // holes for shelf bottom
                    MUp(S2)    PBottom(H) TNutCage(D,-2,profile);
                    MLeft(T/2) PRight(D)  TNutCage(H,-3,profile); // back panel
                    // shelves front panel
                    MDown(H/2-SF1/2) MLeft(left) PLeft(D) TNutCage(SF1,1,profile);
                    MUp  (H/2-SF2/2) MLeft(left) PLeft(D) TNutCage(SF2,2,profile);
                }
            }
        }
        module wallBolts() {
            // those with negative (-) count in walls() are holes, plug with bolts
            // while testing, show only:
            // - wallBolts();
            // - solid() walls();
            MUp(S1)    PBottom(H) patternRepeater(D,2) boltNut();
            MUp(S2)    PBottom(H) patternRepeater(D,2) boltNut();
            MLeft(T/2) PRight(D)  patternRepeater(H,3) boltNut();
        }        
        // *** BACK ***
        module back() {
            effW=W-2*T;
            punch() {
                square([effW,H],center=true);
                union() {                    
                            PLeft(effW)  TNutCage(H, 3,profile); // walls
                            PRight(effW) TNutCage(H, 3,profile);
                    MUp(S1) PBottom(H)   TNutCage(W,-2,profile); // shelves bottom
                    MUp(S2) PBottom(H)   TNutCage(W,-2,profile);
                }
            }
        }
        module backBolts() {
            MUp(S1) PBottom(H) patternRepeater(W,2) boltNut();
            MUp(S2) PBottom(H) patternRepeater(W,2) boltNut();
        }
        // *** SHELVES BOTTOM ***
        module shelfBottom() {
            top    = -T;
            bottom = +EXT;
            effD   = D+top+bottom;
            effW   = W-2*T;
            punch() {
                MDown((-top+bottom)/2)
                square([effW,effD],center=true);
                union() {                    
                    MRight(T)     PLeft(W)   TNutCage(D, 2,profile); // walls
                    MLeft(T)      PRight(W)  TNutCage(D, 2,profile);
                    MUp(bottom-T) PBottom(D) TNutCage(W,-2,profile); // front
                    MDown(-top)   PTop(D)    TNutCage(W, 2,profile); // back
                }
            }
        }
        module shelfBottomBolts() {
            bottom = +EXT;
            MUp(bottom-T) PBottom(D) patternRepeater(W,2) boltNut();
        }        
        // *** SHELVES FRONT ***
        module frontPanel1() {
            effW  =W+EXT*2;
            top   =-T;
            effSF1=SF1+top;
            punch() {
                MDown(-top/2)
                square([effW,effSF1],center=true);
                union() {
                    MRight(T/2)   PLeft(W)     TNutCage(SF1,-1,profile); // walls
                    MLeft (T/2)   PRight(W)    TNutCage(SF1,-1,profile);
                    MDown(-top/2) PTop(effSF1) TNutCage(W  , 2,profile); // front
                }
            }
        }
        module frontPanel1Bolts() {
            top   =-T;
            MRight(T/2) PLeft( W) patternRepeater(SF1,1) boltNut();
            MLeft (T/2) PLeft(-W) patternRepeater(SF1,1) boltNut();
        }
        module frontPanel2() {
            effW  =W+EXT*2;
            bottom=-T;
            effSF2=SF2+bottom;
            punch() {
                MUp(-bottom/2)
                square([effW,effSF2],center=true);
                union() {                    
                    MRight(T/2)    PLeft(W)        TNutCage(SF2,-2,profile); // walls
                    MLeft (T/2)    PRight(W)       TNutCage(SF2,-2,profile);
                    MUp(-bottom/2) PBottom(effSF2) TNutCage(W  , 2,profile); // front
                }
            }
        }
        module frontPanel2Bolts() {
            bottom=-T;
            MRight(T/2) PLeft( W) patternRepeater(SF2,2) boltNut();
            MLeft (T/2) PLeft(-W) patternRepeater(SF2,2) boltNut();
        }       
        
        // to diagnose a part while designing,
        // set debug to true and generate the part. ex:
        //    debug=true;
        //    walls();
        //debug=true;
        debug=false;
        module punch() {
            if (debug) {
                color("green",0.5) 
                difference() {
                    children(0); children(1);
                }
                children(1);
            } else {
                difference() {
                    children(0); children(1);
                }
            }
        }
    }

//
// T-NUT CAGE
//
    
    // TOP VIEW (P1)
    //     |         +---+       - - - - - - - - - -
    //     |         |   |                          ^
    //     +---------+   +----+  ---               |
    //                        |  boltDiameter   nutDiameter
    //     +---------+   +----+  ---               |
    //     |         |   |                          v
    //     |         +---+       - - - - - - - - - -
    //        
    //     |<- gap ->|   |<-- nutThickness
    //
    //     |<-- boltArea   -->|    boltArea = boltLength - panelThickness
    //
    // SIDE VIEW:
    //     |P2|
    //     |  |              P1 connected to P2
    //     |  |                 P1 (male)   will capture the bolt with a nut
    //   ##|  +---@-------      P2 (female) has a hole for the bolt
    //   ##|##|###@##  P1    ### - bolt
    //   ##|  +---@-------   @@@ - nut
    //     |  |
    //     +--+
    //
    // technically, P1 is more female :)

    function TNutCageProfile(
        connectedPanelThickness, // thickness of panel to be connected (P2 in diagram)
        boltDiameter,            // bolt info
        boltLength,
        nutDiameter,             // nut info
        nutThickness,
        nutEdgeGap,              // distance from panel edge to nut capture slot
        boltProfile,             // specify instead of boltLength, boltDiameter
        nutProfile,              // specify instead of boltDiameter, nutDiameter, nutThickness
        boltDiameterAllowance = 0,
        boltLengthAllowance   = 0,
        nutDiameterAllowance  = 0,
        nutThicknessAllowance = 0
    ) = let(
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
        // keep data to cut the holes, not bolt/nut information
        "connectedPanelThickness", connectedPanelThickness,
        "bolt", KVTree([ "effDiameter", eBoltDiameter+boltDiameterAllowance, "effLength", eBoltLength+boltLengthAllowance ]),
        "nut",  KVTree([ "effDiameter", eNutDiameter+nutDiameterAllowance,  
            "thickness", eNutThickness, "thicknessAllowance", nutThicknessAllowance,
            "edgeGap", nutEdgeGap ])
    ]);

    module TNutCage(targetWidth,count,profile,connectedPanelThickness,holeAllowance=0) {
        // connectedPanelThickness - for TNutCage()
        // holeAllowance           - for TNutCagePanelHole()
        if (count>0)
            patternRepeater(targetWidth,count)
                TNutCage_M(profile,connectedPanelThickness);
        else
            patternRepeater(targetWidth,-count)
                TNutCage_F(profile,holeAllowance);
    }

    module TNutCage_M(profile,connectedPanelThickness) {
        overlap=1; // extra on top for clean punch

        ePanelThickness=SELECT(connectedPanelThickness,kvGet(profile,"connectedPanelThickness"));

        bolt         =kvGet(profile,"bolt");
        eBoltDiameter=kvGet(bolt,"effDiameter");
        eBoltLength  =kvGet(bolt,"effLength"  )-ePanelThickness;

        nut         =kvGet(profile,"nut");
        nutDiameter =kvGet(nut,"effDiameter"       );
        nutThickness=kvGet(nut,"thickness"         );
        nTa         =kvGet(nut,"thicknessAllowance");
        nutEdgeGap  =kvGet(nut,"edgeGap"           );
        
        translate( [0,-eBoltLength/2+overlap/2,0] )
            square( [eBoltDiameter,eBoltLength+overlap], center=true );
        translate( [0,-nutEdgeGap-nutThickness/2,0] )
            square( [nutDiameter,nutThickness+nTa], center=true );
    }  

    module TNutCage_F(profile,allowance=0) {
        boltDiameter=kvGet(profile,"bolt.effDiameter");
        circle( d=boltDiameter+allowance );
    }

//
// SPACE EVENLY
//
    
    module patternRepeater(length,count) {
        // repeat children count times along length
        // spaced evenly
        gap=length/(count+1);
        translate( [-length/2,0,0] )
        for (i = [1:count]) {
            translate( [i*gap,0,0] )
            children();
        }        
    }
