# KVTree
Searchable tree data structure for storing multiple values.

---
## List of Functions
<table>
<tr><td><b>KVTree</b>( list )</td><td>create key-value table</td></tr>
<tr><td><b>kvKeys</b>( table, key )</td><td>get keys</td></tr>
<tr><td><b>kvValues</b>( table, key )</td><td>get values</td></tr>
<tr><td><b>kvExists</b>( table, key )</td><td>check if key exists</td></tr>
<tr><td><b>kvShow</b>( table )</td><td>echo to console</td></tr>
<tr><td><b>kvGet</b>( table, key, defaultValue )</td><td>get expected key</td></tr>
<tr><td><b>kvSearch</b>( table, key, defaultValue )</td><td>get optional key</td></tr>
<tr><td><b>kvSearchLax</b>( table, key, defaultValue )</td><td>get optional key, optional table</td></tr>
<tr><td><b>kvSearchOCD</b>( table, key, defaultValue, ifKeyMissing )</td><td>handles missing key vs not defined</td></tr>
</table>

---
#### _KVTree( list )_
<table>
<tr><td>list        <td>list of key, value pairs
<tr><td><b><i>return<td>KVTree table (list)
</table>

#### _kvKeys( table, key )_
<table>
<tr><td>table       <td>KVTree table
<tr><td>key         <td>if specified, returns the keys of of table[key] instead
<tr><td><b><i>return<td>list of keys
</table>

#### _kvValues( table, key )_
<table>
<tr><td>table       <td>KVTree table
<tr><td>key         <td>if specified, returns the values of table[key] instead
<tr><td><b><i>return<td>list of values
</table>

#### _kvExists( table, key )_
<table>
<tr><td>table       <td>KVTree table
<tr><td>key         <td>key to check for
<tr><td><b><i>return<td>boolean
</table>

#### _kvShow( table )_
<table>
<tr><td>table       <td>KVTree table to display on console
</table>

#### _kvGet( table, key, defaultValue )_
<table>
<tr><td>table       <td>KVTree table
<tr><td>key         <td>key to get
<tr><td>defaultValue<td>return if value found is undef
<tr><td><b><i>return<td>value from key
</table>

#### _kvSearch( table, key, defaultValue )_
<table>
<tr><td>table       <td>KVTree table
<tr><td>key         <td>key to get
<tr><td>defaultValue<td>return if missing key or value found is undef
<tr><td><b><i>return<td>value from key
</table>

#### _kvSearchLax( table, key, defaultValue )_
<table>
<tr><td>table       <td>KVTree table
<tr><td>key         <td>key to get
<tr><td>defaultValue<td>return if no table, missing key or value found is undef
<tr><td><b><i>return<td>value from key
</table>

#### _kvSearchOCD( table, key, defaultValue, ifKeyMissing )_
<table>
<tr><td>table       <td>KVTree table
<tr><td>key         <td>key to get
<tr><td>defaultValue<td>return if value found is undef
<tr><td>ifKeyMissing<td>return if key is missing
<tr><td><b><i>return<td>value from key
</table>

<br>

| Version       | Invalid Table | Key is undef | Missing Key  | Value is undef |
| :------------ | :-----------: | :----------: | :----------: | :------------: |
| kvGet()       | ERROR         | ERROR        | ERROR        | defaultValue   |
| kvSearch()    | ERROR         | defaultValue | defaultValue | defaultValue   |
| kvSearchLax() | defaultValue  | defaultValue | defaultValue | defaultValue   |
| kvSearchOCD() | ERROR         | defaultValue | ifMissingKey | defaultValue   |

---
```
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
//echo( kvGet( table, "missingKey", defaultValue=1 ) );    // ERROR: "[missingKey] missing"

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
mathPack = KeyValue([
    "+", function(x,y) x+y,
    "-", function(x,y) x-y,
    "x", function(x,y) x*y,
    "/", function(x,y) x/y
]);
echo( kvGet(mathPack,"+")(10,20) ); // 30
echo( kvGet(mathPack,"x")(10,20) ); // 200     
```
Console for kvEcho():
```
solo: 0
notSure: <undef>
fruit =
   apple: 1
   banana: 2
   carrot: 3
color =
   red: "meat"
   green: "grass"
   blue: "sky"
animal =
   dog =
      breed =
         poodle: 10
         chihuahua: 20
      color =
         white: 30
         brown: 40
   cat =
      breed =
         siamese: 50
         persian: 60
      color =
         cream: 70
         lilac: 80
model: "ABC123"
```
Console for kvEchoAligned():
```
solo   : 0
notSure: <undef>
fruit  = apple : 1
         banana: 2
         carrot: 3
color  = red  : "meat"
         green: "grass"
         blue : "sky"
animal = dog= breed= poodle   : 10
                     chihuahua: 20
              color= white: 30
                     brown: 40
         cat= breed= siamese: 50
                     persian: 60
              color= cream: 70
                     lilac: 80
model  : "ABC123"
```