//
// PANEL-NOTCHES
// by ISC 2021
//
//     TNutCageProfile( ... )       - create profile
//     TNutCage( profile )          - draw 2D bolt/nut capture slots
//     TNutCagePanelHole( profile ) - draw 2D hole for perpendicular panel
//

include <KVTree.scad>

//
// DEMO
//

    // run me !!!
    //$vpr=[0,0,0]; TNutCage_Demo_2D();
    //TNutCage_Demo();

    module TNutCage_Demo_2D() {
        include <nuts-bolts.scad>
        include <orientation.scad>
        $fn=20;
        
        panelThickness =  3;
        boltDiameter   =  3; nutDiameter  = 5;
        boltLength     = 20; nutThickness = 3;
        nutEdgeGap     =  8;
        
        profile1 = TNutCageProfile(
            panelThickness = panelThickness,
            boltDiameter = boltDiameter, nutDiameter  = nutDiameter,
            boltLength   = boltLength,   nutThickness = nutThickness,
            nutEdgeGap   = nutEdgeGap
        );
        
        translate([0,0,0]) {
        malePanel()
        
        /*▶*/   TNutCage( profile1 );
        
        femalePanel(panelThickness,boltDiameter)
        
        /*▶*/   TNutCagePanelHole( profile1 );
        
        translate([0,panelThickness,0]) dummyBolt();
        translate([0,-nutEdgeGap,0]) dummyNut();
        }
        
        // override panel thickness
        translate([50,0,0]) {
        THK=5;
        malePanel()

        /*▶*/   TNutCage( profile1, panelThickness=THK );
        
        femalePanel(THK,boltDiameter)
        
        /*▶*/   TNutCagePanelHole( profile1 );
        
        translate([0,THK,0]) dummyBolt();
        translate([0,-nutEdgeGap,0]) dummyNut();
        }
        
        profile2 = TNutCageProfile(
            panelThickness = panelThickness,
            boltDiameter = boltDiameter, nutDiameter  = nutDiameter,
            boltLength   = boltLength,   nutThickness = nutThickness,
            nutEdgeGap   = nutEdgeGap,
            // allowance from physical sizes...
            boltDiameterAllowance = 1,
            boltLengthAllowance   = 0.5,
            nutDiameterAllowance  = 1,
            nutThicknessAllowance = 1
        );
        
        // allowance on bolt/nuts
        // adjust hole size
        translate([100,0,0]) {
        malePanel()
        
        /*▶*/   TNutCage( profile2 );
        
        femalePanel(panelThickness,boltDiameter)
        
        /*▶*/   TNutCagePanelHole( profile2, allowance=2 );
        
        translate([0,panelThickness,0]) dummyBolt();
        translate([0,-nutEdgeGap,0]) dummyNut();
        }
        
        module malePanel() {
            difference() {
                translate([0,-10,0]) square([20,20],center=true);
                children();
            }
        }
        module femalePanel(thickness,boltDiameter) {
            color("SteelBlue") translate([0,thickness/2,0])
                square([25,thickness],center=true);
            translate([0,20,0]) {
                color("SteelBlue") difference() {
                    square([25,10],center=true);
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
        $fn=50;
        
        panelThickness = 3;
        
        // PANELS ONLY
        
        profile1 = TNutCageProfile(
            panelThickness = panelThickness,
            boltLength   = 15, nutDiameter  = 5,
            boltDiameter =  3, nutThickness = 3,
            nutEdgeGap   =  5
        );
        panelMale()
        
        /*▶*/   TNutCage(profile1);
        
        translate( [0,panelThickness/2,0] ) rotate( [90,0,0] ) panelFemale(panelThickness)
        
        /*▶*/   TNutCagePanelHole(profile1);
        
        // PANELS WITH NUTS AND BOLTS
        // - see "nuts-bolts.scad"
        
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
            panelThickness        = panelThickness,
            boltProfile           = boltProfile,
            nutProfile            = nutProfile,
            nutEdgeGap            = 8,   // panel edge to captured nut
            boltDiameterAllowance = 1,   // allowance from physical sizes...
            boltLengthAllowance   = 0.5,
            nutDiameterAllowance  = 1,
            nutThicknessAllowance = 1
        );
        kvEchoAligned(profile2);

        // ...possibly extract from another module
        edgeGap     =kvGet(profile2,"nut.edgeGap");
        nutThickness=kvGet(profile2,"nut.thickness");
        
        translate([50,0,0]) //rotate([0,0,180]) 
        {
        rotate( [-90,0,0] ) color( "lightgray" ) {
            translate( [0,0,panelThickness] )
                Bolt(boltProfile);
            translate([0,0,-edgeGap-nutThickness]) rotate([0,0,30])
                Nut(nutProfile);
        }
        panelMale()
        
        /*▶*/   TNutCage(profile2);
        
        translate([0,panelThickness/2,0]) rotate([90,0,0]) panelFemale(panelThickness)
        
        /*▶*/   TNutCagePanelHole(profile2);
        }
        
        // USING ORIENTATION HELPERS
        // - see "orientation.scad"
        
        translate([100,0,0]) {
        THK=8;
        OFront(THK,faceIn=true) color( "lightgray" ) {
            OBottom(THK)
                Bolt(boltProfile);
            OBottom(THK,edgeGap+THK+nutThickness) rotate([0,0,30])
                Nut(nutProfile);
        }
        panelMale()
        
        /*▶*/   TNutCage(profile2,panelThickness=THK);
        
        OFront(THK) panelFemale(THK)
        
        /*▶*/   TNutCagePanelHole(profile2,allowance=2);
        }
        
        module panelMale() {
            linear_extrude(panelThickness,center=true)
            difference() { // panel top at origin
                translate( [0,-10,0] ) square( [20,20], center = true );
                children();
            }
        }
        module panelFemale(thickness) {
            color("SteelBlue",0.5)
            linear_extrude(thickness,center=true)
            difference() {
                square( [20,20], center = true );
                children();
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
        panelThickness,          // thickness of panel to be connected (P2 in diagram)
        boltDiameter,            // bolt info
        boltLength,
        nutDiameter,             // nut info
        nutThickness,
        nutEdgeGap,              // distance from panel edge to nut capture slot
        boltProfile,             // specify instead of boltLength, boltDiameter
        nutProfile,              // specify instead of boltDiameter, nutDiameter, nutThickness
        boltDiameterAllowance=0,
        boltLengthAllowance=0,
        nutDiameterAllowance =0,
        nutThicknessAllowance=0
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
        "panelThickness", panelThickness,
        "bolt", KVTree([ "effDiameter", eBoltDiameter+boltDiameterAllowance, "effLength", eBoltLength+boltLengthAllowance ]),
        "nut",  KVTree([ "effDiameter", eNutDiameter+nutDiameterAllowance,  
            "thickness", eNutThickness, "thicknessAllowance", nutThicknessAllowance,
            "edgeGap", nutEdgeGap ])
    ]);

    module TNutCage(profile,panelThickness) {
        overlap=1; // extra on top for clean punch

        ePanelThickness=SELECT(panelThickness,kvGet(profile,"panelThickness"));

        bolt         =kvGet(profile,"bolt");
        eBoltDiameter=kvGet(bolt,"effDiameter" );
        eBoltLength  =kvGet(bolt,"effLength"   )-ePanelThickness;

        nut           =kvGet(profile,"nut");
        nutDiameter          =kvGet(nut, "effDiameter" );
        nutThickness         =kvGet(nut, "thickness");
        nutThicknessAllowance=kvGet(nut, "thicknessAllowance");
        nutEdgeGap           =kvGet(nut, "edgeGap" );
        
        translate( [0,-eBoltLength/2+overlap/2,0] )
            square( [eBoltDiameter,eBoltLength+overlap], center=true );
        // center the nut vertically on allowance
        translate( [0,-nutEdgeGap-nutThickness/2,0] )
            square( [nutDiameter,nutThickness+nutThicknessAllowance], center=true );
    }  

    module TNutCagePanelHole(profile,allowance=0) {
        boltDiameter=kvGet(profile,"bolt.effDiameter");
        circle( d=boltDiameter+allowance );
    }
