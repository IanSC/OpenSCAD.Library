//
// NUT AND BOLTS
// by ISC 2021
//
// accurate by measurement for product design
// for rough visual representation only
//
//     boltProfile = BoltProfile( ... )  - create profile
//     Bolt( boltProfile )               - draw 3D
//     BoltPanelPanelHole( boltProfile ) - draw 2D panel holes
//
//     nutProfile = NutProfile( ... )    - create profile
//     Nut( nutProfile )                 - draw 3D
//

include <KVTree.scad>
include <utility.scad>

//
// DEMO
//

    // run me!!!
    //NutsAndBolts_Demo();

    module NutsAndBolts_Demo() {
        //$fn=30;
        
        profile = BoltProfile(
            shape         = "hex",  // "hex" | "square" | "round" 
            feature       = "none", // "none" | "minus" | "plus" | "hex"
            shaftDiameter = 5,
            length        = 20,
            headDiameter  = 10,
            headThickness = 3 );
        Bolt( profile );

        translate( [0,-15,0] )
            linear_extrude( 3 )
            difference() {
                square( [10,10], center=true );
                BoltPanelHole( profile );
            }

        translate( [30,0,0] ) {
                                  featureVariation( "hex" );
            translate( [20,0,0] ) featureVariation( "square" );
            translate( [40,0,0] ) featureVariation( "round" );
        }

        translate( [0,-40,0] ) {
            nut1 = NutProfile( shape="hex",    boltDiameter=5, nutDiameter=8, thickness=3 );
            nut2 = NutProfile( shape="square", boltDiameter=5, nutDiameter=8, thickness=3 );
            nut3 = NutProfile( shape="round",  boltDiameter=5, nutDiameter=8, thickness=3 );
                                  Nut( nut1 );
            translate( [10,0,0] ) Nut( nut2 );
            translate( [20,0,0] ) Nut( nut3 );
        }

        module featureVariation( shape ) {
            b1 = BoltProfile( shape=shape, shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
            Bolt( b1 );
            //generateBoltAndPanel( b1 );
            translate( [0,15,0] ) {
                b2 = BoltProfile( shape=shape, feature="minus", shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
                Bolt( b2 );
                //generateBoltAndPanel( b2 );
            }
            translate( [0,30,0] ) {
                b3 = BoltProfile( shape=shape, feature="plus", shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
                Bolt( b3 );
                //generateBoltAndPanel( b3 );
            }
            translate( [0,45,0] ) {
                b4 = BoltProfile( shape=shape, feature="hex", shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
                Bolt( b4 );
                //generateBoltAndPanel( b4 );
            }
        }
        module generateBoltAndPanel( profile ) {
            Bolt( profile );
            translate( [0,-10,-3] )
                linear_extrude( 3 )
                difference() {
                    square( [10,10], center=true );
                    BoltPanelHole( profile );
                }
        }
    }

//
// BOLT
//

    function BoltProfile(
        model         = "",
        shape         = "hex",  // "hex" | "square" | "round" 
        feature       = "none", // "none" | "minus" | "plus" | "hex"
        shaftDiameter = undef,
        length        = undef,
        headDiameter  = undef,
        headThickness = undef
    ) = let (
        e1=ErrorIf( shape!="hex" && shape!="square" && shape!="round", "invalid shape [hex|square|round]" ),
        e2=ErrorIf( feature!="none" && feature!="minus" && feature!="plus" && feature!="hex", "invalid feature [none|minus|plus|hex]" ),
        e3=ErrorIf( shaftDiameter==undef, "shaft diameter missing" ),
        e4=ErrorIf( length       ==undef, "length missing"         ),
        e5=ErrorIf( headDiameter ==undef, "head diameter missing"  ),
        e6=ErrorIf( headThickness==undef, "head thickness missing" )
    ) KVTree([
        "type"    , "bolt",
        "model"   , model,
        "diameter", shaftDiameter,
        "length"  , length,
        "head"    , KVTree([ "shape", shape, "diameter", headDiameter, "thickness", headThickness, "feature" , feature ])
    ]);

    module Bolt( profile ) {
        t = kvSearch(profile,"type");
        ExitIf( t!="bolt", "Bolt(): invalid profile" );
        go();
        module go() {
            shaftDiameter = kvGet(profile, "diameter"       );
            length        = kvGet(profile, "length"         );
            shape         = kvGet(profile, "head.shape"     );
            feature       = kvGet(profile, "head.feature"   );
            headSize      = kvGet(profile, "head.diameter"  );
            headThickness = kvGet(profile, "head.thickness" );

            difference() {
                if ( shape == "square" )
                    linear_extrude( headThickness )
                    square( [headSize,headSize], center=true );
                else if ( shape == "round" )
                    linear_extrude( headThickness )
                    circle( d=headSize );
                else if ( shape == "hex" )
                    linear_extrude( headThickness )
                    circle( d=headSize/0.866, $fn = 6 ); // sin(60)=0.866
                else
                    echo( "Bolt(): there's literally 3 options dude!");
                translate( [0,0,0.05] )
                if ( feature == "minus" ) {
                    translate( [0,0,headThickness/2] )
                    linear_extrude( headThickness/2 ) {
                        square( [headSize*1.2,headSize*0.2], center=true );
                    }
                } else if ( feature == "plus" ) {
                    translate( [0,0,headThickness/2] )
                    linear_extrude( headThickness/2 ) {
                        square( [headSize*0.8,headSize*0.2], center=true );
                        square( [headSize*0.2,headSize*0.8], center=true );
                    }
                } else if ( feature == "hex" ) {
                    translate( [0,0,headThickness/2] )
                        cylinder( headThickness/2, d=headSize*0.6, $fn=6 );
                }
            }
            translate( [0,0,-length] )
                cylinder( length, d=shaftDiameter );
        }
    }

    module BoltPanelHole( profile, enlarge=1 ) {
        t = kvSearch(profile,"type");
        ExitIf( t!="bolt", "BoltPanelHole(): invalid profile" );
        go();
        module go() {
            shaftDiameter = kvGet(profile, "diameter" );
            circle( d=shaftDiameter+enlarge );
        }
    }

//
// NUT
//

    function NutProfile(
        model        = "",
        shape        = "hex", // "hex", "square", "round"
        boltDiameter = undef,
        nutDiameter  = undef,
        thickness    = undef
    ) = let (
        e1=ErrorIf( shape!="hex" && shape!="square" && shape!="round", "invalid shape [hex|square|round]" ),
        e2=ErrorIf( boltDiameter==undef, "bolt diameter missing" ),
        e3=ErrorIf( nutDiameter ==undef, "nut diameter missing"  ),
        e4=ErrorIf( thickness   ==undef, "thickness missing"     )
    ) KVTree([
        "type"        , "nut",
        "model"       , model,
        "shape"       , shape,
        "boltDiameter", boltDiameter,
        "nutDiameter" , nutDiameter,
        "thickness"   , thickness
    ]);

    module Nut( profile ) {
        t = kvSearch(profile,"type");
        ExitIf( t!="nut", "Nut(): invalid profile" );
        go();
        module go() {
            shape        = kvGet(profile, "shape"        );
            boltDiameter = kvGet(profile, "boltDiameter" );
            nutDiameter  = kvGet(profile, "nutDiameter"  );
            thickness    = kvGet(profile, "thickness"    );
            difference() {
                if ( shape == "hex" )
                    linear_extrude( thickness )
                    circle( d=nutDiameter/0.866, $fn = 6 ); // sin(60)=0.866
                else if ( shape == "square" )
                    linear_extrude( thickness )
                    square( [nutDiameter,nutDiameter], center=true );
                else if ( shape == "round" )
                    linear_extrude( thickness )
                    circle( d=nutDiameter );
                else
                    echo( "Nut(): there's literally 3 options dude!");
                translate( [0,0,-1] )
                    cylinder( thickness+2, d=boltDiameter );
            }
        }
    }
