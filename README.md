# OpenSCAD.Library

---
### String
**strcat()**: concatenate string list  
**strsplit()**: split string to list  
**substr()**: extract characters from list (start,length)  
**substr2()**: extract characters from list (start,end)

<details>
  <summary>&nbsp; &nbsp;<i>strcat() sample</i></summary>

```
a = ["apple","banana","carrot"];
echo( str   (a    ) ); // ["apple","banana","carrot"]
echo( strcat(a    ) ); // "applebananacarrot"
echo( strcat(a,"-") ); // "apple-banana-carrot"
b = [1,22,333];
echo( strcat(b    ) ); // "122333"
echo( strcat(b,"-") ); // "1-22-333"
```
</details>
<details>
  <summary>&nbsp; &nbsp;<i>strsplit() sample</i></summary>

```
echo( strsplit( "apple"         ) ); // ["apple"]
echo( strsplit( "a.bb.ccc.dddd" ) ); // ["a","bb","ccc","dddd"]
```
</details>
<details>
  <summary>&nbsp; &nbsp;<i>substr() sample</i></summary>

```
echo( substr( "television"       ) ); // "television"
echo( substr( "television", 4    ) ); // "vision"
echo( substr( "television", 4, 5 ) ); // "visio"
```
</details>
<details>
  <summary>&nbsp; &nbsp;<i>substr2() sample</i></summary>

```
echo( substr2( "television"       ) ); // "television"
echo( substr2( "television", 4    ) ); // "vision"
echo( substr2( "television", 4, 5 ) ); // "vi"
```
</details>

---
### Numbers
**numRound()**: number rounding  
**numFormat()**: number formatting

<details>
  <summary>&nbsp; &nbsp;<i>numRound() sample</i></summary>

```
echo( numRound( 123.45678     ) ); // 123.46
echo( numRound( 123.45678,  0 ) ); // 123
echo( numRound( 123.45678,  1 ) ); // 123.5
echo( numRound( 123.45678, -1 ) ); // 120
echo( numRound( 123.45678, -2 ) ); // 100
```
</details>
<details>
  <summary>&nbsp; &nbsp;<i>numFormat() sample</i></summary>

```
n = 123456789.123456789;
echo( numFormat( n                               ) ); // "123,456,789.12"
echo( numFormat( n, 4                            ) ); // "123,456,789.1235"
echo( numFormat( n,    sep1000="`", decPoint="-" ) ); // "123`456`789-12"
echo( numFormat( n, 4, pos1000=4                 ) ); // "1,2345,6789.1235"
```
</details>

---
## List Manipulation
**listSum()**: calculate sum from list given range  
**listRunningSum()**: running totals

<details>
  <summary>&nbsp; &nbsp;<i>listSum() sample</i></summary>

```
a=[1,2,3,4,5];
echo( listSum(a          )); // 15
echo( listSum(a,   2,  3 )); // 7
echo( listSum(a,   2     )); // 12
echo( listSum(a,   2, 10 )); // 12
echo( listSum(a,   0,  3 )); // 10
echo( listSum(a, -10,  3 )); // 10
echo( listSum(a,   2,  0 )); // undef
echo( listSum(a,  10, 20 )); // undef
```
</details>
<details>
  <summary>&nbsp; &nbsp;<i>listRunningSum() sample</i></summary>

```
a=[1,2,3,4,5];
echo( listRunningSum(a) );   // [1, 3, 6, 10, 15]
```
</details>

---
### Key-Value  
**KeyValue()**: create table  
**kvKeys()**: get keys  
**kvValues()**: get values  
**kvExists()**: check if keys exists  
**kvShow()**: echo to console  
**kvGet()**: get expected key  
**kvSearch()**: get optional keys  
**kvSearchOCD()**: differentiates between missing keys and not defined

<details>
  <summary>&nbsp; &nbsp;<i>KeyValue() sample</i></summary>

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
```
</details>
<details>
  <summary>&nbsp; &nbsp;<i>kvKeys()/kvValues() sample</i></summary>

```
echo( kvKeys  ( table ) );          // ["solo", "notSure", "fruit", "color", "animal", "model"]
echo( kvKeys  ( table, "color" ) ); // ["red", "green", "blue"]
echo( kvValues( table, "fruit" ) ); // [1, 2, 3]
```
</details>
<details>
  <summary>&nbsp; &nbsp;<i>kvExists() sample</i></summary>

```
echo( kvExists( table, "solo" ) );                     // true
echo( kvExists( table, "animal.dog.breed.poodle" ) );  // true
echo( kvExists( table, "animal.dog.breed.bulldog" ) ); // false
```
</details>
<details>
  <summary>&nbsp; &nbsp;<i>kvShow() sample</i></summary>

```
kvShow( table );

CONSOLE:

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
<details>
  <summary>&nbsp; &nbsp;<i>kvGet() sample</i></summary>

Get expected keys. Throws error if key is missing.
```
echo( kvGet( table, "solo" ) );                   // 0
echo( kvGet( table, "notSure" ) );                // undef
echo( kvGet( table, "fruit.apple" ) );            // 1
echo( kvGet( table, "color.green" ) );            // "grass"
echo( kvGet( table, "animal.dog.color.white" ) ); // 30
echo( kvGet( table, "model" ) );                  // "ABC123"
```
*Missing expected keys.*
```
echo( kvGet( table, "missingKey" ) );   // ERROR: "[missingKey] missing"
echo( kvGet( table, "fruit.dragon" ) ); // ERROR: "[dragon] in [fruit.dragon] missing"
```
*Extract inner table.*
```
animalTable = kvGet( table, "animal" );
echo( kvGet( animalTable, "cat.breed.siamese" ) ); // 50
```
*Default values. Used if result is **undef**. Still error if key is missing.*
```
echo( kvGet( table, "notSure" ) );                       // undef
echo( kvGet( table, "notSure",    defaultValue=true ) ); // true
echo( kvGet( table, "missingKey", defaultValue=1    ) ); // ERROR: "[missingKey] missing"
```
</details>
<details>
  <summary>&nbsp; &nbsp;<i>kvSearch() sample</i></summary>

Get optional keys. Returns **undef** if missing.
```
echo( kvSearch( table, "solo.hans" ) );     // undef
echo( kvSearch( table, "animal.dragon" ) ); // undef
echo( kvSearch( table, "Model" ) );         // undef
```
*Default values. Used if result is **undef** or key is missing.*
```
echo( kvSearch( table, "solo.hans", defaultValue=123 ) ); // 123
echo( kvSearch( table, "notSure",   defaultValue=123 ) ); // 123
```
</details>
<details>
  <summary>&nbsp; &nbsp;<i>kvSearchOCD() sample</i></summary>

Differentiates between missing keys or set as **undef**.
```
echo( kvSearchOCD( table, "missingKey",                           defaultValue="dunno" ) );   // undef
echo( kvSearchOCD( table, "notSure",                              defaultValue="dunno" ) );   // "dunno"
echo( kvSearchOCD( table, "missingKey", defaultMissing="missing"                       ) );   // "missing"
echo( kvSearchOCD( table, "notSure",    defaultMissing="missing"                       ) );   // undef
echo( kvSearchOCD( table, "missingKey", defaultMissing="missing", defaultValue="dunno" ) );   // "missing"
echo( kvSearchOCD( table, "notSure",    defaultMissing="missing", defaultValue="dunno" ) );   // "dunno"
```
</details>

---
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