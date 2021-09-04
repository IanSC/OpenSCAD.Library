// Parametric Pulley with multiple belt profiles
// by droftarts January 2012 - https://www.thingiverse.com/thing:16627
// by ISC August 2021

// Based on pulleys by:
// http://www.thingiverse.com/thing:11256 by me!
// https://github.com/prusajr/PrusaMendel by Josef Prusa
// http://www.thingiverse.com/thing:3104 by GilesBathgate
// http://www.thingiverse.com/thing:2079 by nophead

// dxf tooth data from http://oem.cadregister.com/asp/PPOW_Entry.asp?company=915217&elementID=07807803/METRIC/URETH/WV0025/F
// pulley diameter checked and modelled from data at http://www.sdp-si.com/D265/HTML/D265T016.html

//     profile = PulleyProfile( ... )                          - create profile
//     Pulley( profile )                                       - draw 3D
//     PulleyConnected( ... )                                  - draw 2 connected pulleys
//     PulleyDiameter( profile, toothCount )                   - calculate outside diameter
//     PulleyCenterDistance( p1, p2, beltLength )              - calculate center distance between pulleys given length of belt
//     PulleyCenterDistanceByModel( "T5", 60, "T5", 20, belt )      - ...

include <key-value.scad>
include <utility.scad>

//
// TEST
//

    // run me!!!
    //Pulley_Demo();
    //PulleyCompareDiameter_Test();

    module Pulley_Demo() {

        profile1 = PulleyProfile(
        
            toothModel       = "GT2 2mm",
            toothCount       = 60,
            beltWidth        = 12,
            shaftDiameter    = 6,
        
            topFlangeInfo    = [ 3,     // offset from computed notched cylinder
                                 1,     // tapered height
                                 2      // flat height
                               ],
                               
            bottomFlangeInfo = [ 3, 
                                 1, 
                                 2
                               ],
                               
            hubInfo          = [ 20,    // diameter
                                 15     // height
                               ],
                               
            nutInfo          = [ "hex", // hex or square
                                 3.2,   // bolt diameter
                                 5.7,   // nut diameter
                                 2.7    // thickness
                               ],
                               
            captiveNutsInfo  = [ 3,     // number of nuts
                                 120,   // angle between nuts
                                 1.2    // offset from shaft (NOT offset from center)
                               ],
                               
            toothWidthTweak  = 0,       // adjustments on teeth for 3D printing
            toothDepthTweak  = 0
            );
           
        translate( [0,0,0] )
            Pulley( profile1, omitTeeth=true );
        
        // detailed but slow
        translate( [100,0,0] )
            Pulley( profile1, for3DPrinting=true, autoFlip=true );

        //
        // HOW IT WAS BUILT - internally uses KeyValue
        //

        translate( [200,0,0] ) {

            nutKV = KeyValue([ "shape", "hex", "boltDiameter", 3.2, "nutDiameter", 5.7, "thickness", 2.7 ]);
            captiveNutsKV = KeyValue([ "count", 2, "angleBetweenNuts", 90, "offsetFromShaft", 1.2 ]);
            pulleyHubCaptiveNuts( 
                nutKV             = nutKV,
                captiveNutsKV     = captiveNutsKV,
                shaftDiameter     = 6,
                nutInsertionDepth = 7.5, // how deep are nuts inserted, half of hub height
                boltLength        = 10   // half of hub diameter
                );
            
            translate( [0,0,15] )
            pulleyHub(
                20,                       // diameter
                15,                       // height
                notchedCylinderDiameter+3 // upper section , smaller so with taper
            );
            
            notchedCylinderDiameter = PulleyDiameter( "GT2 2mm", 20 );
            
            flangeInfoKV = KeyValue([ "offset", 3, "taperHeight", 2, "flatHeight", 3 ]);
            translate( [0,0,40] )
            pulleyBottomFlange(
                notchedCylinderDiameter, // notchCylinder diameter, will offset from this
                flangeInfoKV );
                
            translate( [0,0,55] )
                PulleyNotchedCylinder( toothModel="GT2 2mm", toothCount=20, height=10, shaftDiameter=0 );

            translate( [0,0,75] )
            pulleyTopFlange(
                notchedCylinderDiameter, // notchCylinder diameter, will offset from this
                flangeInfoKV );

        }
            
        //
        // CONNECTED PULLEYS
        //
        
        profile2 = PulleyProfile(
            toothModel="GT2 2mm",
            toothCount=16, beltWidth=12,
            shaftDiameter=6,
            topFlangeInfo=[3,1,2], bottomFlangeInfo=[3,1,2],      
            hubInfo=[20,15] );
        
        translate( [300,0,0] ) {
            PulleyConnected( profile1, profile2, beltLength=200, beltWidth=10, reverseDrivenPulley=true );
            
            s1 = kvGet(profile1,"shaftDiameter" );
            cylinder( 150, d=s1, center=true );
            
            s2 = kvGet(profile2,"shaftDiameter" );
            center2center = PulleyCenterDistance( profile1, profile2, beltLength=200 );
            translate( [center2center,0,0] )
                cylinder( 150, d=s2, center=true );
        }
    }

    module PulleyCompareDiameter_Test() {
        // compare 3D calculated face
        // vs chart data for difference
        // this will affect distance calculations
        // given belt length
        toothCount = 100;
        for( model = pulleyModelsFor3DP ) {
            a = PulleyDiameter( model, toothCount );
            b = pulleyToothData( model, toothCount )[0];
            p = abs( (a-b)/a )*100;
            if ( p > 1 ) {
                echo( str( model, " diff by ", p ) );
                echo( str( "   from datasheets = ", a ) );
                echo( str( "   from model = ", b ) );
            } else {
                echo( str( model, "=", p, "%" ) );
            }
        }
    }

//
// HELPERS
//

    // available models for 3D printing
    pulleyModelsFor3DP = [
        "MXL", "40DP", "XL", "L", 
        "T2.5", "T5", "T10", 
        "AT5",
        "HTD 3mm", "HTD 5mm", "HTD 8mm",
        "GT2 2mm", "GT2 3mm", "GT2 5mm" ];
    
    // available models for mechanical display only
    pulleyModelsForDisplay = [
        "MXL", "40DP", "XL", "L", "H",
        "T2.5", "T5", "T10", 
        "AT5", "AT10",
        "HTD 3mm", "HTD 5mm", "HTD 8mm", "HTD 14mm",
        "GT2 2mm", "GT2 3mm", "GT2 5mm" ];

//
// CONNECTED PULLEYS
//

    module PulleyConnected( motorPulleyProfile, drivenPulleyProfile, beltLength, beltWidth, reverseDrivenPulley=false, omitTeeth=false ) {
        
        // if not specified use smaller one on pulleys
        eBeltWidth = (beltWidth==undef?
            min(kvGet(motorPulleyProfile,"beltWidth"),kvGet(drivenPulleyProfile,"beltWidth"))
            :beltWidth);
        motorCenter = kvGet(motorPulleyProfile, "height.beltCenter");
        drivenCenter = kvGet(drivenPulleyProfile, "height.beltCenter");

        motorModel  = kvGet(motorPulleyProfile ,"toothModel"); motorToothCount  = kvGet(motorPulleyProfile, "toothCount");
        drivenModel = kvGet(drivenPulleyProfile,"toothModel"); drivenToothCount = kvGet(drivenPulleyProfile,"toothCount");     
        c2c = PulleyCenterDistanceByModel( motorModel, motorToothCount, drivenModel, drivenToothCount, beltLength );
        ExitIf( is_nan(c2c), "center to center distance error, belt too short?" );
        
        r = reverseDrivenPulley?[180,0,0]:[0,0,0];

        motorDiameter  = PulleyDiameter(motorModel, motorToothCount );
        drivenDiameter = PulleyDiameter(drivenModel,drivenToothCount);
        
        Pulley( motorPulleyProfile, omitTeeth=omitTeeth );
        
        translate( [c2c,0,motorCenter])
        rotate( r )
        translate( [0,0,-drivenCenter])
        Pulley( drivenPulleyProfile, omitTeeth=omitTeeth );
                
        beltThickness=2;
        translate([0,0,motorCenter-eBeltWidth/2])
        linear_extrude( eBeltWidth )
            difference() {
                hull() {
                    circle(d=motorDiameter+beltThickness*2);
                    translate( [c2c,0,0])
                        circle(d=drivenDiameter+beltThickness*2);
                }
                hull() {
                    circle(d=motorDiameter);
                    translate( [c2c,0,0])
                        circle(d=drivenDiameter);
                }
            }
    }

//
// DISTANCE BETWEEN PULLEYS
//

    function PulleyCenterDistance( motorPulleyProfile, drivenPulleyProfile, beltLength ) =
        PulleyCenterDistanceByModel(
            kvGet(motorPulleyProfile ,"toothModel"), kvGet(motorPulleyProfile, "toothCount"),
            kvGet(drivenPulleyProfile,"toothModel"), kvGet(drivenPulleyProfile,"toothCount"),
            beltLength );

    function PulleyCenterDistanceByModel( toothModel1, toothCoun1, toothModel2, toothCoun2, beltLength ) =
        let(
            diameter1 = PulleyDiameter( toothModel1, toothCoun1 ),
            diameter2 = PulleyDiameter( toothModel2, toothCoun2 )
        )
        CenterToCenterDistanceCore( diameter1, diameter2, beltLength );
        
    function CenterToCenterDistanceCore( diameter1, diameter2, beltLength ) =
        // https://www.sudenga.com/practical-applications/figuring-belt-lengths-and-distance-between-pulleys
        let(
            sum  = diameter1 + diameter2,
            diff = diameter1 - diameter2,
            b    = 4*beltLength - 6.28*sum
        )
        ( b + sqrt( b*b - 32*diff*diff ) ) / 16;

//
// PULLEY PROFILE
//

    function PulleyProfile(
        //
        //   +-----------------------+   ---            ---
        //   |                       |   flatHeight
        //   +-----------------------+   ---            topFlange
        //    \                     /    taperedHeight
        //     \-------------------/     ---            ---
        //      |||||||||||||||||||
        //      |||||||||||||||||||      beltWidth      notchedCylinder   
        //      |||||||||||||||||||
        //     /-------------------\     ---            ---
        //    /                     \    taperedHeight
        //   +-----------------------+   ---            bottomFlange
        //   |                       |   flatHeight
        //   +-------+-------+-------+   ---            ---
        //           |       |           hubHeight      hub
        //           +-------+           ---            ---
        //                     -->|  |<- flange offset
        //
        model,                 // user defined name
        toothModel,            // "T5", "GT2 2mm"...
        toothCount,
        beltWidth,
        shaftDiameter,
        topFlangeInfo,         // [ offset, taperedHeight, flatHeight ], note: [ .. ] is a list
        bottomFlangeInfo,      // [ offset, taperedHeight, flatHeight ]
        hubInfo,               // [ diameter, height ]
        nutInfo,               // [ "hex" or "square", boltDiameter, nutDiameter, thickness ]
        captiveNutsInfo,       // [ nutCount, angleBetweenNuts, offsetFromShaft ]
                               // nutCount         - usually 2 for guys :)
                               // angleBetweenNuts - angle of nuts around the base, eg. 3 nuts, 120 degrees for equal spacing
                               // nutInfo and captiveNutsInfo are for embedding nuts during 3D printing for securing to shaft
        toothWidthTweak = 0.2, // adjustments on teeth for 3D printing
        toothDepthTweak = 0    //    see notes in pulleyNotchedCylinderCore()
    ) = let(
        e1=ErrorIf( toothModel      ==undef, "tooth model missing"    ),
        e2=ErrorIf( toothCount      ==undef, "tooth count missing"    ),
        e3=ErrorIf( beltWidth       ==undef, "belt width missing"     ),
        e4=ErrorIf( shaftDiameter   ==undef, "shaft diameter missing" ),
        e5=ErrorIf( topFlangeInfo   !=undef && len(topFlangeInfo)   !=3, "topFlangeInfo error, expected [offset,taperHeight,flatHeight]" ),
        e6=ErrorIf( bottomFlangeInfo!=undef && len(bottomFlangeInfo)!=3, "bottomFlangeInfo error, expected [offset,taperHeight,flatHeight]" ),
        e7=ErrorIf( hubInfo         !=undef && len(hubInfo)         !=2, "hubInfo error, expected [diameter,height]" ),
        e8=ErrorIf( nutInfo         !=undef && len(nutInfo)         !=4, "nutInfo error, expected [hex|square,boltDiameter,nutDiameter,thickness]" ),
        e9=ErrorIf( captiveNutsInfo !=undef && len(captiveNutsInfo) !=3, "captiveNutsInfo error, expected [nutCount,angleBetweenNuts,offsetFromShaft]" ),

        eTopFlangeHeight    = SELECT( topFlangeInfo   [1]+topFlangeInfo   [2], 0 ),
        eBottomFlangeHeight = SELECT( bottomFlangeInfo[1]+bottomFlangeInfo[2], 0 ),
        eHubHeight          = SELECT( hubInfo[1]                             , 0 ),
        
        eTopFlange = topFlangeInfo==undef?undef:
            KeyValue([ "offset", topFlangeInfo[0], "height", eTopFlangeHeight, "taperHeight", topFlangeInfo[1], "flatHeight", topFlangeInfo[2]    ]),

        eBottomFlangeInfo = bottomFlangeInfo==undef?undef:
            KeyValue([ "offset", bottomFlangeInfo[0], "height", eBottomFlangeHeight, "taperHeight", bottomFlangeInfo[1], "flatHeight", bottomFlangeInfo[2] ]),

        eHub = hubInfo==undef?undef:
            KeyValue([ "diameter", hubInfo[0], "height", hubInfo[1] ]),

        eNut = nutInfo==undef?undef:
            KeyValue([ "shape", nutInfo[0], "boltDiameter", nutInfo[1], "nutDiameter", nutInfo[2], "thickness", nutInfo[3] ]),

        eCaptiveNuts = captiveNutsInfo==undef?undef:
            KeyValue([ "count", captiveNutsInfo[0], "angleBetweenNuts", captiveNutsInfo[1], "offsetFromShaft", captiveNutsInfo[2] ])

    ) KeyValue([
        "type"         , "timing pulley",
        "model"        , model,
        "toothModel"   , toothModel,
        "toothCount"   , toothCount,
        "beltWidth"    , beltWidth,
        "shaftDiameter", shaftDiameter,
        "height"       , KeyValue([ "total"       , beltWidth+eTopFlangeHeight+eBottomFlangeHeight+eHubHeight,
                                    "beltCenter"  , beltWidth/2               +eBottomFlangeHeight+eHubHeight,
                                    "belt"        , beltWidth                                                ,
                                    "topFlange"   ,           eTopFlangeHeight                               ,
                                    "bottomFlange",                            eBottomFlangeHeight           ,
                                    "hub"         ,                                                eHubHeight
                                  ]),
        "topFlange"    , eTopFlange,
        "bottomFlange" , eBottomFlangeInfo,
        "hub"          , eHub,
        "nut"          , eNut,
        "captiveNuts"  , eCaptiveNuts,
        // tweaks for 3D printing are kept also, for different values for each pulley configuration
        "tweak"        , KeyValue([ "toothWidth", toothWidthTweak, "toothDepth", toothDepthTweak ])
    ]);

//
// COMPUTED PULLEY DIAMETER FROM CHARTS
//

    function PulleyDiameter( model, toothCount ) =
        ( model == "MXL" ) ? (
            // https://www.pfeiferindustries.com/timing-belt-pulley-pitch-diameter-outside-diameter-charts
            // https://www.pfeiferindustries.com/documents/Engineering/Timing%20Belt%20Pulley%20PD%20and%20OD/(0.080%20MXL)%20Timing%20Belt%20Pulley%20PD%20and%20OD.pdf
            toothCount * 2.750 / 108 * 25.4 // inch to mm
        ) : ( model == "40DP" ) ? (
            // https://www.pfeiferindustries.com/documents/Engineering/Timing%20Belt%20Pulley%20PD%20and%20OD/(0.0817%2040%20DP)%20Timing%20Belt%20Pulley%20PD%20and%20OD.pdf
            toothCount * 2.600 / 100 * 25.4 // inch to mm
        ) : ( model == "XL" ) ? (
            // https://www.pfeiferindustries.com/documents/Engineering/Timing%20Belt%20Pulley%20PD%20and%20OD/(0.200%20XL)%20Timing%20Belt%20Pulley%20PD%20and%20OD.pdf
            toothCount * 323.40 / 200
        ) : ( model == "L" ) ? (
            // https://www.pfeiferindustries.com/documents/Engineering/Timing%20Belt%20Pulley%20PD%20and%20OD/(0.375%20L)%20Timing%20Belt%20Pulley%20PD%20and%20OD.pdf
            toothCount * 5.7 / 48 * 25.4 // inch to mm        
        ) : ( model == "H" ) ? (
            // https://www.pfeiferindustries.com/documents/Engineering/Timing%20Belt%20Pulley%20PD%20and%20OD/(0.500%20H)%20Timing%20Belt%20Pulley%20PD%20and%20OD.pdf
            // https://us.misumi-ec.com/vona2/detail/110300405760/
            toothCount * 22.600 / 142 * 25.4 // inch to mm
        ) : ( model == "T2.5" ) ? (
            // https://www.technobotsonline.com/timing-pulley-distance-between-centres-calculator.html
            toothCount * 795774715459476700 / 1000000000000000000 // tooth --> PCD per tooth
        ) : ( model == "T5" ) ? (
            // no data, just use half of T10
            toothCount * 3183098861837907000 / 1000000000000000000 / 2
        ) : ( model == "T10" ) ? (
            toothCount * 3183098861837907000 / 1000000000000000000
        ) : ( model == "AT5" ) ? (
            toothCount * 1591549430918953500 / 1000000000000000000
        ) : ( model == "AT10" ) ? (
            toothCount * 3183098861837907000 / 1000000000000000000
        ) : ( model == "HTD 3mm" ) ? (
            toothCount * 954929658551372000 / 1000000000000000000
        ) : ( model == "HTD 5mm" ) ? (
            toothCount * 1591549430918953500 / 1000000000000000000
        ) : ( model == "HTD 8mm" ) ? (
            toothCount * 2546479089470325000 / 1000000000000000000
        ) : ( model == "HTD 14mm" ) ? (
            toothCount * 4456338406573069300 / 1000000000000000000
        ) : ( model == "GT2 2mm" ) ? (
            toothCount * 636619772367581300 / 1000000000000000000
        ) : ( model == "GT2 3mm" ) ? (
            toothCount * 636619772367581300 / 1000000000000000000 / 2 * 3
        ) : ( model == "GT2 5mm" ) ? (
            toothCount * 636619772367581300 / 1000000000000000000 / 2 * 5
        ) : (
            undef
        );

//
// CYLINDER WITH TOOTH FOR 3D PRINTING
//

    module PulleyNotchedCylinder( toothModel, toothCount, height, shaftDiameter, toothWidthTweak = 0, toothDepthTweak = 0 ) {
        toothData = pulleyToothData( toothModel, toothCount );
        ExitIf( toothData==undef, "tooth model not found" );
        difference() {
            pulleyNotchedCylinderCore( toothData, toothCount, height, toothWidthTweak, toothDepthTweak );
            translate([0,0,-1])
                cylinder( height+2, d=shaftDiameter );
        }
    }
    
    module pulleyNotchedCylinderCore( toothData, toothCount, beltWidth, for3DPrinting=false, toothWidthTweak=0.2, toothDepthTweak=0 ) {

        // ==============================
        //   Scaling Tooth for Good Fit
        // ==============================
        //   To improve fit of belt to pulley, set the following constants.
        //
        //   toothWidthTweak
        //       Decrease or increase by 0.1mm at a time.
        //       We are modelling the *BELT* tooth here, not the tooth on the pulley.
        //       Increasing the number will *decrease* the pulley tooth size.
        //       Increasing the tooth width will also scale proportionately the tooth depth,
        //          to maintain the shape of the tooth,
        //          and increase how far into the pulley the tooth is indented.
        //       Can be negative.
        //       default = 0.2 mm
        //
        //   toothDepthTweak
        //	     If you need more tooth depth than this provides,
        //          adjust this constant.
        //       However, this will cause the shape of the tooth to change.

        pulley_OD   = toothData[0];
        tooth_depth = toothData[1];
        tooth_width = toothData[2];
        polyPoints  = toothData[3];
        
        tooth_distance_from_centre 
            = sqrt( pow( pulley_OD/2, 2 ) - pow( (tooth_width+toothWidthTweak)/2, 2 ) );
        tooth_width_scale = (tooth_width + toothWidthTweak ) / tooth_width;
        tooth_depth_scale = (tooth_depth + toothDepthTweak ) / tooth_depth;

        quality = for3DPrinting?toothCount*4:$fn;
        difference() {
            // from solid cylinder ...
            rotate( [ 0, 0, 360/(toothCount*4) ] )
            cylinder( r=pulley_OD/2, h=beltWidth, $fn=quality );
            // ... cut out the tooth
            for ( i = [ 1:toothCount ] ) {
                rotate( [ 0, 0, i*(360/toothCount) ] )
                translate( [ 0, -tooth_distance_from_centre, -1 ] )
                scale( [ tooth_width_scale, tooth_depth_scale , 1 ] ) {
                    // (use ! in front of the linear_extrude) to see 
                    // a single "tooth" profile block
                    // and you will understand quickly how the pulleys are constructed
                    linear_extrude( beltWidth+2 ) polygon( polyPoints );
                }
            }
        }
    }

    function pulleyToothData( model, toothCount ) = let (
        // to add new pulleys, this is the guy to talk to: droftarts
        // https://www.thingiverse.com/thing:16627
        calc_pulley_dia_tooth_spacing = function( toothCount, tooth_pitch, pitch_line_offset ) 
            (2*((toothCount*tooth_pitch)/(3.14159265*2)-pitch_line_offset)),
        calc_pulley_dia_tooth_spacing_curvefit = function( toothCount, b, c, d ) 
            ((c * pow(toothCount,d)) / (b + pow(toothCount,d))) * toothCount
    )
        ( model == "MXL" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 2.032, 0.254 ), // outside diameter of pulley
            0.508,                                                     // tooth depth
            1.321,                                                     // tooth width
            // tooth profile. each item is unique to the belt tooth       
            [[-0.660421,-0.5],[-0.660421,0],[-0.621898,0.006033],[-0.587714,0.023037],[-0.560056,0.049424],[-0.541182,0.083609],[-0.417357,0.424392],[-0.398413,0.458752],[-0.370649,0.48514],[-0.336324,0.502074],[-0.297744,0.508035],[0.297744,0.508035],[0.336268,0.502074],[0.370452,0.48514],[0.39811,0.458752],[0.416983,0.424392],[0.540808,0.083609],[0.559752,0.049424],[0.587516,0.023037],[0.621841,0.006033],[0.660421,0],[0.660421,-0.5]]
        ] : ( model == "40DP" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 2.07264, 0.1778 ),
            0.457,
            1.226,
            [[-0.612775,-0.5],[-0.612775,0],[-0.574719,0.010187],[-0.546453,0.0381],[-0.355953,0.3683],[-0.327604,0.405408],[-0.291086,0.433388],[-0.248548,0.451049],[-0.202142,0.4572],[0.202494,0.4572],[0.248653,0.451049],[0.291042,0.433388],[0.327609,0.405408],[0.356306,0.3683],[0.546806,0.0381],[0.574499,0.010187],[0.612775,0],[0.612775,-0.5]]
        ] : ( model == "XL" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 5.08, 0.254 ),
            1.27,
            3.051,
            [[-1.525411,-1],[-1.525411,0],[-1.41777,0.015495],[-1.320712,0.059664],[-1.239661,0.129034],[-1.180042,0.220133],[-0.793044,1.050219],[-0.733574,1.141021],[-0.652507,1.210425],[-0.555366,1.254759],[-0.447675,1.270353],[0.447675,1.270353],[0.555366,1.254759],[0.652507,1.210425],[0.733574,1.141021],[0.793044,1.050219],[1.180042,0.220133],[1.239711,0.129034],[1.320844,0.059664],[1.417919,0.015495],[1.525411,0],[1.525411,-1]]
        ] : ( model == "L" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 9.525, 0.381 ),
            1.905,
            5.359,
            [[-2.6797,-1],[-2.6797,0],[-2.600907,0.006138],[-2.525342,0.024024],[-2.45412,0.052881],[-2.388351,0.091909],[-2.329145,0.140328],[-2.277614,0.197358],[-2.234875,0.262205],[-2.202032,0.334091],[-1.75224,1.57093],[-1.719538,1.642815],[-1.676883,1.707663],[-1.62542,1.764693],[-1.566256,1.813112],[-1.500512,1.85214],[-1.4293,1.880997],[-1.353742,1.898883],[-1.274949,1.905021],[1.275281,1.905021],[1.354056,1.898883],[1.429576,1.880997],[1.500731,1.85214],[1.566411,1.813112],[1.625508,1.764693],[1.676919,1.707663],[1.719531,1.642815],[1.752233,1.57093],[2.20273,0.334091],[2.235433,0.262205],[2.278045,0.197358],[2.329455,0.140328],[2.388553,0.091909],[2.454233,0.052881],[2.525384,0.024024],[2.600904,0.006138],[2.6797,0],[2.6797,-1]]
        ] : ( model == "T2.5" ) ? [
            calc_pulley_dia_tooth_spacing_curvefit( toothCount, 0.7467,0.796, 1.026 ),
            0.7,
            1.678,
            [[-0.839258,-0.5],[-0.839258,0],[-0.770246,0.021652],[-0.726369,0.079022],[-0.529167,0.620889],[-0.485025,0.67826],[-0.416278,0.699911],[0.416278,0.699911],[0.484849,0.67826],[0.528814,0.620889],[0.726369,0.079022],[0.770114,0.021652],[0.839258,0],[0.839258,-0.5]]
        ] : ( model == "T5" ) ? [
            calc_pulley_dia_tooth_spacing_curvefit( toothCount, 0.6523, 1.591, 1.064 ),
            1.19,
            3.264,
            [[-1.632126,-0.5],[-1.632126,0],[-1.568549,0.004939],[-1.507539,0.019367],[-1.450023,0.042686],[-1.396912,0.074224],[-1.349125,0.113379],[-1.307581,0.159508],[-1.273186,0.211991],[-1.246868,0.270192],[-1.009802,0.920362],[-0.983414,0.978433],[-0.949018,1.030788],[-0.907524,1.076798],[-0.859829,1.115847],[-0.80682,1.147314],[-0.749402,1.170562],[-0.688471,1.184956],[-0.624921,1.189895],[0.624971,1.189895],[0.688622,1.184956],[0.749607,1.170562],[0.807043,1.147314],[0.860055,1.115847],[0.907754,1.076798],[0.949269,1.030788],[0.9837,0.978433],[1.010193,0.920362],[1.246907,0.270192],[1.273295,0.211991],[1.307726,0.159508],[1.349276,0.113379],[1.397039,0.074224],[1.450111,0.042686],[1.507589,0.019367],[1.568563,0.004939],[1.632126,0],[1.632126,-0.5]]
        ] : ( model == "T10" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 10, 0.93 ),
            2.5,
            6.13,
            [[-3.06511,-1],[-3.06511,0],[-2.971998,0.007239],[-2.882718,0.028344],[-2.79859,0.062396],[-2.720931,0.108479],[-2.651061,0.165675],[-2.590298,0.233065],[-2.539962,0.309732],[-2.501371,0.394759],[-1.879071,2.105025],[-1.840363,2.190052],[-1.789939,2.266719],[-1.729114,2.334109],[-1.659202,2.391304],[-1.581518,2.437387],[-1.497376,2.47144],[-1.408092,2.492545],[-1.314979,2.499784],[1.314979,2.499784],[1.408091,2.492545],[1.497371,2.47144],[1.581499,2.437387],[1.659158,2.391304],[1.729028,2.334109],[1.789791,2.266719],[1.840127,2.190052],[1.878718,2.105025],[2.501018,0.394759],[2.539726,0.309732],[2.59015,0.233065],[2.650975,0.165675],[2.720887,0.108479],[2.798571,0.062396],[2.882713,0.028344],[2.971997,0.007239],[3.06511,0],[3.06511,-1]]
        ] : ( model == "AT5" ) ? [
            calc_pulley_dia_tooth_spacing_curvefit( toothCount, 0.6523, 1.591, 1.064 ),
            1.19,
            4.268,
            [[-2.134129,-0.75],[-2.134129,0],[-2.058023,0.005488],[-1.984595,0.021547],[-1.914806,0.047569],[-1.849614,0.082947],[-1.789978,0.127073],[-1.736857,0.179338],[-1.691211,0.239136],[-1.653999,0.305859],[-1.349199,0.959203],[-1.286933,1.054635],[-1.201914,1.127346],[-1.099961,1.173664],[-0.986896,1.18992],[0.986543,1.18992],[1.099614,1.173664],[1.201605,1.127346],[1.286729,1.054635],[1.349199,0.959203],[1.653646,0.305859],[1.690859,0.239136],[1.73651,0.179338],[1.789644,0.127073],[1.849305,0.082947],[1.914539,0.047569],[1.984392,0.021547],[2.057906,0.005488],[2.134129,0],[2.134129,-0.75]]
        ] : ( model == "HTD 3mm" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 3, 0.381 ),
            1.289,
            2.27,
            [[-1.135062,-0.5],[-1.135062,0],[-1.048323,0.015484],[-0.974284,0.058517],[-0.919162,0.123974],[-0.889176,0.206728],[-0.81721,0.579614],[-0.800806,0.653232],[-0.778384,0.72416],[-0.750244,0.792137],[-0.716685,0.856903],[-0.678005,0.918199],[-0.634505,0.975764],[-0.586483,1.029338],[-0.534238,1.078662],[-0.47807,1.123476],[-0.418278,1.16352],[-0.355162,1.198533],[-0.289019,1.228257],[-0.22015,1.25243],[-0.148854,1.270793],[-0.07543,1.283087],[-0.000176,1.28905],[0.075081,1.283145],[0.148515,1.270895],[0.219827,1.252561],[0.288716,1.228406],[0.354879,1.19869],[0.418018,1.163675],[0.477831,1.123623],[0.534017,1.078795],[0.586276,1.029452],[0.634307,0.975857],[0.677809,0.91827],[0.716481,0.856953],[0.750022,0.792167],[0.778133,0.724174],[0.800511,0.653236],[0.816857,0.579614],[0.888471,0.206728],[0.919014,0.123974],[0.974328,0.058517],[1.048362,0.015484],[1.135062,0],[1.135062,-0.5]]
        ] : ( model == "HTD 5mm" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 5, 0.5715 ),
            2.199,
            3.781,
            [[-1.89036,-0.75],[-1.89036,0],[-1.741168,0.02669],[-1.61387,0.100806],[-1.518984,0.21342],[-1.467026,0.3556],[-1.427162,0.960967],[-1.398568,1.089602],[-1.359437,1.213531],[-1.310296,1.332296],[-1.251672,1.445441],[-1.184092,1.552509],[-1.108081,1.653042],[-1.024167,1.746585],[-0.932877,1.832681],[-0.834736,1.910872],[-0.730271,1.980701],[-0.62001,2.041713],[-0.504478,2.09345],[-0.384202,2.135455],[-0.259708,2.167271],[-0.131524,2.188443],[-0.000176,2.198511],[0.131296,2.188504],[0.259588,2.167387],[0.384174,2.135616],[0.504527,2.093648],[0.620123,2.04194],[0.730433,1.980949],[0.834934,1.911132],[0.933097,1.832945],[1.024398,1.746846],[1.108311,1.653291],[1.184308,1.552736],[1.251865,1.445639],[1.310455,1.332457],[1.359552,1.213647],[1.39863,1.089664],[1.427162,0.960967],[1.467026,0.3556],[1.518984,0.21342],[1.61387,0.100806],[1.741168,0.02669],[1.89036,0],[1.89036,-0.75]]
        ] : ( model == "HTD 8mm" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 8, 0.6858 ),
            3.607,
            6.603,
            [[-3.301471,-1],[-3.301471,0],[-3.16611,0.012093],[-3.038062,0.047068],[-2.919646,0.10297],[-2.813182,0.177844],[-2.720989,0.269734],[-2.645387,0.376684],[-2.588694,0.496739],[-2.553229,0.627944],[-2.460801,1.470025],[-2.411413,1.691917],[-2.343887,1.905691],[-2.259126,2.110563],[-2.158035,2.30575],[-2.041518,2.490467],[-1.910478,2.66393],[-1.76582,2.825356],[-1.608446,2.973961],[-1.439261,3.10896],[-1.259169,3.22957],[-1.069074,3.335006],[-0.869878,3.424485],[-0.662487,3.497224],[-0.447804,3.552437],[-0.226732,3.589341],[-0.000176,3.607153],[0.226511,3.589461],[0.447712,3.552654],[0.66252,3.497516],[0.870027,3.424833],[1.069329,3.33539],[1.259517,3.229973],[1.439687,3.109367],[1.608931,2.974358],[1.766344,2.825731],[1.911018,2.664271],[2.042047,2.490765],[2.158526,2.305998],[2.259547,2.110755],[2.344204,1.905821],[2.411591,1.691983],[2.460801,1.470025],[2.553229,0.627944],[2.588592,0.496739],[2.645238,0.376684],[2.720834,0.269734],[2.81305,0.177844],[2.919553,0.10297],[3.038012,0.047068],[3.166095,0.012093],[3.301471,0],[3.301471,-1]]
        ] : ( model == "GT2 2mm" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 2, 0.254 ),
            0.764,
            1.494,
            [[0.747183,-0.5],[0.747183,0],[0.647876,0.037218],[0.598311,0.130528],[0.578556,0.238423],[0.547158,0.343077],[0.504649,0.443762],[0.451556,0.53975],[0.358229,0.636924],[0.2484,0.707276],[0.127259,0.750044],[0,0.76447],[-0.127259,0.750044],[-0.2484,0.707276],[-0.358229,0.636924],[-0.451556,0.53975],[-0.504797,0.443762],[-0.547291,0.343077],[-0.578605,0.238423],[-0.598311,0.130528],[-0.648009,0.037218],[-0.747183,0],[-0.747183,-0.5]]
        ] : ( model == "GT2 3mm" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 3, 0.381 ),
            1.169,
            2.31,
            [[-1.155171,-0.5],[-1.155171,0],[-1.065317,0.016448],[-0.989057,0.062001],[-0.93297,0.130969],[-0.90364,0.217664],[-0.863705,0.408181],[-0.800056,0.591388],[-0.713587,0.765004],[-0.60519,0.926747],[-0.469751,1.032548],[-0.320719,1.108119],[-0.162625,1.153462],[0,1.168577],[0.162625,1.153462],[0.320719,1.108119],[0.469751,1.032548],[0.60519,0.926747],[0.713587,0.765004],[0.800056,0.591388],[0.863705,0.408181],[0.90364,0.217664],[0.932921,0.130969],[0.988924,0.062001],[1.065168,0.016448],[1.155171,0],[1.155171,-0.5]]        
        ] : ( model == "GT2 5mm" ) ? [
            calc_pulley_dia_tooth_spacing( toothCount, 5, 0.5715 ),
            1.969,
            3.952,
            [[-1.975908,-0.75],[-1.975908,0],[-1.797959,0.03212],[-1.646634,0.121224],[-1.534534,0.256431],[-1.474258,0.426861],[-1.446911,0.570808],[-1.411774,0.712722],[-1.368964,0.852287],[-1.318597,0.989189],[-1.260788,1.123115],[-1.195654,1.25375],[-1.12331,1.380781],[-1.043869,1.503892],[-0.935264,1.612278],[-0.817959,1.706414],[-0.693181,1.786237],[-0.562151,1.851687],[-0.426095,1.9027],[-0.286235,1.939214],[-0.143795,1.961168],[0,1.9685],[0.143796,1.961168],[0.286235,1.939214],[0.426095,1.9027],[0.562151,1.851687],[0.693181,1.786237],[0.817959,1.706414],[0.935263,1.612278],[1.043869,1.503892],[1.123207,1.380781],[1.195509,1.25375],[1.26065,1.123115],[1.318507,0.989189],[1.368956,0.852287],[1.411872,0.712722],[1.447132,0.570808],[1.474611,0.426861],[1.534583,0.256431],[1.646678,0.121223],[1.798064,0.03212],[1.975908,0],[1.975908,-0.75]]
        ] : 
            undef;

//
// COMPLETE PULLEY
//

    module Pulley( profile, omitTeeth=false, for3DPrinting=false, autoFlip=false ) {
        
        // omitTeeth     - omit teeth for better performance in mechanical designs
        // for3DPrinting - high quality output
        // autoflip      - flip if hub is smaller than notched cylinder for 3D printing

        t = kvSearch(profile,"type");
        ExitIf( t!="timing pulley", "Pulley(): invalid profile" );
        go();
        module go() {
            toothModel = kvGet(profile, "toothModel" );
            toothCount = kvGet(profile, "toothCount" );
            toothData = pulleyToothData( toothModel, toothCount );            
            if ( for3DPrinting ) {
                // must have tooth data                
                ExitIf( toothData==undef, str( "unsupported toothModel [", toothModel, "]") );
            }
            eOmitTeeth = omitTeeth || toothData==undef;
            notchedCylinderDiameter = toothData!=undef ? toothData[0] : PulleyDiameter( toothModel, toothCount );
            ExitIf( notchedCylinderDiameter==undef, str( "unsupported toothModel [", toothModel, "]") );
            go2();
            module go2() {
                //
                //   +-----------------------+   ---            ---
                //   |                       |   flatHeight
                //   +-----------------------+   ---            topFlange
                //    \                     /    taperedHeight
                //     \-------------------/     ---            ---
                //      |||||||||||||||||||
                //      |||||||||||||||||||      beltWidth      notchedCylinder   
                //      |||||||||||||||||||
                //     /-------------------\     ---            ---
                //    /                     \    taperedHeight
                //   +-----------------------+   ---            bottomFlange
                //   |                       |   flatHeight
                //   +-------+-------+-------+   ---            ---
                //           |       |           hubHeight      hub
                //           +-------+           ---            ---
                //
                // name of parts: https://www.cmtco.com/product-catalogs/stock-timing-pulleys
                
                beltWidth        = kvGet(profile,    "beltWidth"           );
                shaftDiameter    = kvGet(profile,    "shaftDiameter"       );
                topFlangeInfo    = kvSearch(profile, "topFlange"           );
                bottomFlangeInfo = kvSearch(profile, "bottomFlange"        );
                hubInfo          = kvSearch(profile, "hub"                 );
                nutInfo          = kvSearch(profile, "nut"                 );
                captiveNutsInfo  = kvSearch(profile, "captiveNuts"         );
                toothWidthTweak  = kvGet(profile,    "tweak.toothWidth", 0 );
                toothDepthTweak  = kvGet(profile,    "tweak.toothDepth", 0 );

                topFlangeHeight    = topFlangeInfo   ==undef?0:kvGet(topFlangeInfo,   "height");
                bottomFlangeHeight = bottomFlangeInfo==undef?0:kvGet(bottomFlangeInfo,"height");

                hubDiameter = hubInfo==undef?0:kvGet(hubInfo, "diameter" );
                hubHeight   = hubInfo==undef?0:kvGet(hubInfo, "height"   );
                
                // diameter of part on top of hub, either bottomFlange or notchedCylinder
                hubTopDiameter = ( bottomFlangeInfo==undef?
                    notchedCylinderDiameter : notchedCylinderDiameter + kvGet(bottomFlangeInfo,"offset")*2 );

                // WARNINGS - based on original code
                if ( for3DPrinting && hubInfo!=undef && nutInfo!=undef && captiveNutsInfo!=undef ) {
                    nutDiameter  = kvGet(nutInfo, "nutDiameter" );
                    nutThickness = kvGet(nutInfo, "thickness"   );
                    ExitIf( hubHeight<2, "*** HUB HEIGHT LESS THAN 2 ***" );
                    ExitIf( hubHeight<nutDiameter, "*** PROBLEM WITH CAPTIVE NUTS, HUB HEIGHT LESS THAN NUT DIAMETER ***" );
                    ExitIf( (hubDiameter-shaftDiameter)/2 < nutThickness+3, "*** PROBLEM WITH CAPTIVE NUTS, HUB DIAMETER TOO SMALL FOR NUT DEPTH ***" );

                }
                
                // flip if upper portion > base diameter
                autoFlipData = ( autoFlip && ( hubTopDiameter > hubDiameter )
                    ? [ [0,0,topFlangeHeight+beltWidth+bottomFlangeHeight+hubHeight], [0,180,0] ]
                    : [ [0,0,0], [0,0,0] ]
                );        
                translate( autoFlipData[0] ) rotate( autoFlipData[1] )

                difference() {
                    // combine all...
                    union() {
                        translate( [0,0,hubHeight] ) {
                            translate( [0,0,bottomFlangeHeight] ) {
                                // TOP FLANGE
                                if ( topFlangeHeight > 0 ) {
                                    translate( [0,0,beltWidth] )
                                    pulleyTopFlange( notchedCylinderDiameter, topFlangeInfo, for3DPrinting, toothCount );
                                }
                                // NOTCHED CYLINDER
                                if ( eOmitTeeth )
                                    cylinder( beltWidth, d=notchedCylinderDiameter );
                                else
                                    pulleyNotchedCylinderCore( toothData, toothCount, beltWidth, 
                                        for3DPrinting, toothWidthTweak, toothDepthTweak );
                            }
                            // BOTTOM FLANGE
                            if ( bottomFlangeHeight > 0 )
                                pulleyBottomFlange( notchedCylinderDiameter, bottomFlangeInfo, for3DPrinting, toothCount );
                        }
                        // HUB
                        if ( hubHeight>0 ) {
                            difference() {
                                // create base ...
                                pulleyHub( hubDiameter, hubHeight, hubTopDiameter, for3DPrinting );
                                // ... subtract bolt/grub
                                if ( nutInfo!=undef && captiveNutsInfo!=undef ) {
                                    translate( [ 0,0,hubHeight/2 ] )
                                    pulleyHubCaptiveNuts( nutInfo, captiveNutsInfo, shaftDiameter,
                                        hubHeight/2,  // center bolts on hub
                                        hubDiameter/2
                                    );
                                }
                            }
                        }
                    }
                    // ... subtract shaft from everything
                    quality = for3DPrinting?shaftDiameter*4:$fn;
                    translate( [0,0,-1] )
                    cylinder( r=shaftDiameter/2,
                        h = topFlangeHeight + beltWidth + bottomFlangeHeight + hubHeight + 2,
                        $fn=quality );
                }
            }
        }
    }

//
// FLANGES
//

    module pulleyTopFlange( pulleyDiameter, flangeInfoKV, for3DPrinting=false, toothCount ) {
        // flangeInfoKV = KeyValue([ "offset", _, "taperHeight", _, "flatHeight", _ ]),
        offset      = kvGet(flangeInfoKV, "offset"      );
        taperHeight = kvGet(flangeInfoKV, "taperHeight" );
        flatHeight  = kvGet(flangeInfoKV, "flatHeight"  );
        // +--------+
        //          |
        //          +
        //         /
        //        /
        // 0-----+
        quality = for3DPrinting?toothCount*4:$fn;
        rotate_extrude( $fn=quality ) polygon([
            [ 0                         , 0                        ],
            [ pulleyDiameter/2          , 0                        ],
            [ pulleyDiameter/2 + offset , taperHeight              ],
            [ pulleyDiameter/2 + offset , taperHeight + flatHeight ],
            [ 0                         , taperHeight + flatHeight ]
        ]);
    }

    module pulleyBottomFlange( pulleyDiameter, flangeInfoKV, for3DPrinting=false, toothCount ) {
        // flangeInfoKV = KeyValue([ "offset", _ "taperHeight", _ "flatHeight", _ ]),
        offset      = kvGet(flangeInfoKV, "offset"      );
        taperHeight = kvGet(flangeInfoKV, "taperHeight" );
        flatHeight  = kvGet(flangeInfoKV, "flatHeight"  );
        // +-----+
        //        \
        //         \
        //          +
        //          |
        // 0--------+
        quality = for3DPrinting?toothCount*4:$fn;
        rotate_extrude( $fn=quality ) polygon([
            [ 0                         , 0                        ],
            [ pulleyDiameter/2 + offset , 0                        ],
            [ pulleyDiameter/2 + offset ,               flatHeight ],
            [ pulleyDiameter/2          , taperHeight + flatHeight ],
            [ 0                         , taperHeight + flatHeight ],
        ]);
    }

//
// HUB
//

    module pulleyHub( diameter, height, upperSectionDiameter, for3DPrinting=false ) {
        quality = for3DPrinting?diameter*2:$fn;
        if ( upperSectionDiameter >= diameter ) {
            // NO BEVEL - hub smaller than upper section
            //   +----------+
            //   ||||||||||||
            //   +---+--+---+
            //       |  |
            //       +--+
            translate( [0,0,height/2] )
                cylinder( h=height, r=diameter/2, center=true, $fn=quality );
        } else {
            // WITH BEVEL - hub bigger than upper section
            //       +--+
            //       ||||
            //   /---+--+---\
            //   |          |
            //   +----------+
            bevel = ( diameter - upperSectionDiameter < 1 )
                ? ( diameter - upperSectionDiameter ) // bevel the difference
                : 1;                                  // but limit to 1
            rotate_extrude( $fn=quality ) {
                square(    [ diameter/2-bevel , height       ] );
                square(    [ diameter/2       , height-bevel ] );
                translate( [ diameter/2-bevel , height-bevel ] )
                    circle( bevel );
            }
        }
    }

    module pulleyHubCaptiveNuts( nutKV, captiveNutsKV, shaftDiameter, nutInsertionDepth, boltLength ) {

        // nutKV = KeyValue([ "shape", _, "boltDiameter", _, "nutDiameter", _, "thickness", _ ]),
        useHex       = kvGet(nutKV, "shape" )!="square"; // unless square, default to hex
        boltDiameter = kvGet(nutKV, "boltDiameter" );
        nutFaceSize  = kvGet(nutKV, "nutDiameter"  );
        nutThickness = kvGet(nutKV, "thickness"    );

        // captiveNutsKV = KeyValue([ "count", _, "angleBetweenNuts", _, "offsetFromShaft", _ ])
        numberOfNuts     = kvGet(captiveNutsKV, "count"            );
        angleBetweenNuts = kvGet(captiveNutsKV, "angleBetweenNuts" );
        offsetFromShaft  = kvGet(captiveNutsKV, "offsetFromShaft"  );
        offsetFromOrigin = offsetFromShaft + shaftDiameter/2;
        
        NUT_POINTS = 2*((nutFaceSize/2)/cos(30));
        
        for( j = [ 1 : numberOfNuts ] ) {
            rotate( [ 0, 0, j*angleBetweenNuts ] )
            rotate( [90,0,0] )
            union() {
                
                // nut entrance
                translate( [ 0, -nutInsertionDepth/2-0.5, nutThickness/2+offsetFromOrigin ] )
                    cube( [ nutFaceSize, nutInsertionDepth+1, nutThickness ], center=true );

                // nut
                if ( useHex ) {
                    // hex nut
                    translate( [ 0, 0.25, nutThickness/2+offsetFromOrigin ] ) 
                    rotate( [0,0,30] ) 
                    cylinder( r=NUT_POINTS/2, h=nutThickness, center=true, $fn=6 );
                } else {
                    // square nut
                    translate( [ 0, 0.25, nutThickness/2+offsetFromOrigin ] ) 
                    cube( [ nutFaceSize, nutFaceSize, M3_NUT_DEPTH ], center=true );
                }

                // grub bolt hole
                rotate( [0,0,22.5] ) cylinder( d=boltDiameter, h=boltLength+1, $fn=8 );
            }
        }
    }
