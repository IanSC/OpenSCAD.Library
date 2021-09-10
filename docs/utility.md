# Utilities

---
## String Functions
<table>
<tr><td><b>stringJoin</b>( list, separator )      </td><td>concatenate list of strings</td></tr>
<tr><td><b>stringSplit</b>( string, breaker )     </td><td>split string to list</td></tr>
<tr><td><b>stringLeft</b>( string, length )       </td><td>extract characters from the left</td></tr>
<tr><td><b>stringRight</b>( string, length )      </td><td>extract characters from the right</td></tr>
<tr><td><b>stringMid</b>( string, start, length ) </td><td>extract characters by start position and length</td></tr>
<tr><td><b>stringExtract</b>( string, start, end )</td><td>extract characters by start and end positions</td></tr>
<tr><td><b>stringRepeat</b>( string, repeat )     </td><td>repeat string number of times</td></tr>
<tr><td><b>stringRepeat</b>( string, repeat )     </td><td>repeat string number of times</td></tr>
<tr><td><b>stringPad</b>( string, length )        </td><td>pad string to specified length</td></tr>
<tr><td><b>stringPadLeft</b>( string, length )    </td><td>pad string to specified length on the left</td></tr>
</table>

#### _stringJoin( list, separator )_
<table>
<tr><td>list          <td>list of strings
<tr><td>separator = ""<td>optional separator between items
<tr><td><b><i>return  <td>string
</table>

#### _stringSplit( string, breaker )_
<table>
<tr><td>string       <td>string to split
<tr><td>breaker = "."<td>breaker to use to separate each substring
<tr><td><b><i>return <td>list of string
</table>

#### _stringLeft( string, length )_
<table>
<tr><td>string      <td>string to extract from
<tr><td>length      <td>number of characters to extract from the left
<tr><td><b><i>return<td>string
</table>

#### _stringRight( string, length )_
<table>
<tr><td>string      <td>string to extract from
<tr><td>length      <td>number of characters to extract from the right
<tr><td><b><i>return<td>string
</table>

#### _stringMid( string, start, length )_
<table>
<tr><td>string      <td>string to extract from
<tr><td>start = 0   <td>starting character position to extract
<tr><td>length      <td>number of characters to extract
<tr><td><b><i>return<td>string
</table>

#### _stringExtract( string, start, end )_
<table>
<tr><td>string      <td>string to extract from
<tr><td>start = 0   <td>starting character position to extract
<tr><td>end         <td>ending character position to extract
<tr><td><b><i>return<td>string
</table>

#### _stringRepeat( string, repeat )_
<table>
<tr><td>string      <td>string to repeat
<tr><td>repeat = 1  <td>number of times to repeat
<tr><td><b><i>return<td>string
</table>

#### stringPad( string, length, trimIfExcess, char )_
<table>
<tr><td>string            <td>string to pad
<tr><td>length            <td>target length
<tr><td>trimIfExcess=false<td>trim instead string is over the desired length
<tr><td>char = " "        <td>padding character
<tr><td><b><i>return<td>string
</table>

#### stringPadLeft( string, length, trimIfExcess, char )_
<table>
<tr><td>string            <td>string to pad
<tr><td>length            <td>target length
<tr><td>trimIfExcess=false<td>trim instead string is over the desired length
<tr><td>char = " "        <td>padding character
<tr><td><b><i>return<td>string
</table>

<br>

```
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
```

---
## Numbers

#### _numRound( value, decPlace )_
<table>
<tr><td>value       <td>number to round
<tr><td>decPlace = 2<td>decimal places to round to
<tr><td><b><i>return<td>number
</table>

#### _numFormat( value, decPlace )_
<table>
<tr><td>value         <td>number to format
<tr><td>decPlace = 2  <td>decimal places to round to
<tr><td>pos1000 = 3   <td>number of digits for 'thousand' separator
<tr><td>sep1000 = "," <td>character for 'thousand' separator
<tr><td>decPoint = "."<td>character for decimal point
<tr><td><b><i>return  <td>string
</table>

<br>

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

---
## List Operations

#### _listSum( list, start, end )_
<table>
<tr><td>list        <td>list of numbers
<tr><td>start = 0   <td>starting position to sum
<tr><td>end         <td>ending position to sum
<tr><td><b><i>return<td>number
</table>

#### _listRunningSum( list )_
<table>
<tr><td>list        <td>list of numbers
<tr><td><b><i>return<td>list of numbers, output[n]=sum(input[0]:input[n])
</table>

#### _listOperator( list, fOperation, fEach )_
<table>
<tr><td>list      <td>list to process
<tr><td>fOperation<td>function that accepts 2 values from the list and returns a result<br>
ex. <i>function(x,y) x+y</i>, add all items
<tr><td>fEach     <td>function to optionally apply to each item before
being used by fOperation()</br>
ex. <i>function(x) x*x</i>, square each item before doing operation
<tr><td><b><i>return<td>value from supplied function fOperation()
</table>

<br>

```
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
```

---
## Graphical Functions
<table>
<tr><td><b>CubeExtents</b>( width, depth, height )</td><td>draw markers for verifying extents</td></tr>
</table>

#### _CubeExtents( width, depth, height, size )_
<table>
<tr><td>width <td>width (x-axis)
<tr><td>depth <td>depth (y-axis)
<tr><td>height<td>height (z-axis)
<tr><td>size = 1<td>size of markers
</table>

<br>

![photo](/images/utility-graphical.png)
```
CubeExtents( 50,40,60, color="red" );
color("green",0.5) cube([50,40,60],center=true);
```
