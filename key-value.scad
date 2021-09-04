//
// KEY-VALUE TABLE
// by ISC 2021
//
// searchable key-value table
// for compact storage of data values

include <utility.scad>

// run me!!!
//KeyValue_Demo();

module KeyValue_Demo() {
    table = KeyValue( [         
                "solo"  , 0,
                "fruit" , KeyValue( [ "apple",  1, "banana",  2, "carrot",  3 ] ),
                "color" , KeyValue( [ "red"  , 11, "green" , 12, "blue"  , 13 ] ),
                "animal", KeyValue( [ "dog"  , 21, "cat"   , 22, "mouse" , 23 ] ),
                "model" , "ABC123"
        ] );
    
    kvShow( table );

    echo( kvGet( table, "solo" ) );             // 0
    echo( kvGet( table, "fruit.apple" ) );      // 1
    echo( kvGet( table, "color.green" ) );      // 12
    echo( kvGet( table, "animal.mouse" ) );     // 13
    echo( kvGet( table, "model" ) );            // "ABC123"
    
    // return undef is missing
    echo( kvSearch( table, "solo.hans" ) );     // undef
    echo( kvSearch( table, "animal.dragon" ) ); // undef
    echo( kvSearch( table, "Model" ) );         // undef

    // missing but with default value
    echo( kvGet( table, "whatever", 123 ) );    // 123
    
    // ASSERT FAILED
    echo( kvGet( table, "solo.hans" ) );
}

function KeyValue( list ) =
    // input  = [ "a", 1, "b", 2, "c", 3 ]
    // output = [ ["a",1] , ["b",2] , ["c",3] ]
    [ for(i=[0:2:len(list)-1]) [ list[i], list[i+1] ] ];

// key is expected to exist, fail if missing unless defaultValue is specified
function kvGet(keyValues,keywords,defaultValue=undef) =
    kvFindCore(keyValues,keywords,defaultValue,failOnUndef=true);

// possibly missing, return undef, no fail
function kvSearch(keyValues,keywords,defaultValue=undef) =
    kvFindCore(keyValues,keywords,defaultValue,failOnUndef=false);

function kvFindCore(keyValues,keywords,defaultValue=undef,failOnUndef=true) =
    let (
        e1=ErrorIf(keyValues==undef,"missing table"),
        e2=ErrorIf(keyValues==undef,"missing keywords"),
        Break = function(keywords,breaker=".")
            let (
                pos = search(breaker,keywords,0)[0],
                // search( ".", "aa.bb.cc.dd", 0 ) ==> [[2,5,8]]
                ext = concat(
                    0,                               // 0
                    [ for(i=pos) each([i-1,i+1]) ],  // pos-1, pos+1
                    len(keywords)-1                  // N
                )
                // extract [0:pos1-1],[pos1+1:pos2-1]...[posN+1,N]
            )
            ( len(pos)==0 ) ? [keywords] : 
            [ for(i=[0:2:len(ext)-1]) ExtractString(keywords,ext[i],ext[i+1]) ],
            // echo( Break( "apple" ) );         // ==> ["apple"]
            // echo( Break( "a.bb.ccc.dddd" ) ); // ==> ["a","bb","ccc","dddd"]        
    
        ExtractString = function(string,start,end)
            ConcatStr( [ for(i=[start:end]) string[i] ] ),
            // echo( ExtractString("apple",2,3) ); // ==> "pl"

        ConcatStr = function(charList,index=0)
            ( len(charList)-1==index ) ? charList[index] :
            str( charList[index], ConcatStr(charList,index+1) ),
            //echo( str("a","b","c") );         // ==> "abc"
            //echo( str(["a","b","c"]) );       // ==> ["a","b","c"] not what we want
            //echo( ConcatStr(["a","b","c"]) ); // ==> "abc"
            //echo( ConcatStr([1,2,3]) );       // ==> "123"
            
        FindCore = function(table,tIndex,keys,kIndex)
            ( table==undef || !is_list(table) || len(table)<=tIndex ) ?
                // not a list or empty                
                undef
            : ( table[tIndex][0]==keys[kIndex] ) ? (
                // found ...
                ( len(keys)-1==kIndex ) ?
                    // ... last key - return value
                    table[tIndex][1]
                :
                    // ... find next subkey
                    FindCore(table[tIndex][1],0,keys,kIndex+1)
            ) : ( len(table)-1==tIndex ) ? (
                // last entry and did not match
                undef
            ) : (
                // check next entry
                FindCore(table,tIndex+1,keys,kIndex)
            ),

        keys   = Break(keywords),
        found  = FindCore(keyValues,0,keys,0),
        result = ( found==undef ) ? defaultValue : found,
        has    = !failOnUndef || result!=undef
    )
    assert( has, str( "[", keywords, "] missing" ) ) // assertion 'has' failed - HAHA!
    result;

module kvEcho(keyValues) {

    echo( show(keyValues,"") );
    
    function show(a,indent) =
        ConcatStr([
            for( i=[0:len(a)-1] )
            ( is_list(a[i][1]) ) ?            
                str( "\n", indent, key(a[i][0]), " =", show(a[i][1],str(indent,"     ")) )
            :
                str( "\n", indent, key(a[i][0]), ": ", value(a[i][1]) )
        ]);
    ConcatStr = function(charList,index=0)
        ( len(charList)-1==index ) ? charList[index] :
        str( charList[index], ConcatStr(charList,index+1) );
    function key(k)   = is_undef (k) ? "<undef>"  : k;
    function value(v) = is_undef (v) ? "<undef>"  :
                        is_string(v) ? str("'",v,"'") : v;
}