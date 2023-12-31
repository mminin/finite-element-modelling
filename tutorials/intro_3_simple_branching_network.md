Let's add one more layer of complexity to our network, and add a side branch.
```
  N1
  |
 (E1)
  |
  N2--(E2)--N3
  |
 (E3)
  |
  N4
```

Same as before resistances at E1, E2, E3 are r1, r2, r3.
Then 
```
k1, k2, k3 = 1/r1, 1/r2, 1/r3

K12 = Matrix(
[[k1,-k1,0,0],
 [-k1,k1,0,0],
 [0,0,0,0],
 [0,0,0,0]]
)
K23 = Matrix(
[[0,0,0,0],
 [0,r2,-r2,0],
 [0,-r2,r2,0],
 [0,0,0,0]]
)
K24 = Matrix(
[[0,0,0,0],
 [0,r3,0,-r3],
 [0,0,0,0],
 [0,-r3,0,r3]]
)

K = K12 + K23 + K24
```
This results in total stiffness matrix
```
Matrix([
[ k1,          -k1,   0,   0],
[-k1, k1 + k2 + k3, -k2, -k3],
[  0,          -k2,  k2,   0],
[  0,          -k3,   0,  k3]])
```
Notice that v2=v3 regardless or resistances assigned (try varying them), 
as long as there is no current draw on node N3.
This may seem counterintuitive, but you can easily confirm this experimentally.

---------------------------------

Finally, lets consider a fairly complicated electrical network:
```
  --Ra--- ---Rb---
 |+      |        |+
---Vf    Re      ---Vg
 -       |        -
 |       |        |
  --Rc--------Rd--
```
Where Rx are resistors and Vx are power supplies.
If R1 = 3ohm, Rb = 4 ohm, Rc = 3 Ohm, Rd = 2 Ohm, Re = 1 ohm, Vf = 6v, Vg = 10V;
Then (and you can confirm this with linear algebra) the currents through the nodes would be
Ia = 5/6 amp, Ib = 1/6 amp; Ie = 1 amp.

Lets solve this using FEM and see if we get the same result.
The network can be modelled as:
```
 N1--(E1)--N2--(E2)--N3
           |
          (E3)
           |
 N5--(E4)--N4--(E5)--N6
```
First step is to determine the stiffness matrix:



