# OpenSCAD.Library
---
<!--
### String
**stringJoin(** list, separator="" **)**: concatenate list of strings  
**stringSplit(** string, breaker="." **)**: split string to list  
**stringLeft(** string, length **)**: extract characters from the left  
**stringRight(** string, length **)**: extract characters from the right  
**stringMid(** string, start, length **)**: extract characters by start position and length  
**stringExtract(** string, start, end **)**: extract characters by start and end positions
-->

<table>
<tr><td colspan="2"><h3>String</h3></td></tr>
<tr><td><b>stringJoin</b>( list, separator="" )   </td><td>concatenate list of strings</td></tr>
<tr><td><b>stringSplit</b>( string, breaker="." ) </td><td>split string to list</td></tr>
<tr><td><b>stringLeft</b>( string, length )       </td><td>extract characters from the left</td></tr>
<tr><td><b>stringRight</b>( string, length )      </td><td>extract characters from the right</td></tr>
<tr><td><b>stringMid</b>( string, start, length ) </td><td>extract characters by start position and length</td></tr>
<tr><td><b>stringExtract</b>( string, start, end )</td><td>extract characters by start and end positions</td></tr>
</table>

<details>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="2"><h4>stringJoin( list, separator="" )
<tr><td>list        <td>list of strings
<tr><td>separator   <td>optional separator between items
<tr><td><b><i>return<td>string
</table>
<table>
<tr><td colspan="2"><h4>stringSplit( string, breaker="." )
<tr><td>string      <td>string to split
<tr><td>breaker     <td>breaker to use to separate each substring
<tr><td><b><i>return<td>list of string
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
<tr><td>start       <td>starting character position to extract
<tr><td>length      <td>number of characters to extract
<tr><td><b><i>return<td>string
</table>
<table>
<tr><td colspan="2"><h4>stringExtract( string, start, end )
<tr><td>string      <td>string to extract from
<tr><td>start       <td>starting character position to extract
<tr><td>end         <td>ending character position to extract
<tr><td><b><i>return<td>string
</table>
</details>

<details>
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

---
<!--
### Numbers
**numRound()**: number rounding  
**numFormat()**: number formatting
-->

<table>
<tr><td colspan="2"><h3>Numbers</h3></td></tr>
<tr><td><b>numRound</b>( value, decPlace=2 )   </td><td>round number</td></tr>
<tr><td><b>numFormat</b>( value, decPlace=2 ) </td><td>format number for display</td></tr>
</table>

<details>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="2"><h4>numRound( value, decPlace=2 )
<tr><td>value       <td>number to round
<tr><td>decPlace    <td>decimal places to round to
<tr><td><b><i>return<td>number
</table>
<table>
<tr><td colspan="2"><h4>numFormat( value, decPlace=2, pos1000=3, sep1000=",", decPoint="." )
<tr><td>value       <td>number to format
<tr><td>decPlace    <td>decimal places to round to
<tr><td>pos1000     <td>number of digits for 'thousand' separator
<tr><td>sep1000     <td>character for 'thousand' separator
<tr><td>decPoint    <td>character for decimal point
<tr><td><b><i>return<td>string
</table>
</details>

<details>
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


---
<!--
## List Manipulation
**listSum()**: calculate sum from list given range  
**listRunningSum()**: running totals
-->
<table>
<tr><td colspan="2"><h3>List Operations</h3></td></tr>
<tr><td><b>listSum</b>( list, start=0, end )   </td><td>calculate sum from list given range</td></tr>
<tr><td><b>listRunningSum</b>( list ) </td><td>running totals</td></tr>
</table>

<details>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="2"><h4>listSum( list, start=0, end )
<tr><td>list        <td>list of numbers
<tr><td>start       <td>starting position to sum
<tr><td>end         <td>ending position to sum
<tr><td><b><i>return<td>number
</table>
<table>
<tr><td colspan="2"><h4>listRunningSum( list )
<tr><td>list        <td>list of numbers
<tr><td><b><i>return<td>list of numbers, output[n]=sum(input[0]:input[n])
</table>
</details>

<details>
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


---
<!--
### Key-Value  
**KeyValue()**: create table  
**kvKeys()**: get keys  
**kvValues()**: get values  
**kvExists()**: check if key exists  
**kvShow()**: echo to console  
**kvGet()**: get expected key  
**kvSearch()**: get optional key 
**kvSearchOCD()**: differentiates between missing keys and not defined
-->

<table>
<tr><td colspan="2"><h3>Key-Value ~ Searchable Data Storage</h3></td></tr>
<tr><td><b>KeyValue</b>( list )</td><td>create key-value table</td></tr>
<tr><td><b>kvKeys</b>( table, key )</td><td>get keys</td></tr>
<tr><td><b>kvValues</b>( table, key )</td><td>get values</td></tr>
<tr><td><b>kvExists</b>( table, key )</td><td>check if key exists</td></tr>
<tr><td><b>kvShow</b>( table )</td><td>echo to console</td></tr>
<tr><td><b>kvGet</b>( table, key, defaultValue )</td><td>get expected key</td></tr>
<tr><td><b>kvSearch</b>( table, key, defaultValue )</td><td>get optional key</td></tr>
<tr><td><b>kvSearchLax</b>( table, key, defaultValue )</td><td>get optional key, optional table</td></tr>
<tr><td><b>kvSearchOCD</b>( table, key, defaultValue, ifKeyMissing )</td><td>handles missing key vs not defined</td></tr>
</table>

<details>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="2"><h4>KeyValue( list )
<tr><td>table       <td>KeyValue() table
<tr><td><b><i>return<td>list (referred to as table)
</table>
<table>
<tr><td colspan="2"><h4>kvKeys( table, key )
<tr><td>table       <td>KeyValue() table
<tr><td>key         <td>if specified, returns the keys of table[key] instead
<tr><td><b><i>return<td>list of keys
</table>
<table>
<tr><td colspan="2"><h4>kvValues( table, key )
<tr><td>table       <td>KeyValue() table
<tr><td>key         <td>if specified, returns the values table[key] instead
<tr><td><b><i>return<td>list of values
</table>
<table>
<tr><td colspan="2"><h4>kvExists( table, key )
<tr><td>table       <td>KeyValue() table
<tr><td>key         <td>key to check for
<tr><td><b><i>return<td>boolean
</table>
<table>
<tr><td colspan="2"><h4>kvShow( table )
<tr><td>table       <td>KeyValue() table to display on console
</table>
<table>
<tr><td colspan="2"><h4>kvGet( table, key, defaultValue )
<tr><td>table       <td>KeyValue() table
<tr><td>key         <td>key to get
<tr><td>defaultValue<td>return if value found is undef
<tr><td><b><i>return<td>value from key
</table>
<table>
<tr><td colspan="2"><h4>kvSearch( table, key, defaultValue )
<tr><td>table       <td>KeyValue() table
<tr><td>key         <td>key to get
<tr><td>defaultValue<td>return if missing key or value found is undef
<tr><td><b><i>return<td>value from key
</table>
<table>
<tr><td colspan="2"><h4>kvSearchLax( table, key, defaultValue )
<tr><td>table       <td>KeyValue() table
<tr><td>key         <td>key to get
<tr><td>defaultValue<td>return if no table, missing key or value found is undef
<tr><td><b><i>return<td>value from key
</table>
<table>
<tr><td colspan="2"><h4>kvSearchOCD( table, key, defaultValue, ifKeyMissing )
<tr><td>table       <td>KeyValue() table
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

<details>
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


---
<table>
<tr><td colspan="2"><h3>Stepper Motor</h3></td></tr>
<tr><td><b>StepperMotorProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>StepperMotor</b>( profile )</td><td>generate stepper motor</td></tr>
<tr><td><b>StepperMotorPanelHole</b>( profile )</td><td>generate 2D holes for panel mounting</td></tr>
</table>
<details>
  <summary>&nbsp; &nbsp;<i>details</i></summary>

<table>
<tr><td colspan="2"><h4>StepperMotorProfile( ... )
<tr><td>model             <td>user defined model name
<tr><td>nemaModel         <td>use info from NEMA model (unless overridden)
<tr><td>bodyDiameter      <td>width and depth of the motor
<tr><td>bodyLength        <td>length excluding shafts and cylinders
<tr><td>shaftDiameter     <td>shaft diameter
<tr><td>shaftLength       <td>shaft length
<tr><td>boltProfile       <td>use info from bolt profile (unless overridden)
<tr><td>boltDiameter      <td>bolt diameter
<tr><td>boltLength        <td>bold length
<tr><td>boltToBoltDistance<td>distance between bolts
<tr><td>frontCylinder     <td>list [ diameter, height ]
<tr><td>backCylinder      <td>list [ diameter, height ]
<tr><td>flangeThickness   <td>list [ upper height, lower height ]
<tr><td>bodyTaper         <td>taper on body between flanges
<tr><td>overallTaper      <td>taper on motor body
<tr><td>backShaftLength   <td>length of shaft at the back
<tr><td>panelHoleDiameter <td>size of center hole for panel mounting the motor
<tr><td><b><i>return      <td>profile (KeyValue())
</table>
<table>
<tr><td colspan="2"><h4>StepperMotor( profile )
<tr><td>profile       <td>stepper motor profile to display
</table>
<table>
<tr><td colspan="2"><h4>StepperMotorPanelHole( profile )
<tr><td>profile       <td>stepper motor profile to generate panel holes for
</table>

Profile Structure:
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

![stepper-motor](/images/stepper-motor.png)
<details>
  <summary>&nbsp; &nbsp;<i>code sample</i></summary>

```
profile1 = StepperMotorProfile( nemaModel="NEMA17" );
generateMotorAndPanel( profile1 );

// custom size
// https://www.sparkfun.com/products/13656 ==> Wantai 57BYGH420-2
// https://www.openimpulse.com/blog/wp-content/uploads/wpsc/downloadables/57BYGH420-Stepper-Motor-Datasheet.pdf
profile2 = StepperMotorProfile(
    bodyDiameter       = 56.4,
    bodyLength         = 56,
    shaftDiameter      = 6.35,
    shaftLength        = 21-1.6,
    boltDiameter       = 5,
    boltLength         = 10,
    boltToBoltDistance = 47.14,
    frontCylinder      = [38.1,1.6], // diameter,height
    flangeThickness    = [4.8,0],    // top, bottom
    bodyTaper          = 1 );
translate( [100,0,0] )
    generateMotorAndPanel( profile2 );

// with gear, bolts on gear
profile3 = StepperMotorProfile(
    nemaModel          = "NEMA23",
    boltToBoltDistance = 20,
    frontCylinder      = [40,20]
);
translate( [200,0,0] )
    generateMotorAndPanel( profile3 );
    
// with gear, bolts on body, back cylinder and shaft
// bigger panel hole
profile4 = StepperMotorProfile(
    nemaModel          = "NEMA23",
    boltDiameter       = 8,
    boltLength         = 25+8,    // go below frontCylinderLength
    boltToBoltDistance = 38,
    frontCylinder      = [40,25],
    backCylinder       = [40,20],
    panelHoleDiameter  = 40+2,    // larger than frontCylinderDiameter
    backShaftLength    = 20 );
// position to upper flange
translate( [300,0,0] ) {
    translate( [0,0, kvGet(profile4,"length.frontCylinder")] )
        StepperMotor( profile4 );
    translate( [0,-100,0] )
        generatePanel( profile4 );
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

module generateMotorAndPanel( profile ) {
    StepperMotor( profile );
    translate( [0,-100,0] )
        generatePanel( profile );            
}
module generatePanel( profile ) {
    linear_extrude( 3 )
    difference() {
        square( [60,60], center=true );
        StepperMotorPanelHole( profile );
    }
}
```
</details>

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
