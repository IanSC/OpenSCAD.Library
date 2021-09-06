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
        echo( stringSplit( "apple"        , "." ) ); // ["apple"]
        echo( stringSplit( "a.bb.ccc.dddd", "." ) ); // ["a","bb","ccc","dddd"]
        
        echo("\n\n stringLeft(s,length):");          // "television"
        echo(    stringLeft( "television", 1 ) );    // "t"
        echo(    stringLeft( "television", 4 ) );    // "tele"
        
        echo("\n\n stringRight(s,length):");         // "television"
        echo(   stringRight( "television", 4 ) );    //       "sion"
        echo(   stringRight( "television", 6 ) );    //     "vision"
        
        echo("\n\n stringMid(s,position,length):");  // "television"
        echo(     stringMid( "television", 0, 4 ) ); // "tele"
        echo(     stringMid( "television", 4, 6 ) ); //     "vision"
        echo(     stringMid( "television", 4, 5 ) ); //     "visio"
        
        echo("\n\n stringExtract(s,start,end):");    // "television"
        echo( stringExtract( "television", 0, 3 ) ); // "tele"
        echo( stringExtract( "television", 4, 9 ) ); //     "vision"
        echo( stringExtract( "television", 4, 5 ) ); //     "vi"
    }

    // concatenate string with optional separator
    function stringJoin(list,separator="") = let(
        core = function(list,separator,index=0)
            ( len(list)-1==index )
                ? list[index]
                : str( list[index], separator, core(list,separator,index+1) )    
    )   (list==undef || !is_list(list))
            ? undef
            : core(list,separator);

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

//
// NUMBERS
//
    
    //Number_Demo(); 
    module Number_Demo() {
        echo("\n\nnumRound():");
        echo( numRound( 123.45678     ) ); // 123.46
        echo( numRound( 123.45678,  0 ) ); // 123
        echo( numRound( 123.45678,  1 ) ); // 123.5
        echo( numRound( 123.45678, -1 ) ); // 120
        echo( numRound( 123.45678, -2 ) ); // 100
        
        echo("\n\nnumFormat():");
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
        a=[1,2,3,4,5];
        echo( listSum(a          )); // 15
        echo( listSum(a,   2,  3 )); // 7
        echo( listSum(a,   2     )); // 12
        echo( listSum(a,   2, 10 )); // 12
        echo( listSum(a,   0,  3 )); // 10
        echo( listSum(a, -10,  3 )); // 10
        echo( listSum(a,   2,  0 )); // undef
        echo( listSum(a,  10, 20 )); // undef
        
        echo( listRunningSum(a) );   // [1, 3, 6, 10, 15]
    }
    
    function listSum(list,start=0,end) = let (
        // auto assign start and limit to 0 if negative
        eStart = (start==undef||start<0) ? 0 : start,
        // auto assign end and limit to end if beyond
        eEnd = (end==undef||end>len(list)-1)
            ? len(list)-1 : end,
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
