# Thrust Bearing

---
## List of Functions
<table>
<tr><td><b>ThrustBearingProfile</b>( ... )</td><td>create profile</td></tr>
<tr><td><b>ThrustBearingFromLibrary</b>( model )</td><td>profile from predefined models</td></tr>
<tr><td><b>ThrustBearing</b>( profile )</td><td>generate thrust bearing</td></tr>
</table>

---
#### _ThrustBearingProfile( ... )_
<table>
<tr><td>model       <td>        <td>user defined model name
<tr><td>ID          <td>&#10004;<td>outside diameter
<tr><td>OD          <td>&#10004;<td>inside diameter
<tr><td>thickness   <td>&#10004;<td>thickness
<tr><td colspan="2"><b><i>return<td>KVTree profile
</table>

#### _ThrustBearingFromLibrary( model )_
<table>
<tr><td>model<td>&#10004;<td>commercial name of thrust bearing, see source code
<tr><td colspan="2"><b><i>return<td>profile from predefined modes (see source code)
</table>

#### _ThrustBearing( profile )_
<table>
<tr><td>profile<td>&#10004;<td>thrust bearing profile to display
</table>

---
## Data Structure
```
type: "thrust bearing"
model: "51102"
ID: 15
OD: 28
thickness: 9
```

---
## Sample Code
![photo](/images/bearing-thrust.png)
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
