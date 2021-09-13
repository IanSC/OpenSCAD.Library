//
// PANEL-NOTCHES
// by ISC 2021
//
//     NotchProfile( ... )                              - create profile
//     Notch( targetWidth, notches, profile )      - draw 2D centered notches or notch holes
//     NotchEdge( targetWidth, notches, profile  ) - draw notches/holes edge to edge
//

include <KVTree.scad>

//
// DEMO
//

    // run me !!!
    //$vpr=[0,0,0]; Notch_Demo_2D();
    Notch_Demo();
    //Notch_Assembly_Demo();

    module Notch_Demo_2D() {
        
        include <orientation.scad>
        
        profile1 = NotchProfile( panelThickness = 3 );
        profile2 = NotchProfile( panelThickness = 3,
            notchWidthAllowance  = -1, holeWidthAllowance  = 1,
            notchHeightAllowance =  3, holeHeightAllowance = 1,
            leftGap = 10, rightGap = 10
        );
        kvEchoAligned(profile2);
        
        // gray patches were punched out
        translate([  0,  0,0]) demoM( 80,profile1,"gray")  Notch    (  80,  2, profile1 );
        translate([  0, 35,0]) demoM( 80,profile1,"gray")  NotchEdge(  80,  2, profile1 );
        translate([  0, 60,0]) demoF( 80,         "gray")  Notch    (  80, -2, profile1 );

        // green patches were added
        translate([ 90,  0,0]) demoM( 80,profile1,"green") Notch    (  80,  2, profile1, additive=true  );
        translate([ 90, 35,0]) demoM( 80,profile1,"green") NotchEdge(  80,  2, profile1, additive=true  );

        // gray patches were punched out
        translate([190,  0,0]) demoM(100,profile2,"gray")  Notch    ( 100,  2, profile2                 );
        translate([190, 35,0]) demoM(100,profile2,"gray")  Notch    ( 100,  2, profile2, punchGap=false );
        translate([190, 70,0]) demoM(100,profile2,"gray")  NotchEdge( 100,  2, profile2                 );
        translate([190,105,0]) demoM(100,profile2,"gray")  NotchEdge( 100,  2, profile2, punchGap=false );
        translate([190,130,0]) demoF(100,         "gray")  Notch    ( 100, -2, profile2                 );
        
        module demoM(width,profile,color) {
            color("red") translate([0,0,1]) square([width,0.5],center=true); // origin
            difference() {
                union() {
                    translate([0,-10,0]) square([width,20],center=true); // panel top at origin
                    nHa=kvGet(profile,"notch.heightAllowance");
                    if (nHa>0) // notchHeightAllowance above origin
                        translate([0,nHa/2-0.5,0]) square([width,nHa+1],center=true);
                }
                children();
            }
            color(color) children();
        }
        module demoF(width,color) {
            color("red") translate([0,0,1]) square([width,0.5],center=true); // origin
            difference() {
                square([width,20],center=true);
                children();
            }
            color(color) children();
        }
    }

    module Notch_Demo() {
        
        include <orientation.scad>
        
        panelThickness = 3;
        profile1 = NotchProfile( panelThickness = panelThickness );
        profile2 = NotchProfile( panelThickness = panelThickness,
            notchWidthAllowance  = -1, holeWidthAllowance  = 1,
            notchHeightAllowance =  3, holeHeightAllowance = 1,
            leftGap = 10, rightGap = 10
        );

        // *** MALE/FEMALE ***
        translate([0,0,0]) {
            solid() malePanel(80,profile1)
            
            /* ▶ */     Notch( 80, 2, profile1 );
            
            OBack(panelThickness) color("green",0.5) solid() femalePanel(80)
            
            /* ▶ */     Notch( 80, -2, profile1 );
        }

        // *** MALE/MALE BROMANCE ***
        translate([0,50,0]) {
            OTop(panelThickness) solid() malePanel(80,profile1)
            
            /* ▶ */     Notch( 80, 2, profile1 );
            
            OBack(panelThickness) color("green",0.5) solid() malePanel(80,profile1)
                
            /* ▶ */     NotchEdge( 80, 2, profile1, punchGap=false );
        }
        
        // *** MALE/FEMALE WITH ADJUSTMENTS ***
        translate([0,100,0]) {
            solid() malePanel(100,profile2)
            
            /* ▶ */     Notch( 100, 2, profile2 );
            
            OBack(panelThickness) color("green",0.5) solid() femalePanel(100)
            
            /* ▶ */     Notch( 100, -2, profile2 );
        }
            
        // *** MALE/MALE BROMANCE WITH ADJUSTMENTS ***
        translate([0,150,0]) {
            OTop(panelThickness) solid() malePanel(100,profile2)
            
            /* ▶ */     Notch( 100, 2, profile2 );
            
            OBack(panelThickness) color("green",0.5) solid() malePanel(100,profile2)
            
            /* ▶ */     NotchEdge( 100, 2, profile2, punchGap=false );
        }

        module solid() linear_extrude(panelThickness,center=true) children();
        
        module malePanel(width,profile) {
            difference() {
                union() {
                    translate([0,-10,0]) square([width,20],center=true); // panel top at origin
                    nHa=kvGet(profile,"notch.heightAllowance");
                    if (nHa>0) // notchHeightAllowance above origin
                        translate([0,nHa/2-0.5,0]) square([width,nHa+1],center=true);
                }
                children();
            }
        }
        module femalePanel(width) {
            difference() {
                square([width,20],center=true);
                children();
            }
        }
    }

    module Notch_Assembly_Demo() {
        include <positioning.scad>
        include <orientation.scad>
        
        W  = 80;  // width
        D  = 50;  // depth
        H  = 100; // height
        T  = 3;   // panel thickness
        S1 = 10;  // shelf1 position (from bottom)
        S2 = 50;  // shelf2 position (from bottom)

        SF1 = S1+T/2;   // shelf1 front panel height
        SF2 = H-S2+T/2; // shelf2 front panel height
        
        profile = NotchProfile(panelThickness=T);
        
        assembly();
        translate([120,0,0])
        rotate([0,0,180])
            assembly();
        
        module assembly() {
            CubeExtents(W,D,H);

            // shelves
            color("LightGrey") OBottom(0,H/2-S1) solid() shelfBottom();
            color("LightGrey") OBottom(0,H/2-S2) solid() shelfBottom();
            
            // walls
            OLeft (T,W/2) solid()                   walls();
            ORight(T,W/2) solid() rotate([0,180,0]) walls();
            
            // shelves front panel
            color("gray") OFront(T,D/2,0,-H/2+SF1/2) solid() frontPanel1();
            color("gray") OFront(T,D/2,0, H/2-SF2/2) solid() frontPanel2();

            // back panel
            color("DarkGray")  OBack (T,D/2) solid() back();
        }
        
        module solid() linear_extrude(T,center=true) children();
        module walls() {
            punch() {
                square([D,H],center=true);
                union() {                    
                    MUp(S1) PBottom(H) Notch    (D,-2,profile); // holes for shelf bottom
                    MUp(S2) PBottom(H) Notch    (D,-2,profile);
                            PRight(D)  NotchEdge(H,3,profile);  // back panel
                    // shelves front panel
                    PLeft(D) NotchEdge(H,1,profile,punchGap=false,rightGap=H-SF1);
                    PLeft(D) NotchEdge(H,2,profile,punchGap=false,leftGap =H-SF2);
                }
            }
        }
        module back() {
            punch() {
                square([W,H],center=true);
                union() {                    
                            PLeft(W)   Notch(H,3,profile);  // walls
                            PRight(W)  Notch(H,3,profile);
                    MUp(S1) PBottom(H) Notch(W,-2,profile); // shelves bottom
                    MUp(S2) PBottom(H) Notch(W,-2,profile);
                }
            }
        }
        module shelfBottom() {
            punch() {
                square([W,D],center=true);
                union() {                    
                    PLeft(W)   Notch    (D,2,profile); // walls
                    PRight(W)  Notch    (D,2,profile);
                    PBottom(D) NotchEdge(W,2,profile); // front
                    PTop(D)    Notch    (W,2,profile); // back
                }
            }
        }
        module frontPanel1() {
            punch() {
                square([W,SF1],center=true);
                union() {
                    PLeft(W)  Notch(SF1,1,profile); // walls
                    PRight(W) Notch(SF1,1,profile);
                    PTop(SF1) Notch(W,2,profile);   // front
                }
            }
        }
        module frontPanel2() {
            punch() {
                square([W,SF2],center=true);
                union() {                    
                    PLeft(W)     Notch(SF2,2,profile); // walls
                    PRight(W)    Notch(SF2,2,profile);
                    PBottom(SF2) Notch(W,2,profile);   // front
                }
            }
        }
        
        // to diagnose a part while designing,
        // set debug to true and generate the part. ex:
        //    debug=true;
        //    walls();
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
        panelThickness,           // set only this to default notch notchHeight, holeHeight
        notchHeight,              // height of notch, usually same as panel thickness
        holeHeight,               // height of holes, usually same as panel thickness
        notchWidthAllowance = 0,  // allowance when creating notches, - smaller, to fit notches
        notchHeightAllowance = 0, // to adjust protrusion to the other face when inserted
        holeWidthAllowance = 0,   // allowance when creating holes, + bigger, to for notches
        holeHeightAllowance = 0,  // ...
                                  // params to Notch()/NotchEdge(), for default
                                  // but can be overridden when calling those modules
        punchGap = undef,         
        leftGap  = 0,             // ... will be added to supplied params
        rightGap = 0,             // ... will be added to supplied params
        fromEdge = undef,
        additive = undef,
    ) = let(
        eNotchHeight = (notchHeight==undef)?panelThickness:notchHeight,
        eHoleHeight  = (holeHeight ==undef)?panelThickness:holeHeight,
        e1=ErrorIf(eNotchHeight==undef, "notchHeight or panelThickness required" ),
        e2=ErrorIf(eHoleHeight ==undef, "holeHeight or panelThickness required" )
    ) KVTree([
        "notch", KVTree([ "height", eNotchHeight, "widthAllowance", notchWidthAllowance, "heightAllowance", notchHeightAllowance ]),
        "hole", KVTree([ "height", eHoleHeight, "widthAllowance", holeWidthAllowance, "heightAllowance", holeHeightAllowance ]),
        "defaults", KVTree([ "punchGap", punchGap, "leftGap", leftGap, "rightGap", rightGap, "fromEdge", fromEdge, "additive", additive ])
    ]);

    module Notch(targetWidth,notches,profile,punchGap,leftGap=0,rightGap=0,additive,fromEdge) {
        //  notches    value   fromEdge   result                  notes
        //  --------   -----   --------   |-------------------|   -----
        //
        //  positive     2     false          +---+   +---+       2 notches centered
        //                                +---+   +---+   +---+
        //
        //  negative    -2     false      |   #####   #####   |   2 holes centered
        //
        //  positive   [ 2]    -any-      +---+   +---+   +---+   partner of "2 nothces centered"
        //               2     true       |   +---+   +---+   |   ... so 3 notches edge to edge
        //
        //  negative   [-2]    -any       #####   #####   #####   holes for partner of "2 notches centered"
        //              -2     true                               ... so 3 holes edge to edge
        //
        //  ex. male/male connected, visually 2 and 2:
        //      Notch(notches=2)
        //      Notch(notches=2,fromEdge=true)
        //  vs. male/male connected, visually 2 and 3:
        //      Notch(notches=2)
        //      Notch(notches=3,fromEdge=true)

        defaults  = kvGet(profile,"defaults");
        eFromEdge = is_list(notches) || SELECT(fromEdge,kvGet(defaults,"fromEdge"),false);
        value     = is_list(notches)?notches[0]:notches;
        eNotch    = abs(value);
        ExitIf(eNotch<=0,"invalid notches");
        
        if (value<=0) {
            notchFemale(targetWidth,eNotch,profile,eFromEdge,leftGap,rightGap);
        } else {
            eAdditive=SELECT(additive,kvGet(defaults,"additive"),false);
            if (eAdditive)
                notchMaleAdditive(targetWidth,eNotch,profile,eFromEdge,leftGap,rightGap);
            else
                notchMale(targetWidth,eNotch,profile,eFromEdge,punchGap,leftGap,rightGap);
        }
    }
    
    module NotchEdge(targetWidth,notches,profile,punchGap,leftGap=0,rightGap=0,additive,notEdge) {
        // same notes as Notch(), but reversed
        //
        // ex. male/male connected, visually 2 and 2:
        //     Notch    (notches=2)
        //     NotchEdge(notches=2)
        eNotEdge=is_list(notches) || (notEdge==true);
        value   =is_list(notches)?notches[0]:notches;
        Notch(targetWidth,value,profile,punchGap,leftGap,rightGap,additive,!eNotEdge);
    }
    
    module notchMaleAdditive(targetWidth,notches,profile,fromEdge,leftGap=0,rightGap=0) {
        // for union() to panels
        
        overlap = 1; // extra at the bottom for clean union

        notch       = kvGet(profile,"notch");
        notchHeight = kvGet(notch,"height"         );
        nWa         = kvGet(notch,"widthAllowance" );
        nHa         = kvGet(notch,"heightAllowance");

        defaults  = kvGet(profile,"defaults");
        eFromEdge = SELECT(fromEdge,kvGet(defaults,"fromEdge"),false);
        eGapLeft  = kvGet(defaults,"leftGap" ) + leftGap;
        eGapRight = kvGet(defaults,"rightGap") + rightGap;

        effWidth   = targetWidth-eGapLeft-eGapRight;
        div        = notches*2+1;
        notchWidth = effWidth/div;

        translate( [eGapLeft/2-eGapRight/2,notchHeight/2+nHa/2-overlap/2,0] )
        notchRepeater(effWidth,notches,eFromEdge)
            square( [notchWidth+nWa,notchHeight+nHa+overlap], center=true );
    }
    
    module notchMale(targetWidth,notches,profile,fromEdge,punchGap,leftGap=0,rightGap=0) {
        // for difference() to panels
        
        overlap    = 1; // extra on top for clean punch
        gapOverlap = 0.001;
        
        notch       = kvGet(profile,"notch");
        notchHeight = kvGet(notch,"height"         );
        nWa         = kvGet(notch,"widthAllowance" );
        nHa         = kvGet(notch,"heightAllowance");

        defaults  = kvGet(profile,"defaults" );
        eFromEdge = SELECT(fromEdge,kvGet(defaults,"fromEdge"),false);
        ePunchGap = SELECT(punchGap,kvGet(defaults,"punchGap"),true);
        eGapLeft  = kvGet(defaults,"leftGap" ) + leftGap;
        eGapRight = kvGet(defaults,"rightGap") + rightGap;
        
        effWidth   = targetWidth-eGapLeft-eGapRight;        
        div        = notches*2+1;
        punchWidth = effWidth/div;
        
        // notchHeightAllowance >= 0, higher notches
        //
        //    increase notch height
        //    move pattern up by heightAllowance
        //
        //    assume user has positioned panel +notchHeightAllowance above the origin
        //       for easier positioning with female panel, eg. female still anchored on origin
        //
        //             ###  <-- heightAllowance if +, above y-axis
        //       --+---###---+---- y-axis
        //         | F ###   |     # - notch
        //         +---###---+     F - female panel
        //         | M       |     M - male panel
        //
        //    otherwise, need to move female panel down by notchHeightAllowance
        //
        //       ------###-------- y-axis
        //         +---###---+
        //         | F ###   |     # - notch
        //         +---###---+     F - female panel
        //         | M       |     M - male panel
        //
        // notchHeightAllowance <= 0, increase notch height below origin
        //
        //    use same cutting depth without allowance
        //    remove strip on top of the whole panel, female still anchored on origin
        //
        //       --+---------+---- y-axis
        //         | F ###   |     # - notch
        //         +---###---+     F - female panel
        //         | M       |     M - male panel
        //
        eHeight=(nHa>=0)?notchHeight+nHa:notchHeight;
        yOffset=(nHa>=0)?nHa            :0          ;
        
        translate( [0,yOffset,0] ) {
            
            // notEdge, notches = 2
            //       +---+   +---+
            //   +---+   +---+   +---+
            //   |                   |
            //
            // edge, notches = 2
            //   +---+   +---+   +---+
            //   |   +---+   +---+   |
            //   |                   |

            // we are punching so reverse allowance and notch positions
            translate( [eGapLeft/2-eGapRight/2,-eHeight/2+overlap/2,0] )
            notchRepeater(effWidth,notches,!eFromEdge)
                square( [punchWidth-nWa,eHeight+overlap], center=true );
            
            if (ePunchGap) {
                // punch out left/right gaps
                if (eGapLeft!=0) // && eGapLeft<=targetWidth)
                    translate( [-targetWidth/2-gapOverlap,-eHeight,0] )
                    square( [eGapLeft+gapOverlap,eHeight+overlap] );
                if (eGapRight!=0) // && eGapRight<=targetWidth)
                    translate( [targetWidth/2-eGapRight,-eHeight,0] )
                    square( [eGapRight+gapOverlap,eHeight+overlap] );
            }
        }
    }
    
    module notchFemale(targetWidth,notches,profile,fromEdge,leftGap=0,rightGap=0) {
        // holes to receive notches

        hole       = kvGet(profile,"hole");
        holeHeight = kvGet(hole,"height"         );
        hWa        = kvGet(hole,"widthAllowance" );
        hHa        = kvGet(hole,"heightAllowance");

        defaults  = kvGet(profile,"defaults");
        eFromEdge = SELECT(fromEdge,kvGet(defaults,"fromEdge"),false);
        eGapLeft  = kvGet(defaults,"leftGap" ) + leftGap;
        eGapRight = kvGet(defaults,"rightGap") + rightGap;
        
        effWidth  = targetWidth-eGapLeft-eGapRight; 
        div       = notches*2+1;
        holeWidth = effWidth/div;
        
        translate( [eGapLeft/2-eGapRight/2,0,0] )
        notchRepeater(effWidth,notches,eFromEdge)
            square( [holeWidth+hWa,holeHeight+hHa], center=true );
        
        if (eFromEdge && hWa==0) {
            // if widthAllowance +, will already punch cleanly
            // if widthAllowance -, user wants space ???
            // if widthAllowance 0, add extra to punch cleanly
            overlap = 1;
            if (eGapLeft==0) {
                translate( [-targetWidth/2,0,0] )
                    square( [overlap,holeHeight+hHa], center=true );
            }
            if (eGapRight==0) {
                translate( [targetWidth/2,0,0] )
                    square( [overlap,holeHeight+hHa], center=true );
            }
        }
    }

//
// REPEATERS
//
    
    module notchRepeater(targetWidth,notches,fromEdge=false) {
        if (fromEdge)
            notchRepeaterOutside(targetWidth,notches) children();
        else
            notchRepeaterInside(targetWidth,notches) children();  
    }
    
    module notchRepeaterInside(targetWidth,notches) {
        //    ###   ###
        // +--   ---   --+
        // |             |
        div = notches*2+1;
        notchSize = targetWidth/div;
        translate( [-(notches-1)*notchSize,0,0] )
        for (i = [0:notches-1]) {
            translate( [i*notchSize*2,0,0] )
            children();
        }        
    }

    module notchRepeaterOutside(targetWidth,notches) {
        // ###   ###   ###
        // |  ---   ---  |
        // |             |
        div = notches*2+1;
        notchSize = targetWidth/div;
        translate( [-notches*notchSize,0,0] )
        for (i = [0:notches]) {
            translate( [i*notchSize*2,0,0] )
            children();
        }                
    }
