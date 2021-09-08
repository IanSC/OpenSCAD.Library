# Utilities

---
## String

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
<tr><td colspan="2"><h4>stringExtract( string, start, end )
<tr><td>string      <td>string to extract from
<tr><td>start = 0   <td>starting character position to extract
<tr><td>end         <td>ending character position to extract
<tr><td><b><i>return<td>string
</table>

---

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

---

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
---

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

