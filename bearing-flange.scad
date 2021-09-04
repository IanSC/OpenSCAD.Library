//
// FLANGE BEARING - USING 2 or 4 BOLTS
// by ISC 2021
//
// accurate by measurement for product design
// for rough visual representation only
//
//     profile = FlangeBearingProfile( ... ) - create profile
//     FlangeBearing( profile )              - draw 3D
//     FlangeBearingPanelHole( profile  )    - draw 2D panel holes
//

include <key-value.scad>
include <utility.scad>

//
// DEMO
//

    // run me !!!
    //FlangeBearing2Bolts_Demo();
    //translate( [0,-200,0] )
    //    FlangeBearing4Bolts_Demo();

    module FlangeBearing2Bolts_Demo() {

        profile1 = FlangeBearingProfile( shaftDiameter=8, boltDistance=37, boltCount=2, height=12 );
        FlangeBearing( profile1 );
        translate( [0,-80,0] )
             linear_extrude( 3 )
             difference() {
                 square( [100,60], center=true );
                 FlangeBearingPanelHole( profile1 );
             }

        profile2 = FlangeBearingProfile(
            shaftDiameter = 10,
            boltDiameter = 5, boltDistance = 80, boltCount=2, 
            width = 100, depth = 60,
            height = 20
        );
        translate( [150,0,0] ) {
            FlangeBearing( profile2 );
            translate( [0,-80,0] )
                linear_extrude( 3 )
                difference() {
                    square( [100,60], center=true );
                    FlangeBearingPanelHole( profile2, enlargeBolt=1 );
                }
        }

        profile3 = FlangeBearingProfile(
            shaftDiameter = 8,
            boltDiameter = 5, boltDistance = 37, boltCount=2, 
            width = 47, depth = 27,
            height = 12, ringHeight=8, baseHeight=3
        );
        translate( [300,0,0] ) {
            FlangeBearing( profile3 );
            translate( [0,-80,0] )
                linear_extrude( 3 )
                difference() {
                    square( [100,60], center=true );
                    FlangeBearingPanelHole( profile3, omitCenterHole=false, enlargeShaft=2, enlargeBolt=1 );
                }
        }
    }


    module FlangeBearing4Bolts_Demo() {

        profile1 = FlangeBearingProfile( shaftDiameter=8, boltDistance=37, boltCount=4, height=12 );
        FlangeBearing( profile1 );
        translate( [0,-80,0] )
             linear_extrude( 3 )
             difference() {
                 square( [80,80], center=true );
                 FlangeBearingPanelHole( profile1 );
             }

        profile2 = FlangeBearingProfile(
            shaftDiameter = 10,
            boltDiameter = 5, boltDistance = 50, boltCount=4, 
            width = 60,
            height = 20
        );
        translate( [150,0,0] ) {
            FlangeBearing( profile2 );
            translate( [0,-80,0] )
                linear_extrude( 3 )
                difference() {
                    square( [80,80], center=true );
                    FlangeBearingPanelHole( profile2, enlargeBolt=1 );
                }
        }

        profile3 = FlangeBearingProfile(
            shaftDiameter = 15,
            boltDiameter = 5, boltDistance = 40, boltCount=4, 
            width = 50,
            height = 25, ringHeight=16, baseHeight=7
        );
        translate( [300,0,0] ) {
            FlangeBearing( profile3 );
            translate( [0,-80,0] )
                linear_extrude( 3 )
                difference() {
                    square( [80,80], center=true );
                    FlangeBearingPanelHole( profile3, omitCenterHole=false, enlargeShaft=2, enlargeBolt=1 );
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
        height,
        boltCount    = 2,
        boltDiameter = 5,
        width        = undef,
        depth        = undef,        
        ringHeight   = undef,
        baseHeight   = undef
    ) = let (
        e1=ErrorIf( shaftDiameter==undef, "shaftD diameter missing" ),
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
    ) KeyValue ([
        "type"         , "flange bearing",
        "model"        , model,
        "shaftDiameter", shaftDiameter,
        "bolt"         , KeyValue([ "diameter", boltDiameter, "distance", boltDistance, "count", boltCount ]),
        "width"        , eWidth,
        "depth"        , eDepth,
        "height"       , KeyValue([ "center", height, "ring", eRingHeight, "base", eBaseHeight ])
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
                                    circle( d=depth );
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
