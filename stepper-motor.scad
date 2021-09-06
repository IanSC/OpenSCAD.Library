//
// STEPPER MOTORS
// by ISC 2021
//
// accurate by measurement for product design
// for rough visual representation only
//
//     profile = StepperMotorProfile( ... ) - create profile
//     StepperMotor( profile )              - draw 3D
//     StepperMotorPanelHole( profile )     - draw 2D panel holes

include <key-value.scad>
include <utility.scad>

//
// DEMO
//

    // run me!!!
    //StepperMotor_Demo();

    module StepperMotor_Demo() {
        
        profile1 = StepperMotorProfile( nemaModel="NEMA17" );
        generateMotorAndPanel( profile1 );
        
        // custom size
        // https://www.sparkfun.com/products/13656 ==> Wantai 57BYGH420-2
        // https://www.openimpulse.com/blog/wp-content/uploads/wpsc/downloadables/57BYGH420-Stepper-Motor-Datasheet.pdf
        profile2 = StepperMotorProfile(
            model              = "Wantai 57BYGH420-2",
            bodyDiameter       = 56.4,
            bodyLength         = 56,
            shaftDiameter      = 6.35,
            shaftLength        = 21-1.6,
            boltDiameter       = 5,
            boltLength         = 10,
            boltToBoltDistance = 47.14,
            frontCylinder      = [38.1,1.6], // diameter,height
            flangeThickness    = [4.8,0],    // top, bottom
            bodyTaper          = 1 );
        translate( [100,0,0] )
            generateMotorAndPanel( profile2 );
        kvEcho( profile2 );
        
        // with gear, bolts on gear
        profile3 = StepperMotorProfile(
            nemaModel          = "NEMA23",
            boltToBoltDistance = 20,
            frontCylinder      = [40,20]
        );
        translate( [200,0,0] )
            generateMotorAndPanel( profile3 );
            
        // with gear, bolts on body, back cylinder and shaft
        // bigger panel hole
        profile4 = StepperMotorProfile(
            nemaModel          = "NEMA23",
            boltDiameter       = 8,
            boltLength         = 25+8,    // go below frontCylinderLength
            boltToBoltDistance = 38,
            frontCylinder      = [40,25],
            backCylinder       = [40,20],
            panelHoleDiameter  = 40+2,    // larger than frontCylinderDiameter
            backShaftLength    = 20 );
        // position to upper flange
        translate( [300,0,0] ) {
            translate( [0,0, kvGet(profile4,"length.frontCylinder")] )
                StepperMotor( profile4 );
            translate( [0,-100,0] )
                generatePanel( profile4 );
        }
        
        // position to lower shaft
        translate( [400,0,0] ) {
            translate( [0,0,kvGet(profile3,"length.body")] )
                StepperMotor( profile3 );
        }
        
        // position to bottom of body, excluding lower cylinder
        translate( [500,0,0] ) {
            translate( [0,0,kvGet(profile4,"length.body")-kvGet(profile4,"length.backCylinder")] )
                StepperMotor( profile4 );
        }
        
        module generateMotorAndPanel( profile ) {
            StepperMotor( profile );
            translate( [0,-100,0] )
                generatePanel( profile );            
        }
        module generatePanel( profile ) {
            linear_extrude( 3 )
            difference() {
                square( [60,60], center=true );
                StepperMotorPanelHole( profile );
            }
        }
    }

//
// NEMA
//

    // to use: specify nemaModel while building the motor profile and defaults will be used
    // profile = StepperMotorProfile( nemaModel="NEMA23", bodyLength=50 );

    function NemaFrameProfile(
        model,
        boltDistance,    // bolt to bolt distance
        defBodyDiameter,
        defBodyLength,
        defShaftDiameter,
        defShaftLength,
        defBoltDiameter
    ) = KeyValue([
        "model"        , model,
        "boltDistance" , boltDistance,
        "bodyDiameter" , defBodyDiameter, 
        "bodyLength"   , defBodyLength, 
        "shaftDiameter", defShaftDiameter,
        "shaftLength"  , defShaftLength,
        "boltDiameter" , defBoltDiameter
    ]);

    // as far as i know, nema defines the motor size and mount only
    //    eg. bigger motors with gears need bigger bolts, bigger shafts, longer, etc.
    //        but uses a standard mount
    //    https://www.zikodrive.com/ufaqs/nema-motor-frame-sizes-mean/
    //    https://blog.oyostepper.com/2018/04/21/nema-motor-frame-sizes-and-what-they-mean/
    // but without defaults it will be difficult to use the library
    //    so some sensible defaults are assumed, which were based on:
    // https://www.sanyodenki.com/archive/document/product/servo/catalog_E_pdf/SANMOTION_F2_E.pdf#page=1
    // NEMA8=?, NEMA11=28mm, NAME14=35mm, NEMA16=40, NEMA17=42, NEMA23=56mm?, NEMA24=60mm, NEMA34=86mm, NEMA42=106mm

    NemaFrameSizes = KeyValue( [
        "NEMA8",  NemaFrameProfile( model="NEMA8" , boltDistance=16   , defBodyDiameter=0.8*25.4, defBodyLength=0.8*25.4, defShaftDiameter= 4   , defShaftLength=10, defBoltDiameter=2.5 ),        
        "NEMA11", NemaFrameProfile( model="NEMA11", boltDistance=23   , defBodyDiameter=1.1*25.4, defBodyLength=1.1*25.4, defShaftDiameter= 5   , defShaftLength=10, defBoltDiameter=2.5 ),
        "NEMA14", NemaFrameProfile( model="NEMA14", boltDistance=26   , defBodyDiameter=1.4*25.4, defBodyLength=1.4*25.4, defShaftDiameter= 5   , defShaftLength=20, defBoltDiameter=3   ),
        "NEMA16", NemaFrameProfile( model="NEMA16", boltDistance=31   , defBodyDiameter=1.6*25.4, defBodyLength=1.6*25.4, defShaftDiameter= 5   , defShaftLength=24, defBoltDiameter=3   ),
        "NEMA17", NemaFrameProfile( model="NEMA17", boltDistance=31   , defBodyDiameter=1.7*25.4, defBodyLength=1.7*25.4, defShaftDiameter= 5   , defShaftLength=24, defBoltDiameter=3   ),
        "NEMA23", NemaFrameProfile( model="NEMA23", boltDistance=47.14, defBodyDiameter=2.3*25.4, defBodyLength=2.3*25.4, defShaftDiameter= 6.35, defShaftLength=20, defBoltDiameter=4   ),
        "NEMA24", NemaFrameProfile( model="NEMA24", boltDistance=47.14, defBodyDiameter=2.4*25.4, defBodyLength=2.4*25.4, defShaftDiameter= 6.35, defShaftLength=20, defBoltDiameter=4   ),
        "NEMA34", NemaFrameProfile( model="NEMA34", boltDistance=69.6 , defBodyDiameter=3.4*25.4, defBodyLength=3.4*25.4, defShaftDiameter=14   , defShaftLength=30, defBoltDiameter=4   ),
        "NEMA42", NemaFrameProfile( model="NEMA42", boltDistance=88.9 , defBodyDiameter=4.2*25.4, defBodyLength=4.2*25.4, defShaftDiameter=16   , defShaftLength=35, defBoltDiameter=4   )
    ] );

//
// CORE
//

    function StepperMotorProfile(
        model = "",
        nemaModel = undef,

        bodyDiameter, bodyLength,
        shaftDiameter, shaftLength,

        boltProfile,
        boltDiameter, boltLength,
        boltToBoltDistance,

        frontCylinder, // [ diameter, height ]
        backCylinder,  // [ diameter, height ]

        //frontCylinderDiameter = 0, frontCylinderLength = 0,
        //backCylinderDiameter  = 0, backCylinderLength  = 0,
        flangeThickness, // [ upper flange, lower flange ]
        //frontFlangeLength = undef, backFlangeLength = undef, 
        bodyTaper,     // taper between flanges
        overallTaper,  // taper on flanges and body
        backShaftLength = 0,
        panelHoleDiameter
    ) = let(

        sel = function( d1, d2, d3 ) ((d1!=undef) ? d1 : (d2!=undef) ? d2 : d3 ),
        //iif = function( cond, trueCond, falseCond ) ( cond ? trueCond : falseCond ),
    
        nemaData = ( nemaModel==undef || nemaModel=="" ? undef : kvSearch( NemaFrameSizes, nemaModel ) ),
        
        eNemaModel     = sel( nemaModel,          ""                                  ),
        eBodyDiameter  = sel( bodyDiameter,       kvSearchLax(nemaData,"bodyDiameter" ) ),
        eBodyLength    = sel( bodyLength,         kvSearchLax(nemaData,"bodyLength"   ) ),
        eShaftDiameter = sel( shaftDiameter,      kvSearchLax(nemaData,"shaftDiameter") ),
        eShaftLength   = sel( shaftLength,        kvSearchLax(nemaData,"shaftLength"  ) ),
        eB2BDistance   = sel( boltToBoltDistance, kvSearchLax(nemaData,"boltDistance" ), eBodyDiameter*0.8 ),

        //eBoltDiameter  = sel( boltDiameter,       kvSearchLax(nemaData,"boltDiameter" ), 0 ),
        eBoltDiameter  = sel( boltDiameter, kvSearchLax(boltProfile,"diameter" ), kvSearchLax(nemaData,"boltDiameter" ) ),
        eBoltLength    = sel( boltLength  , kvSearchLax(boltProfile,"length"   ), 5 ),

        frontCylinderDiameter = sel( frontCylinder[0], 0 ), frontCylinderLength = sel( frontCylinder[1], 0 ),
        backCylinderDiameter  = sel( backCylinder [0], 0 ), backCylinderLength  = sel( backCylinder [1], 0 ),

        // if not specified assume shaftDiameter + 2mm
        ePanelHoleDiameter = sel( panelHoleDiameter,  eShaftDiameter+2 ),

        eOverallTaper = sel( overallTaper, eBodyDiameter*0.05 /* 5% of body */ ),

        // assume flange to be 25% of body if not specified
        eFrontFlangeLength = (flangeThickness==undef)?eBodyLength*0.25:flangeThickness[0],
        eBackFlangeLength  = (flangeThickness==undef)?eBodyLength*0.25:flangeThickness[1],

        //eFrontFlangeLength = sel( frontFlangeLength, IIF(backFlangeLength ==undef,eBodyLength*0.25,0) ),
        //eBackFlangeLength  = sel( backFlangeLength,  IIF(frontFlangeLength==undef,eBodyLength*0.25,0) ),

        // assume body taper if has flanges 
        eBodyTaper = sel( bodyTaper, 
            IIF( eFrontFlangeLength==0 && eBackFlangeLength==0,
                0,
                min( eBodyDiameter*0.2, eBodyDiameter - eB2BDistance )
            ) ),
//        eBodyTaper = sel( bodyTaper, 
//            IIF( eFrontFlangeLength==0 && eBackFlangeLength==0,
//                0,
//                min( eBodyDiameter*0.2, eBodyDiameter - eB2BDistance )
//            ) ),
            
        e1=ErrorIf( nemaModel!=undef && nemaData==undef, "NEMA model not found" ),
        e2=ErrorIf( eBodyLength-eFrontFlangeLength-eBackFlangeLength<=0, "flanges too thick" )
        
    ) KeyValue([
        "type"             , "stepper motor",
        "model"            , model,
        "nema"             , eNemaModel,
        "bodyDiameter"     , eBodyDiameter,
        "length"           , KeyValue([
            "all"          , eShaftLength+frontCylinderLength+eBodyLength+backCylinderLength+backShaftLength,
            "body"         ,              frontCylinderLength+eBodyLength+backCylinderLength                ,
            "bodyOnly"     ,                                  eBodyLength                                   ,
            "frontCylinder",              frontCylinderLength                                               ,
            "backCylinder" ,                                              backCylinderLength                ,
            "shaft"        , eShaftLength                                                                   ,
            "backShaft"    ,                                                                 backShaftLength,
            "frontFlange"  , eFrontFlangeLength,
            "backFlange"   , eBackFlangeLength ]),
        "shaft"            , KeyValue([ "diameter", eShaftDiameter, "length", eShaftLength ]),
        "backShaft"        , KeyValue([ "diameter", eShaftDiameter, "length", backShaftLength ]),
        "bolt"             , KeyValue([ "diameter", eBoltDiameter,  "length", eBoltLength, "distance", eB2BDistance ]),
        "panelHole"        , ePanelHoleDiameter,
        "frontCylinder"    , KeyValue([ "diameter", frontCylinderDiameter, "length", frontCylinderLength ]),
        "backCylinder"     , KeyValue([ "diameter", backCylinderDiameter,  "length", backCylinderLength  ]),
        "taper"            , KeyValue([ "overall",  eOverallTaper, "body", eBodyTaper ])
    ]);

    module StepperMotor( profile ) {
        t = kvSearch(profile,"type");
        ExitIf( t!="stepper motor", "StepperMotor(): invalid profile" );
        go();
        module go() {
            //   -----                            #
            //     ^                              #
            //     |    -----                +----#----+        ---
            //     |      ^                  |         |        frontCylinderLength (optional)
            //     |      |    -----    +----+---------+----+   ---
            //     |      |      ^      |                   |   frontFlangeLength   (optional)
            //     |      |      |      +-------------------+   ---
            //     |      |   bodyOnly    |               |
            //     |      |      |        |               |
            //     |    body     |      +-------------------+   ---
            //     |      |      v      |                   |   backFlangeLength    (optional)
            //    all     |    -----    +----+---------+----+   ---
            //     |      v                  |         |        backCylinderLength  (optional)
            //     |    -----                +----#----+        ---
            //     v                              #
            //   -----                            #

            bodyWidth             = kvGet(profile, "bodyDiameter"           );
            bodyOnlyLength        = kvGet(profile, "length.bodyOnly"        );
            shaftDiameter         = kvGet(profile, "shaft.diameter"         );
            shaftLength           = kvGet(profile, "shaft.length"           );
            boltDiameter          = kvGet(profile, "bolt.diameter"          );
            boltLength            = kvGet(profile, "bolt.length"            );
            boltToBoltDistance    = kvGet(profile, "bolt.distance"          );
            frontCylinderDiameter = kvGet(profile, "frontCylinder.diameter" );
            frontCylinderLength   = kvGet(profile, "frontCylinder.length"   );
            frontFlangeLength     = kvGet(profile, "length.frontFlange"     );
            backFlangeLength      = kvGet(profile, "length.backFlange"      );
            backCylinderDiameter  = kvGet(profile, "backCylinder.diameter"  );
            backCylinderLength    = kvGet(profile, "backCylinder.length"    );
            backShaftDiameter     = kvGet(profile, "backShaft.diameter"     );
            backShaftLength       = kvGet(profile, "backShaft.length"       );

            panelHoleDiameter     = kvGet(profile, "panelHole"              );
            taperOverall          = kvGet(profile, "taper.overall"          );
            taperBody             = kvGet(profile, "taper.body"             );

            betweenFlangeHeight = bodyOnlyLength - frontFlangeLength - backFlangeLength;

            // make body smaller if has upper/lower flange for aesthetics
            // ebodyWidth = ( frontFlangeLength!=0||lowerFlangeHeight!=0 ? 
            //     min( bodyWidth*0.90, bodyWidth-taperOverall*20 )
            //     : bodyWidth );

            ebodyWidth = bodyWidth * 
                ( frontFlangeLength != 0 || lowerFlangeHeight != 0 ? 0.95 : 1 );

            difference() {
                union() {
                    // front shaft
                    if ( shaftLength != 0 )
                        cylinder( shaftLength, d=shaftDiameter );
                    translate( [0,0,-frontCylinderLength] ) {
                        // front cylinder
                        cylinder( frontCylinderLength, d=frontCylinderDiameter );
                        translate( [0,0,-frontFlangeLength] ) {
                            // front flange
                            if ( frontFlangeLength > 0 )
                                linear_extrude( frontFlangeLength )
                                taperedSquare( bodyWidth, taperOverall );
                            // main body
                            translate( [0,0,-betweenFlangeHeight] ) {
                                if ( betweenFlangeHeight > 0 )
                                    linear_extrude( betweenFlangeHeight )
                                    difference() {
                                        taperedSquare( ebodyWidth, taperOverall );
                                        //square( [ebodyWidth,ebodyWidth], center=true );
                                        {
                                            bw2 = ebodyWidth / 2;
                                            translate( [ bw2, bw2,0] ) circle( r=taperBody );
                                            translate( [ bw2,-bw2,0] ) circle( r=taperBody );
                                            translate( [-bw2, bw2,0] ) circle( r=taperBody );
                                            translate( [-bw2,-bw2,0] ) circle( r=taperBody );
                                        }
                                    }
                                translate( [0,0,-backFlangeLength] ) {
                                    // back flange
                                    if ( backFlangeLength > 0 )
                                        linear_extrude( backFlangeLength )
                                        taperedSquare( bodyWidth, taperOverall );
                                    translate( [0,0,-backCylinderLength] ) {
                                        // back cylinder
                                        cylinder( backCylinderLength, d=backCylinderDiameter );
                                        // back shaft
                                        translate( [0,0,-backShaftLength] )
                                            cylinder( backShaftLength, d=backShaftDiameter );
                                    }
                                }
                            }
                        }
                    }
                }
                {
                    // bolt holes
                    b2b2 = boltToBoltDistance/2;
                    translate( [0,0,-boltLength] ) {
                        translate( [ b2b2, b2b2,0] ) cylinder( boltLength+1, d=boltDiameter );
                        translate( [ b2b2,-b2b2,0] ) cylinder( boltLength+1, d=boltDiameter );
                        translate( [-b2b2, b2b2,0] ) cylinder( boltLength+1, d=boltDiameter );
                        translate( [-b2b2,-b2b2,0] ) cylinder( boltLength+1, d=boltDiameter );
                    }
                }
            }
            module taperedSquare( width, taper ) {
                w = width/2;
                polygon([
                    [  w-taper,  w       ], // upper, right
                    [  w      ,  w-taper ],
                    [  w      , -w+taper ], // lower, right
                    [  w-taper, -w       ],
                    [ -w+taper, -w       ], // lower, left
                    [ -w      , -w+taper ],
                    [ -w      ,  w-taper ], // upper, left
                    [ -w+taper,  w       ]
                ]);
            }
        }
    }

    module StepperMotorPanelHole( profile, enlarge=1 ) {
        t = kvSearch(profile,"type");
        ExitIf( t!="stepper motor", "StepperMotorPanelHole(): invalid profile" );
        go();
        module go() {
            boltDiameter       = kvGet(profile, "bolt.diameter" );
            boltToBoltDistance = kvGet(profile, "bolt.distance" );
            panelHoleDiameter  = kvGet(profile, "panelHole"     );

            b2b2 = boltToBoltDistance/2;
            translate( [ b2b2, b2b2,0] ) circle( d=boltDiameter+enlarge );
            translate( [ b2b2,-b2b2,0] ) circle( d=boltDiameter+enlarge );
            translate( [-b2b2, b2b2,0] ) circle( d=boltDiameter+enlarge );
            translate( [-b2b2,-b2b2,0] ) circle( d=boltDiameter+enlarge );
            circle( d=panelHoleDiameter );
        }
    }
