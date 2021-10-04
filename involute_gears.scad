// Parametric Involute Bevel and Spur Gears by GregFrost
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2010 by GregFrost, thingiverse.com/Amp
// http://www.thingiverse.com/thing:3575 and http://www.thingiverse.com/thing:3752

include <KVTree.scad>
include <utility.scad>

// Simple Test:
//gear (circular_pitch=700,
//  gear_thickness = 12,
//  rim_thickness = 15,
//  hub_thickness = 17,
//  circles=8);

//Complex Spur Gear Test:
//test_gears ();



// Demonstrate the backlash option for Spur gears.
//test_backlash ();


//
// DEMO
//

    //Gear_Demo();

    module Gear_Demo() {
        
        toothProfile = GearToothProfile( circularPitch=70, teeth=15, twist=0 );
        bodyProfile = GearBodyProfile(
            rim=[30,20],
            hub=[undef,30,false], 
            //body=[0],spokes=[8],
            body=[40],holeArray=[8]
            //toothProfile=toothProfile
            ,rootRadius=150
            );
        
        kvEchoAligned(toothProfile);
        kvEchoAligned(bodyProfile);

        Gear( toothProfile, bodyProfile );
    }
    
    //GearDouble_Demo();
    
    module GearDouble_Demo() {

        // circularPitch=70;
        // teeth1=25;
        // teeth2=20;
        
        circularPitch=9;
        teeth1=148;
        teeth2=12;
        
        toothProfile1 = GearToothProfile( circularPitch=circularPitch, teeth=teeth1, twist=0 );
        toothProfile2 = GearToothProfile( circularPitch=circularPitch, teeth=teeth2, twist=0 );

        radius1 = GearPitchRadius(circularPitch,teeth1);
        radius2 = GearPitchRadius(circularPitch,teeth2);

        translate([radius1,0,0])
            Gear2D( toothProfile1 );
        translate([-radius2,0,0])
             Gear2D( toothProfile2 );
    }

    //function pitch_radius(mm_per_tooth=3,number_of_teeth=11) = mm_per_tooth * number_of_teeth / PI / 2;
    function GearPitchRadius(circularPitch,teeth) = circularPitch * teeth / PI / 2;
    function GearRootRadius(circularPitch,teeth,clearance) = let(
        e1=ErrorIf( circularPitch==undef, "GearRootRadius(): circular pitch missing" ),
        e2=ErrorIf( teeth        ==undef, "GearRootRadius(): teeth missing" ),
        // circularPitch = (circularPitch!=undef?circularPitch:PI/diametralPitch);
        effClearance    = (clearance!=undef?clearance:0.25 * circularPitch / PI), // calculate default if not specified
        pitchRadius     = teeth * circularPitch / PI / 2,
        addendum        = circularPitch / PI,               // Addendum: Radial distance from pitch circle to outside circle
        dedendum        = addendum + effClearance,          // Dedendum: Radial distance from pitch circle to root diameter
        rootRadius      = pitchRadius - dedendum           // Root diameter: Diameter of bottom of tooth spaces
    ) rootRadius;

    //GearRack_Demo();
    module GearRack_Demo() {
        
        toothProfile = GearToothProfile( circularPitch=15, teeth=12 ); 
        GearRack( toothProfile, baseHeight=20, thickness=10 );

//        bodyProfile = GearBodyProfile( toothProfile, body=[10] );
        bodyProfile = GearBodyProfile( toothProfile, thickness=10, holeArray=[3,8] ); //, body=[10] );
        offset = kvGet(toothProfile,"radius.pitch");
        translate([0,offset,0])
            Gear( toothProfile, bodyProfile );
        
       kvEchoAligned(bodyProfile);
    }    
   
    //translate([0,0,100])
    //MeshingDoubleHelixGear_Demo();
    module MeshingDoubleHelixGear_Demo()
    {

        circularPitch = 700*PI/180;
        teeth1=17;
        teeth2=13;
        offset1 = pitch_radius(circularPitch,teeth1);
        offset2 = pitch_radius(circularPitch,teeth2);

        translate ([-offset1,0,0])
        doubleHelixGear(circularPitch,teeth1,8);

        translate ([offset2,0,0])
        mirror ([0,1,0])
        doubleHelixGear(circularPitch,teeth2,6);

        module doubleHelixGear( circularPitch,teeth,circles ) {

            twist=200;
            height=20;
            pressure_angle=30;
            
            toothProfile = GearToothProfile(
                teeth         = teeth,
                circularPitch = circularPitch,
                pressureAngle = pressure_angle,
                clearance     = 0.2,
                twist         = twist/teeth
            );
            
            bodyProfile = GearBodyProfile(
                toothProfile,
                body         = [height/2*0.5,false],
                rim          = [5,height/2],
                hub          = [15,height/2*1.2],
                boreDiameter = 5,
                holeArray    = [circles]
            );
                
            translate([0,0,height/4])
                Gear( toothProfile, bodyProfile );
            translate([0,0,-height/4])
            mirror([0,0,1])
                Gear( toothProfile, bodyProfile );
        }
    }
    // Meshing Double Helix:
    // //test_meshing_double_helix ();
    // module test_meshing_double_helix(){
    //     meshing_double_helix ();
    // }
    
    //Backlash_Demo(); //$vpr=[0,0,1]; $vpt=[0,0,0]; $vpf=30;
    
    module Backlash_Demo()
    {
        $fn=50;
        
        circularPitch = 700*PI/180;
        teeth         = 15;
        backlash      = 2;
        
        toothProfile = GearToothProfile(
            circularPitch = circularPitch,
            teeth         = teeth,
            backlash      = backlash
        );

        radius = kvGet(toothProfile,"radius.pitch");
        
        translate([radius,0,0])
        //rotate ([0,0,-360/teeth/4])
            Gear2D( toothProfile );
        translate([-radius,0,0])
        //rotate ([0,0,360/teeth/4])
             Gear2D( toothProfile );

        color("red")
        translate([0,3.065,0])
        circle(d=backlash/2);
        
        color("red")
        translate([0,-3.065,0])
        circle(d=backlash/2);
        
        
        
        //cylinder ($fn=20,r=backlash / 4,h=25);

//        translate ([-29.166666,0,0])
//        {
//            translate ([58.3333333,0,0])
//            rotate ([0,0,-360/teeth/4])
//            gear (
//                number_of_teeth = teeth,
//                circular_pitch=700*PI/180,
//                gear_thickness = 12,
//                rim_thickness = 15,
//                rim_width = 5,
//                hub_thickness = 17,
//                hub_diameter=15,
//                bore_diameter=5,
//                backlash = backlash,
//                circles=8);
//
//            rotate ([0,0,360/teeth/4])
//            gear (
//                number_of_teeth = teeth,
//                circular_pitch=700*PI/180,
//                gear_thickness = 12,
//                rim_thickness = 15,
//                rim_width = 5,
//                hub_thickness = 17,
//                hub_diameter=15,
//                bore_diameter=5,
//                backlash = backlash,
//                circles=8);
//        }

//        color([0,0,1,0.5])
//        translate([0,0,-5])
//        cylinder ($fn=20,r=backlash / 4,h=25);
    }

//
// GEAR 2-D
//

    function GearToothProfile(
        model          = "",
        circularPitch,          // pitch per tooth, the circumference of the pitch circle divided by the number of teeth
        teeth,                  // total number of teeth around the entire perimeter
        pressureAngle  = 28,    // Controls how straight or bulged the tooth sides are. In degrees.
        clearance      = undef, // gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
        backlash       = 0.0,   // gap between two meshing teeth, in the direction along the circumference of the pitch circle
        twist          = 0,     // teeth rotate this many degrees from bottom of gear to top.  360 makes the gear a screw with each thread going around once
        facets         = undef  // number of fragments of generated involutes
        //thickness      = 6,     // thickness of gear in mm
        //center         = true,  // center gear by z axis
        //holeDiameter   = 0,     // diameter of the hole in the center, in mm
        //hiddenTeeth    = 0,     // number of teeth to delete to make this only a fraction of a circle
        //$fn                     // number of fragments to draw hole cylinder
    ) = let (
        e1=ErrorIf( circularPitch==undef, "circular pitch missing" ),
        e2=ErrorIf( teeth        ==undef, "teeth missing" ),
        // circularPitch = (circularPitch!=undef?circularPitch:PI/diametralPitch);
        effClearance    = (clearance!=undef?clearance:0.25 * circularPitch / PI), // calculate default if not specified
        pitchDiameter   = teeth * circularPitch / PI,       // diameter of pitch circle
        pitchRadius     = pitchDiameter / 2,
        baseRadius      = pitchRadius * cos(pressureAngle), // base circle        
        //diametrialPitch = teeth / pitchDiameter,          // Diametrial Pitch: Number of teeth per unit length
        //addendum        = 1 / diametrialPitch,            // Addendum: Radial distance from pitch circle to outside circle
        addendum        = circularPitch / PI,               // Addendum: Radial distance from pitch circle to outside circle        
        outerRadius     = pitchRadius + addendum,           // Outer Circle
        dedendum        = addendum + effClearance,          // Dedendum: Radial distance from pitch circle to root diameter
        rootRadius      = pitchRadius - dedendum,           // Root diameter: Diameter of bottom of tooth spaces
        backlashAngle   = backlash / pitchRadius * 180 / PI,
        halfThickAngle  = (360 / teeth - backlashAngle) / 4,
        effFacets       = (facets!=undef)?facets:($fn==0)?5:ceil($fn/4)
    ) KVTree([
        "type"          , "involute gear",
        "model"         , model,
        "circularPitch" , circularPitch,
        "teeth"         , teeth,
        "pressureAngle" , pressureAngle,
        "addendum"      , addendum,
        "dedendum"      , dedendum,
        "toothHeight"   , outerRadius - rootRadius,
        "clearance"     , effClearance,
        "backlash"      , backlash,
        "twist"         , twist,
        "radius"        , KVTree([ "pitch", pitchRadius, "base", baseRadius, "root", rootRadius, "outer", outerRadius ]),
        "halfThickAngle", halfThickAngle,
        "facets"        , effFacets
    ]);

    module Gear2D( toothProfile, facets ) {
        e1=ErrorIf( toothProfile==undef, "Gear2D(): tooth profile missing" );
        t = kvSearch(toothProfile,"type");
        e2=ErrorIf( t!="involute gear", "Gear2D(): invalid tooth profile" );
        go();
        module go() {
            teeth           = kvGet(toothProfile, "teeth" );
            halfThickAngle  = kvGet(toothProfile, "halfThickAngle" );            
            radius          = kvGet(toothProfile, "radius" );
            pitchRadius     = kvGet(radius, "pitch" );
            rootRadius      = kvGet(radius, "root" );
            baseRadius      = kvGet(radius, "base" );
            outerRadius     = kvGet(radius, "outer" );
            involute_facets = SELECT( facets, kvGet(toothProfile, "facets" ) );
            gear_shape (
                number_of_teeth = teeth,
                pitch_radius = pitchRadius,
                root_radius = rootRadius,
                base_radius = baseRadius,
                outer_radius = outerRadius,
                half_thick_angle = halfThickAngle,
                involute_facets = involute_facets);
        }
    }

    module gear_shape (
        number_of_teeth,
        pitch_radius,
        root_radius,
        base_radius,
        outer_radius,
        half_thick_angle,
        involute_facets )
    {
        union() {
            rotate (half_thick_angle) circle ($fn=number_of_teeth*2, r=root_radius);
            for (i = [1:number_of_teeth]) {
                rotate ([0,0,i*360/number_of_teeth]) {
                    involute_gear_tooth(
                        pitch_radius = pitch_radius,
                        root_radius = root_radius,
                        base_radius = base_radius,
                        outer_radius = outer_radius,
                        half_thick_angle = half_thick_angle,
                        involute_facets = involute_facets );
                }
            }
        }
    }

    module involute_gear_tooth (
        pitch_radius,
        root_radius,
        base_radius,
        outer_radius,
        half_thick_angle,
        involute_facets)
    {
        min_radius = max (base_radius,root_radius);

        pitch_point = involute (base_radius, involute_intersect_angle (base_radius, pitch_radius));
        pitch_angle = atan2 (pitch_point[1], pitch_point[0]);
        centre_angle = pitch_angle + half_thick_angle;

        start_angle = involute_intersect_angle (base_radius, min_radius);
        stop_angle = involute_intersect_angle (base_radius, outer_radius);

        res=(involute_facets!=undef)?involute_facets:($fn==0)?5:ceil($fn/4);

        union() {
            for (i=[1:res]) {
                point1=involute (base_radius,start_angle+(stop_angle - start_angle)*(i-1)/res);
                point2=involute (base_radius,start_angle+(stop_angle - start_angle)*i/res);
                side1_point1=rotate_point (centre_angle, point1);
                side1_point2=rotate_point (centre_angle, point2);
                side2_point1=mirror_point (rotate_point (centre_angle, point1));
                side2_point2=mirror_point (rotate_point (centre_angle, point2));
                polygon(
                    points=[[0,0],side1_point1,side1_point2,side2_point2,side2_point1],
                    paths=[[0,1,2,3,4,0]] );
            }
        }
    }

    // Mathematical Functions
    //===============

    // Finds the angle of the involute about the base radius at the given distance (radius) from it's center.
    //source: http://www.mathhelpforum.com/math-help/geometry/136011-circle-involute-solving-y-any-given-x.html

    function involute_intersect_angle (base_radius, radius) = sqrt (pow (radius/base_radius, 2) - 1) * 180 / PI;

    // Calculate the involute position for a given base radius and involute angle.

    function rotated_involute (rotate, base_radius, involute_angle) = [
        cos (rotate) * involute (base_radius, involute_angle)[0] + sin (rotate) * involute (base_radius, involute_angle)[1],
        cos (rotate) * involute (base_radius, involute_angle)[1] - sin (rotate) * involute (base_radius, involute_angle)[0]
    ];

    function mirror_point (coord) = [
        coord[0],
        -coord[1]
    ];

    function rotate_point (rotate, coord) = [
        cos (rotate) * coord[0] + sin (rotate) * coord[1],
        cos (rotate) * coord[1] - sin (rotate) * coord[0]
    ];

    function involute (base_radius, involute_angle) = [
        base_radius*(cos (involute_angle) + involute_angle*PI/180*sin (involute_angle)),
        base_radius*(sin (involute_angle) - involute_angle*PI/180*cos (involute_angle))
    ];
    
//
// GEAR 3-D
//
        
    function GearBodyProfile(
        model        = "",
        toothProfile,
        rootRadius,
        thickness    = undef,
        boreDiameter = undef, // central hole
        body         = undef, // [ thickness, centered ]
                              //   thickness - thickness of part between hub and rim
                              //               set to 0 to remove for spokes
                              //   centered  - relative to rim
        rim          = undef, // [ width, thickness ]
                              //   width - distance from gear root diameter                              
        hub          = undef, // [ diameter, thickness, centered ]
                              //   centered - relative to rim
        spokes       = undef, // [ count, width, thickness, squared ]
        holeArray    = undef  // [ count, diameter, orbitDiameter ]
    ) = let (
        t1=kvSearchLax( toothProfile,"type" ),
        e1=ErrorIf ( toothProfile!=undef && t1!="involute gear", "GearBodyProfile(): invalid tooth profile" ),
        effRootRadius=SELECT( rootRadius, kvSearchLax(toothProfile,"radius.root" ) ),
        e2=ErrorIf ( effRootRadius==undef, "GearBodyProfile(): tooth profile or rootRadius missing" ),

        // e1=ErrorIf ( toothProfile==undef, "GearBodyProfile(): tooth profile missing" ),
        // t1=kvSearch( toothProfile,"type" ),
        // e2=ErrorIf ( t1!="involute gear", "GearBodyProfile(): invalid tooth profile" ),        
        // effRootRadius=kvGet(toothProfile,"radius.root"),
        
        effBoreDiameter = boreDiameter!=undef?boreDiameter:effRootRadius*0.2,
        
        //bodyThickness = SELECT( SELECT( body[0], thickness, rim[1] ), hub[1], rootRadius*0.1 ),
        bodyThickness = SELECT( body[0], thickness, effRootRadius*0.1 ),
        bodyCentered  = SELECT( body[1], false ),
        //bodyThickness = getElementHelper(body,rootRadius*0.1,0),
        //bodyCentered  = getElementHelper(body,false,1),

        //rimThickness = SELECT( SELECT( rim[1], thickness, body[0] ), hub[1], rootRadius*0.15 ),
        rimThickness = SELECT( rim[1], thickness, bodyThickness*1.5 ),
        rimWidth     = SELECT( rim[0], effRootRadius*0.1 ),
        rimRadius    = effRootRadius - rimWidth,
        
//        rimWidth     = getElementHelper(rim,rootRadius*0.1,0),
//        rimThickTmp  = rim[1],
//        rimThickness = rimThickTmp!=undef?
//            (rimThickTmp!=0?rimThickTmp:bodyThickness)
//            :bodyThickness * 1.5,
//        rimRadius    = rootRadius - rimWidth,
        
        //        rim_thickness = (rim_thickness!=undef?
        //            (rim_thickness!=0?rim_thickness:gear_thickness)
        //            :gear_thickness * 1.5);
        //        rim_width = (rim_width!=undef?rim_width:root_radius * .1);
        //        rim_radius = root_radius - rim_width;
        
        hubDiameter  = SELECT( hub[0], effRootRadius*0.3 ),
        hubThickness = SELECT( hub[1], thickness, bodyThickness*2 ),
        hubCentered  = SELECT( hub[2], false ),
        
        //hubDiameter  = getElementHelper(hub,rootRadius*0.3,0),
//        hubThickTmp  = hub[1],
//        hubThickness = hubThickTmp!=undef?
//            (hubThickTmp!=0?hubThickTmp:bodyThickness)
//            :bodyThickness * 2,
//        hubCentered  = getElementHelper(hub,false,2),
        
        //hub_thickness = (hub_thickness!=undef?(hub_thickness!=0?hub_thickness:gear_thickness):gear_thickness * 2);
        //hub_diameter = (hub_diameter!=undef?hub_diameter:root_radius * .3);
        //hub_base = (centered_hub == false)? 0 : rim_thickness/2 - hub_thickness/2;
        
        spokeCount     = SELECT( spokes[0], 0 ),
        spokeWidth     = spokeCount==0?0:SELECT( spokes[1], 0.75*PI*hubDiameter/spokeCount ),
        spokeThickness = SELECT( spokes[2], thickness, rimThickness ),
        spokeLength    = rimRadius+(effRootRadius-rimRadius)/2,
        spokeSquared   = SELECT( spokes[3], false ),
        
//        spokeCount     = getElementHelper(spokes,0,0),
//        spokeWidth     = spokeCount==0?0:getElementHelper(spokes,0.75*PI*hubDiameter/spokeCount,1),
//        spokeThickness = getElementHelper(spokes,rimThickness,2),
//        spokeLength    = rimRadius+(rootRadius-rimRadius)/2,
//        spokeSquared   = getElementHelper(spokes,false,3),
        
        //        //spokes = spokes == undef? 0 : spokes;
        //        spoke_thickness = (spoke_thickness == undef)? rim_thickness : spoke_thickness;
        //        spoke_width = (spokes==0)? 1 : (spoke_width == undef)?  0.75 * PI * hub_diameter / spokes : spoke_width; 
        //        spoke_length=rim_radius+(root_radius-rim_radius)/2;             

        circleCount         = SELECT( holeArray[0], 0 ),
        circleOrbitDiameter = SELECT( holeArray[2], hubDiameter/2+rimRadius ),
        circleOrbitCircumference = PI*circleOrbitDiameter,
        defaultDiameter = min( 0.70*circleOrbitCircumference/circleCount, 
            (rimRadius+hubDiameter/2)*0.9), // Limit the circle size to 90% of the gear face
        circleDiameter=circleCount==0?0:SELECT( holeArray[1], defaultDiameter )        
                
//        circleCount         = getElementHelper(holeArray,0,0),
//        circleOrbitDiameter = getElementHelper(holeArray,hubDiameter/2+rimRadius,2),
//        circleOrbitCircumference = PI*circleOrbitDiameter,
//        defaultDiameter = min( 0.70*circleOrbitCircumference/circleCount, 
//            (rimRadius+hubDiameter/2)*0.9), // Limit the circle size to 90% of the gear face
//        circleDiameter=circleCount==0?0:getElementHelper(holeArray,defaultDiameter,1)
        
        //        // CIRCULAR HOLES
        //        circle_orbit_diameter=hub_diameter/2+rim_radius;
        //        
        //        circle_orbit_curcumference=PI*circle_orbit_diameter;
        //        circle_default_diameter = // Limit the circle size to 90% of the gear face.
        //            min( 0.70*circle_orbit_curcumference/circles, 
        //                (rim_radius+hub_diameter/2)*0.9);
        //                
        //        circle_diameter=(circle_diameter != undef)? circle_diameter : circle_default_diameter;

    ) KVTree([
        "type"        , "involute gear body",
        "model"       , model,
        "boreDiameter", effBoreDiameter,
        "body"        , KVTree([ "thickness", bodyThickness, "centered", bodyCentered ]),
        "rim"         , KVTree([ "radius", rimRadius, "width", rimWidth, "thickness", rimThickness ]),
        "hub"         , KVTree([ "diameter", hubDiameter, "thickness", hubThickness, "centered", hubCentered ]),
        "spokes"      , KVTree([ "count", spokeCount, "width", spokeWidth, "thickness", spokeThickness, "length", spokeLength, "squared", spokeSquared ]),
        "holeArray"   , KVTree([ "count", circleCount, "diameter", circleDiameter, "orbitDiameter", circleOrbitDiameter ])
    ]);
    
    module Gear( toothProfile, bodyProfile, facets ) {
        e1=ErrorIf( toothProfile==undef, "Gear(): tooth profile missing" );
        t1=kvSearch(toothProfile,"type");
        e2=ErrorIf( t1!="involute gear", "Gear(): invalid tooth profile" );
        e3=ErrorIf( bodyProfile==undef, "Gear(): body profile missing" );
        t2=kvSearch(bodyProfile,"type");
        e4=ErrorIf( t2!="involute gear body", "Gear(): invalid body profile" );
        go();
        module go() {
            mainBodyProfile = kvGet( bodyProfile,     "body"      );
            bodyThickness   = kvGet( mainBodyProfile, "thickness" );
            bodyCentered    = kvGet( mainBodyProfile, "centered"  );
            
            rimProfile   = kvGet( bodyProfile, "rim"       );
            rimRadius    = kvGet( rimProfile,  "radius"    );
            rimThickness = kvGet( rimProfile,  "thickness" );
            
            hubProfile   = kvGet( bodyProfile, "hub"       );
            hubDiameter  = kvGet( hubProfile,  "diameter"  );
            hubThickness = kvGet( hubProfile,  "thickness" );
            hubCentered  = kvGet( hubProfile,  "centered"  );
        
            difference() {
                union() {
                    
                    //
                    // RIM WITH TEETH
                    //
                    twist = kvGet( toothProfile, "twist" );
                    linear_extrude(height=rimThickness,center=true,convexity=10,twist=twist)
                        difference() {
                            Gear2D( toothProfile, facets );
                            if ( bodyThickness > rimThickness )
                                circle( r=rimRadius-1 ); // penetrate rim into body
                            else
                                circle( r=rimRadius );
                        }
            
                    //
                    // BODY
                    //
                    bodyRadius = bodyThickness<rimThickness ? rimRadius+1 : rimRadius; // penetrate body into rim
                    holesProfile = kvGet( bodyProfile,  "holeArray" );
                    holesCount   = kvGet( holesProfile, "count"     );
                    gearOffset = (bodyCentered?0:bodyThickness/2-rimThickness/2);
                    translate ([0,0,gearOffset])
                    difference() {
                        linear_extrude(height=bodyThickness,center=true)
                            circle( r=bodyRadius );
                        if ( holesCount>0 ) {
                            holesDiameter      = kvGet( holesProfile, "diameter" );
                            holesOrbitDiameter = kvGet( holesProfile, "orbitDiameter" );
                            linear_extrude(height=bodyThickness+2,center=true)
                                rotate([0,0,360/holesCount/2])
                                    circles( holesCount, holesDiameter, holesOrbitDiameter );
                        } 
                    }
                    /*
                    // preview error, if 2D punch then extrude, so extrude then punch
                    translate ([0,0,gearOffset])
                        linear_extrude(height=bodyThickness,center=true)
                            if ( holesCount>0 ) {
                                holesDiameter      = kvGet( holesProfile, "diameter" );
                                holesOrbitDiameter = kvGet( holesProfile, "orbitDiameter" );
                                difference() {
                                    circle(r=bodyRadius);
                                    rotate([0,0,360/holesCount/2])
                                        circles( holesCount, holesDiameter, holesOrbitDiameter );
                                }
                            } else
                                circle( r=bodyRadius );
                    */
            
                    //
                    // HUB
                    //
                    translate ([0,0,hubOffset])
                        linear_extrude(height=hubThickness,center=true)
                            circle( d=hubDiameter );
            
                    //
                    // SPOKES
                    //
                    spokeProfile = kvGet( bodyProfile,  "spokes" );
                    spokeCount   = kvGet( spokeProfile, "count"  );
                    if ( spokeCount>0 ) {
                        spokeWidth     = kvGet( spokeProfile, "width"     );
                        spokeThickness = kvGet( spokeProfile, "thickness" );
                        spokeLength    = kvGet( spokeProfile, "length"    );
                        spokeSquared   = kvGet( spokeProfile, "squared"   );
                        spokes(spokeCount,
                            spokeWidth,spokeThickness,spokeLength,
                            square=spokeSquared);
                    }
                }
                
                //
                // BORE HOLE
                //
                boreDiameter = kvGet( bodyProfile, "boreDiameter" );
                hubOffset    = (hubCentered?0:max(bodyThickness,hubThickness)/2-rimThickness/2);
                translate ([0,0,hubOffset])
                    linear_extrude(height=2+max(rimThickness,bodyThickness,hubThickness),center=true)
                        circle ( d=boreDiameter );
            }
        }
        module spokes( spokes, width, thickness, length, square=false ) {
            if (spokes!=undef && spokes>0) {
                for( i=[0:spokes-1] ) {
                    rotate([-90,0,i*360/spokes])
                    if (square) {
                        resize([width,thickness,length])
                        translate([0,0,.5])
                        cube(1,center=true);
                    } else {
                        resize([width,thickness,length])
                        cylinder(h=10,d=10);
                    }
                }
            }
        }
        module circles( circles, diameter, orbitDiameter ) {
            if (circles!=undef && circles>0 && diameter!=undef && orbitDiameter!=undef) {
                for(i=[0:circles-1])
                    rotate([0,0,i*360/circles])
                    translate([0,orbitDiameter/2,0])
                    circle(r=diameter/2);
            }
        }
    }
    
//
// RACK
//

    module GearRack2D( toothProfile, baseHeight ) {
        e1=ErrorIf( toothProfile==undef, "GearRack(): tooth profile missing" );
        t1=kvSearch(toothProfile,"type");
        e2=ErrorIf( t1!="involute gear", "GearRack(): invalid tooth profile" );
        go();
        module go() {
            teeth         = kvGet(toothProfile,"teeth");
            circularPitch = kvGet(toothProfile,"circularPitch");
            pressureAngle = kvGet(toothProfile,"pressureAngle");
            addendum      = kvGet(toothProfile,"addendum");
            dedendum      = kvGet(toothProfile,"dedendum");
            
            pitch      = circularPitch;
            pitchSlope = tan(pressureAngle);
            
            effBaseHeight = baseHeight!=undef?baseHeight:kvGet(toothProfile,"toothHeight");

            union() {
                translate([0,-dedendum-effBaseHeight/2])
                    square([teeth*pitch,effBaseHeight],center=true);
                
                p1 = pitch / 4 + pitchSlope * dedendum;
                p2 = pitch / 4 - pitchSlope * addendum;
                for( i=[1:teeth] ) {
                    translate([pitch*(i-teeth/2-0.5),0])
                    polygon( points=[
                        [-p1,-dedendum],
                        [p1,-dedendum],
                        [p2,addendum],
                        [-p2,addendum]
                    ]);
                }
            }
        }
    }
    
    module GearRack( toothProfile, baseHeight, thickness=20 ) {
        linear_extrude(height=thickness,convexity=2,center=true)
        GearRack2D( toothProfile, baseHeight );
    }
    


//
//
//






// Test Cases
//===============

module test_gears()
{
    $fs = 0.2;
    $fa =1;
    translate([17,-15])
    {
        gear (number_of_teeth=17,
            circular_pitch=500*PI/180,
            spokes=6,
            spoke_thickness=4,
            gear_thickness=0,
            rim_thickness=5,
            hub_thickness=5,
            hub_diameter=10,
            circles=0);

        rotate ([0,0,360*4/17])
        translate ([39.088888,0,0])
        {
            gear (number_of_teeth=11,
                circular_pitch=500*PI/180,
                hub_diameter=0,
                rim_width=65);
            translate ([0,0,8])
            {
                gear (number_of_teeth=6,
                    circular_pitch=300*PI/180,
                    hub_diameter=0,
                    rim_width=5,
                    rim_thickness=6,
                    pressure_angle=31);
                rotate ([0,0,360*5/6])
                translate ([22.5,0,1])
                gear (number_of_teeth=21,
                    circular_pitch=300*PI/180,
                    bore_diameter=2,
                    hub_diameter=4,
                    rim_width=1,
                    hub_thickness=4,
                    rim_thickness=4,
                    gear_thickness=3,
                    pressure_angle=31);
            }
        }

        translate ([-61.1111111,0,0])
        {
            gear (number_of_teeth=27,
                circular_pitch=500*PI/180,
                circles=6,
                circle_diameter=12,
                spokes=6,
                gear_thickness=2,
                hub_thickness=10,
                centered_gear=true,
                spoke_thickness=3,
                hub_diameter=2*8.88888889);

            translate ([-37.5,0,0])
            rotate ([0,0,-90])
            rack (
                circular_pitch=500*PI/180
                 );

            translate ([0,0,10])
            {
                gear (
                    number_of_teeth=14,
                    circular_pitch=200*PI/180,
                    pressure_angle=5,
                    twist=30,
                    clearance = 0.2,
                    gear_thickness = 10,
                    rim_thickness = 10,
                    rim_width = 15,
                    bore_diameter=5,
                    circles=0);
                translate ([13.8888888,0,1])
                gear (
                    number_of_teeth=10,
                    circular_pitch=200*PI/180,
                    pressure_angle=5,
                    clearance = 0.2,
                    gear_thickness = 10,
                    rim_thickness = 8,
                    twist=-30*8/10,
                    rim_width = 15,
                    hub_thickness = 10,
                    centered_hub=true,
                    hub_diameter=7,
                    bore_diameter=4,
                    circles=0);
            }
        }

        rotate ([0,0,360*-5/17])
        translate ([44.444444444,0,0])
        gear (number_of_teeth=15,
            circular_pitch=500*PI/180,
            hub_diameter=10,
            rim_width=5,
            rim_thickness=5,
            gear_thickness=4,
            hub_thickness=6,
            circles=9);

        rotate ([0,0,360*-1/17])
        translate ([30.5555555,0,-1])
        gear (number_of_teeth=5,
            circular_pitch=500*PI/180,
            hub_diameter=0,
            rim_width=5,
            rim_thickness=10);
    }
}

module test_backlash ()
{
    backlash = 2;
    teeth = 15;

    translate ([-29.166666,0,0])
    {
        translate ([58.3333333,0,0])
        rotate ([0,0,-360/teeth/4])
        gear (
            number_of_teeth = teeth,
            circular_pitch=700*PI/180,
            gear_thickness = 12,
            rim_thickness = 15,
            rim_width = 5,
            hub_thickness = 17,
            hub_diameter=15,
            bore_diameter=5,
            backlash = backlash,
            circles=8);

        rotate ([0,0,360/teeth/4])
        gear (
            number_of_teeth = teeth,
            circular_pitch=700*PI/180,
            gear_thickness = 12,
            rim_thickness = 15,
            rim_width = 5,
            hub_thickness = 17,
            hub_diameter=15,
            bore_diameter=5,
            backlash = backlash,
            circles=8);
    }

    color([0,0,1,0.5])
    translate([0,0,-5])
    cylinder ($fn=20,r=backlash / 4,h=25);
}


//
// OLD
//

    module meshing_double_helix ()
    {
        test_double_helix_gear ();

        mirror ([0,1,0])
        translate ([58.33333333,0,0])
        test_double_helix_gear (teeth=13,circles=6);
    }

    module test_double_helix_gear (
        teeth=17,
        circles=8)
    {
        //double helical gear
        {
            twist=200;
            height=20;
            pressure_angle=30;

            gear (number_of_teeth=teeth,
                circular_pitch=700*PI/180,
                pressure_angle=pressure_angle,
                clearance = 0.2,
                gear_thickness = height/2*0.5,
                rim_thickness = height/2,
                rim_width = 5,
                hub_thickness = height/2*1.2,
                hub_diameter=15,
                bore_diameter=5,
                circles=circles,
                twist=twist/teeth);
            mirror([0,0,1])
            gear (number_of_teeth=teeth,
                circular_pitch=700*PI/180,
                pressure_angle=pressure_angle,
                clearance = 0.2,
                gear_thickness = height/2,
                rim_thickness = height/2,
                rim_width = 5,
                hub_thickness = height/2,
                hub_diameter=15,
                bore_diameter=5,
                circles=circles,
                twist=twist/teeth);
        }
    }

    module gear (
        number_of_teeth=15,
        circular_pitch=undef, diametral_pitch=undef,
        pressure_angle=28,
        clearance = undef,
        gear_thickness=5,
        rim_thickness=undef,
        rim_width=undef,
        hub_thickness=undef,
        hub_diameter=undef,
        spokes=0,
        spoke_width=undef,
        spoke_thickness=undef,
        spoke_square=false,
        centered_gear=false,
        centered_hub=false,
        bore_diameter=undef,
        circles=0,
        circle_diameter=undef,
        backlash=0,
        twist=0,
        involute_facets=undef,
        flat=false)
    {
        
        // Check for undefined circular pitch (happens when neither circular_pitch or diametral_pitch are specified)
        if (circular_pitch==undef)
            echo("MCAD ERROR: gear module needs either a diametral_pitch or circular_pitch");

        //Convert diametrial pitch to our native circular pitch
        circular_pitch = (circular_pitch!=undef?circular_pitch:PI/diametral_pitch);

        // Calculate default clearance if not specified
        clearance = (clearance!=undef?clearance:0.25 * circular_pitch / PI);

        // Pitch diameter: Diameter of pitch circle.
        pitch_diameter = number_of_teeth * circular_pitch / PI;
        pitch_radius = pitch_diameter/2;
        echo (str("Teeth: ", number_of_teeth, ", Pitch Radius: ", pitch_radius, ", Clearance: ", clearance));

        // Base Circle
        base_radius = pitch_radius*cos(pressure_angle);

        // Diametrial pitch: Number of teeth per unit length.
        pitch_diametrial = number_of_teeth / pitch_diameter;

        // Addendum: Radial distance from pitch circle to outside circle.
        addendum = 1/pitch_diametrial;

        //Outer Circle
        outer_radius = pitch_radius+addendum;

        // Dedendum: Radial distance from pitch circle to root diameter
        dedendum = addendum + clearance;

        // Root diameter: Diameter of bottom of tooth spaces.
        root_radius = pitch_radius-dedendum;
        backlash_angle = backlash / pitch_radius * 180 / PI;
        half_thick_angle = (360 / number_of_teeth - backlash_angle) / 4;


        // Variables controlling the rim.
        rim_thickness = (rim_thickness!=undef?(rim_thickness!=0?rim_thickness:gear_thickness):gear_thickness * 1.5);
        rim_width = (rim_width!=undef?rim_width:root_radius * .1);
        rim_radius = root_radius - rim_width;
        
        
        // if rim_width is not specified, assume 10% of root_radius
        rimWidthPercent=(rim_width==undef?0.1:0);
        

        // Variables controlling the hub
        hub_thickness = (hub_thickness!=undef?(hub_thickness!=0?hub_thickness:gear_thickness):gear_thickness * 2);
        hub_diameter = (hub_diameter!=undef?hub_diameter:root_radius * .3);
        hub_base = (centered_hub == false)? 0 : rim_thickness/2 - hub_thickness/2;

        // Variables controlling the spokes
        spokes = spokes == undef? 0 : spokes;
        spoke_thickness = (spoke_thickness == undef)? rim_thickness : spoke_thickness;
        spoke_width = (spokes==0)? 1 : (spoke_width == undef)?  0.75 * PI * hub_diameter / spokes : spoke_width; 
        //spoke_depth is depth spoke must penetrate into hub to ensure complete penetration
        spoke_depth = ((hub_diameter/2)^2-(spoke_width/2)^2)^0.5 +.01;
        //spoke length is length of spoke including the depth sunk into the hub
        spoke_length = spoke_depth+rim_radius-(hub_diameter/2.0);
        //spoke raius is the distance from gear center to base of the spoke(inside the hub)
        spoke_radius = (hub_diameter/2.0)-spoke_depth;
        //echo (str("spoke_width: ",spoke_width,", hub_diameter: ",hub_diameter, ", spoke_depth: ",spoke_depth));
        
        // Variables controlling the bore
        bore_diameter = bore_diameter!=undef?bore_diameter:root_radius * .1;

        // Variables controlling the circular holes in the gear.
        circle_orbit_diameter=hub_diameter/2+rim_radius;
        circle_orbit_curcumference=PI*circle_orbit_diameter;

        // Limit the circle size to 90% of the gear face.
        circle_default_diameter = min (
            0.70*circle_orbit_curcumference/circles, 
            (rim_radius+hub_diameter/2)*0.9);
        circle_diameter=(circle_diameter != undef)? circle_diameter : circle_default_diameter;
        echo(str("cir_orb_dia: ", circle_orbit_diameter, ", cir_orb_circumf: ", circle_orbit_curcumference, ", default cir dia: ",circle_default_diameter, ", cir_dia:",circle_diameter));
        
        difference() {
            union () {
                difference () {
                    //start with a plane toothed disk gear
                    linear_extrude_flat_option(flat=flat, height=rim_thickness, convexity=10, twist=twist)

//                    gear2D (
//                        number_of_teeth=number_of_teeth,
//                        circular_pitch=circular_pitch, diametral_pitch=diametral_pitch,
//                        pressure_angle=pressure_angle,
//                        clearance = clearance,
//                        backlash=backlash,
//                        involute_facets=involute_facets//,
//                        //rimWidthPercent=rimWidthPercent,
//                        //rimWidth=rim_width
//                    );
                     gear_shape (
                         number_of_teeth,
                         pitch_radius = pitch_radius,
                         root_radius = root_radius,
                         base_radius = base_radius,
                         outer_radius = outer_radius,
                         half_thick_angle = half_thick_angle,
                         involute_facets=involute_facets);

                    //if we have a 0 hub thickness, then hub must be removed
                    if (hub_thickness == 0)
                        translate ([0,0,-1])
                        cylinder (r=rim_radius,h=rim_thickness+2);
                    //if the rim is thicker than the gear, carve out gear body
                    else if (rim_thickness>gear_thickness){
                        //if not centered, carve out only the top
                        if (centered_gear == false){
                            translate ([0,0,gear_thickness])
                            cylinder (r=rim_radius,h=rim_thickness);
                        } else
                            //carve out half from top and half from bottom
                            union () {
                                translate ([0,0,(gear_thickness + rim_thickness)/2])
                                    cylinder (r=rim_radius,h=rim_thickness+1);
                                translate ([0,0,-1 -(gear_thickness + rim_thickness)/2])
                                    cylinder (r=rim_radius,h=rim_thickness+1);
                            }                
                    }
                }
                
                //extend the gear body if gear_thickness > rim_thickness unless spoked, 
                if (gear_thickness > rim_thickness) {
                    if (centered_gear == false) {
                        linear_extrude_flat_option(flat=flat, height=gear_thickness)
                        circle (r=rim_radius);
                    } else {
                        translate ([0,0,-(gear_thickness - rim_thickness)/2])
                        linear_extrude_flat_option(flat=flat, height=gear_thickness)
                        circle (r=rim_radius);
                    }
                    //if rim is thicker than body, body protrudes into rim
                }
                //add the hub
                translate ([0,0,hub_base])
                linear_extrude_flat_option(flat=flat, height=hub_thickness)
                    circle (r=hub_diameter/2);
                
                //add in spokes
                if (spokes>0) {          
                    for(i=[0:spokes-1])
                        translate([0,0,rim_thickness/2])
                        rotate([90,0,i*360/spokes])
                        translate([0,0,spoke_radius]) {
                            if (spoke_square==true){
                                resize([spoke_width,spoke_thickness,spoke_length])
                                translate([0,0,.5])
                                cube(1,center=true);
                            }
                            if (spoke_square==false){
                                resize([spoke_width,spoke_thickness,spoke_length])
                                cylinder(h=10,d=10);
                            }
                        }
                }
            }
            
            //remove the center bore
            translate ([0,0,-1])
            linear_extrude_flat_option(flat =flat, height=2+max(rim_thickness,hub_thickness,gear_thickness))
            circle (r=bore_diameter/2);
            
            //remove circles from gear body
            if (circles>0) {
                for(i=[0:circles-1])
                    rotate([0,0,i*360/circles])
                    translate([circle_orbit_diameter/2,0,-1])
                    linear_extrude_flat_option(flat =flat, height=max(gear_thickness,rim_thickness)+3)
                    circle(r=circle_diameter/2);
            }
        }
    }
    
    module gear2Dxxx (
        number_of_teeth=15,
        circular_pitch=undef, diametral_pitch=undef,
        pressure_angle=28,
        clearance=undef,
        backlash=0,
        involute_facets=undef
        //,rimWidthPercent=undef
        //,rimWidth=undef,
        //,aaa=1
    ) {
        // Check for undefined circular pitch (happens when neither circular_pitch or diametral_pitch are specified)
        //if (circular_pitch==undef&&diametral_pitch==undef)
        //    echo("MCAD ERROR: gear module needs either a diametral_pitch or circular_pitch");
        e1=ErrorIf( circular_pitch==undef&&diametral_pitch==undef, "circular or diametral pitch missing" );

        //Convert diametrial pitch to our native circular pitch
        circular_pitch = (circular_pitch!=undef?circular_pitch:PI/diametral_pitch);

        // Calculate default clearance if not specified
        clearance = (clearance!=undef?clearance:0.25 * circular_pitch / PI);

        // Pitch diameter: Diameter of pitch circle.
        pitch_diameter  =  number_of_teeth * circular_pitch / PI;
        pitch_radius = pitch_diameter/2;
        //echo (str("Teeth: ", number_of_teeth, ", Pitch Radius: ", pitch_radius, ", Clearance: ", clearance));

        // Base Circle
        base_radius = pitch_radius*cos(pressure_angle);

        // Diametrial pitch: Number of teeth per unit length.
        pitch_diametrial = number_of_teeth / pitch_diameter;

        // Addendum: Radial distance from pitch circle to outside circle.
        addendum = 1/pitch_diametrial;

        //Outer Circle
        outer_radius = pitch_radius+addendum;

        // Dedendum: Radial distance from pitch circle to root diameter
        dedendum = addendum + clearance;

        // Root diameter: Diameter of bottom of tooth spaces.
        root_radius = pitch_radius-dedendum;
        backlash_angle = backlash / pitch_radius * 180 / PI;
        half_thick_angle = (360 / number_of_teeth - backlash_angle) / 4;

        //rim_width = (rim_width!=undef?rim_width:root_radius * .1);
        //rim_radius = root_radius - rim_width;
        // default rimWidthPercent = 10%
    //    rim_radius=(rimWidthPercent==undef&&rimWidth==undef)?0:
    //        root_radius
    //        -((rimWidthPercent==undef)?0:rimWidthPercent*root_radius)
    //        -((rimWidth       ==undef)?0:rimWidth);

        //translate([aaa*pitch_diameter/2,0,0])
        gear_shape (
            number_of_teeth,
            pitch_radius = pitch_radius,
            root_radius = root_radius,
            base_radius = base_radius,
            outer_radius = outer_radius,
            half_thick_angle = half_thick_angle,
            involute_facets = involute_facets);
            
       color("red")
       translate([0,0,2])
       circle(r=base_radius);
        
       color("blue")
       translate([0,0,1])
       circle(r=root_radius);
    //    circle(r=root_radius);
    }

    //translate([0,0,180])
    //gear (
    //    circular_pitch=70,
    //    
    //    rim_thickness = 20,
    //rim_width=30,
    //    hub_thickness = 30,
    //centered_gear=true,
    //centered_hub=true,
    ////involute_facets=40,
    //
    //    gear_thickness = 0, spokes=8, circles=0
    ////    gear_thickness = 10, spokes=0, circles=8
    //
    //);


    //GearNew (
    //    circular_pitch=70,
    //    
    ////    gear_thickness = 20,
    //    gear_thickness = 0,
    //    
    //    rim_thickness = 20,
    //rim_width=30,
    //    hub_thickness = 30,
    //
    ////centered_gear=true,
    //centered_gear=false,
    //
    //centered_hub=false,
    ////centered_hub=true,
    //
    ////involute_facets=40,
    //    spokes=8,
    //    circles=8);

    //GearNew (
    //    circular_pitch=70,
    //    
    ////    gear_thickness = 20,
    //    gear_thickness = 0,
    //    
    //    rim_thickness = 20,
    //rim_width=30,
    //    hub_thickness = 30,
    //
    ////centered_gear=true,
    //centered_gear=false,
    //
    //centered_hub=false,
    ////centered_hub=true,
    //
    ////involute_facets=40,
    //    spokes=8,
    //    circles=8);
    
    module GearNew(
        number_of_teeth=15,
        circular_pitch=undef, diametral_pitch=undef,
        pressure_angle=28,
        clearance = undef,
        
//        hole      = undef, // central hole
//        rim       = undef, // [ width, thickness ]
//        hub       = undef, // [ diameter, thickness, centered ]
//        body      = undef, // [ thickness, centered ]
//        spokes    = undef, // [ count, width, thickness, squared ]
//        holeArray = undef, // [ count, diameter ]
        
        gear_thickness=5,
        rim_thickness=undef,
        rim_width=undef,
        hub_thickness=undef,
        hub_diameter=undef,
        spokes=0,
        spoke_width=undef,
        spoke_thickness=undef,
        spoke_square=false,
        centered_gear=false,
        centered_hub=false,
        
        bore_diameter=undef,
        circles=0,
        circle_diameter=undef,
        
        backlash=0,
        twist=0,
        involute_facets=undef,
        flat=false)
    {
        
        // Check for undefined circular pitch (happens when neither circular_pitch or diametral_pitch are specified)
        if (circular_pitch==undef)
            echo("MCAD ERROR: gear module needs either a diametral_pitch or circular_pitch");

        //Convert diametrial pitch to our native circular pitch
        circular_pitch = (circular_pitch!=undef?circular_pitch:PI/diametral_pitch);

        // Calculate default clearance if not specified
        clearance = (clearance!=undef?clearance:0.25 * circular_pitch / PI);

        // Pitch diameter: Diameter of pitch circle.
        pitch_diameter = number_of_teeth * circular_pitch / PI;
        pitch_radius = pitch_diameter/2;
        echo (str("Teeth: ", number_of_teeth, ", Pitch Radius: ", pitch_radius, ", Clearance: ", clearance));

        // Base Circle
        base_radius = pitch_radius*cos(pressure_angle);

        // Diametrial pitch: Number of teeth per unit length.
        pitch_diametrial = number_of_teeth / pitch_diameter;

        // Addendum: Radial distance from pitch circle to outside circle.
        addendum = 1/pitch_diametrial;

        //Outer Circle
        outer_radius = pitch_radius+addendum;

        // Dedendum: Radial distance from pitch circle to root diameter
        dedendum = addendum + clearance;

        // Root diameter: Diameter of bottom of tooth spaces.
        root_radius = pitch_radius-dedendum;
        backlash_angle = backlash / pitch_radius * 180 / PI;
        half_thick_angle = (360 / number_of_teeth - backlash_angle) / 4;

        // Variables controlling the rim.
        rim_thickness = (rim_thickness!=undef?(rim_thickness!=0?rim_thickness:gear_thickness):gear_thickness * 1.5);
        rim_width = (rim_width!=undef?rim_width:root_radius * .1);
        rim_radius = root_radius - rim_width;
        
        
        
        
        
        // HUB
        hub_thickness = (hub_thickness!=undef?(hub_thickness!=0?hub_thickness:gear_thickness):gear_thickness * 2);
        hub_diameter = (hub_diameter!=undef?hub_diameter:root_radius * .3);
        hub_base = (centered_hub == false)? 0 : rim_thickness/2 - hub_thickness/2;

        // SPOKES
        //spokes = spokes == undef? 0 : spokes;
        spoke_thickness = (spoke_thickness == undef)? rim_thickness : spoke_thickness;
        spoke_width = (spokes==0)? 1 : (spoke_width == undef)?  0.75 * PI * hub_diameter / spokes : spoke_width; 
        spoke_length=rim_radius+(root_radius-rim_radius)/2;        
        
        // CIRCULAR HOLES
        circle_orbit_diameter=hub_diameter/2+rim_radius;
        circle_orbit_curcumference=PI*circle_orbit_diameter;
        circle_default_diameter = // Limit the circle size to 90% of the gear face.
            min( 0.70*circle_orbit_curcumference/circles, 
                (rim_radius+hub_diameter/2)*0.9);
        circle_diameter=(circle_diameter != undef)? circle_diameter : circle_default_diameter;
                
        // CENTER HOLE
        bore_diameter = bore_diameter!=undef?bore_diameter:root_radius * .1;
        
        difference() {
            union() {
                //
                // RIM WITH TEETH
                //
                linear_extrude(height=rim_thickness,center=true,convexity=10,twist=twist)
                difference() {
                    gear2D (
                        number_of_teeth=number_of_teeth,
                        circular_pitch=circular_pitch, diametral_pitch=diametral_pitch,
                        pressure_angle=pressure_angle,
                        clearance = clearance,
                        backlash=backlash,
                        involute_facets=involute_facets
                    );
                    circle(r=rim_radius);
                }
        
                //
                // BODY
                //
                gearOffset=(centered_gear?0:gear_thickness/2-rim_thickness/2);
                translate ([0,0,gearOffset])
                linear_extrude(height=gear_thickness,center=true)
                if (circles>0)
                    difference() {
                        circle(r=rim_radius);
                        rotate([0,0,360/circles/2])
                        circles( circles, circle_diameter,circle_orbit_diameter);
                    }
                else
                    circle(r=rim_radius);
        
                //
                // HUB
                //
                translate ([0,0,hubOffset])
                linear_extrude(height=hub_thickness,center=true)
                    circle(d=hub_diameter);
        
                //
                // SPOKES
                //
                spokes(spokes,
                    spoke_width,spoke_thickness,spoke_length,
                    square=spoke_square);
            }
            
            //
            // HOLE
            //
            hubOffset=(centered_hub?0:hub_thickness/2-rim_thickness/2);
            translate ([0,0,hubOffset])
            linear_extrude(height=2+max(rim_thickness,gear_thickness,hub_thickness),center=true)
            circle (d=bore_diameter);
        }
        
    }

    module rack(
            number_of_teeth=15,
            circular_pitch=false, diametral_pitch=false,
            pressure_angle=28,
            clearance=0.2,
            rim_thickness=8,
            rim_width=5,
            flat=false)
    {

        if (circular_pitch==false && diametral_pitch==false)
            echo("MCAD ERROR: gear module needs either a diametral_pitch or circular_pitch");

        //Convert diametrial pitch to our native circular pitch
        circular_pitch = (circular_pitch!=false?circular_pitch:PI/diametral_pitch);
        pitch = circular_pitch;

        addendum = circular_pitch / PI;
        dedendum = addendum + clearance;
        pitch_slope = tan(pressure_angle);

        linear_extrude_flat_option(flat=flat, height=rim_thickness)
            union() {
                translate([0,-dedendum-rim_width/2])
                    square([number_of_teeth*pitch, rim_width],center=true);

                p1 = pitch / 4 + pitch_slope * dedendum;
                p2 = pitch / 4 - pitch_slope * addendum;
                for(i=[1:number_of_teeth])
                    translate([pitch*(i-number_of_teeth/2-0.5),0])
                        polygon(points=[
                                [-p1,-dedendum],
                                [p1,-dedendum],
                                [p2,addendum],
                                [-p2,addendum]
                        ]);
            }
    }

    module linear_extrude_flat_option(flat =false, height = 10, center = false, convexity = 2, twist = 0)
    {
        if(flat==false) {
            linear_extrude(height = height, center = center, convexity = convexity, twist= twist) children(0);
        } else {
            children(0);
        }
    }