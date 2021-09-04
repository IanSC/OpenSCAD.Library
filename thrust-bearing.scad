//
// THRUST BEARINGS
// by Ian Co 2021
//
// accurate by measurement for product design
// for rough visual representation only
//
//     profile = ThrustBearingProfile( ... )         - create profile
//     profile = ThrustBearingFromLibrary( "51120" ) - use specific model
//     ThrustBearing( profile, omitBalls )           - draw 3D
//
//     ThrustBearingModels[]                         - predefined models (add your own)
//
// note: use omitBalls parameter to disable balls for faster redraw

include <key-value.scad>
include <utility.scad>

//
// DEMO
//

    // run me!!!
    //ThrustBearing_Demo();

    module ThrustBearing_Demo() {
        $fn=20;
        
        profile1 = ThrustBearingProfile(
            model="abc", ID=20, OD=30, thickness=10 );
        ThrustBearing( profile1 );
        
        profile2 = ThrustBearingFromLibrary( "51102" );        
        translate( [50,0,-kvGet(profile2,"thickness")] )
            ThrustBearing( profile2 );        
        kvEcho( profile2 );

        profile3 = ThrustBearingFromLibrary( "F12-21M" );        
        translate( [100,0,0] )
            ThrustBearing( profile3, omitBalls=true );        

    }

//
// CORE
//

    function ThrustBearingProfile(
        model     = "",
        ID        = 10,
        OD        = 20,
        thickness = 5
    ) = let(
        e1=ErrorIf( ID       ==undef, "inner diameter missing" ),
        e2=ErrorIf( OD       ==undef, "outer diameter missing" ),
        e3=ErrorIf( thickness==undef, "thickness missing"      )
    ) KeyValue([
        "type"     , "thrust bearing",
        "model"    , model,
        "ID"       , ID,
        "OD"       , OD,
        "thickness", thickness
    ]);


    function ThrustBearingFromLibrary( model ) = 
        let(
            find = function( model )
                ThrustBearingModels[ search( [ model ], ThrustBearingModels )[0] ],
            //r = ThrustBearingFindModel( model )
            r = find( model ),
            e1=ErrorIf( r==undef, "model not found" )
        ) 
        KeyValue([
            "type"     , "thrust bearing",
            "model"    , r[0],
            "ID"       , r[1],
            "OD"       , r[2],
            "thickness", r[3]
        ]);

    module ThrustBearing( profile, omitBalls=false ) {
        t = kvSearch(profile,"type");
        ExitIf( t!="thrust bearing", "ThrustBearing(): invalid profile" );
        go();
        module go() {

            ID        = kvGet(profile, "ID"        );
            OD        = kvGet(profile, "OD"        );
            thickness = kvGet(profile, "thickness" );
            gap       = thickness*0.3;

            // rings
            linear_extrude( (thickness-gap)/2 )
                difference() {
                    circle( d=OD );
                    circle( d=ID );
                }
            translate( [0,0,thickness-(thickness-gap)/2] )
                linear_extrude( (thickness-gap)/2 )
                difference() {
                    circle( d=OD );
                    circle( d=ID );
                }
            
            // balls
            if ( !omitBalls ) {
                ringCenter = (ID+OD)/2;
                sphereSize = min( thickness/2, (OD-ID)/2*0.8 );
                // https://stackoverflow.com/questions/56004326/calculate-the-number-of-circles-that-fit-on-the-circumference-of-another-circle
                N = ceil( 180 / asin(sphereSize/ringCenter) );
                for( i=[0:N]) {
                    color( "red" )
                    rotate( [0,0,i*360/N] )
                    translate( [ringCenter/2,0,thickness/2] )
                        sphere( d=sphereSize );
                }
            }
        }
    }

//
// PREDEFINED
//

    // model, inner, outer, thickness
    ThrustBearingModels = [ 
        [ "51100",    10,  24,  9 ],
        [ "51101",    12,  26,  9 ],
        [ "51102",    15,  28,  9 ],
        [ "51103",    17,  30,  9 ],
        [ "51104",    20,  35, 10 ],
        [ "51105",    25,  42, 11 ],
        [ "51106",    30,  47, 11 ],
        [ "51107",    35,  52, 12 ],
        [ "51108",    40,  60, 13 ],
        [ "51109",    45,  65, 14 ],
        [ "51110",    50,  70, 14 ],
        [ "51124",   120, 155, 25 ], // shopee

        [ "51200",    10,  26, 11 ],
        [ "51201",    11,  28, 11 ],
        [ "51202",    15,  32, 12 ],
        [ "51203",    17,  35, 12 ],
        [ "51204",    20,  40, 14 ],
        [ "51205",    25,  47, 15 ],
        [ "51206",    30,  52, 16 ],
        [ "51207",    35,  62, 18 ],
        [ "51208",    40,  68, 19 ],
        [ "51209",    45,  73, 20 ],
        [ "51210",    50,  78, 22 ],

        [ "51211",    55,  90, 25 ],
        [ "51212",    60,  95, 26 ],
        [ "51213",    65, 100, 27 ],
        [ "51214",    70, 105, 27 ],
        [ "51215",    75, 110, 27 ],
        [ "51216",    80, 115, 28 ],
        [ "51217",    85, 125, 31 ],
        [ "51218",    90, 135, 35 ],
        [ "51220",   100, 150, 38 ],

        [ "51305",    25,  52, 18 ],
        [ "51306",    30,  60, 21 ],
        [ "51307",    35,  68, 24 ],
        [ "51308",    40,  78, 26 ],
        [ "51309",    45,  85, 28 ],
        [ "51310",    50,  95, 31 ],
        [ "51311",    55, 105, 35 ],
        [ "51312",    60, 110, 35 ],
        [ "51313",    65, 115, 36 ],
        [ "51314",    70, 125, 40 ],
        [ "51315",    75, 135, 44 ],

        [ "51405",    25,  60, 24 ],
        [ "51406",    30,  70, 28 ],
        [ "51407",    35,  80, 32 ],
        [ "51408",    40,  90, 36 ],
        [ "51409",    45, 100, 39 ],
        [ "51410",    50, 110, 43 ],
        [ "51411",    55, 120, 48 ],
        [ "51412",    60, 130, 51 ],
        [ "51413",    65, 140, 56 ],
        [ "51414",    70, 150, 60 ],
        [ "51415",    75, 160, 65 ],

        // http://www.brg-catalogues.com/Catalogue_store/UBC/H-Needle%20Roller%20Bearings%20and%20Cage%20Assembly.pdf
        [ "AKX0414",   4,  14,  4 ],
        [ "AKX0515",   5,  15,  4 ],
        [ "AKX0821",   8,  21,  4 ], // shopee
        [ "AKX1024",  10,  24,  4 ],
        [ "AKX1226",  12,  26,  4 ],
        [ "AKX1528",  15,  28,  4 ],
        [ "AKX1730",  17,  30,  4 ],
        [ "AKX2035",  20,  35,  4 ],
        [ "AKX2542",  25,  42,  4 ],

        [ "AKX3047",  30,  47,  4 ],
        [ "AKX3552",  35,  52,  4 ],
        [ "AKX4060",  40,  60,  5 ],
        [ "AKX4565",  45,  65,  5 ],
        [ "AKX5070",  50,  70,  5 ],
        [ "AKX6085",  60,  85,  5 ],
        [ "AKX6590",  65,  90,  5 ],
        [ "AKX75100", 75, 100,  6 ],

        [ "F2-6M",     2   ,  6 ,  3   ],
        [ "F2.5-6M",   2.5 ,  6 ,  3   ],
        [ "F3-7M",     3   ,  7 ,  3   ],
        [ "F3-8M",     3   ,  8 ,  3.5 ],
        [ "F4-9M",     4   ,  9 ,  4   ],
        [ "F4-10M",    4   , 10 ,  4   ],
        [ "F5-10M",    5   , 10 ,  4   ],
        [ "F5-11M",    5   , 11 ,  4.5 ],
        [ "F5-12M",    5   , 12 ,  4   ],
        [ "F6-11M",    6   , 11 ,  4.5 ],
        [ "F6-12M",    6   , 12 ,  4.5 ],
        [ "F6-14M",    6   , 14 ,  5   ],
        [ "F7-13M",    7   , 13 ,  4.5 ],
        [ "F7-15M",    7   , 15 ,  5   ],
        [ "F7-17M",    7   , 17 ,  6   ],
        [ "F8-14M",    8   , 14 ,  4   ],
        [ "F8-16M",    8   , 16 ,  5   ],
        [ "F8-19M",    8   , 19 ,  7   ],
        [ "F8-22M",    8   , 22 ,  7   ],
        [ "F9-17M",    9   , 17 ,  5   ],
        [ "F9-20M",    9   , 20 ,  7   ],
        [ "F10-17M",  10   , 17 ,  5   ],
        [ "F10-18M",  10   , 18 ,  5.5 ],
        [ "F10-20M",  10   , 20 ,  6.5 ],
        [ "F12-21M",  12   , 21 ,  5   ],
        [ "F12-23M",  12   , 23 ,  7.5 ]

        //32005
        //KFL08
    ];

