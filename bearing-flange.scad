//
// FLANGE BEARING - USING 2 or 4 BOLTS
// by ISC 2021-09
//
// rough visual representation only
// accurate measurement/holes for product design
//
//     profile = FlangeBearingProfile( ... ) - create profile
//     FlangeBearing( profile )              - draw 3D
//     FlangeBearingPanelHole( profile  )    - draw 2D panel holes
//

include <KVTree.scad>
include <utility.scad>

//
// DEMO
//

    // run me !!!
    //FlangeBearing_Demo();

    module FlangeBearing_Demo() {

        profile2a = FlangeBearingProfile(
            shaftDiameter =  8,
            boltDistance  = 37,
            height        = 12 );
        PartAndPanel() {
            FlangeBearing( profile2a );
            FlangeBearingPanelHole( profile2a );
        }

        profile2b = FlangeBearingProfile(
            shaftDiameter =  10,
            boltDiameter  =   5, 
            boltDistance  =  80,
            boltCount     =   2, 
            height        =  20,
            width         = 100,
            depth         =  60 );
        translate( [150,0,0] )
        PartAndPanel() {
            FlangeBearing( profile2b );
            FlangeBearingPanelHole( profile2b, enlargeBolt=3 );
        }
        
        profile4a = FlangeBearingProfile( 
            shaftDiameter =  8,
            boltDistance  = 37,
            boltCount     =  4, 
            height        = 12 );
        translate( [300,0,0] )
        PartAndPanel() {
            FlangeBearing( profile4a );
            FlangeBearingPanelHole( profile4a, omitCenterHole=false, enlargeShaft=5 );
        }

        profile4b = FlangeBearingProfile(
            shaftDiameter =  10,
            boltDiameter  =   5,
            boltDistance  =  50,
            boltCount     =   4, 
            height        =  32,
            ringHeight    =  25, 
            baseHeight    =  10,
            width         = 100,
            depth         =  80 );
        translate( [450,0,0] )
        PartAndPanel() {
            FlangeBearing( profile4b );
            FlangeBearingPanelHole( profile4b );
        }

        kvEchoAligned( profile4b );

        module PartAndPanel() {
            children(0);
            translate( [0,-100,0] )
                linear_extrude( 3 )
                difference() {
                    square( [120,100], center=true );
                    children(1);
                }
        }
    }

        
//
// CORE
//

    function FlangeBearingProfile(
        model = "",
        shaftDiameter,
        boltDistance, // bolt to bolt distance
        boltCount    = 2,
        height,
        boltDiameter = 5,
        width        = undef,
        depth        = undef,
        ringHeight   = undef,
        baseHeight   = undef
    ) = let (
        e1=ErrorIf( shaftDiameter==undef, "shaft diameter missing" ),
        e2=ErrorIf( boltDistance ==undef, "bolt distance missing"   ),
        e3=ErrorIf( boltCount!=2 && boltCount!=4, "invalid number of bolts [2|4]" ),
        e4=ErrorIf( height == undef, "height missing" ),
        eWidth = IIF( boltCount==2,
            /* 2 bolts */ SELECT( width, boltDistance+boltDiameter*2.5 ),
            /* 4 bolts */ SELECT( width, depth, boltDistance+boltDiameter*4 )
        ),
        eDepth = IIF( boltCount==2,
            /* 2 bolts */ SELECT( depth, boltDistance/2*1.5 ),
            /* 4 bolts */ SELECT( depth, width, boltDistance+boltDiameter*4 )
        ),
        eRingHeight = SELECT( ringHeight, height*0.6 ),
        eBaseHeight = SELECT( baseHeight, height/3 )
    ) KVTree([
        "type"         , "flange bearing",
        "model"        , model,
        "shaftDiameter", shaftDiameter,
        "bolt"         , KVTree([ "diameter", boltDiameter, "distance", boltDistance, "count", boltCount ]),
        "width"        , eWidth,
        "depth"        , eDepth,
        "height"       , KVTree([ "center", height, "ring", eRingHeight, "base", eBaseHeight ])
    ]);

    module FlangeBearing( profile ) {
        t = kvSearch(profile,"type");
        e1=ErrorIf( t!="flange bearing", "FlangeBearing(): invalid profile" );
        go();
        module go() {
            shaftDiameter = kvGet(profile, "shaftDiameter" );
            boltDiameter  = kvGet(profile, "bolt.diameter" );
            boltToBolt    = kvGet(profile, "bolt.distance" );
            boltCount     = kvGet(profile, "bolt.count"    );
            width         = kvGet(profile, "width"         );
            depth         = kvGet(profile, "depth"         );
            cenerHeight   = kvGet(profile, "height.center" );
            ringHeight    = kvGet(profile, "height.ring"   );
            baseHeight    = kvGet(profile, "height.base"   );
            if ( boltCount == 2 )
                bolt2();
            else
                bolt4();

            module bolt2() {
                // |<- width->|
                //       _         ---
                //  __--/ \--__
                // | o   O   o |   depth
                //  --__   __--
                //      \ /        ---
                //
                //      +-+        ---
                //      | |        mainHeight
                //    +-+-+-+       |  ---
                //    |     |       |  ringHeight
                //  +-+-----+-+     |   |  ---
                //  |         |     v   v  baseHeight
                //  +---------+    ------------

                sideDiameters = width - boltToBolt;
                centerToBolts = boltToBolt/2;
                mainRing      = shaftDiameter + (depth-shaftDiameter)/4;
                outerRing     = shaftDiameter + (depth-shaftDiameter)*0.9;
                innerRing     = shaftDiameter + (depth-shaftDiameter)*0.5;

                difference() {
                    union() {
                        linear_extrude( baseHeight )
                            hull() {
                                circle( d=depth );
                                translate( [-centerToBolts,0,0] ) circle( d=sideDiameters );
                                translate( [ centerToBolts,0,0] ) circle( d=sideDiameters );
                            }
                        cylinder( cenerHeight, d=mainRing );                
                        color( "gray" )
                            cylinder( ringHeight+0.1, d=innerRing );
                    }
                    union() {
                        translate([0,0,-1]) {
                            cylinder( cenerHeight+2, d=shaftDiameter );
                            translate( [ centerToBolts,0,0] ) cylinder( baseHeight+2, d=boltDiameter );
                            translate( [-centerToBolts,0,0] ) cylinder( baseHeight+2, d=boltDiameter );
                        }
                    }
                }
                difference() {
                    cylinder( ringHeight, d=outerRing );
                    translate( [0,0,-1] ) cylinder( ringHeight+2, d=innerRing );
                }
            }
            module bolt4() {
                minDim = min(width,depth);
                cornerDiameters = minDim - boltToBolt;
                
                b2b2 = boltToBolt/2;
                mainRing  = shaftDiameter + (minDim-shaftDiameter)/4;
                outerRing = shaftDiameter + (minDim-shaftDiameter)*0.7;
                innerRing = shaftDiameter + (minDim-shaftDiameter)*0.5;
                
                wOff = (width-cornerDiameters)/2;
                dOff = (depth-cornerDiameters)/2;

                difference() {
                    union() {
                        linear_extrude( baseHeight )
                            if ( cornerDiameters>0 )
                                hull() {
                                    //circle( d=depth );
                                    translate( [ wOff, dOff,0] ) circle( d=cornerDiameters );
                                    translate( [ wOff,-dOff,0] ) circle( d=cornerDiameters );
                                    translate( [-wOff, dOff,0] ) circle( d=cornerDiameters );
                                    translate( [-wOff,-dOff,0] ) circle( d=cornerDiameters );
                                }
                            else
                                square( [width,depth], center=true );
                        cylinder( cenerHeight, d=mainRing );                
                        color( "gray" )
                            cylinder( ringHeight+0.1, d=innerRing );
                    }
                    union() {
                        translate([0,0,-1]) {
                            cylinder( cenerHeight+2, d=shaftDiameter );
                            translate( [ b2b2, b2b2,0] ) cylinder( baseHeight+2, d=boltDiameter );
                            translate( [ b2b2,-b2b2,0] ) cylinder( baseHeight+2, d=boltDiameter );
                            translate( [-b2b2, b2b2,0] ) cylinder( baseHeight+2, d=boltDiameter );
                            translate( [-b2b2,-b2b2,0] ) cylinder( baseHeight+2, d=boltDiameter );
                        }
                    }
                }
                difference() {
                    cylinder( ringHeight, d=outerRing );
                    translate( [0,0,-1] ) cylinder( ringHeight+2, d=innerRing );
                }
            }
        }
    }

    module FlangeBearingPanelHole( profile, omitCenterHole=true, enlargeShaft=1, enlargeBolt=1 ) {
        t = kvSearch(profile,"type");
        e1=ErrorIf( t!="flange bearing", "FlangeBearingPanelHole(): invalid profile" );
        boltCount = kvGet(profile, "bolt.count" );
        if ( boltCount==2 ) bolt2(); else bolt4();
        module bolt2() {
            shaftDiameter = kvGet(profile, "shaftDiameter" );
            boltDiameter  = kvGet(profile, "bolt.diameter" );
            boltToBolt    = kvGet(profile, "bolt.distance" );
            b2b2          = boltToBolt/2;
            if ( !omitCenterHole )
                circle( d=shaftDiameter+enlargeShaft );
            translate( [ b2b2,0,0] ) circle( d=boltDiameter+enlargeBolt );
            translate( [-b2b2,0,0] ) circle( d=boltDiameter+enlargeBolt );
        }
        module bolt4() {
            shaftDiameter = kvGet(profile, "shaftDiameter" );
            boltDiameter  = kvGet(profile, "bolt.diameter" );
            boltToBolt    = kvGet(profile, "bolt.distance" );
            b2b2          = boltToBolt/2;
            if ( !omitCenterHole )
                circle( d=shaftDiameter+enlargeShaft );
            translate( [ b2b2, b2b2,0] ) circle( d=boltDiameter+enlargeBolt );
            translate( [ b2b2,-b2b2,0] ) circle( d=boltDiameter+enlargeBolt );
            translate( [-b2b2, b2b2,0] ) circle( d=boltDiameter+enlargeBolt );
            translate( [-b2b2,-b2b2,0] ) circle( d=boltDiameter+enlargeBolt );
        }
    }
