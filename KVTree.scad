//
// KVTree
// by ISC 2021
//
// searchable key-value tree structure
// for compact storage of data values

include <utility.scad>

//
// DEMO
//

    // run me!!!
    //KVTree_Demo();

    module KVTree_Demo() {

        table = KVTree([
            "solo"   , 0,
            "notSure", undef,
            "fruit"  , KVTree([ "apple", 1,      "banana", 2,       "carrot", 3     ]),
            "color"  , KVTree([ "red"  , "meat", "green" , "grass", "blue"  , "sky" ]),
            "animal" , KVTree([
                "dog"  , KVTree([
                    "breed", KVTree([ "poodle",  10, "chihuahua", 20 ]),
                    "color", KVTree([ "white",   30, "brown",     40 ]) ]),
                "cat"  , KVTree([
                    "breed", KVTree([ "siamese", 50, "persian",   60 ]),
                    "color", KVTree([ "cream",   70, "lilac",     80 ]) ]) ]),
            "model", "ABC123"
        ]);
        
        echo( "\n\n ECHO: kvEcho()" );
        kvEcho( table );

        echo( "\n\n KEYS/VALUES: kvKeys()/kvValues()" );
        echo( kvKeys  ( table ) );          // ["solo", "notSure", "fruit", "color", "animal", "model"]
        echo( kvKeys  ( table, "color" ) ); // ["red", "green", "blue"]
        echo( kvValues( table, "fruit" ) ); // [1, 2, 3]
        
        echo( "\n\n KEYS EXISTS: kvExists()" );
        echo( kvExists( table, "solo" ) );                    // true
        echo( kvExists( table, "animal.dog.breed.poodle" ) ); // true
        echo( kvExists( table, "animal.dog.breed.bulldog" ) ); // false
        
        echo( "\n\n EXPECTED KEYS: kvGet()" );
        echo( kvGet( table, "solo" ) );                   // 0
        echo( kvGet( table, "notSure" ) );                // undef
        echo( kvGet( table, "fruit.apple" ) );            // 1
        echo( kvGet( table, "color.green" ) );            // "grass"
        echo( kvGet( table, "animal.dog.color.white" ) ); // 30
        echo( kvGet( table, "model" ) );                  // "ABC123"
        //echo( kvGet( table, "missingKey" ) );           // ERROR: "[missingKey] missing"
        //echo( kvGet( table, "fruit.dragon" ) );         // ERROR: "[dragon] in [fruit.dragon] missing"

        echo( "\n\n INNER TABLE:" );
        animalTable = kvGet( table, "animal" );
        echo( kvGet( animalTable, "cat.breed.siamese" ) );         // 50

        echo( "\n\n DEFAULT VALUES:" );
        echo( kvGet( table, "notSure" ) );                         // undef
        echo( kvGet( table, "notSure",      defaultValue=true ) ); // true
        //echo( kvGet( table, "missingKey", defaultValue=1    ) ); // ERROR: "[missingKey] missing"

        echo( "\n\n OPTIONAL KEYS: kvSearch()" );
        echo( kvSearch( table, "missingKey" ) );                   // undef
        echo( kvSearch( table, "animal.dragon" ) );                // undef
        echo( kvSearch( table, "Model" ) );                        // undef
        
        echo( kvSearch( table, "missingKey", defaultValue=123 ) ); // 123
        echo( kvSearch( table, "notSure",    defaultValue=123 ) ); // 123
        //echo( kvSearch( undef, "notSure",  defaultValue=123 ) ); // ERROR: "table not specified"

        echo( "\n\n OPTIONAL TABLE: kvSearchLax()" );
        echo( kvSearchLax( undef        ) );                       // undef
        echo( kvSearchLax( table, undef ) );                       // undef

        echo( "\n\n MISSING vs UNDEF: kvSearchOCD()" );
        echo( kvSearchOCD( table, "missingKey", defaultValue="dunno"                         ) ); //  undef
        echo( kvSearchOCD( table, "notSure"   , defaultValue="dunno"                         ) ); // "dunno"
        echo( kvSearchOCD( table, "missingKey",                       ifKeyMissing="missing" ) ); // "missing"
        echo( kvSearchOCD( table, "notSure"   ,                       ifKeyMissing="missing" ) ); //  undef
        echo( kvSearchOCD( table, "missingKey", defaultValue="dunno", ifKeyMissing="missing" ) ); // "missing"
        echo( kvSearchOCD( table, "notSure"   , defaultValue="dunno", ifKeyMissing="missing" ) ); // "dunno"

        echo( "\n\n FUNCTION" );
        mathPack = KVTree([
            "+", function(x,y) x+y,
            "-", function(x,y) x-y,
            "x", function(x,y) x*y,
            "/", function(x,y) x/y
        ]);
        echo( kvGet(mathPack,"+")(10,20) ); // 30
        echo( kvGet(mathPack,"x")(10,20) ); // 200
    }

//
// CREATE
//

    function KVTree( list ) =
        // input  = [ "a", 1, "b", 2, "c", 3 ]
        // output = [ ["a",1] , ["b",2] , ["c",3] ]
        [ for(i=[0:2:len(list)-1]) [ list[i], list[i+1] ] ];

    function kvKeys(table,key=undef) = let (
            kv = (key==undef)?table:kvGet(table,key)        
        )
        [ for(i=kv) i[0] ];
            
    function kvValues(table,key=undef) = let (
            kv = (key==undef)?table:kvGet(table,key)        
        )
        [ for(i=kv) i[1] ];

//
// GET
//

    // key is expected to exist:
    // - fail if key is missing
    // - return defaultValue, if found value is undef
    function kvGet(table,key,defaultValue=undef) =
        kvFindCore(table,key,defaultValue=defaultValue,failIfMissing=true);

    // optional key:
    // - return defaultValue, if key is missing
    // - return defaultValue, if found value is undef
    function kvSearch(table,key,defaultValue=undef) =
        kvFindCore(table,key,defaultValue=defaultValue,ifKeyMissing=defaultValue,failIfMissing=false);

    // optional key:
    // - return defaultValue, if table is undef
    // - return defaultValue, if key is missing
    // - return defaultValue, if found value is undef
    function kvSearchLax(table,key,defaultValue=undef) =
        kvFindCore(table,key,defaultValue=defaultValue,ifKeyMissing=defaultValue,failIfMissing=false,failIfNoTable=false);

    // optional key:
    // - return defaultMissing, if key is missing
    // - return defaultValue,   if found value is undef
    function kvSearchOCD(table,key,defaultValue=undef,ifKeyMissing=undef) =
        kvFindCore(table,key,defaultValue=defaultValue,ifKeyMissing=ifKeyMissing,failIfMissing=false);

    // check if key exists
    function kvExists(table,key) = let(
        r = kvFindCore(table,key,defaultValue=true,ifKeyMissing=undef,failIfMissing=false)
    ) (r!=undef);

    function kvFindCore(table,key,defaultValue=undef,ifKeyMissing=undef,failIfMissing=true,failIfNoTable=true) =
        let (
            
            has=false,
            e1=( failIfNoTable && (table==undef||!is_list(table) ) ?
                assert(has,"table not specified") : 0 ),
            e2=( failIfMissing && key==undef ?
                assert(has,"key not specified" ) : 0 ),

            FindCore = function(table,tIndex,keywords,kIndex)
                ( table[tIndex][0]==keywords[kIndex] ) ? (
                    // found ...
                    ( len(keywords)-1==kIndex ) ?
                        // ... last key - return value
                        (table[tIndex][1]==undef) ? defaultValue : table[tIndex][1]
                    :
                        // ... find next subkey
                        FindCore(table[tIndex][1],0,keywords,kIndex+1)
                ) : ( table[tIndex+1]==undef || !is_list(table[tIndex+1]) || len(table)-1==tIndex ) ? (
                    // current entry did not match
                    // next entry is invalid or no next entry
                    (failIfMissing)?(
                        (len(keywords)==1)?
                            assert(has,str( "[", key, "] missing" ))
                        :
                            assert(has,str( "[", keywords[kIndex], "] in [", key, "] missing" ))
                    ) :
                        ifKeyMissing
                ) : (
                    // check next entry
                    FindCore(table,tIndex+1,keywords,kIndex)
                )
        ) (table==undef||key==undef)?defaultValue
        :let(
            keywords = stringSplit(key,"."),
            result   = FindCore(table,0,keywords,0)
        ) result;

//
// ECHO
//

    module kvEcho(table) {
        echo( show(table,"") );        
        function show(a,indent) =
            stringJoin([
                for( i=[0:len(a)-1] )
                ( is_list(a[i][1]) ) ?            
                    str( "\n", indent, key(a[i][0]), " =", show(a[i][1],str(indent,"   ")) )
                :
                    str( "\n", indent, key(a[i][0]), ": ", value(a[i][1]) )
            ]);
        function key(k)   = is_undef (k) ? "<undef>"  : k;
        function value(v) = is_undef (v) ? "<undef>"  :
                            is_string(v) ? str("\"",v,"\"") : v;
    }