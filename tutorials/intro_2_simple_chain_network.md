Building on the methodology presented in the previous section, we can easily scale up elementary network
into more complex arrangement.
Let us now consider second most simple network possible.
The network will have 3 nodes and 2 connections, like so:
N1--(E1)--N2--(E2)--N3
The first step now would be to build individual stiffness matrices for each of the connecting elements:
```
K12 = Matrix([[k1,-k1,0],[-k1,k1,0],[0,0,0]])
K23 = Matrix([[0,0,0],[0,k2, -k2],[0,-k2,k2]])
```
The overall stiffness matrix is then simply K=K12+K23.
Note also that matrix J in teh equation J = K*V represents abstract essense being added or removed 
from the network at each node. Since no current is being lost at node N2, we can then set J to be
```
J = Matrix([j1,0,j3])
```
Similarly to the previous example, solution is now straightforward:
```
# Simple network with 3 nodes and 2 elements:
# N1--(E1)--N2--(E2)--N3
c, v1, v2, v3, r1, r2,j1,j2,j3 = symbols('c v1 v2 v3 r1 r2, j1, j2, j3')
RESISTANCE_E1 = 8
RESISTANCE_E2 = 2
GROUND_VOLTAGE = 0
SUPPLY_VOLTAGE = 10
c=5
v1=SUPPLY_VOLTAGE
v3=GROUND_VOLTAGE
k1 = 1/RESISTANCE_E1
k2 = 1/RESISTANCE_E2
K12 = Matrix([[k1,-k1,0],[-k1,k1,0],[0,0,0]])
K23 = Matrix([[0,0,0],[0,k2, -k2],[0,-k2,k2]])

K=K12+K23
V = Matrix([c+v1,c+v2,c+v3])
J = Matrix([j1,0,j3])
sympy.solve(Eq(K*V,J))
```
The answer would be 
{j1: 1.00000000000000, j3: -1.00000000000000, v2: 2.00000000000000}
You can confirm that this answer is correct by solving the same system using Ohm's law:
I = v/R = (10-v2)/8;
I=v2/2;
Therefore (10-v2)/8 = v2/2; meaning v2=2.
Input current at j1 is 1 amp; as againt would be expected from Ohms law as 10/(8+2)=1; 
and exit current at j3 = -j1 = -1 amp.

---------------------------------
Point of interest: 
At this point we can already easily do some fairly advanced things that would require effort 
when done using traditional methods, for instance, lets model a leaky pipe, lets say we're 
loosing 0.1 amps at node 2, for whaterver reason (leaky pipe scenario).
Simply change the last two lines to
```
J = Matrix([j1,-0.1,j3])
sympy.solve(Eq(K*V,J))
```
And the new answer becomes
{j1: 1.02000000000000, j3: -0.920000000000000, v2: 1.84000000000000}

