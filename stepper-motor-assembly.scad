include <timing-pulley.scad>
include <stepper-motor.scad>

    // run me!!!
    //StepperMotorAssembly_Test();

    module StepperMotorAssembly_Test() {

        motorProfile = StepperMotorBuildProfile( bodyWidth=42.20, bodyHeight=35+40, shaftDiameter=5, shaftLength=18,
            boltDiameter = 4, boltLength = 5, boltToBoltDistance = 20,
            upperCylinderDiameter=38, upperCylinderHeight=40,
            upperFlangeHeight=4.8, betweenFlangeTaper=-1 );

        motorPulleyProfile = PulleyBuildCADProfile(
            model          = "GT2 2mm",
            teethCount     = 20,
            beltWidth      = 8,
            shaftDiameter  = 5,
            retainerHeight = 1,
            idlerHeight    = 1,
            baseDiameter   = 16,
            baseHeight     = 6
        );

        drivenPulleyProfile = PulleyBuildCADProfile(
            model          = "GT2 2mm",
            teethCount     = 60,
            beltWidth      = 8,
            shaftDiameter  = 8,
            retainerHeight = 1.5,
            idlerHeight    = 1.5,
            baseDiameter   = 20,
            baseHeight     = 6
        );

        StepperMotorAssembly( motorProfile, motorPulleyProfile, drivenPulleyProfile, 158, 3, false );
    }
    
    module StepperMotorAssembly( motorProfile, motorPulleyProfile, drivenPulleyProfile, beltLength, pulleyOffset, 
    reverseDrivenPulley = false ) {
        StepperMotor( motorProfile );
        translate( [0,0,pulleyOffset])
            PulleyDual( motorPulleyProfile, drivenPulleyProfile, beltLength, reverseDrivenPulley );
    }
