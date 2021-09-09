include <timing-pulley.scad>
include <stepper-motor.scad>

    // run me!!!
    //StepperMotorAssembly_Demo();

    module StepperMotorAssembly_Demo() {

        motorProfile = StepperMotorProfile(
            bodyDiameter    = 42.20,
            bodyLength      = 40, 
            shaftDiameter   = 5,
            shaftLength     = 18,
            boltDiameter    = 4,
            boltLength      = 5,
            boltDistance    = 20,
            frontCylinder   = [ 38, 30 ],
            flangeThickness = [ 4.8, 0 ],
            bodyTaper       = 1
        );

        motorizedPulleyProfile = TimingPulleyProfileCAD(
            toothModel         = "GT2 2mm",
            toothCount         = 20,
            beltWidth          = 8,
            shaftDiameter      = 5,
            flangeOffset       = 2,
            topFlangeHeight    = 1,
            bottomFlangeHeight = 1,
            hubInfo            = [ 16, 6 ]
        );

        drivenPulleyProfile = TimingPulleyProfileCAD(
            toothModel         = "GT2 2mm",
            toothCount         = 60,
            beltWidth          = 8,
            shaftDiameter      = 8,
            flangeOffset       = 2,
            topFlangeHeight    = 1.5,
            bottomFlangeHeight = 1.5,
            hubInfo            = [ 20, 6 ]
        );
        
        beltLength = 158;
        
        StepperMotorAssembly( motorProfile,
            motorizedPulleyProfile, drivenPulleyProfile, beltLength = beltLength, 
            pulleyOffset = 3, reverseDrivenPulley = true );
        
        c2c   = TimingPulleyCenterDistance( motorizedPulleyProfile, drivenPulleyProfile, beltLength );
        shaft = kvGet( drivenPulleyProfile, "shaftDiameter" );
        translate([c2c,0,0])
            cylinder( 100, d=shaft );
    }
    
    module StepperMotorAssembly( motorProfile, motorizedPulleyProfile, drivenPulleyProfile, beltLength,
    pulleyOffset=0, beltWidth, beltThickness=2,
    reverseDrivenPulley = false, omitTeeth=false, showBelt=true ) {
        StepperMotor( motorProfile );
        translate( [0,0,pulleyOffset])
            TimingPulleyConnected( profile1=motorizedPulleyProfile, profile2=drivenPulleyProfile, beltLength=beltLength,
                beltWidth=beltWidth, beltThickness=beltThickness,
                reversed=reverseDrivenPulley, omitTeeth=omitTeeth, showBelt=showBelt );
    }
