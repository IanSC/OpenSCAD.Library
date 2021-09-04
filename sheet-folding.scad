$fn=50;

//
// SETTINGS
//

    //    |
    //    |
    //    +---------     ---
    //              \
    //              /    FoldMarkThickness
    //    +---------     ---
    //    |
    //    |
    // -->|          |<-- FoldMarkLength
    
    FoldMarkThickness = 1;
    FoldMarkLength    = 3;
    
//
// TEST
//

//linear_extrude(height = 5, center = true, convexity = 10)
//		import(file = "/Users/ianco/Documents/OpenSCAD/sheet-folding.dxf", layer = "0");

    translate([200,0,0])
        Test1();
    //Test2();
    //Test3();
    //Test4();
    sheetCore_v2( [100,200,20,30,10,50] );

    module Test1() {
        a = P(
            w=100, h=30,
            c=5,
            up = F( o=10, p=P( 60,30, up=F(a= 45,p=P(50,20)) ) ),
            dn = F( o= 0, p=P(100,30, dn=F(a= 45,p=P(20,20)) ) ),
            lf = F( o= 0, p=P( 50,30, lf=F(a=-45,p=P(20,20)) ) ),
            rt = F( o= 5, p=P( 50,20, rt=F(a= 45,p=P(20,20)) ) )
        );
        b = P(
            w = 50,
            h = 30,
            ctl=5,ctr=3,cbl=4,cbr=10
        );
        c = P(30,30,ct=4);

        translate([0,0,50])
            model(a);
        sheet(a);
  
        translate([0,-100,0])
            sheetCore(c);
    }

    module Test2() {
        topPanel    = P( 80, 20 );
        bottomPanel = P( 70, 10 );
        mainPanel = P( 80, 50,         // main panel: 80x20
            up=F( p=topPanel ),        // put topPanel on top of mainPanel
            dn=F( p=bottomPanel, o=5 ) // put bottomPanel below mainPanel, offset to the right
        );
        sheet(mainPanel);
        translate([0,0,50])
            model(mainPanel);
    }

    module Test3() {
        leftPanel1 = P( 30, 30 );      // leftmost
        leftPanel2 = P( 20, 50,
            lf=F( p=leftPanel1, a=45 ) // put of left, 45 degrees
            );
        mainPanel = P( 50, 50,
            lf=F( p=leftPanel2, a=45 ) // put on left again of another panel
        );
        sheet(mainPanel);
        translate([0,0,50])
            model(mainPanel);
    }
    
    module Test4() {
        a = P(
            w=100, h=30,
            ctl=5,
            up = F( o=10, p=P( 60,30, up=F(a= 45,p=P(50,20)) ) ),
            dn = F( o= 0, p=P(100,30, dn=F(a= 45,p=P(20,20)) ) ),
            lf = F( o= 0, p=P( 50,30, lf=F(a=-45,p=P(20,20)) ) ),
            rt = F( o= 5, p=P( 50,20, rt=F(a= 45,p=P(20,20)) ) )
        );
        echo(a);
        
        // got echo(a) from console
        b=[100, 30, 5, 0, 0, 0, [90, 10, [60, 30, 0, 0, 0, 0, [45, 0, [50, 20, 0, 0, 0, 0, undef, undef, undef, undef]], undef, undef, undef]], [90, 0, [100, 30, 0, 0, 0, 0, undef, [45, 0, [20, 20, 0, 0, 0, 0, undef, undef, undef, undef]], undef, undef]], [90, 0, [50, 30, 0, 0, 0, 0, undef, undef, [-45, 0, [20, 20, 0, 0, 0, 0, undef, undef, undef, undef]], undef]], [90, 5, [50, 20, 0, 0, 0, 0, undef, undef, undef, [45, 0, [20, 20, 0, 0, 0, 0, undef, undef, undef, undef]]]]];
        translate([0,0,50])
            model(b);
        sheet(b);
    }

//
// ASSEMBLER
//

    // panel
    function P(
        w,h,
        up=undef,dn=undef,lf=undef,rt=undef,
        ctl=0, ctr=0, cbl=0, cbr=0, // specific corner
        ct=-1, cb=-1, cl=-1, cr=-1, // specific side
        c=-1                        // all corners
    ) = 
        let(
            // c-applies to all
            // ct-both top, cb-both bottom, ...
            ectl=(c!=-1)?c:(ct!=-1)?ct:(cl!=-1)?cl:ctl,
            ectr=(c!=-1)?c:(ct!=-1)?ct:(cr!=-1)?cr:ctr,
            ecbl=(c!=-1)?c:(cb!=-1)?cb:(cl!=-1)?cl:cbl,
            ecbr=(c!=-1)?c:(cb!=-1)?cb:(cr!=-1)?cr:cbr
        )
        [
        w,h,
        ectl,ectr,ecbl,ecbr,
        up,dn,lf,rt
        ];

    // fold
    function F(a=90,o=0,p) = [a,o,p];

//
// 3D MODEL
//

    module model( panel ) {
        if ( panel==undef ) echo( "***** MISSING PARAMETER *****" );
        else {
            w=panel[0]; h=panel[1];
            ctl=panel[2]; ctr=panel[3]; cbl=panel[4]; cbr=panel[5];
            up=panel[6]; dn=panel[7]; lf=panel[8]; rt=panel[9];
            sheetCore(panel);
            if ( up != undef ) {
                a=up[0]; o=up[1]; r2=up[2];
                translate([0,h/2,0])
                rotate([a,0,0])
                translate([o,r2[1]/2,0])
                model( r2 );
            }
            if ( dn != undef ) {
                a=dn[0]; o=dn[1]; r2=dn[2];
                translate([0,-h/2,0])
                rotate([-a,0,0])
                translate([o,-r2[1]/2,0])
                model( r2 );
            }
            if ( lf != undef ) {
                a=lf[0]; o=lf[1]; r2=lf[2];
                translate([-w/2,0,0])
                rotate([0,a,0])
                translate([-r2[0]/2,o,0])
                model( r2 );
            }
            if ( rt != undef ) {
                a=rt[0]; o=rt[1]; r2=rt[2];
                translate([w/2,0,0])
                rotate([0,-a,0])
                translate([r2[0]/2,o,0])
                model( r2 );
            }
        }
    }

//
// FLAT SHEET
//

    module sheet( panel ) {
        if ( panel==undef ) echo( "***** MISSING PARAMETER *****" );
        else {
            w=panel[0]; h=panel[1];
            ctl=panel[2]; ctr=panel[3]; cbl=panel[4]; cbr=panel[5];
            up=panel[6]; dn=panel[7]; lf=panel[8]; rt=panel[9];
            difference() {
                //color( "yellow", 0.5 )
                union() {
                    sheetCore( panel );
                    if ( up != undef ) {
                        a=up[0]; o=up[1]; r2=up[2]; r2h=r2[1];
                        translate([0,h/2,0])
                        translate([o,r2h/2,0])
                        sheet( r2 );
                    }
                    if ( dn != undef ) {
                        a=dn[0]; o=dn[1]; r2=dn[2]; r2h=r2[1];
                        translate([0,-h/2,0])
                        translate([o,-r2h/2,0])
                        sheet( r2 );
                    }
                    if ( lf != undef ) {
                        a=lf[0]; o=lf[1]; r2=lf[2]; r2w=r2[0];
                        translate([-w/2,0,0])
                        translate([-r2w/2,o,0])
                        sheet( r2 );
                    }
                    if ( rt != undef ) {
                        a=rt[0]; o=rt[1]; r2=rt[2]; r2w=r2[0];
                        translate([w/2,0,0])
                        translate([r2w/2,o,0])
                        sheet( r2 );
                    }
                }
                //color( "red", 0.5 )
                union() {
                    if ( up != undef ) {
                        a=up[0]; o=up[1]; r2=up[2]; r2w=r2[0];
                        translate([-effLeft(w,r2w,o),h/2,0]) fm("r");
                        translate([effRight(w,r2w,o),h/2,0]) fm("l");
                    }
                    if ( dn != undef ) {
                        a=dn[0]; o=dn[1]; r2=dn[2]; r2w=r2[0];
                        translate([-effLeft(w,r2w,o),-h/2,0]) fm("r");
                        translate([effRight(w,r2w,o),-h/2,0]) fm("l");
                    }
                    if ( lf != undef ) {
                        a=lf[0]; o=lf[1]; r2=lf[2]; r2h=r2[1];
                        translate([-w/2,effTop(h,r2h,o),0]) fm("b");
                        translate([-w/2,-effBottom(h,r2h,o),0]) fm("u");
                    }
                    if ( rt != undef ) {
                        a=rt[0]; o=rt[1]; r2=rt[2]; r2h=r2[1];
                        translate([w/2,effTop(h,r2h,o),0]) fm("b");
                        translate([w/2,-effBottom(h,r2h,o),0]) fm("u");
                    }
                }
            }
        }
    }

    module sheetCore_v2( panel ) {
        if ( panel==undef ) echo( "***** MISSING PARAMETER *****" );
        else {
            w=panel[0]; h=panel[1];
            ctl=panel[2]; ctr=panel[3]; cbl=panel[4]; cbr=panel[5];
            hull()
            {
                s=1e-5;
                translate([-w/2,h/2,0])
                if ( ctl==0 )
                    translate([0,-s,0]) square([s,s]);
                else
                    translate([ctl,-ctl,0]) circle(r=ctl);
                translate([w/2,h/2,0])
                if ( ctr==0 )
                    translate([-s,-s,0]) square([s,s]);
                else
                    translate([-ctr,-ctr,0]) circle(r=ctr);
                translate([-w/2,-h/2,0])
                if ( cbl==0 )
                    square([s,s]);
                else
                    translate([cbl,cbl,0]) circle(r=cbl);
                translate([w/2,-h/2,0])
                if ( cbr==0 )
                    translate([-s,0,0]) square([s,s]);
                else
                    translate([-cbr,cbr,0]) circle(r=cbr);
            }
        }
    }
    
    module sheetCore( panel ) {
        if ( panel==undef ) echo( "***** MISSING PARAMETER *****" );
        else {
            w=panel[0]; h=panel[1];
            ctl=panel[2]; ctr=panel[3]; cbl=panel[4]; cbr=panel[5];
            up=panel[6]; dn=panel[7]; lf=panel[8]; rt=panel[9];
            t=1;
            union() {
                difference() {
                    //color( "yellow", 0.5 )
                    square( [w,h], center=true);
                    //color( "red", 0.5 )
                    union() {
                        if ( ctl!=0 )
                            translate([-w/2-t,h/2-ctl,0])
                            square([ctl+t,ctl+t]);
                        if ( ctr!=0 )
                            translate([w/2-ctr,h/2-ctr,0])
                            square([ctr+t,ctr+t]);
                        if ( cbl!=0 )
                            translate([-w/2-t,-h/2-t,0])
                            square([cbl+t,cbl+t]);
                        if ( cbr!=0 )
                            translate([w/2-cbr,-h/2-t,0])
                            square([cbr+t,cbr+t]);
                    }
                }
                //color( "green", 0.5 )
                union() {
                    if ( ctl!=0 )
                        translate([-w/2+ctl,h/2-ctl,0])
                        circle(r=ctl);
                    if ( ctr!=0 )
                        translate([w/2-ctr,h/2-ctr,0])
                        circle(r=ctr);
                    if ( cbl!=0 )
                        translate([-w/2+cbl,-h/2+cbl,0])
                        circle(r=cbl);
                    if ( cbr!=0 )
                        translate([w/2-cbr,-h/2+cbr,0])
                        circle(r=cbr);
                }
            }
        }
    }

//
// SUPPORT
//

    //effPos_test();

    module effPos_test() {
        echo( effLeft(10,12,1) );
        echo( effRight(10,20,-1) );
        echo( effTop(10,12,1) );
    }

    // main - length of main panel
    // ext  - length of extension
    // off  - offset or ext relative to main
    // return outermost position
    function effLeft  (main,ext,off) = min(main/2,ext/2-off);
    function effRight (main,ext,off) = min(main/2,ext/2+off);
    function effTop   (main,ext,off) = min(main/2,ext/2+off);
    function effBottom(main,ext,off) = min(main/2,ext/2-off);

//
// FOLD MARKS
//

    //fm_test();

    module fm_test() {
        translate([30,0,0]) {
            color("yellow",0.5) translate([0,-10,0]) square([20,20]);
            color("red",0.5) fm("r");
        }
        color("yellow",0.5) translate([-10,-20,0]) square([20,20]);
        color("green",0.5) translate([0,0,0]) square([20,20]);
        color("red",0.5) fm("r");
    }

    module fm(d) {
        // d = "t" | "b" | "l" | "r"
        //     top/bottom/left/right direction
        if ( FoldMarkThickness==0 || FoldMarkThickness==undef
        || FoldMarkLength==0 || FoldMarkLength==undef ) {
        } else {
            fml=FoldMarkLength;    // length of mark    = 4
            fmt=FoldMarkThickness; // thickness of mark = 1
            r = (d=="l")?[0,0,180]:(d=="r")?[0,0,0]:(d=="u")?[0,0,90]:(d=="b")?[0,0,-90]:[0,0,0];
            rotate(r) {
                translate([0,-fmt/2,0])
                    square([fml,fmt]);
                translate([fml,0,0])
                    circle(d=fmt);
                circle(d=fmt);
            }
        }
    }
