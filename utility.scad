//
// ERRORS - END EXECUTION
//

    Error = function(msg) let( has=false )
        // assertion 'has' failed - HAHA!
        assert(has,msg);

    ErrorIf = function(condition,msg) let( has=!condition )
        assert(has,msg);

    module Exit(msg) {
        has=false;
        assert(has,msg);   
    }

    module ExitIf(condition,msg) {
        has=!condition;
        assert(has,msg);   
    }

//
//
//

    SELECT = function( d1, d2, d3 ) ((d1!=undef) ? d1 : (d2!=undef) ? d2 : d3 );
    IIF = function( cond, trueCond, falseCond ) ( cond ? trueCond : falseCond );
    function is_nan(x) = x!=x;

//
// STRING
//

    //String_Demo(); 
    module String_Demo() {
        
        echo("\n\n stringJoin():");
        a = [ "apple", "banana", "carrot" ];
        echo( str       ( a      ) ); // ["apple","banana","carrot"]
        echo( stringJoin( a      ) ); // "applebananacarrot"
        echo( stringJoin( a, "-" ) ); // "apple-banana-carrot"
        b = [ 1, 22, 333 ];
        echo( stringJoin( b      ) ); // "122333"
        echo( stringJoin( b, "-" ) ); // "1-22-333"

        echo("\n\n stringSplit():");
        echo( stringSplit( "apple"        , "." ) );   // ["apple"]
        echo( stringSplit( "a.bb.ccc.dddd", "." ) );   // ["a","bb","ccc","dddd"]
        
        echo("\n\n stringLeft():");                    // "television"
        echo(    stringLeft( "television", 1 ) );      // "t"
        echo(    stringLeft( "television", 4 ) );      // "tele"
        
        echo("\n\n stringRight():");                   // "television"
        echo(   stringRight( "television", 4 ) );      //       "sion"
        echo(   stringRight( "television", 6 ) );      //     "vision"
        
        echo("\n\n stringMid(): start,length");        // "television"
        echo(     stringMid( "television", 0, 4 ) );   // "tele"
        echo(     stringMid( "television", 4, 6 ) );   //     "vision"
        echo(     stringMid( "television", 4, 5 ) );   //     "visio"
        
        echo("\n\n stringExtract(): start,end");       // "television"
        echo( stringExtract( "television", 0, 3 ) );   // "tele"
        echo( stringExtract( "television", 4, 9 ) );   //     "vision"
        echo( stringExtract( "television", 4, 5 ) );   //     "vi"

        echo("\n\n stringRepeat():");
        echo( stringRepeat( "." , 3 ) ); // "..."        
        echo( stringRepeat( "hi", 3 ) ); // "hihihi"

        echo("\n\n stringPad(),stringPadLeft():");
        echo( stringPad    ("a"         ,5                  ) ); // "a    "
        echo( stringPad    ("a"         ,5,char="."         ) ); // "a...."
        echo( stringPadLeft("a"         ,5,char="."         ) ); // "....a" 
        echo( stringPad    ("television",5,trimIfExcess=true) ); // "telev"
        echo( stringPadLeft("television",5,trimIfExcess=true) ); // "ision"       
    }
    
    function stringJoin(list,separator="") = let(
        // speed:  a = [ for(i=[1:1000]) "hellothere" ];
        //         for(x=[1:1000]) { b=stringJoin(a); }
        //    linear ~= 5.4 sec
        //    tree   ~= 7.1 sec
        //    but why???
        // limits:
        //    stringJoin( [ for(i=[1:5248]) "hellothere" ] )
        //       linear ==> ERROR: Recursion detected
        //                  [1:5247] okay
        //    stringJoin( [ for(i=[1:999999]) "hellothere" ] )
        //       tree   ==> okay
        //                  [1:1000000], not allowed in OpenSCAD
        // SO: 5000 or less, use linear, otherwise use tree
        N = len(list),
        linear = function(index)
            ( N-1==index )
                ? list[index]
                : str( list[index], separator, linear(index+1) ),
        tree = function(from,to) let ( n=to-from )
            // from listCompareEach()
            (n<=0) ?
                list[from]
            : let(
                mid = ceil(n/2),
                L = (mid  ==1)?list[from]:tree(from    ,from+mid-1),
                R = (n-mid==0)?list[to]  :tree(from+mid,to        )
            ) str( L, separator, R )
    )   (list==undef || !is_list(list))?undef:
        (N<=5000) // <-- change/remove to force which version to use
            ? linear(0)
            : tree(0,N-1);

    //Benchmark();
    //module Benchmark() {
    //    //repeat=1;
    //    repeat=1000;
    //    a = [ for(i=[1:1000]) "hellothere" ];
    //    for(x=[1:repeat]) { b = stringJoin(a); }
    //    if ( repeat == 1 ) {
    //        b = stringJoin(a);
    //        echo( len(b) );
    //    }
    //}

    // split string based on breaker    
    function stringSplit(string,breaker=".") = let (
        core = function(string,breaker)
            let (
                pos = search(breaker,string,0)[0],
                // search( ".", "aa.bb.cc.dd", 0 ) ==> [[2,5,8]]
                ext = concat(
                    0,                               // 0
                    [ for(i=pos) each([i-1,i+1]) ],  // pos-1, pos+1
                    len(string)-1                    // M
                )
                // extract [0:pos1-1],[pos1+1:pos2-1]...[posN+1,M]
            )
            ( len(pos)==0 )
                ? [string]
                : [ for(i=[0:2:len(ext)-1]) 
                    //stringExtract(string,ext[i],ext[i+1])
                    stringJoin( [ for(j=[ext[i]:ext[i+1]]) string[j] ] )
                  ]
    )   (string==undef||breaker==undef)
            ? undef
            : core(string,breaker);

    // extract subtring from left
    function stringLeft(string,length) =
        (string==undef||length==undef) ? undef
        :(length<=0) ? ""
            : let(sl=len(string),eLength=(length==undef||length>sl)?sl:length)
              stringJoin( [ for(i=[0:eLength-1]) string[i] ] );

    // extract subtring from right
    function stringRight(string,length) =
        (string==undef||length==undef) ? undef
        :(length<=0) ? ""
            : let(sl=len(string),eLength=(length==undef||length>sl)?sl:length)
              stringJoin( [ for(i=[sl-eLength:sl-1]) string[i] ] );

    // extract subtring based on start position and length
    function stringMid(string,start=0,length) =
        (string==undef)?undef:
            let(eLength=(length==undef)?len(string):length)
            stringExtract(string,start,start+eLength-1);

    // extract subtring based on start and end positions
    function stringExtract(string,start=0,end) = let (
        // auto assign start and limit to 0 if negative
        eStart = (start==undef||start<0) ? 0 : start
    )
        (string==undef)?undef
        // auto assign end and limit to end if beyond
        : let(sl=len(string),eEnd=(end==undef||end>sl-1)?sl-1:end)
          (eEnd<eStart)?undef
          : stringJoin( [ for(i=[eStart:eEnd]) string[i] ] );

    function stringRepeat(string,repeat=1) =
        (string==undef||repeat==undef)?undef:
        (repeat==0)?"":
            stringJoin( [ for(i=[1:repeat]) string ] );
   
    function stringPad(string,length,trimIfExcess=false,char=" ") = let (
            n=len(string)
        )
        (n==length)?string:
        (n<length)?stringJoin([string,stringRepeat(char,length-n)]):
        (trimIfExcess)?stringLeft(string,length):
        string;
        
    function stringPadLeft(string,length,trimIfExcess=false,char=" ") = let (
            n=len(string)
        )
        (n==length)?string:
        (n<length)?stringJoin([stringRepeat(char,length-n),string]):
        (trimIfExcess)?stringRight(string,length):
        string;

//
// NUMBERS
//
    
    //Number_Demo(); 
    module Number_Demo() {
        echo("\n\n numRound(value,decPlace=2):");
        echo( numRound( 123.45678     ) ); // 123.46
        echo( numRound( 123.45678,  0 ) ); // 123
        echo( numRound( 123.45678,  1 ) ); // 123.5
        echo( numRound( 123.45678, -1 ) ); // 120
        echo( numRound( 123.45678, -2 ) ); // 100
        
        echo("\n\n numFormat(value,decPlace=2):");
        n = 123456789.123456789;
        echo( numFormat( n                               ) ); // "123,456,789.12"
        echo( numFormat( n, 4                            ) ); // "123,456,789.1235"
        echo( numFormat( n,    sep1000="`", decPoint="-" ) ); // "123`456`789-12"
        echo( numFormat( n, 4, pos1000=4                 ) ); // "1,2345,6789.1235"
    }
    
    function numRound(value,decPlace=2) =
        let ( f=pow(10,decPlace) )
        round(value*f)/f;
    
    function numFormat(value,decPlace=2,pos1000=3,sep1000=",",decPoint=".") = let(

        f       = pow(10,decPlace),
        rounded = round(value*f)/f,
        whole   = round(rounded),
        decPart = (rounded-whole)*f,
        decimal = substr(str(decPart+f),1,decPlace), // add trailing 0s
        
        magnitude  = ceil(log(value)),
        groupCount = ceil(magnitude/pos1000)-1, // number of 1000s sections
        thousand = pow(10,pos1000),
        //e1=echo("whole"     ,whole     ),
        //e2=echo("decimal"   ,decimal   ),
        //e3=echo("groupCount",groupCount),
    
        extract = function(value,power) let(
                                                              // 123`056`789, power=1, need 056
                                                              // throw away right side
            noRight   = floor(value/pow(thousand,power)),     // 123`056`789 ==> 123`056.789 ==> 123`056
                                                              // throw awy left side
            needDec   = noRight/thousand,                     // 123`056 ==> 123.056
            noLeft    = (needDec-floor(needDec))*thousand,    // 123.056 ==> 0.056 ==> 56
            final = (power==groupCount) ? noLeft
                :substr(str(noLeft+thousand),1,pos1000)       // 56 ==> "056"
            //e1=echo("noRight",noRight),
            //e2=echo("needDec",needDec),
            //e3=echo("noLeft" ,noLeft )
        ) (power==groupCount)?final:[sep1000,final]        
    ) strcat( concat( [ for( i=[groupCount:-1:0] ) each(extract(whole,i)) ], [decPoint, decimal ] ) );

//
// LIST
//

    //List_Demo(); 
    module List_Demo() {
        echo("\n\n listSum(): start,end");
        a=[1,2,3,4,5];
        echo( listSum(a          )); // 15
        echo( listSum(a,   2,  3 )); // 7
        echo( listSum(a,   2     )); // 12
        echo( listSum(a,   2, 10 )); // 12
        echo( listSum(a,   0,  3 )); // 10
        echo( listSum(a, -10,  3 )); // 10
        echo( listSum(a,   2,  0 )); // undef
        echo( listSum(a,  10, 20 )); // undef
        
        echo("\n\n listRunningSum():");
        echo( listRunningSum([1,2,3,4,5]) );   // [1, 3, 6, 10, 15]
        echo( listRunningSum([5,4,3,2,1]) );   // [5, 9, 12, 14, 15]
        
        echo("\n\n listOperator():");
        echo( listOperator( [ 5,3,1,4,2 ], function(x,y) max(x,y) ) ); // 5
        echo( listOperator( [ 5,3,1,4,2 ], function(x,y) min(x,y) ) ); // 1

        // sum of squares
        echo( listOperator( [1,2,3,4,5], 
            function(x,y) x+y, function(x) x*x ) );         // 55
        
        // get length of string and find max
        echo( listOperator( [ "apple","banana","carrots" ], 
            function(x,y) max(x,y), function(x) len(x) ) ); // 7
            
        // combine each element with breaker
        echo( listOperator( [ "a","b","c" ],
            function(x,y) str(x,"-",y) ) );                 // "a-b-c"
    }
    
    function listSum(list,start=0,end) = let (
        // auto assign start and limit to 0 if negative
        eStart = (start==undef||start<0) ? 0 : start,
        // auto assign end and limit to end if beyond
        eEnd = (end==undef||end>len(list)-1) ? len(list)-1 : end,
        core = function(index)
            list[index] + ( (index>=eEnd)?0
                            :core(index+1) )
    )
        (eStart>eEnd||eStart>=len(list))?undef:
            core(eStart);

    function listRunningSum(list) = let (
        core = function(index,stop)
            list[index] + ( (index>=stop)?0
                             :core(index+1,stop) )
    ) [ for( i=[0:len(list)-1] ) core(0,i) ];

        // ex.
        // listCompareEach( [ 5,1,3,4,2 ],                  function(x,y) max(x,y)                     ) ==> 5
        // listCompareEach( [ 5,1,3,4,2 ],                  function(x,y) min(x,y)                     ) ==> 1
        // listCompareEach( [ "apple","banana","carrots" ], function(x,y) max(x,y), function(x) len(x) ) ==> 7

    function listOperator(list,fOperation,fEach) = let (
        // apply fEach() to each element, then feed to fOperation()
        //
        // speed: a = [ for(i=[1:1000]) "a" ];
        //        for(x=[1:repeat]) { b = listOperator(a,function(x,y)x+y,function(x)len(x)); }
        //    linear ~= 5.8 sec
        //    tree   ~= 9.4 sec
        //    but why???
        // limits:
        //    ... [ for(i=[1:  8037]) 1 ] linear ==> ERROR: Recursion detected, [1:8036] okay
        //    ... [ for(i=[1:999999]) 1 ] tree   ==> okay, [1:1000000], not allowed in OpenSCAD
        // SO: 5000 or less, use linear, otherwise use tree
        E = fEach==undef?function(x) x:fEach,
        N = len(list),
        linear = function(index)
            ( N-1==index )
                ? E(list[index])
                : fOperation( E(list[index]), linear(index+1) ),    
        tree = function(from,to) let ( n=to-from )
            // from   to   n    mid   n-mid   left   right
            // 0      0    0
            // 0      1    1    1     0       0      1
            // 0      2    2    1     1       0      1:2
            // 0      3    3    2     1       0:1    2:3
            // 0      4    4    2     2       0:1    2:4
            // 0      5    5    3     2       0:2    3:5
            (n<=0) ?
                E( list[from] )
            : let(
                // split on the middle for shallower tree
                mid = ceil(n/2),
                //e1=echo( str( ">>> [",from,":", to,"], n=",  n,", mid=", mid) ),
                //e2=echo( str("   L: ", (mid  ==1)?from:str(from    ,":",from+mid-1))),
                //e3=echo( str("   R: ", (n-mid==0)?to  :str(from+mid,":",to        ))),
                L = (mid  ==1)?E(list[from]):tree(from    ,from+mid-1),
                R = (n-mid==0)?E(list[to]  ):tree(from+mid,to        )
            ) fOperation( L, R )
    )   (list==undef || !is_list(list))?undef:
        (N>=5000) // <-- change/remove to force which version to use
            ? linear(0)
            : tree(0,N-1);
    
    //Benchmark2();
    //module Benchmark2() {
    //    //repeat=1;
    //    repeat=1000;
    //    a = [ for(i=[1:1000]) "a" ];
    //    for(x=[1:repeat]) { b = listOperator(a,function(x,y)x+y,function(x)len(x)); }
    //    if ( repeat == 1 ) {
    //        b = listOperator(a,function(x,y)x+y,function(x)len(x));
    //        echo( b );
    //    }
    //}    
    
//
// GRAPHICAL
//

    //Graphical_Demo(); 
    module Graphical_Demo() {
        CubeExtents( 50,40,60, color="red" );
        color("green",0.5) cube([50,40,60],center=true);
    }

    module CubeExtents( width, depth, height, size=1, color="red" ) {
        w = (width+size)/2;
        d = (depth+size)/2;
        h = (height+size)/2;
        C() {
            translate([ w, d, h]) cube([size,size,size],center=true);
            translate([ w, d,-h]) cube([size,size,size],center=true);
            translate([ w,-d, h]) cube([size,size,size],center=true);
            translate([ w,-d,-h]) cube([size,size,size],center=true);
            translate([-w, d, h]) cube([size,size,size],center=true);
            translate([-w, d,-h]) cube([size,size,size],center=true);
            translate([-w,-d, h]) cube([size,size,size],center=true);
            translate([-w,-d,-h]) cube([size,size,size],center=true);
        }
        module C() {
            if ( color==undef ) children(); else color(color) children();
        }
    }
