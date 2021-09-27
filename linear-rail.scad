//
// LINEAR RAILS
// by ISC 2021-09
//
// rough visual representation only
// accurate measurement/holes for product design
//
// not sure if SHF and SK are official names
// based it off what the seller calls them
//
// SHF:
//     profile = LinearRailHolderSHFProfile( ... ) - create profile
//     LinearRailHolderSHF( profile )              - draw 3D
//     LinearRailHolderSHFPanelHole( profile )     - draw 2D panel holes
//
// SK:
//     profile = LinearRailHolderSKProfile( ... ) - create profile
//     LinearRailHolderSK( profile )              - draw 3D
//     LinearRailHolderSKPanelHole( profile )     - draw 2D panel holes
//

include <KVTree.scad>
include <utility.scad>

//
// DEMO
//

    // run me!!!
                         LinearRailHolderSHF_Demo();
    translate([100,0,0]) LinearRailHolderSK_Demo();

    module LinearRailHolderSHF_Demo() {
        profile = LinearRailHolderSHFProfile(
            model              = "SHF8",
            shaftDiameter      = 8,
            boltDistance       = 34,
            width              = 34+5+2+2, // overall width
            centerRingDiameter = 8+5,
            baseHeight         = 14,       // shaft center to base bottom
            baseWidth          = 20,
            slit               = 1    
        );
        profileAuto = LinearRailHolderSHFProfile(
            model         = "SHF8-auto",
            shaftDiameter = 8,
            boltDistance  = 34
        );

        LinearRailHolderSHF( profile );
        kvEchoAligned( profile );
        
        translate([0,40,0])
            LinearRailHolderSHF( profileAuto );
        
        translate([0,-40,-3])
        linear_extrude(3)
        difference() {
            square([70,25],center=true);
            LinearRailHolderSHFPanelHole( profile );
        }
    }

    module LinearRailHolderSK_Demo() {
        profileAuto = LinearRailHolderSKProfile(
            model         = "SK8-auto",
            shaftDiameter = 8,
            shaftHeight   = 20,
            boltDistance  = 32
        );
        profile = LinearRailHolderSKProfile(
            model = "SK8",
            shaftDiameter = 8,
            shaftHeight   = 20, // floor to shaft center
            boltDiameter  = 5, 
            boltDistance  = 32,
            width         = 18,
            height        = 33, // overall height
            thickness     = 15,
            baseWidth     = 41,
            baseHeight    = 5,
            slit          = 1
        );
        
        LinearRailHolderSKProfile( profile );
        kvEchoAligned( profile );
        
        translate([0,40,0])
            LinearRailHolderSKProfile( profileAuto );
        
        translate([0,-40,-3])
        linear_extrude(3)
        difference() {
            square([70,25],center=true);
            LinearRailHolderSKPanelHole( profile );
        }
        
        shaftHeight = kvGet(profile, "shaft.height" );
        color("green")
        translate([0,20,shaftHeight])
        rotate([90,0,0])
            cylinder(100,d=8,center=true);
    }
    
//
// HOLDER SHF
//

    function LinearRailHolderSHFProfile(
        model = "",
        shaftDiameter,
        boltDiameter       = 5,
        boltDistance,               // bolt to bolt distance
        thickness          = 10,
        width              = undef, // overall width
        centerRingDiameter = undef, // diameter of ring around shaft
        baseHeight         = undef, // shaft center to base bottom
        baseWidth          = undef,
        slit               = 1      // clamp slit width on base
    ) = let (
        e1=ErrorIf( shaftDiameter==undef, "shaft diameter missing" ),
        e2=ErrorIf( boltDistance ==undef, "bolt distance missing"  ),
        eWidth      = SELECT( width     , boltDistance+boltDiameter*1.5 ),
        eRD         = SELECT( centerRingDiameter, shaftDiameter*1.6 ),
        eBaseHeight = SELECT( baseHeight, shaftDiameter*2 ),
        eBaseWidth  = SELECT( baseWidth , shaftDiameter*2.5 )
    ) KVTree([
        "type"         , "linear rail holder SHF",
        "model"        , model,
        "shaftDiameter", shaftDiameter,
        "bolt"         , KVTree([ "diameter", boltDiameter, "distance", boltDistance ]),
        "body"         , KVTree([ "width", eWidth, "ringDiameter", eRD, "thickness", thickness ]),
        "base"         , KVTree([ "width", eBaseWidth, "height", eBaseHeight, "slit", slit ])
    ]);

    module LinearRailHolderSHF( profile ) {
        t = kvSearch(profile,"type");
        e1=ErrorIf( t!="linear rail holder SHF", "LinearRailHolderSHF(): invalid profile" );
        go();
        module go() {
            shaftDiameter = kvGet(profile, "shaftDiameter" );
            boltDiameter  = kvGet(profile, "bolt.diameter" );
            boltToBolt    = kvGet(profile, "bolt.distance" );
            body = kvGet(profile,"body");
            width        = kvGet(body, "width"        );
            ringDiameter = kvGet(body, "ringDiameter" );
            thickness    = kvGet(body, "thickness"    );
            base = kvGet(profile,"base");            
            baseWidth    = kvGet(base, "width"  );
            baseHeight   = kvGet(base, "height" );
            slitWidth    = kvGet(base, "slit"   );
            sideDiameters = width - boltToBolt;
            linear_extrude(thickness)
            difference() {
                union() {
                    hull() {
                        translate([-boltToBolt/2,0,0])
                            circle(d=sideDiameters);
                        translate([boltToBolt/2,0,0])
                            circle(d=sideDiameters);
                        circle(d=ringDiameter);
                    }
                    translate([0,-baseHeight/2])
                        square([baseWidth,baseHeight],center=true);
                }
                union() {
                    translate([-boltToBolt/2,0,0])
                        circle(d=boltDiameter);
                    translate([boltToBolt/2,0,0])
                        circle(d=boltDiameter);
                    circle(d=shaftDiameter);
                    translate([0,-baseHeight/2])
                        square([slitWidth,baseHeight],center=true);        
                }
            }
        }
    }

    module LinearRailHolderSHFPanelHole( profile, omitCenterHole=true, enlargeShaft=1, enlargeBolt=1 ) {
        t = kvSearch(profile,"type");
        e1=ErrorIf( t!="linear rail holder SHF", "LinearRailHolderSHFPanelHole(): invalid profile" );
        go();
        module go() {
            shaftDiameter = kvGet(profile, "shaftDiameter" );
            boltDiameter  = kvGet(profile, "bolt.diameter" );
            boltToBolt    = kvGet(profile, "bolt.distance" );
            b2b2          = boltToBolt/2;
            if ( !omitCenterHole )
                circle( d=shaftDiameter+enlargeShaft );
            translate( [ b2b2,0,0] ) circle( d=boltDiameter+enlargeBolt );
            translate( [-b2b2,0,0] ) circle( d=boltDiameter+enlargeBolt );
        }
    }
    
    /*
    boltDistance=34;
    boltDiameter=5;
    shaftDiameter=8;
    centerDiameter=18;
    sideDiameter=9;
    baseHeight=14;
    baseWidth=20;
    slitWidth=1;

    difference() {
        union() {
            hull() {
                translate([-boltDistance/2,0,0])
                    circle(d=sideDiameter);
                translate([boltDistance/2,0,0])
                    circle(d=sideDiameter);
                circle(d=centerDiameter);
            }
            translate([0,-baseHeight/2])
                square([baseWidth,baseHeight],center=true);
        }
        union() {
            translate([-boltDistance/2,0,0])
                circle(d=boltDiameter);
            translate([boltDistance/2,0,0])
                circle(d=boltDiameter);
            circle(d=shaftDiameter);
            translate([0,-baseHeight/2])
                square([slitWidth,baseHeight],center=true);        
        }
    }
    */

//
// HOLDER SK
//

    function LinearRailHolderSKProfile(
        model = "",
        shaftDiameter,
        shaftHeight,          // floor to shaft center
        boltDiameter = 5,        
        boltDistance,         // bolt to bolt distance
        thickness    = 10,
        width        = undef, // width of shaft holder
        height       = undef, // overall height
        baseWidth    = undef,
        baseHeight   = 8,
        slit         = 1
    ) = let (
        e1=ErrorIf( shaftDiameter==undef, "shaft diameter missing" ),
        e2=ErrorIf( shaftHeight  ==undef, "shaft height missing"   ),
        e3=ErrorIf( boltDistance ==undef, "bolt distance missing"  ),
        
        eWidth      = SELECT( width     , shaftDiameter*2 ),
        eHeight     = SELECT( height    , shaftHeight+boltDiameter*2 ),
        eBaseWidth  = SELECT( baseWidth , boltDistance+boltDiameter*2 ),
        eBaseHeight = SELECT( baseHeight, shaftDiameter*2 )
    ) KVTree([
        "type"         , "linear rail holder SK",
        "model"        , model,
        "shaft"        , KVTree([ "diameter", shaftDiameter, "height", shaftHeight ]),
        "bolt"         , KVTree([ "diameter", boltDiameter, "distance", boltDistance ]),
        "body"         , KVTree([ "width", eWidth, "height", eHeight, "thickness", thickness, "slit", slit ]),
        "base"         , KVTree([ "width", eBaseWidth, "height", eBaseHeight ])
    ]);

    module LinearRailHolderSKProfile( profile ) {
        t = kvSearch(profile,"type");
        e1=ErrorIf( t!="linear rail holder SK", "LinearRailHolderSKProfile(): invalid profile" );
        go();
        module go() {
            shaftDiameter = kvGet(profile, "shaft.diameter" );
            shaftHeight   = kvGet(profile, "shaft.height" );
            boltDiameter  = kvGet(profile, "bolt.diameter" );
            boltToBolt    = kvGet(profile, "bolt.distance" );
            body = kvGet(profile,"body");
            width     = kvGet(body, "width"     );
            height    = kvGet(body, "height"    );
            thickness = kvGet(body, "thickness" );
            slitWidth = kvGet(body, "slit"      );
            base = kvGet(profile,"base");
            baseWidth  = kvGet(base, "width"  );
            baseHeight = kvGet(base, "height" );
            
            rotate([90,0,0])
            linear_extrude(thickness,center=true)
            difference() 
            {
                translate([-width/2,0,0])
                    square([width,height]);
                union() {
                    translate([0,shaftHeight,0])
                        circle(d=shaftDiameter);
                    slitHeight=height-shaftHeight;
                    translate([-slitWidth/2,height-slitHeight,0])
                        square([slitWidth,slitHeight+1]);
                }
            }
            linear_extrude(baseHeight)
            difference() {
                square([baseWidth,thickness],center=true);
                union() {
                    translate([-boltToBolt/2,0,0])
                        circle(d=boltDiameter);
                    translate([boltToBolt/2,0,0])
                        circle(d=boltDiameter);
                }
            }
        }
    }

    module LinearRailHolderSKPanelHole( profile, enlargeBolt=1 ) {
        t = kvSearch(profile,"type");
        e1=ErrorIf( t!="linear rail holder SK", "LinearRailHolderSKPanelHole(): invalid profile" );
        go();
        module go() {
            boltDiameter  = kvGet(profile, "bolt.diameter" );
            boltToBolt    = kvGet(profile, "bolt.distance" );
            b2b2          = boltToBolt/2;
            translate( [ b2b2,0,0] ) circle( d=boltDiameter+enlargeBolt );
            translate( [-b2b2,0,0] ) circle( d=boltDiameter+enlargeBolt );
        }
    }
    
    /*
    boltDistance=32;
    boltDiameter=5;

    shaftDiameter=8;
    shaftHeight=20;

    width=18;
    height=33;
    thickness=15;

    baseWidth=41;
    baseHeight=5;
    slit=1;

    rotate([90,0,0])
    linear_extrude(thickness,center=true)
    difference() 
    {
        translate([-width/2,0,0])
            square([width,height]);
        union() {
            translate([0,shaftHeight,0])
                circle(d=shaftDiameter);
            slitHeight=height-shaftHeight;
            translate([-slit/2,height-slitHeight,0])
                square([slit,slitHeight+1]);
        }
    }
    linear_extrude(baseHeight)
    difference() {
        square([baseWidth,thickness],center=true);
        union() {
            translate([-boltDistance/2,0,0])
                circle(d=boltDiameter);
            translate([boltDistance/2,0,0])
                circle(d=boltDiameter);
        }
    }
    */


