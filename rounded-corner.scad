//o=[0,0];
//polygon([[-100,0],o,[100,-100],[100,-200],[-100,-200]]);
//r=20;

$fn=50;

difference() {
    square([200,200],center=true);
    union() {
        translate([100,100])
            cutCornerTR(75,75,30,30);
        translate([-100,100])
            cutCornerTL(25,75,20,50);
        translate([100,-100])
            cutCornerBR(25,75,20,50);
        translate([-100,-100])
            cutCornerBL(50,25,40,20);
    }
}
//cutCornerTR(50,25,30,10);

function fCutCorner(xOffset,yOffset,r) = let (
    // POV: top/right
    //
    // 2 connected lines L1, L2
    // find circle with radius r tangent to the lines
    //
    //        o
    //  L1 ----  -  -  - +
    //       a \         
    //            \      |
    //               \   
    //                  \|
    //                   |
    //                  L2
    //
    angle=atan2(yOffset,xOffset),
    a =(180-angle)/2,
    // delta = distance from o along L1,L2
    //         where the circle is tangent to lines
    delta = r/tan(a), // tan(a)=r/x;
    cOrigin=[-xOffset-delta,-r],
    dx2=cos(angle)*delta,
    dy2=sin(angle)*delta,
    
    cutExact=[[-xOffset,0],[0,0],[0,-yOffset],[-xOffset,0]],

    overlap=10,
    xO=xOffset+overlap/yOffset*xOffset,
    yO=yOffset+overlap/xOffset*yOffset,
    cutExtended=[[-xO,overlap],[overlap,overlap],[overlap,-yO],[-xO,overlap]],

    circlePie=[cOrigin,[cOrigin.x,0],[-xOffset+dx2,-dy2],cOrigin],
    circlePieEnd=[[-xOffset,0],[cOrigin.x,0],[-xOffset+dx2,-dy2],[-xOffset,0]],

    v=[-xOffset+dx2-cOrigin.x,-dy2-cOrigin.y],
    circlePieExtended=[[cOrigin.x,r],cOrigin,[cOrigin.x+v.x*2,cOrigin.y+v.y*2],[cOrigin.x,r]]

) [cutExtended,cOrigin,circlePieExtended,delta];

module cutCornerTR(xOffset,yOffset,r1,r2) {
    
    c1=fCutCorner(xOffset,yOffset,r1);
    cut=c1[0];
    cOrigin=c1[1];
    circlePieExtended=c1[2];

    //translate([0,0,1]) color("red")
    polygon(cut);
    
    //translate([0,0,2]) color("green")
    difference() {
        polygon(circlePieExtended);
        translate(cOrigin)
            circle(r1);
    }
    
    c2=fCutCorner(yOffset,xOffset,r2);
    cut2=c2[0];
    cOrigin2=c2[1];
    circlePieExtended2=c2[2];
    dx2=c2[3];
    reverseXY=[for(i=circlePieExtended2) [i.y,i.x]];
    
    //polygon(cut2);
    
    difference() {
        polygon(reverseXY);
        translate([cOrigin2.y,cOrigin2.x])
            circle(r2);
    }
}

module cutCornerTL(xOffset,yOffset,r1,r2) {
    mirror([-1,0,0])
    cutCornerTR(xOffset,yOffset,r1,r2);
}
module cutCornerBR(xOffset,yOffset,r1,r2) {
    mirror([0,-1,0])
    cutCornerTR(xOffset,yOffset,r1,r2);
}
module cutCornerBL(xOffset,yOffset,r1,r2) {
    mirror([-1,0,0])
    mirror([0,-1,0])
    cutCornerTR(xOffset,yOffset,r1,r2);
}
