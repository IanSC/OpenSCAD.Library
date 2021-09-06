//
// KEY-VALUE TABLE
// by ISC 2021
//
// searchable key-value table
// for compact storage of data values

include <utility.scad>

//
// DEMO
//

    // run me!!!
    //KeyValue_Demo();

    module KeyValue_Demo() {
        table = KeyValue([
            "solo"   , 0,
            "notSure", undef,
            "fruit"  , KeyValue([ "apple", 1,      "banana", 2,       "carrot", 3     ]),
            "color"  , KeyValue([ "red"  , "meat", "green" , "grass", "blue"  , "sky" ]),
            "animal" , KeyValue([
                "dog"  , KeyValue([
                    "breed", KeyValue([ "poodle",  10, "chihuahua", 20 ]),
                    "color", KeyValue([ "white",   30, "brown",     40 ]) ]),
                "cat"  , KeyValue([
                    "breed", KeyValue([ "siamese", 50, "persian",   60 ]),
                    "color", KeyValue([ "cream",   70, "lilac",     80 ]) ]) ]),
            "model", "ABC123"
        ]);
        
        kvEcho( table );
        echo( kvKeys  ( table ) );          // ["solo", "notSure", "fruit", "color", "animal", "model"]
        echo( kvKeys  ( table, "color" ) ); // ["red", "green", "blue"]
        echo( kvValues( table, "fruit" ) ); // [1, 2, 3]
        
        echo( "\n\nKEYS EXISTS:" );
        echo( kvExists( table, "solo" ) );                    // true
        echo( kvExists( table, "animal.dog.breed.poodle" ) ); // true
        echo( kvExists( table, "animal.dog.breed.bulldog" ) ); // false
        
        echo( "\n\nEXPECTED KEYS:" );
        echo( kvGet( table, "solo" ) );                   // 0
        echo( kvGet( table, "notSure" ) );                // undef
        echo( kvGet( table, "fruit.apple" ) );            // 1
        echo( kvGet( table, "color.green" ) );            // "grass"
        echo( kvGet( table, "animal.dog.color.white" ) ); // 30
        echo( kvGet( table, "model" ) );                  // "ABC123"
        //echo( kvGet( table, "missingKey" ) );           // ERROR: "[missingKey] missing"
        //echo( kvGet( table, "fruit.dragon" ) );         // ERROR: "[dragon] in [fruit.dragon] missing"

        echo( "\n\nINNER TABLE:" );
        animalTable = kvGet( table, "animal" );
        echo( kvGet( animalTable, "cat.breed.siamese" ) );         // 50

        echo( "\n\nDEFAULT VALUES:" );
        echo( kvGet( table, "notSure" ) );                         // undef
        echo( kvGet( table, "notSure",      defaultValue=true ) ); // true
        //echo( kvGet( table, "missingKey", defaultValue=1 ) );    // ERROR: "[missingKey] missing"

        // return undef if missing
        echo( "\n\nOPTIONAL KEYS:" );
        echo( kvSearch( table, "missingKey" ) );                   // undef
        echo( kvSearch( table, "animal.dragon" ) );                // undef
        echo( kvSearch( table, "Model" ) );                        // undef
        
        echo( kvSearch( table, "missingKey", defaultValue=123 ) ); // 123
        echo( kvSearch( table, "notSure",    defaultValue=123 ) ); // 123

        echo( "\n\nMISSING vs UNDEF:" );
        echo( kvSearchOCD( table, 
            "missingKey",                                   defaultValue="dunno" ) );   // undef
        echo( kvSearchOCD( table, 
            "notSure",
                                                            defaultValue="dunno" ) );   // "dunno"
        echo( kvSearchOCD( table, 
            "missingKey",         defaultMissing="missing"                       ) );   // "missing"
        echo( kvSearchOCD( table, 
            "notSure",            defaultMissing="missing"                       ) );   // undef
        echo( kvSearchOCD( table, 
            "missingKey",         defaultMissing="missing", defaultValue="dunno" ) );   // "missing"
        echo( kvSearchOCD( table, 
            "notSure",            defaultMissing="missing", defaultValue="dunno" ) );   // "dunno"
    }


//
// CREATE
//

    function KeyValue( list ) =
        // input  = [ "a", 1, "b", 2, "c", 3 ]
        // output = [ ["a",1] , ["b",2] , ["c",3] ]
        [ for(i=[0:2:len(list)-1]) [ list[i], list[i+1] ] ];

    function kvKeys(keyValues,key=undef) = let (
            kv = (key==undef)?keyValues:kvGet(keyValues,key)        
        )
        [ for(i=kv) i[0] ];
            
    function kvValues(keyValues,key=undef) = let (
            kv = (key==undef)?keyValues:kvGet(keyValues,key)        
        )
        [ for(i=kv) i[1] ];

//
// GET
//

    // key is expected to exist:
    // - fail if missing
    // - return defaultValue, if found and value is undef
    function kvGet(keyValues,key,defaultValue=undef) =
        kvFindCore(keyValues,key,defaultValue=defaultValue,failIfMissing=true);

    // optional key:
    // - return defaultValue, if key is missing
    // - return defaultValue, if found and value is undef
    function kvSearch(keyValues,key,defaultValue=undef) =
        kvFindCore(keyValues,key,defaultValue=defaultValue,defaultMissing=defaultValue,failIfMissing=false);

    // optional key:
    // - return defaultValue, if keyValues in undef
    // - return defaultValue, if key is missing
    // - return defaultValue, if found and value is undef
    function kvSearchLax(keyValues,key,defaultValue=undef) =
        kvFindCore(keyValues,key,defaultValue=defaultValue,defaultMissing=defaultValue,failIfMissing=false,failIfNoTable=false);

    // optional key:
    // - return defaultMissing, if key is missing
    // - return defaultValue,   if found and value is undef
    function kvSearchOCD(keyValues,key,defaultValue=undef,,defaultMissing=undef) =
        kvFindCore(keyValues,key,defaultValue=defaultValue,defaultMissing=defaultMissing,failIfMissing=false);

    // check if key exists
    function kvExists(keyValues,key) = let(
        r = kvFindCore(keyValues,key,defaultValue=true,defaultMissing=undef,failIfMissing=false)
    ) (r!=undef);

    function kvFindCore(keyValues,key,defaultValue=undef,defaultMissing=undef,failIfMissing=true,failIfNoTable=true) =
        let (
            
            has=false,
            e1=(failIfNoTable&&(keyValues==undef||!is_list(keyValues))?assert(has,"table not specified"):0),
            e2=(key      ==undef?assert(has,"key not specified" ):0),

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
                        defaultMissing
                ) : (
                    // check next entry
                    FindCore(table,tIndex+1,keywords,kIndex)
                ),

            keywords = stringSplit(key,"."),
            result   = FindCore(keyValues,0,keywords,0)
        )
        result;

//
// ECHO
//

    module kvEcho(keyValues) {
        echo( show(keyValues,"") );        
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