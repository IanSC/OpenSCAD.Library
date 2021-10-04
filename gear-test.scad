use <gear.scad>
use <involute_gears.scad>

//$fn=100;

//////////////////////////////////////////////////////////////////////////////////////////////
// example gear train.  
// Try it with OpenSCAD View/Animate command with 20 steps and 24 FPS.
// The gears will continue to be rotated to mesh correctly if you change the number of teeth.

n1 = 148;
n2 = 12;

mm_per_tooth = 9;
clearance    = 0.25;
fn           = 300;

c2c = pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n2);

echo( str("center-to-center distance=", c2c) );

translate( [0,0,0] )
    rotate( [0,0,$t*360/n1] )
    color( [1.00,0.75,0.75] )
    gear2D( mm_per_tooth, n1, 16*25.4, clearance=clearance, $fn=fn );

translate( [c2c,0,0] )
    rotate( [0,0,-($t+n2/2-0*n1+1/2)*360/n2] )
    color( [0.75,1.00,0.75] )
    gear2D( mm_per_tooth, n2, 5, clearance=clearance, $fn=fn );

circle(d=10);

translate( [0,0,1] )
gear (circular_pitch=mm_per_tooth,
number_of_teeth=n1//,
  //gear_thickness = 12,
  //rim_thickness = 15,
  //hub_thickness = 17,
  //circles=8
  );
  
translate( [c2c,0,0] )
rotate( [0,0,360/n2/2] )
gear (circular_pitch=mm_per_tooth,
number_of_teeth=n2//,
  //gear_thickness = 12,
  //rim_thickness = 15,
  //hub_thickness = 17,
  //circles=8
  );
  
  