# OpenSCAD.Library

---
### KVTree
Searchable tree structure for storing multiple data values.
```
table = KVTree([ "bolt", KVTree([ "diameter", 5, "length", 20 ]) ]);
v = kvGet( table, "bolt.diameter" );
```
[check it out](./docs/KVTree.md)

---
### Hardware

Basic parts for mechanical designs. A part is created by defining a profile,
which contains all the information for rendering the part. The profile can
be passed to modules/functions, queried and rendered multiple times.
Concentrate on the design part and have a compact and consistent part
library. Port your other parts by checking the source.

#### Nuts and Bolts
![photo](/images/nuts-bolts.png)
[check it out](./docs/nuts-bolts.md)

#### Stepper Motor
![photo](/images/stepper-motor.png)
[check it out](./docs/stepper-motor.md)

#### Flange Bearing
![photo](/images/bearing-flange.png)
[check it out](./docs/bearing-flange.md)

#### Thrust Bearing
![photo](/images/bearing-thrust.png)
[check it out](./docs/bearing-thrust.md)

#### Timing Pulley
![photo](/images/timing-pulley.png)
[check it out](./docs/timing-pulley.md)

---
### Positioning
Routines for positioning elements of the edges of a rectangular canvas.
![photo](/images/positioning.png)
[check it out](./docs/positioning.md)

---
### Orientation
Routines for positioning panels to form a box.
![photo](/images/orientation.png)
[check it out](./docs/orientation.md)

---
### Utilities
Simple routines for basic operations.
[check it out](./docs/utility.md)
