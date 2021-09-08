# OpenSCAD.Library
---

### Utilities
Various basic functions.

<!--section Utilities.String-->
<table>
<tr><td colspan="2"><h4>String</h4></td></tr>
<tr><td><b>stringJoin</b>( list, separator )      </td><td>concatenate list of strings</td></tr>
<tr><td><b>stringSplit</b>( string, breaker )     </td><td>split string to list</td></tr>
<tr><td><b>stringLeft</b>( string, length )       </td><td>extract characters from the left</td></tr>
<tr><td><b>stringRight</b>( string, length )      </td><td>extract characters from the right</td></tr>
<tr><td><b>stringMid</b>( string, start, length ) </td><td>extract characters by start position and length</td></tr>
<tr><td><b>stringExtract</b>( string, start, end )</td><td>extract characters by start and end positions</td></tr>
</table>

<details function>
  <summary>&nbsp; &nbsp;<i>details</i></summary>
<table>
<tr><td colspan="2"><h4>stringJoin( list, separator )
<tr><td>list          <td>list of strings
<tr><td>separator = ""<td>optional separator between items
<tr><td><b><i>return  <td>string
</table>
<table>
<tr><td colspan="2"><h4>stringSplit( string, breaker )
<tr><td>string       <td>string to split
<tr><td>breaker = "."<td>breaker to use to separate each substring
<tr><td><b><i>return <td>list of string
</table>
<table>
<tr><td colspan="2"><h4>stringLeft( string, length )
<tr><td>string      <td>string to extract from
<tr><td>length      <td>number of characters to extract from the left
<tr><td><b><i>return<td>string
</table>
<table>
<tr><td colspan="2"><h4>stringRight( string, length )
<tr><td>string      <td>string to extract from
<tr><td>length      <td>number of characters to extract from the right
<tr><td><b><i>return<td>string
</table>
<table>
<tr><td colspan="2"><h4>stringMid( string, start, length )
<tr><td>string      <td>string to extract from
<tr><td>start = 0   <td>starting character position to extract
<tr><td>length      <td>number of characters to extract
<tr><td><b><i>return<td>string
</table>
<table>
<tr><td colspan="2"><h4>stringExtract( string, start, end )
<tr><td>string      <td>string to extract from
<tr><td>start = 0   <td>starting character position to extract
<tr><td>end         <td>ending character position to extract
<tr><td><b><i>return<td>string
</table>

</details>

<details code>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

```
echo("\n\n stringJoin(list,separator=\".\"):");
a = [ "apple", "banana", "carrot" ];
echo( str       ( a      ) ); // ["apple","banana","carrot"]
echo( stringJoin( a      ) ); // "applebananacarrot"
echo( stringJoin( a, "-" ) ); // "apple-banana-carrot"
b = [ 1, 22, 333 ];
echo( stringJoin( b      ) ); // "122333"
echo( stringJoin( b, "-" ) ); // "1-22-333"

echo("\n\n stringSplit(string,breaker=\".\"):");
echo( stringSplit( "apple"        , "." ) );   // ["apple"]
echo( stringSplit( "a.bb.ccc.dddd", "." ) );   // ["a","bb","ccc","dddd"]

echo("\n\n stringLeft(string,length):");       // "television"
echo(    stringLeft( "television", 1 ) );      // "t"
echo(    stringLeft( "television", 4 ) );      // "tele"

echo("\n\n stringRight(string,length):");      // "television"
echo(   stringRight( "television", 4 ) );      //       "sion"
echo(   stringRight( "television", 6 ) );      //     "vision"

echo("\n\n stringMid(string,start,length):");  // "television"
echo(     stringMid( "television", 0, 4 ) );   // "tele"
echo(     stringMid( "television", 4, 6 ) );   //     "vision"
echo(     stringMid( "television", 4, 5 ) );   //     "visio"

echo("\n\n stringExtract(string,start,end):"); // "television"
echo( stringExtract( "television", 0, 3 ) );   // "tele"
echo( stringExtract( "television", 4, 9 ) );   //     "vision"
echo( stringExtract( "television", 4, 5 ) );   //     "vi"
```
</details>
<!--/section-->

<!--section Utilities.Numbers-->
<table>
<tr><td colspan="2"><h4>Numbers</h4></td></tr>
<tr><td><b>numRound</b>( value, decPlace ) </td><td>round number
<tr><td><b>numFormat</b>( value, decPlace )</td><td>format number for display
</table>

<details function>
  <summary>&nbsp; &nbsp;<i>details</i></summary>
<table>
<tr><td colspan="2"><h4>numRound( value, decPlace=2 )
<tr><td>value       <td>number to round
<tr><td>decPlace = 2<td>decimal places to round to
<tr><td><b><i>return<td>number
</table>
<table>
<tr><td colspan="2"><h4>numFormat( value, decPlace=2, pos1000=3, sep1000=",", decPoint="." )
<tr><td>value         <td>number to format
<tr><td>decPlace = 2  <td>decimal places to round to
<tr><td>pos1000 = 3   <td>number of digits for 'thousand' separator
<tr><td>sep1000 = "," <td>character for 'thousand' separator
<tr><td>decPoint = "."<td>character for decimal point
<tr><td><b><i>return  <td>string
</table>
</details>

<details code>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

```
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
```
</details>

<!--/section-->

<!--section Utilities.List Operations-->

<table>
<tr><td colspan="2"><h4>List Operations</h4></td></tr>
<tr><td><b>listSum       </b>( list, start, end )</td><td>calculate sum list given a range
<tr><td><b>listRunningSum</b>( list )            </td><td>running totals
</table>

<details function>
  <summary>&nbsp; &nbsp;<i>details</i></summary>
<table>
<tr><td colspan="2"><h4>listSum( list, start=0, end )
<tr><td>list        <td>list of numbers
<tr><td>start = 0   <td>starting position to sum
<tr><td>end         <td>ending position to sum
<tr><td><b><i>return<td>number
</table>
<table>
<tr><td colspan="2"><h4>listRunningSum( list )
<tr><td>list        <td>list of numbers
<tr><td><b><i>return<td>list of numbers, output[n]=sum(input[0]:input[n])
</table>
</details>

<details code>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

```
echo("\n\n listSum(list,start=0,end):");
a=[1,2,3,4,5];
echo( listSum(a          )); // 15
echo( listSum(a,   2,  3 )); // 7
echo( listSum(a,   2     )); // 12
echo( listSum(a,   2, 10 )); // 12
echo( listSum(a,   0,  3 )); // 10
echo( listSum(a, -10,  3 )); // 10
echo( listSum(a,   2,  0 )); // undef
echo( listSum(a,  10, 20 )); // undef

echo("\n\n listRunningSum(list):");
echo( listRunningSum(a) );   // [1, 3, 6, 10, 15]
```
</details>
<!--/section-->

---
### KVTree
Searchable tree data structure for storing multiple values.

<!--section Key-Value-->
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

<details function>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="2"><h4>KVTree( list )
<tr><td>list        <td>list of key, value pairs
<tr><td><b><i>return<td>KVTree table (list)
</table>
<table>
<tr><td colspan="2"><h4>kvKeys( table, key )
<tr><td>table       <td>KVTree table
<tr><td>key         <td>if specified, returns the keys of of table[key] instead
<tr><td><b><i>return<td>list of keys
</table>
<table>
<tr><td colspan="2"><h4>kvValues( table, key )
<tr><td>table       <td>KVTree table
<tr><td>key         <td>if specified, returns the values of table[key] instead
<tr><td><b><i>return<td>list of values
</table>
<table>
<tr><td colspan="2"><h4>kvExists( table, key )
<tr><td>table       <td>KVTree table
<tr><td>key         <td>key to check for
<tr><td><b><i>return<td>boolean
</table>
<table>
<tr><td colspan="2"><h4>kvShow( table )
<tr><td>table       <td>KVTree table to display on console
</table>
<table>
<tr><td colspan="2"><h4>kvGet( table, key, defaultValue )
<tr><td>table       <td>KVTree table
<tr><td>key         <td>key to get
<tr><td>defaultValue<td>return if value found is undef
<tr><td><b><i>return<td>value from key
</table>
<table>
<tr><td colspan="2"><h4>kvSearch( table, key, defaultValue )
<tr><td>table       <td>KVTree table
<tr><td>key         <td>key to get
<tr><td>defaultValue<td>return if missing key or value found is undef
<tr><td><b><i>return<td>value from key
</table>
<table>
<tr><td colspan="2"><h4>kvSearchLax( table, key, defaultValue )
<tr><td>table       <td>KVTree table
<tr><td>key         <td>key to get
<tr><td>defaultValue<td>return if no table, missing key or value found is undef
<tr><td><b><i>return<td>value from key
</table>
<table>
<tr><td colspan="2"><h4>kvSearchOCD( table, key, defaultValue, ifKeyMissing )
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

</details>

<details code>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

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
</details>
<!--/section-->

---
### Hardwares
Uses KVTree to create a profile. A profile stores all parameters to render a hardware. Store various configurations for reuse.

<!--section Stepper Motor-->
<table>
<tr><td colspan="2"><h4>Nuts and Bolts</h4></td></tr>
<tr><td><b>BoltProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>Bolt</b>( profile )</td><td>generate bolt</td></tr>
<tr><td><b>BoltPanelHole</b>( profile )</td><td>generate 2D holes for panel mounting</td></tr>
<tr><td><b>NutProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>Nut</b>( profile )</td><td>generate nut</td></tr>
</table>

![photo](/images/nuts-bolts.png)
<details function>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="3"><h4>BoltProfile( ... )</td></tr>
<tr><td>model           <td>        <td>user defined model name
<tr><td>shape = "hex"   <td>        <td>shape of head: "hex", "square" or "round"
<tr><td>feature = "none"<td>        <td>feature on head: "none", "minus", "plus" or "hex"
<tr><td>shaftDiameter   <td>&#10004;<td>shaft diameter
<tr><td>length          <td>&#10004;<td>length, exclusing head
<tr><td>headDiameter    <td>&#10004;<td>head diameter
<tr><td>headThickness   <td>&#10004;<td>head thickness
<tr><td colspan="2"><b><i>return    <td>KVTree profile
</table>
<table>
<tr><td colspan="3"><h4>Bolt( profile )
<tr><td>profile<td>&#10004;<td>bolt profile to display
</table>
<table>
<tr><td colspan="3"><h4>BoltPanelHole( profile )
<tr><td>profile<td>&#10004;<td>bolt profile to generate panel holes for
</table>

<table>
<tr><td colspan="3"><h4>NutProfile( ... )</td></tr>
<tr><td>model        <td>        <td>user defined model name
<tr><td>shape = "hex"<td>        <td>shape of head: "hex", "square" or "round"
<tr><td>boltDiameter <td>&#10004;<td>inside diameter
<tr><td>nutDiameter  <td>&#10004;<td>outside diameter
<tr><td>thickness    <td>&#10004;<td>thickness
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>
<table>
<tr><td colspan="3"><h4>Nut( profile )
<tr><td>profile<td>&#10004;<td>nut profile to display
</table>
</details>

<details structure>
  <summary>&nbsp; &nbsp;<i>profile structure</i></summary>

```
type: "bolt"
model: "esV"
diameter: 5
length: 20
head =
   shape: "hex"
   diameter: 10
   thickness: 3
   feature: "none"
```
```
type: "nut"
model: "ella"
shape: "hex"
boltDiameter: 5
nutDiameter: 8
thickness: 3"
```
</details>

<details code>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

```
profile = BoltProfile(
    shape         = "hex",  // "hex" | "square" | "round" 
    feature       = "none", // "none" | "minus" | "plus" | "hex"
    shaftDiameter = 5,
    length        = 20,
    headDiameter  = 10,
    headThickness = 3 );
Bolt( profile );

translate( [0,-15,0] )
    linear_extrude( 3 )
    difference() {
        square( [10,10], center=true );
        BoltPanelHole( profile );
    }

translate( [30,0,0] ) {
                          featureVariation( "hex" );
    translate( [20,0,0] ) featureVariation( "square" );
    translate( [40,0,0] ) featureVariation( "round" );
}

translate( [0,-40,0] ) {
    nut1 = NutProfile( shape="hex",    boltDiameter=5, nutDiameter=8, thickness=3 );
    nut2 = NutProfile( shape="square", boltDiameter=5, nutDiameter=8, thickness=3 );
    nut3 = NutProfile( shape="round",  boltDiameter=5, nutDiameter=8, thickness=3 );
                          Nut( nut1 );
    translate( [10,0,0] ) Nut( nut2 );
    translate( [20,0,0] ) Nut( nut3 );
}

module featureVariation( shape ) {
    b1 = BoltProfile( shape=shape, shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
    Bolt( b1 );
    translate( [0,15,0] ) {
        b2 = BoltProfile( shape=shape, feature="minus", shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
        Bolt( b2 );
    }
    translate( [0,30,0] ) {
        b3 = BoltProfile( shape=shape, feature="plus", shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
        Bolt( b3 );
    }
    translate( [0,45,0] ) {
        b4 = BoltProfile( shape=shape, feature="hex", shaftDiameter=3, length=15, headDiameter=6, headThickness=3 );
        Bolt( b4 );
    }
}
```
</details>

<!--/section-->

<!--section Stepper Motor-->
<table>
<tr><td colspan="2"><h4>Stepper Motor</h4></td></tr>
<tr><td><b>StepperMotorProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>StepperMotor</b>( profile )</td><td>generate stepper motor</td></tr>
<tr><td><b>StepperMotorPanelHole</b>( profile )</td><td>generate 2D holes for panel mounting</td></tr>
</table>

![photo](/images/stepper-motor.png)

<details function>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="3"><h4>StepperMotorProfile( ... )</td></tr>
<tr><td>model              <td>        <td>user defined model name
<tr><td>nemaModel          <td>1A      <td>use info from NEMA model (unless overridden)
<tr><td>bodyDiameter       <td>1B      <td>width and depth of the motor
<tr><td>bodyLength         <td>1B      <td>length excluding shafts and cylinders
<tr><td>shaftDiameter      <td>1B      <td>shaft diameter
<tr><td>shaftLength        <td>1B      <td>shaft length
<tr><td>boltProfile        <td>2A      <td>use info from bolt profile (unless overridden)
<tr><td>boltDiameter       <td>2B      <td>bolt diameter
<tr><td>boltLength         <td>2B      <td>bolt length
<tr><td>boltToBoltDistance <td>&#10004;<td>distance between bolts
<tr><td>frontCylinder      <td>        <td>list [ diameter, height ]
<tr><td>backCylinder       <td>        <td>list [ diameter, height ]
<tr><td>flangeThickness    <td>        <td>list [ upper height, lower height ]
<tr><td>bodyTaper          <td>        <td>taper on body between flanges
<tr><td>overallTaper       <td>        <td>taper on motor body
<tr><td>backShaftLength = 0<td>        <td>length of shaft at the back
<tr><td>panelHoleDiameter  <td>        <td>size of center hole for panel mounting the motor
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>
<table>
<tr><td colspan="3"><h4>StepperMotor( profile )
<tr><td>profile<td>&#10004;<td>stepper motor profile to display
</table>
<table>
<tr><td colspan="3"><h4>StepperMotorPanelHole( profile )
<tr><td>profile<td>&#10004;<td>stepper motor profile to generate panel holes for
</table>
</details>

<details structure>
  <summary>&nbsp; &nbsp;<i>profile structure</i></summary>

```
type: "stepper motor"
model: "Wantai 57BYGH420-2"
nema: ""
bodyDiameter: 56.4
length =
   all: 77
   body: 57.6
   bodyOnly: 56
   frontCylinder: 1.6
   backCylinder: 0
   shaft: 19.4
   backShaft: 0
   frontFlange: 4.8
   backFlange: 0
shaft =
   diameter: 6.35
   length: 19.4
backShaft =
   diameter: 6.35
   length: 0
bolt =
   diameter: 5
   length: 10
   distance: 47.14
panelHole: 8.35
frontCylinder =
   diameter: 38.1
   length: 1.6
backCylinder =
   diameter: 0
   length: 0
taper =
   overall: 2.82
   body: 1
```
</details>

<details code>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

```
profile1 = StepperMotorProfile( nemaModel="NEMA17" );
PartAndPanel() {
    StepperMotor( profile1 );
    StepperMotorPanelHoles( profile1 );
};

// custom size
// https://www.sparkfun.com/products/13656 ==> Wantai 57BYGH420-2
// https://www.openimpulse.com/blog/wp-content/uploads/wpsc/downloadables/57BYGH420-Stepper-Motor-Datasheet.pdf
profile2 = StepperMotorProfile(
    model           = "Wantai 57BYGH420-2",
    bodyDiameter    = 56.4,
    bodyLength      = 56,
    shaftDiameter   = 6.35,
    shaftLength     = 21-1.6,
    boltDiameter    = 5,
    boltLength      = 10,
    boltDistance    = 47.14,
    frontCylinder   = [ 38.1, 1.6 ], // diameter, height
    flangeThickness = [  4.8,   0 ], // upper, lower
    bodyTaper       = 1 );
translate( [100,0,0] )
PartAndPanel() {
    StepperMotor( profile2 );
    StepperMotorPanelHoles( profile2, enlargeBolt=3 );
};
kvEcho( profile2 );

// with gear, bolts on gear
profile3 = StepperMotorProfile(
    nemaModel     = "NEMA23",
    boltDistance  = 20,
    frontCylinder = [40,20]
);
translate( [200,0,0] )
PartAndPanel() {
    StepperMotor( profile3 );
    StepperMotorPanelHoles( profile3 );
};
    
// with gear, bolts on body, back cylinder and shaft
// bigger panel hole
profile4 = StepperMotorProfile(
    nemaModel          = "NEMA23",
    boltDiameter       = 8,
    boltLength         = 25+8,    // go below frontCylinderLength
    boltDistance       = 38,
    frontCylinder      = [40,25],
    backCylinder       = [40,20],
    panelHoleDiameter  = 40+2,    // larger than frontCylinderDiameter
    backShaftLength    = 20 );
translate( [300,0,0] ) {
    // position to upper flange
    translate( [0,0, kvGet(profile4,"length.frontCylinder")] )
        StepperMotor( profile4 );
    translate( [0,-100,0] ) PanelOnly()
        StepperMotorPanelHoles( profile4 );
}

// position to lower shaft
translate( [400,0,0] ) {
    translate( [0,0,kvGet(profile3,"length.body")] )
        StepperMotor( profile3 );
}

// position to bottom of body, excluding lower cylinder
translate( [500,0,0] ) {
    translate( [0,0,kvGet(profile4,"length.body")-kvGet(profile4,"length.backCylinder")] )
        StepperMotor( profile4 );
}

module PartAndPanel() {
    children(0);
    translate( [0,-100,0] )
        PanelOnly() children(1);
}
module PanelOnly() {
    linear_extrude( 3 )
    difference() {
        square( [60,60], center=true );
        children();
    }
}
```
</details>

<!--/section-->


<!--section Hardware.FlangeBearing-->
<table>
<tr><td colspan="2"><h4>Flange Bearing</h4></td></tr>
<tr><td><b>FlangeBearingProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>FlangeBearing</b>( profile )</td><td>generate flange bearing</td></tr>
<tr><td><b>FlangeBearingPanelHoles</b>( profile )</td><td>generate 2D holes for panel mounting</td></tr>
</table>

![photo](/images/bearing-flange.png)

<details function>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="3"><h4>FlangeBearingProfile( ... )</td></tr>
<tr><td>model           <td>        <td>user defined model name
<tr><td>shaftDiameter   <td>&#10004;<td>shaft diameter
<tr><td>boltDiameter = 5<td>        <td>size of bolts
<tr><td>boltDistance    <td>&#10004;<td>bolt to bolt distance
<tr><td>boltCount = 2   <td>        <td>number of bolts, 2 or 4 only
<tr><td>height          <td>&#10004;<td>height of central part
<tr><td>ringHeight      <td>        <td>height of ring around the center
<tr><td>baseHeight      <td>        <td>thickness of base
<tr><td>width           <td>        <td>overall width
<tr><td>depth           <td>        <td>overall depth
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>
<table>
<tr><td colspan="3"><h4>FlangeBearing( profile )
<tr><td>profile<td>&#10004;<td>flange bearing profile to display
</table>
<table>
<tr><td colspan="3"><h4>FlangeBearingPanelHoles( profile )
<tr><td>profile<td>&#10004;<td>flange bearing profile to generate panel holes for
</table>
</details>

<details structure>
  <summary>&nbsp; &nbsp;<i>profile structure</i></summary>

```
type: "flange bearing"
model: "FB-100"
shaftDiameter: 10
bolt =
   diameter: 5
   distance: 50
   count: 4
width: 100
depth: 80
height =
   center: 32
   ring: 25
   base: 10
```
</details>

<details code>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

```
profile2a = FlangeBearingProfile(
    shaftDiameter =  8,
    boltDistance  = 37,
    height        = 12 );
PartAndPanel() {
    FlangeBearing( profile2a );
    FlangeBearingPanelHole( profile2a );
}

profile2b = FlangeBearingProfile(
    shaftDiameter =  10,
    boltDiameter  =   5, 
    boltDistance  =  80,
    boltCount     =   2, 
    height        =  20,
    width         = 100,
    depth         =  60 );
translate( [150,0,0] )
PartAndPanel() {
    FlangeBearing( profile2b );
    FlangeBearingPanelHole( profile2b, enlargeBolt=3 );
}

profile4a = FlangeBearingProfile( 
    shaftDiameter =  8,
    boltDistance  = 37,
    boltCount     =  4, 
    height        = 12 );
translate( [300,0,0] )
PartAndPanel() {
    FlangeBearing( profile4a );
    FlangeBearingPanelHole( profile4a, omitCenterHole=false, enlargeShaft=5 );
}

profile4b = FlangeBearingProfile(
    shaftDiameter =  10,
    boltDiameter  =   5,
    boltDistance  =  50,
    boltCount     =   4, 
    height        =  32,
    ringHeight    =  25, 
    baseHeight    =  10,
    width         = 100,
    depth         =  80 );
translate( [450,0,0] )
PartAndPanel() {
    FlangeBearing( profile4b );
    FlangeBearingPanelHole( profile4b );
}

module PartAndPanel() {
    children(0);
    translate( [0,-100,0] )
        linear_extrude( 3 )
        difference() {
            square( [120,100], center=true );
            children(1);
        }
}
```
</details>
<!--/section-->

<!--section Hardware.Thrust Bearing-->
<table>
<tr><td colspan="2"><h4>Thrust Bearing</h4></td></tr>
<tr><td><b>ThrustBearingProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>ThrustBearingFromLibrary</b>( model )</td><td>profile from predefined models</td></tr>
<tr><td><b>ThrustBearing</b>( profile )</td><td>generate thrust bearing</td></tr>
</table>

![stepper-motor](/images/bearing-thrust.png)

<details function>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="3"><h4>ThrustBearingProfile( ... )</td></tr>
<tr><td>model       <td>        <td>user defined model name
<tr><td>ID          <td>&#10004;<td>outside diameter
<tr><td>OD          <td>&#10004;<td>inside diameter
<tr><td>thickness   <td>&#10004;<td>thickness
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>
<table>
<tr><td colspan="3"><h4>ThrustBearingFromLibrary( model )
<tr><td>model<td>&#10004;<td>commercial name of thrust bearing, see source code
<tr><td colspan="2"><b><i>return<td>profile from predefined modes (see source code)
</table>
<table>
<tr><td colspan="3"><h4>ThrustBearing( profile )
<tr><td>profile<td>&#10004;<td>thrust bearing profile to display
</table>
</details>

<details structure>
  <summary>&nbsp; &nbsp;<i>profile structure</i></summary>

```
type: "thrust bearing"
model: "51102"
ID: 15
OD: 28
thickness: 9
```
</details>

<details code>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

```
profile1 = ThrustBearingProfile(
    model="dunkin", ID=20, OD=30, thickness=10 );
ThrustBearing( profile1 );

profile2 = ThrustBearingFromLibrary( "51102" );
translate( [50,0,-kvGet(profile2,"thickness")] )
    ThrustBearing( profile2 );

profile3 = ThrustBearingFromLibrary( "F12-21M" );
translate( [100,0,0] )
    ThrustBearing( profile3, omitBalls=true );
```
</details>

>|Timing Pulley
-|:-|
TimingPulleyProfile  |create profile
TimingPulley         |generate timing pulley
TimingPulleyConnected|generate connected timing pulleys
TimingPulleyCenterDistance|calculate distance between pulleys
TimingPulleyCenterDistanceByModel|calculate distance between pulleys
TimingPulleyDiameter|calculate diameter of pulley

<!--/section-->

<!--section Hardware.Timing Pulley-->
<!--
<table>
<tr><td colspan="2"><h4>Timing Pulley</h4>
</h4></td></tr>
<tr><td><b>TimingPulleyProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>TimingPulley</b>( profile )</td><td>generate timing pulley</td></tr>
<tr><td><b>TimingPulleyConnected</b>( profile1, profile2, beltLength )</td><td>generate connected timing pulleys</td></tr>
<tr><td><b>TimingPulleyCenterDistance</b>( profile1, profile2, beltLength )</td><td>center to center distance between 2 pulleys</td></tr>
<tr><td><b>TimingPulleyCenterDistanceByModel</b>( model, tooth1, tooth2, beltLength )</td><td>center to center distance between 2 pulleys</td></tr>
<tr><td><b>TimingPulleyDiameter</b>( model, toothCount )</td><td>calculate diameter of pulley</td></tr>
</table>
-->

base code from: [https://www.thingiverse.com/thing:16627](https://www.thingiverse.com/thing:16627) by droftarts
this version is still suitable for 3D printing
![stepper-motor](/images/timing-pulley.png)

<details function>
  <summary>&nbsp; &nbsp;<i>details</i></summary>


|>|>|TimingPulleyProfile( ... )
|-|-|:-|
| model                 | &nbsp;   | user defined model name
| toothModel            | &#10004; | pulley type, eg. "T5", "GT2 2mm"...
| toothCount            | &#10004; | number of teeth
| beltWidth             | &#10004; | thickness of notched cylinder
| shaftDiameter         | &#10004; | shaft diameter
| topFlangeInfo         | &nbsp;   | list [ radiusOffset, taperedHeight, flatHeight ]
| bottomFlangeInfo      | &nbsp;   | list [ radiusOffset, taperedHeight, flatHeight ]
| hubInfo               | &nbsp;   | list [ diameter, height ]
| nutInfo               | &nbsp;   | list [ "hex" or "square", boltDiameter, nutDiameter, thickness ]
| captiveNutsInfo       | &nbsp;   | list [ nutCount, angleBetweenNuts, offsetFromShaft ]
| toothWidthTweak = 0.2 | &nbsp;   | adjustments to fine tune 3D printing...
| toothDepthTweak = 0   | &nbsp;   | ... see source timingPulleyNotchedCylinderCore()
| **_return_**          |          | KVTree profile

|>|>|TimingPulley( profile )
|-|-|:-|
|model|&#10004;|user defined model name

|>|>|TimingPulleyConnected( profile1, profile2, beltLength )
|-|-|:-|
| profile1        | &#10004; | timing pulley profile 1
| profile2        | &#10004; | timing pulley profile 2
| beltLength      | &#10004; | length of belt to use
| beltWidth       | &nbsp;   | width of belt
| beltThickness=2 | &nbsp;   | thickness of belt for display
| reversed=false  | &nbsp;   | reverse 2nd pulley (hub of other side)
| omitTeeth=false | &nbsp;   | omit teeth notches for display performance
| showBelt=true   | &nbsp;   | display connecting belt
 
<!--
<table>
<tr><td colspan="3"><h4>TimingPulleyProfile( ... )
<tr><td>model                <td>        <td>user defined model name
<tr><td>toothModel           <td>&#10004;<td>pulley type, eg. "T5", "GT2 2mm"...
<tr><td>toothCount           <td>&#10004;<td>number of teeth
<tr><td>beltWidth            <td>&#10004;<td>thickness of notched cylinder
<tr><td>shaftDiameter        <td>&#10004;<td>shaft diameter
<tr><td>topFlangeInfo        <td>        <td>list [ radiusOffset, taperedHeight, flatHeight ]
<tr><td>bottomFlangeInfo     <td>        <td>list [ radiusOffset, taperedHeight, flatHeight ]
<tr><td>hubInfo              <td>        <td>list [ diameter, height ]
<tr><td>nutInfo              <td>        <td>list [ "hex" or "square", boltDiameter, nutDiameter, thickness ]
<tr><td>captiveNutsInfo      <td>        <td>list [ nutCount, angleBetweenNuts, offsetFromShaft ]
<tr><td>toothWidthTweak = 0.2<td>        <td>adjustments to fine tune 3D printing...
<tr><td>toothDepthTweak = 0  <td>        <td>... see source timingPulleyNotchedCylinderCore()
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>
<table>
<tr><td colspan="3"><h4>TimingPulley( profile )
<tr><td>profile<td>&#10004;<td>timing pulley profile to display
</table>
<table>
<tr><td colspan="3"><h4>TimingPulleyConnected( profile1, profile2, beltLength )
<tr><td>profile1       <td>&#10004;<td>timing pulley profile 1
<tr><td>profile2       <td>&#10004;<td>timing pulley profile 2
<tr><td>beltLength     <td>&#10004;<td>length of belt to use
<tr><td>beltWidth      <td>        <td>width of belt
<tr><td>beltThickness=2<td>        <td>thickness of belt for display
<tr><td>reversed=false <td>        <td>reverse 2nd pulley (hub of other side)
<tr><td>omitTeeth=false<td>        <td>omit notches for display performance
<tr><td>showBelt=true  <td>        <td>show or hide connecting belt
</table>
-->

<table>
<tr><td colspan="3"><h4>TimingPulleyCenterDistance( profile1, profile2, beltLength )
<tr><td>profile1  <td>&#10004;<td>timing pulley profile 1
<tr><td>profile2  <td>&#10004;<td>timing pulley profile 2
<tr><td>beltLength<td>&#10004;<td>length of belt to use
<tr><td colspan="2"><b><i>return<td>distance between centers
</table>
<table>
<tr><td colspan="3"><h4>TimingPulleyCenterDistanceByModel( model, toothCount1, toothCount2, beltLength )
<tr><td>model      <td>&#10004;<td>pulley type, eg. "T5", "GT2 2mm"...
<tr><td>toothCount1<td>&#10004;<td>number of teeth of pulley 1
<tr><td>toothCount2<td>&#10004;<td>number of teeth of pulley 2
<tr><td>beltLength <td>&#10004;<td>length of belt to use
<tr><td colspan="2"><b><i>return<td>distance between centers
</table>
<table>
<tr><td colspan="3"><h4>TimingPulleyDiameter( model, toothCount )
<tr><td>model     <td>&#10004;<td>pulley type, eg. "T5", "GT2 2mm"...
<tr><td>toothCount<td>&#10004;<td>number of teeth of pulley 1
<tr><td colspan="2"><b><i>return<td>diameter of pulley
</table>
</details>

<details structure>
  <summary>&nbsp; &nbsp;<i>profile structure</i></summary>

```
type: "timing pulley"
model: "pushy-101"
toothModel: "GT2 2mm"
toothCount: 60
beltWidth: 12
shaftDiameter: 6
height =
   total: 33
   beltCenter: 24
   belt: 12
   topFlange: 3
   bottomFlange: 3
   hub: 15
topFlange =
   offset: 3
   height: 3
   taperHeight: 1
   flatHeight: 2
bottomFlange =
   offset: 3
   height: 3
   taperHeight: 1
   flatHeight: 2
hub =
   diameter: 20
   height: 15
nut =
   shape: "hex"
   boltDiameter: 3.2
   nutDiameter: 5.7
   thickness: 2.7
captiveNuts =
   count: 3
   angleBetweenNuts: 120
   offsetFromShaft: 1.2
tweak =
   toothWidth: 0
   toothDepth: 0
```
</details>

<details code>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

```
profile1 = TimingPulleyProfile(

    toothModel         = "GT2 2mm",
    toothCount         =   60,
    beltWidth          =   12,
    shaftDiameter      =    6,
    topFlangeInfo    = [    3,   // offset notched cylinder diameter
                            1,   // tapered height
                            2    // flat height
                       ],
    bottomFlangeInfo = [    3,
                            1,
                            2
                       ],
    hubInfo          = [   20,   // diameter
                           15    // height
                       ],         
    nutInfo          = [ "hex",  // hex or square
                            3.2, // bolt diameter
                            5.7, // nut diameter
                            2.7  // thickness
                       ],
    captiveNutsInfo  = [    3,   // number of nuts
                          120,   // angle between nuts
                            1.2  // offset from shaft (NOT offset from center)
                       ],
    toothWidthTweak    =    0.2, // fine tune teeth for 3D printing
    toothDepthTweak    =    0
    );

translate( [0,0,0] )
    TimingPulley( profile1, omitTeeth=true );

// 3-D PRINTING (detailed but slow)
translate( [75,0,0] )
    TimingPulley( profile1, for3DPrinting=true, autoFlip=true );

// CONNECTED PULLEYS
profile2 = TimingPulleyProfile(
    toothModel="GT2 2mm",
    toothCount=16, beltWidth=12,
    shaftDiameter=6,
    topFlangeInfo=[3,1,2], bottomFlangeInfo=[3,1,2],
    hubInfo=[20,15] );

beltLength=200;
center2center = TimingPulleyCenterDistance( profile1, profile2, beltLength );
s1 = kvGet(profile1,"shaftDiameter" );
s2 = kvGet(profile2,"shaftDiameter" );

translate( [150,0,0] ) {
    TimingPulleyConnected( profile1, profile2, beltLength, beltWidth=10, reversed=true );            
                                     translate( [0,0,30] ) cylinder( 100, d=s1, center=true );
    translate( [center2center,0,0] ) translate( [0,0,30] ) cylinder( 100, d=s2, center=true );
}

// COMPUTATIONS
echo( TimingPulleyDiameter( "AT5", 64 ) );
echo( TimingPulleyDiameter( "AT5", 20 ) );
echo( TimingPulleyCenterDistanceByModel( "AT5", 64, 20, 700 ) );
```
</details>

<!--/section-->





---
---
<!--section TEMPLATE-->
<table>
<tr><td colspan="2"><h4>PART</h4></td></tr>
<tr><td><b>function</b>( ... )</td><td>description</td></tr>
</table>

![stepper-motor](/images/abc.png)

<details function>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="2"><h4>function( ... )</td></tr>
<tr><td>param              <td>description
<tr><td><b><i>return       <td>description
</table>
</details>

<details structure>
  <summary>&nbsp; &nbsp;<i>profile structure</i></summary>

```
tree
```
</details>

<details code>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

```
code

```
</details>

<!--/section-->


<!--
## TEST ONLY
<details>

  <summary>Click to expand!</summary>
  
  ## Heading
  
  ### 3rd level

  #### 4th

  ##### 5th

  1. A numbered
  2. list
     * With some
     * Sub bullets

</details>
.  

  ## Heading
  
  ### 3rd level

  #### 4th

  ##### 5th

  1. A numbered
  2. list
     * With some
     * Sub bullets
.  
  
hello there  
  
  

```
code
```

[Contribution guidelines for this project](docs/CONTRIBUTING.md)
-->
