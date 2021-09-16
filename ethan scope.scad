include <bearing-flange.scad>
include <nuts-bolts.scad>
include <timing-pulley.scad>
include <stepper-motor.scad>
include <thrust-bearing.scad>
include <panel-tnut-notched.scad>
include <orientation.scad>
include <positioning.scad>
include <stepper-motor-assembly.scad>
include <misc-items.scad>

//$fn=20;

module panelColor() { color( "green", 0.5 ) children(); }

//
//
//

    Body();
    ControlButtons();
    Platform( 0 );
    UpperFlange();
    UpperMotor();
    ShowPCB();
    translate( [0,-mainWidth/2,0] )
        rotate( [90,0,0] )
        JoyStick();

    // thrustBearingProfile = [ "tb", model, innerDiameter, outerDiameter, height ]
    thrustBearingProfile = ThrustBearingFromLibrary( "AKX4565" );

    translate( [0,0,-kvGet(thrustBearingProfile,"thickness")-10] )
        ThrustBearing( thrustBearingProfile );

//
// GLOBALS
//

    metalThickness = 3;
    controlBoxHeight = 75;

    mainWidth  = 180;
    mainDepth  = 80;
    mainHeight = 155;

    allowanceForTNut = 10; // extra material for t-nut

    platformAxleHeight = 120;

    rightSectionWidth = 63;
    stepperMotorHoleDepth = 35;
    
    shaftDiameter = 8;

    platformHeightOffset   = 30; // from axle to platform

    platformDepth          = 80;
    platformLeftOffset     = 20;
    platformRightOffset    = 65;
    
    platformConnectorWidth = 60; // width of axle connectors

    flangeBearing_PROFILE = FlangeBearingProfile(
        shaftDiameter=8, boltDiameter=5, boltDistance=36.5,
        width=48, depth=27, height=13, baseHeight=4 );

    panelNUT = NutProfile( shape="hex", boltDiameter=3, nutDiameter=5.5, thickness=2.5 );
//    panelBoltLength = 15;
//    panelNutEdgeGap = 10;

    // tnutProfile  = [ nutProfile, boltLength, edgeGap ];
    T_NUT_PROFILE = TNutCageProfile(
        connectedPanelThickness = metalThickness,
//        boltDiameter = 3,
        nutProfile = panelNUT,
        boltLength = 12,
        nutEdgeGap = 5
    );
    //[ panelNUT, panelBoltLength, panelNutEdgeGap ];

//    notchWidthAllowance  = 0.2; // allowance for notch width
//    notchHeightAllowance = 0.1; // allowance for notch height

    // notchProfile = [ notchHeight, widthAllowance, heightAllowance ];
    NOTCH_PROFILE = NotchProfile(
        panelThickness = metalThickness,
        holeWidthAllowance = 0.2,
        holeHeightAllowance = 0.1
    );
    // [ metalThickness, notchWidthAllowance, notchHeightAllowance ];

    buttonProfile = ButtonBuildProfile(
        model = "Shopee",
        holeSize      = 16,
        presserColor  = "red",
        presserRing   = [ 14,  1 ],
        panelRing     = [ 18,  2 ],
        bodyRing      = [ 16, 12 ],
        connectorRing = [ 10,  6 ]
    );

//
// PLATFORM
//

    module Platform( angle ) {

        translate( [0,0,platformAxleHeight] )
        rotate( [angle,0,0] )  {
            // scope
            translate( [0,0,platformHeightOffset] )
                rotate( [0,0,90] )
                SpottingScope();
            // platform
            translate( [0,0,platformHeightOffset-metalThickness/2] )
                linear_extrude( metalThickness, center=true ) platformDXF();
            // left connector
            leftPos = mainWidth/2-platformLeftOffset;
            translate( [-leftPos,0,0] )
                rotate( [90,0,90] )
                linear_extrude( metalThickness, center=true ) platformConnectorDXF();
            // right connector
            rightPos = mainWidth/2-platformRightOffset;
            translate( [rightPos,0,0] )
                rotate( [90,0,90] )
                linear_extrude( metalThickness, center=true ) platformConnectorDXF();
            // shaft
            color( "blue" )
                rotate( [0,90,0] )
                cylinder(mainWidth,d=shaftDiameter,center=true);                
        }
    }

    module platformDXF() {

        edgeGap = 3;

        difference() {
            square( [mainWidth-edgeGap*2,platformDepth], center=true );
            {
                leftPos = mainWidth/2-platformLeftOffset;
                translate( [-leftPos,0,0] )
                    rotate( [0,0,90] )
                    TNutCageNotched_F( platformConnectorWidth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
                rightPos = mainWidth/2-platformRightOffset;
                translate( [rightPos,0,0] )
                    rotate( [0,0,90] )
                    TNutCageNotched_F( platformConnectorWidth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
            }
        }
    }

    module platformConnectorDXF() {        
        difference() {
            union() {
                translate( [0,platformHeightOffset/2,0] )
                    square( [platformConnectorWidth,platformHeightOffset], center=true );
                circle( d=platformConnectorWidth );
            }
            {
                translate( [0,platformHeightOffset,0] )
                TNutCageNotched_M( platformConnectorWidth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
                circle( d=shaftDiameter );
            }
        }
    }
        
//
// BODY
//
    
    module Body() {
        // lower flange bearing
        translate( [0,0,metalThickness] )
        rotate( [0,0,90] )
        FlangeBearing( flangeBearing_PROFILE );

        // upper flange bearing
        translate( [0,0,controlBoxHeight-metalThickness] )
        rotate( [180,0,90] )
        FlangeBearing( flangeBearing_PROFILE );

        // stepper motor
        translate( [0,0,controlBoxHeight] )
        translate( [-pulleyToPulleyDistance,0,0] )
        rotate( [180,0,0] )
        StepperMotorAssembly( motorProfile, motorPulleyProfile, drivenPulleyProfile, 
            beltLength, pulleyOffset=pulleyToMotorOffset,
            reverseDrivenPulley=false, omitTeeth=true );

        // shaft
        translate( [0,0,-30-metalThickness] )
        color( "blue" )
        cylinder(controlBoxHeight+30,r=4);

        // color( "red", 0.5 )
        color( "red" ) panelTop_Matrix()    linear_extrude( metalThickness, center=true ) panelTopDXF();
        color( "red" ) panelBottom_Matrix() linear_extrude( metalThickness, center=true ) panelBottomDXF();
        // panelColor()
        panelLeft_Matrix()           linear_extrude( metalThickness, center=true ) panelLeftDXF();
        panelRight_Matrix()          linear_extrude( metalThickness, center=true ) panelRightDXF();
        panelRightInnerWall_Matrix() linear_extrude( metalThickness, center=true ) panelRightInnerWallDXF();
    }
        
    //
    // DXF TO 3D POSITION
    //
    
    module panelTop_Matrix() {
        OTop( metalThickness,controlBoxHeight)
        //translate( [0,0,controlBoxHeight-metalThickness/2] )
        children();
    }

    module panelBottom_Matrix() {
        OBottom( metalThickness, 0,0,0 )
        //translate( [0,0,metalThickness/2] )
        children();
    }

    module panelLeft_Matrix() {
        OLeft( metalThickness, mainWidth/2,0,0 )
        //translate( [-mainWidth/2+metalThickness/2,0,0] )
        //rotate( [90,0,90] )
        children();
    }

    module panelRight_Matrix() {
        ORight( metalThickness, mainWidth/2,0,0 )
        //translate( [mainWidth/2-metalThickness/2,0,0] )
        //rotate( [90,0,90] )
        children();
    }

    module panelRightInnerWall_Matrix() {
        ORight( metalThickness, mainWidth/2-rightSectionWidth,0,0, false )
        //translate( [mainWidth/2-metalThickness/2-rightSectionWidth,0,0] )
        //rotate( [90,0,90] )
        children();
    }
    
    //
    // PANELS DXF
    //
    
    module panelTopDXF() {
        // cut a hole for the motor
        difference() {
            square( [mainWidth,mainDepth], center=true );
            union() {
                // left notches
                translate( [-mainWidth/2,0,0] )
                rotate( [0,0,90] )
                    TNutCageNotched_M( mainDepth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
                // right section wall
                s = ( mainDepth - stepperMotorHoleDepth )/2;
                offset = mainDepth/2-s/2;
                translate( [mainWidth/2-rightSectionWidth-metalThickness/2,offset,0] )
                rotate( [0,0,-90] )
                    TNutCageNotched_F( s, 0, T_NUT_PROFILE, NOTCH_PROFILE );
                translate( [mainWidth/2-rightSectionWidth-metalThickness/2,-offset,0] )
                rotate( [0,0,-90] )
                   TNutCageNotched_F( s, 0, T_NUT_PROFILE, NOTCH_PROFILE );
                // motor hole
                translate( [-rightSectionWidth/2+mainWidth/2+0.5,0,0] )
                    square( [rightSectionWidth+1,stepperMotorHoleDepth], center=true );
                // right inner wall
                translate( [-rightSectionWidth+mainWidth/2-metalThickness/2+0.5,0,0] )
                    square( [metalThickness+1,stepperMotorHoleDepth], center=true );                
                // right notches
                translate( [mainWidth/2,offset,0] )
                rotate( [0,0,-90] )
                    TNutCageNotched_M( s, 0, T_NUT_PROFILE, NOTCH_PROFILE );
                translate( [mainWidth/2,-offset,0] )
                rotate( [0,0,-90] )
                    TNutCageNotched_M( s, 0, T_NUT_PROFILE, NOTCH_PROFILE );
                // flange bearing
                rotate( [0,0,90] )
                    FlangeBearingPanelHole( flangeBearing_PROFILE, omitCenterHole=true, enlargeShaft=2 );
                // stepper motor
                rotate( [0,0,90] )
                translate( [0,pulleyToPulleyDistance,0] )
                    StepperMotor( motorProfile );
                    // Nema17MountingHoles();
            }
        }
    }
    
    module panelBottomDXF() {
        difference() {
            square( [mainWidth,mainDepth], center=true );
            union() {
                // left notches
                translate( [-mainWidth/2,0,0] )
                rotate( [0,0,90] )
                    TNutCageNotched_M( mainDepth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
                // right section wall
                translate( [mainWidth/2-rightSectionWidth-metalThickness/2,0,0] )
                rotate( [0,0,90] )
                    TNutCageNotched_F( mainDepth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
                // right notches
                translate( [mainWidth/2,0,0] )
                rotate( [0,0,-90] )
                    TNutCageNotched_M( mainDepth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
                // flange bearing
                rotate( [0,0,90] )
                    FlangeBearingPanelHole( flangeBearing_PROFILE, enlargeShaft=2 );
                // pcb
                panelBottomDXF_Extra();
            }
        }
    }
    
    module panelLeftDXF() {
        difference() {
            union() {
                translate( [0,mainHeight/2,0] )
                    square( [mainDepth,mainHeight+allowanceForTNut], center=true );
                translate( [0,mainHeight+metalThickness,0] )
                    scale( [1,0.5,1] )
                    circle( d=mainDepth );
            }
            {
                // top notch holes
                translate( [0,metalThickness/2+controlBoxHeight-metalThickness,0] )
                    TNutCageNotched_F( mainDepth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
                // bottom notch holes
                translate( [0,metalThickness/2,0] )
                    TNutCageNotched_F( mainDepth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
                // flange bearing
                translate( [0,platformAxleHeight,0] )
                    FlangeBearingPanelHole( flangeBearing_PROFILE, enlargeShaft=2 );
            }
        }
    }

    module panelRightDXF() {
        difference() {
            union() {
                translate( [0,mainHeight/2,0] )
                    square( [mainDepth,mainHeight+allowanceForTNut], center=true );
                translate( [0,mainHeight+metalThickness,0] )
                    scale( [1,0.5,1] )
                    circle( d=mainDepth );
            }
            {
                // top notch holes
                s = ( mainDepth - stepperMotorHoleDepth )/2;
                offset = mainDepth/2-s/2;
                translate( [offset,metalThickness/2+controlBoxHeight-metalThickness,0] )
                    TNutCageNotched_F( s, 0, T_NUT_PROFILE, NOTCH_PROFILE );
                translate( [-offset,metalThickness/2+controlBoxHeight-metalThickness,0] )
                    TNutCageNotched_F( s, 0, T_NUT_PROFILE, NOTCH_PROFILE );
                // bottom notch holes
                translate( [0,metalThickness/2,0] )
                    TNutCageNotched_F( mainDepth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
                // flange bearing
                translate( [0,platformAxleHeight,0] )
                    FlangeBearingPanelHole( flangeBearing_PROFILE, enlargeShaft=2 );
                // stepper motor                
                translate( [0,platformAxleHeight-pulleyToPulleyDistance,0] )
                    // Nema17MountingHoles();
                    StepperMotorPanelHoles( motorProfile );
            }
        }
    }
    
    module panelRightInnerWallDXF() {
        difference() {
            translate( [0,controlBoxHeight/2,0] )
                square( [mainDepth,controlBoxHeight], center=true );
            {
                // top notches
                s = ( mainDepth - stepperMotorHoleDepth )/2;
                offset = mainDepth/2-s/2;
                translate( [offset,controlBoxHeight,0] )
                    TNutCageNotched_M( s, 0, T_NUT_PROFILE, NOTCH_PROFILE );
                translate( [-offset,controlBoxHeight,0] )
                    TNutCageNotched_M( s, 0, T_NUT_PROFILE, NOTCH_PROFILE );
                // bottom notches
                rotate( [0,0,180] ) {
                    TNutCageNotched_M( mainDepth, 2, T_NUT_PROFILE, NOTCH_PROFILE );
                }
                // pcb
                panelRightInnerWallDXF_Extra();
            }
        }
    }

//
// STEPPER MOTOR
//

    motorProfile = StepperMotorProfile( bodyDiameter=42.20, bodyLength=35+40, shaftDiameter=5, shaftLength=18,
        boltDiameter = 4, boltLength = 5, boltDistance = 20,
        frontCylinder = [38,40],
        flangeThickness = [4.8,0],
        bodyTaper=1 );
//        upperCylinderDiameter=38, upperCylinderHeight=40,
//        upperFlangeHeight=4.8, betweenFlangeTaper=-1 );

    motorPulleyProfile = TimingPulleyProfileCAD(
        toothModel         = "GT2 2mm",
        toothCount         = 20,
        beltWidth          = 8,
        shaftDiameter      = 5,
        topFlangeHeight    = 1,
        bottomFlangeHeight = 1,
        hubInfo            = [16,6]
    );

    drivenPulleyProfile = TimingPulleyProfileCAD(
        toothModel         = "GT2 2mm",
        toothCount         = 60,
        beltWidth          = 8,
        shaftDiameter      = 8,
        topFlangeHeight    = 1.5,
        bottomFlangeHeight = 1.5,
        hubInfo            = [20,6]
    );

    beltLength = 158;
    pulleyToMotorOffset = 3;
    pulleyToPulleyDistance = TimingPulleyCenterDistance( motorPulleyProfile, drivenPulleyProfile, beltLength );

//
// PCB
//

    pcbController = CircuitBoardBuildProfile(
        model         = "controller",
        width         = 44,
        length        = 60,
        height        = 8,
        boltWidthGap  = 37,
        boltLengthGap = 52
    );

    pcbDriver = CircuitBoardBuildProfile(
        model         = "driver",
        width         = 42,
        length        = 42,
        height        = 8,
        boltWidthGap  = 36,
        boltLengthGap = 36
    );

    module ShowPCB() {
        panelRightInnerWall_Matrix() panelRightInnerWall_Extra();
        panelBottom_Matrix() panelBottom_Extra();
    }

    module panelRightInnerWall_Extra() {
        translate( [0,0,metalThickness/2] ) {
            translate( [0,35,0] ) rotate( [0,0,90] ) CircuitBoard( pcbController );
        }
    }

    module panelRightInnerWallDXF_Extra() {
        translate( [0,35,0] ) rotate( [0,0,90] ) CircuitBoardHole( pcbController );
    } 

    module panelBottom_Extra() {
        translate( [0,0,metalThickness/2] )
        {
            translate( [-45,0,0] ) rotate( [0,0,90] ) CircuitBoard( pcbController );
            translate( [mainWidth/2-30, 23,0] )       CircuitBoard( pcbDriver );
            translate( [mainWidth/2-30,-23,0] )       CircuitBoard( pcbDriver );
        }
    }

    module panelBottomDXF_Extra() {
        translate( [-45,0,0] ) rotate( [0,0,90] ) CircuitBoardHole( pcbController );
        translate( [mainWidth/2-30, 23,0] )       CircuitBoardHole( pcbDriver );
        translate( [mainWidth/2-30,-23,0] )       CircuitBoardHole( pcbDriver );
    }

//
// CONTROL BUTTONS
//

    module ControlButtons() {
        buttonOffset = 16;
        buttonHeight = 40;
        buttonCenter = 50;
        // direction buttons
        translate( [-buttonCenter,-mainDepth/2,buttonHeight] ) rotate( [0,-90,90] ) 
        {
            translate( [ buttonOffset,0,0] ) Button( buttonProfile );
            translate( [-buttonOffset,0,0] ) Button( buttonProfile );
            translate( [0, buttonOffset,0] ) Button( buttonProfile );
            translate( [0,-buttonOffset,0] ) Button( buttonProfile );
        }
        // speed dials
        translate( [65,-mainDepth/2,37] ) rotate( [90,0,0] ) {
        translate( [0, 16,0] ) Potentiometer();
        translate( [0,-16,0] ) Potentiometer();
        }
    }

    module ControlButtonsHoles() {
        buttonOffset = 16;
        translate( [ buttonOffset,0,0] ) ButtonHole( buttonProfile );
        translate( [-buttonOffset,0,0] ) ButtonHole( buttonProfile );
        translate( [0, buttonOffset,0] ) ButtonHole( buttonProfile );
        translate( [0,-buttonOffset,0] ) ButtonHole( buttonProfile );
    }

    module Potentiometer() {
        color( "violet" )
        cylinder( h=12.2, d1=26.2, d2=25.2 );
    }

//
// UPPER FLANGE BEARING
//
    
    module UpperFlange() {
        translate( [0,0,platformAxleHeight] ) {
            translate( [mainWidth/2-metalThickness,0,0] )
                rotate( [0,-90,0] )
                rotate( [0,0,90] )
                FlangeBearing( flangeBearing_PROFILE );
            translate( [-mainWidth/2+metalThickness,0,0] )
                rotate( [0,90,0] )
                rotate( [0,0,90] )
                FlangeBearing( flangeBearing_PROFILE );
        }
    }

//
// UPPER MOTOR
//
    
    module UpperMotor() {
        translate( [mainWidth/2,0,platformAxleHeight] )
        rotate( [0,-90,0] )
        translate( [-pulleyToPulleyDistance,0,0] )
        StepperMotorAssembly( motorProfile, motorPulleyProfile, drivenPulleyProfile, 
            beltLength, pulleyOffset=pulleyToMotorOffset,
            reverseDrivenPulley=false, omitTeeth=true );
    }

