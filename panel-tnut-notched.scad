//
// PANEL-TNUT-NOTCHED
// by ISC 2021
//
//     TNutCageNotched_M( targetWidth, notches, tnutProfile, notchProfile )  - draw 2D t-nut capture with notches
//     TNutCageNotched_F( targetWidth, notches, tnutProfile, notchProfile  ) - draw 2D t-nut capture with notches
//     TNutCageNotched( targetWidth, notches, tnutProfile, notchProfile )    - draw 2D t-nut capture with notches
//

include <KVTree.scad>
include <panel-notch.scad>
include <panel-tnut.scad>

//
// DEMO
//

    // run me !!!
    //TNutCageNotched_Demo();
    //TNutCageNotched_Assembly_Demo();

    module TNutCageNotched_Demo() {
        include <nuts-bolts.scad>
        include <orientation.scad>
        $fn = 20;
        
        panelThickness = 3;

        // NOTCH PROFILE
        notchProfile = NotchProfile(
            panelThickness = panelThickness,
            notchWidthAllowance  = 0, holeWidthAllowance  = 1,
            notchHeightAllowance = 0, holeHeightAllowance = 1
        );

        // T-NUT PROFILE
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
            connectedPanelThickness = panelThickness,
            boltProfile             = boltProfile,
            nutProfile              = nutProfile,
            nutEdgeGap              = 8,   // panel edge to captured nut
            boltDiameterAllowance   = 1,   // allowance from physical sizes
            boltLengthAllowance     = 0.5,
            nutDiameterAllowance    = 1,
            nutThicknessAllowance   = 1
        );
        
        // ...possibly extract from another module
        edgeGap     =kvGet(tnutProfile,"nut.edgeGap");
        nutThickness=kvGet(tnutProfile,"nut.thickness");

        // *** SINGLE T-NUT ***
        translate([0,0,0]) {
           OFFront(panelThickness,panelThickness) color( "lightgray" ) {
                OBottom(panelThickness)
                    Bolt(boltProfile);
                OBottom(panelThickness,edgeGap+panelThickness+nutThickness) rotate([0,0,30])
                    Nut(nutProfile);
            }
            malePanel(30,notchProfile)
            
                /* ▶ */     TNutCageNotched_M( 30, 0, tnutProfile, notchProfile );
                
            OBack(panelThickness) femalePanel(30)
            
                /* ▶ */     TNutCageNotched_F( 30, 0, tnutProfile, notchProfile );
        }

        // *** MULTIPLE T-NUTS 1 ***
        translate([60,0,0]) rotate([0,0,180]) {
            OFFront(panelThickness,panelThickness) color( "lightgray" ) {
                notchRepeaterOutside(50,1) {
                    OBottom(panelThickness)
                        Bolt(boltProfile);
                    OBottom(panelThickness,edgeGap+panelThickness+nutThickness) rotate([0,0,30])
                        Nut(nutProfile);
                }
            }
            malePanel(50,notchProfile)
            
                /* ▶ */     TNutCageNotched( 50, 1, tnutProfile, notchProfile );
                
            OBack(panelThickness) femalePanel(50)
            
                /* ▶ */     TNutCageNotched( 50, -1, tnutProfile, notchProfile );
        }

        // *** MULTIPLE T-NUTS 2 ***
        translate([150,0,0]) {
            OFFront(panelThickness,panelThickness) color( "lightgray" ) {
                notchRepeaterOutside(80,3) {
                    OBottom(panelThickness)
                        Bolt(boltProfile);
                    OBottom(panelThickness,edgeGap+panelThickness+nutThickness) rotate([0,0,30])
                        Nut(nutProfile);
                }
            }
            malePanel(80,notchProfile)
            
                /* ▶ */     TNutCageNotched( 80, 3, tnutProfile, notchProfile );
                
            OBack(panelThickness) femalePanel(80)
            
                /* ▶ */     TNutCageNotched( 80, -3, tnutProfile, notchProfile );
        }

        module malePanel(width,notchProfile) {
            linear_extrude(panelThickness,center=true)
            difference() {
                union() {
                    translate([0,-10,0]) square([width,20],center=true); // panel top at origin
                    nHa=kvGet(notchProfile,"notch.heightAllowance");
                    if (nHa>0) // notchHeightAllowance above origin
                        translate([0,nHa/2-0.5,0]) square([width,nHa+1],center=true);
                }
                children();
            }
        }
        module femalePanel(width) {
            color( "green", 0.7 )
            linear_extrude(panelThickness,center=true)
            difference() {
                square([width,20],center=true);
                children();
            }
        }
    }

    module TNutCageNotched_Assembly_Demo() {
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
        
        // NOTCH PROFILE
        notchProfile = NotchProfile(
            panelThickness = T,
            notchWidthAllowance  = 0, holeWidthAllowance  = 1,
            notchHeightAllowance = 0, holeHeightAllowance = 1
        );

        // T-NUT PROFILE
        boltProfile = BoltProfile(
            shaftDiameter =  1,
            length        = 8,
            headDiameter  =  3,
            headThickness =  1 );
        nutProfile = NutProfile(
            boltDiameter = 1,
            nutDiameter  = 3,
            thickness    = 1 );
        tnutProfile = TNutCageProfile(
            connectedPanelThickness = T,
            boltProfile             = boltProfile,
            nutProfile              = nutProfile,
            nutEdgeGap              = 3,   // panel edge to captured nut
            boltDiameterAllowance   = 1,   // allowance from physical sizes...
            boltLengthAllowance     = 0.5,
            nutDiameterAllowance    = 1,
            nutThicknessAllowance   = 1
        );

        // ...possibly extract from another module
        edgeGap     =kvGet(tnutProfile,"nut.edgeGap");
        nutThickness=kvGet(tnutProfile,"nut.thickness");
        
        assembly();
        translate([120,0,0])
        rotate([0,0,180])
            assembly();
        
        showBolts=true;
        
        module assembly() {
            CubeExtents(W,D,H);

            // shelves
            color("LightGrey") OBottom (0,H/2-S1) solid() shelfBottom();
            color("LightGrey") OBottom (0,H/2-S2) solid() shelfBottom();
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
            right = +EXT;
            effD  = D+right;
            punch() {
                MRight(right/2)
                square([effD,H],center=true);
                union() {                    
                    MUp(S1)    PBottom(H) TNutCageNotched(D,-2,tnutProfile,notchProfile,5,5); // holes for shelf bottom
                    MUp(S2)    PBottom(H) TNutCageNotched(D,-2,tnutProfile,notchProfile,5,5);
                    MLeft(T/2) PRight(D)  TNutCageNotched(H,-3,tnutProfile,notchProfile); // back panel
                    // shelves front panel
                    MUp  (H/2-SF2/2) PLeft(D) TNutCageNotched_M(SF2,2,tnutProfile,notchProfile,5,5);
                    // for bottom, single t-nut, trim panel
                    MDown(H/2-SF1/2,T) PLeft(D) TNutCage_M(tnutProfile);
                    MDown(H/2-SF1/2,T/2) PLeft(D) square([SF1,T],center=true);
                }
            }
        }
        module wallBolts() {
            // those with negative (-) count in walls() are holes, plug with bolts
            // while testing, show only:
            // - wallBolts();
            // - solid() walls();
            MUp(S1)    PBottom(H) notchRepeaterOutside(D-5-5,2) boltNut();
            MUp(S2)    PBottom(H) notchRepeaterOutside(D-5-5,2) boltNut();
            MLeft(T/2) PRight(D)  notchRepeaterOutside(H,3)     boltNut();
        }        
        // *** BACK ***
        module back() {
            punch() {
                square([W,H],center=true);
                union() {                    
                            PLeft(W)   TNutCageNotched(H, 3,tnutProfile,notchProfile);       // walls
                            PRight(W)  TNutCageNotched(H, 3,tnutProfile,notchProfile);
                    MUp(S1) PBottom(H) TNutCageNotched(W,-2,tnutProfile,notchProfile,10,10); // shelves bottom
                    MUp(S2) PBottom(H) TNutCageNotched(W,-2,tnutProfile,notchProfile,10,10);
                }
            }
        }
        module backBolts() {
            MUp(S1) PBottom(H) notchRepeaterOutside(W-10-10,2) boltNut();
            MUp(S2) PBottom(H) notchRepeaterOutside(W-10-10,2) boltNut();
        }
        // *** SHELVES BOTTOM ***
        module shelfBottom() {
            bottom = +EXT;
            effD   = D+bottom;
            punch() {
                MDown(bottom/2)
                square([W,effD],center=true);
                union() {
                             PLeft(W)   TNutCageNotched(D, 2,tnutProfile,notchProfile,5,5);   // walls   
                             PRight(W)  TNutCageNotched(D, 2,tnutProfile,notchProfile,5,5);
                    MUp(T/2) PBottom(D) TNutCageNotched(W,-2,tnutProfile,notchProfile);       // front 
                             PTop(D)    TNutCageNotched(W, 2,tnutProfile,notchProfile,10,10); // back
                }
            }
        }
        module shelfBottomBolts() {
            bottom = +EXT;
            MUp(bottom-T) PBottom(D) notchRepeaterOutside(W,2) boltNut();
        }        
        // *** SHELVES FRONT ***
        module frontPanel1() {
            effW=W+EXT*2;
            punch() {
                square([effW,SF1],center=true);
                union() {
                    MRight(T/2) PLeft(W)  TNutCage_F     (tnutProfile);                   // walls
                    MLeft (T/2) PRight(W) TNutCage_F     (tnutProfile);
                                PTop(SF1) TNutCageNotched (W,2,tnutProfile,notchProfile); // front
                }
            }
        }
        module frontPanel1Bolts() {
            top   =-T;
            MRight(T/2) PLeft( W) notchRepeaterOutside(SF1,0) boltNut();
            MLeft (T/2) PLeft(-W) notchRepeaterOutside(SF1,0) boltNut();
        }
        module frontPanel2() {
            effW=W+EXT*2;
            punch() {
                square([effW,SF2],center=true);
                union() {                    
                    MRight(T/2) PLeft(W)     TNutCageNotched(SF2,-2,tnutProfile,notchProfile,5,5); // walls
                    MLeft (T/2) PRight(W)    TNutCageNotched(SF2,-2,tnutProfile,notchProfile,5,5);
                                PBottom(SF2) TNutCageNotched(W  , 2,tnutProfile,notchProfile);     // front
                }
            }
        }
        module frontPanel2Bolts() {
            MRight(T/2) PLeft( W) notchRepeaterOutside(SF2-5-5,2) boltNut();
            MLeft (T/2) PLeft(-W) notchRepeaterOutside(SF2-5-5,2) boltNut();
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
// T-NUT WITH NOTCHES 
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

    module TNutCageNotched(targetWidth,notches,tnutProfile,notchProfile,leftGap=0,rightGap=0) {
        if (notches==0 || notches==undef)
            Exit( "TNutCageNotched(): notches cannot be 0, use *_M() or *_F() instead" );
        if (notches>0)
           TNutCageNotched_M(targetWidth,notches,tnutProfile,notchProfile,leftGap,rightGap);
        else
           TNutCageNotched_F(targetWidth,-notches,tnutProfile,notchProfile,leftGap,rightGap);
    }

    module TNutCageNotched_M(targetWidth,notches=0,tnutProfile,notchProfile,leftGap=0,rightGap=0) {
        if ( notches <= 0 ) {
            //
            // SINGLE T-NUT CAGE (but put notches on both sides)
            //

            //       +-+     +-+ 
            //       | |     | |   <-- add 2 notches
            //     +-+ +--#--+ +-+
            //     |      #      |
            //     |     ###     |
            //     |      #      |
            //  -->|             |<-- targetWidth

            overlap = 1; // extra on top for clean punch

            nutDiameter = kvGet(tnutProfile,"nut.effDiameter");

            notch       = kvGet(notchProfile,"notch");
            notchHeight = kvGet(notch,"height" );
            nHa         = kvGet(notch,"heightAllowance");

            defaults = kvGet(notchProfile,"defaults");
            gapLeft  = kvGet(defaults,"leftGap");
            gapRight = kvGet(defaults,"rightGap");

            notchArea = (targetWidth-nutDiameter)/2;

            translate([0,-notchHeight,0])
                TNutCage_M(tnutProfile);

            translate([-targetWidth/2+notchArea/2,0,0])
                notchMale(notchArea,1,notchProfile,leftGap=-gapLeft,rightGap=-gapRight);
            translate([targetWidth/2-notchArea/2,0,0])
                notchMale(notchArea,1,notchProfile,leftGap=-gapLeft,rightGap=-gapRight);
            translate([0,-notchHeight/2+abs(nHa)/2+overlap/2,0])
                square([nutDiameter+2,notchHeight+abs(nHa)+overlap],center=true);
        } else {
            //
            // MULTIPLE NOTCHES AND T-NUT CAGES
            //

            notchHeight = kvGet(notchProfile,"notch.height" );

            defaults = kvGet(notchProfile,"defaults");
            eGapLeft  = kvGet(defaults,"leftGap")  + leftGap;
            eGapRight = kvGet(defaults,"rightGap") + rightGap;

            width    = targetWidth-eGapLeft-eGapRight; 

            // NOTCH
            notchMale(targetWidth,notches,notchProfile,leftGap=leftGap,rightGap=rightGap);
            // T-NUT
            translate([(eGapLeft-eGapRight)/2,-notchHeight,0])
                notchRepeaterOutside(width,notches)
                    TNutCage_M(tnutProfile);
        }
    }   

    module TNutCageNotched_F(targetWidth,notches=0,tnutProfile,notchProfile,leftGap=0,rightGap=0) {
        if ( notches <= 0 ) {
            //
            // SINGLE T-NUT HOLE (but put notch holes on both sides)
            //

            nutDiameter = kvGet(tnutProfile, "nut.effDiameter" );

            defaults = kvGet(notchProfile,"defaults");
            gapLeft  = kvGet(defaults,"leftGap");
            gapRight = kvGet(defaults,"rightGap");

            notchArea = (targetWidth-nutDiameter)/2;

            TNutCage_F(tnutProfile);

            translate([-targetWidth/2+notchArea/2,0,0])
                notchFemale(notchArea,1,notchProfile,leftGap=-gapLeft,rightGap=-gapRight);
            translate([targetWidth/2-notchArea/2,0,0])
                notchFemale(notchArea,1,notchProfile,leftGap=-gapLeft,rightGap=-gapRight);

        } else {
            //
            // MULTIPLE NOTCH HOLES AND T-NUT HOLES
            //

            defaults  = kvGet(notchProfile,"defaults");
            eGapLeft  = kvGet(defaults,"leftGap")  + leftGap;
            eGapRight = kvGet(defaults,"rightGap") + rightGap;

            width = targetWidth-eGapLeft-eGapRight; 

            // NOTCH
            notchFemale(targetWidth,notches,notchProfile,leftGap=leftGap,rightGap=rightGap);
            // T-NUT
            translate([(eGapLeft-eGapRight)/2,0,0])
                notchRepeaterOutside(width,notches)
                    TNutCage_F(tnutProfile);
        }
    }
