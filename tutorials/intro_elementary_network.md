The fundamental idea behind this method is that you can take a very complex system, 
split it up into elementary components with well known behaviour,
then assemble these components into a single matrix - which then can be readily solved on a computer with linear algebra.

The linear system would follow the most beautiful formula in all of physis - the Ohms law: ```I=(1/R)*V```;
The Ohms law can be generalized to any linear system on a network as: ```J=K*V```; 
Note the main difference is that Ohms law works on scalars, and FEM works on matrices.

Lets examine the simplest possible network.
(N1)---E1---(N2).
Here we have a network of two nodes, N1 and N2 and one connecting element between the nodes E1. 
Now lets suppose that connecting element E1 presents resistance to flow r1 
(this flow could be anything - electricity, heat, forces, basically anything at all, 
so R is just abstract resistance is an abstract flow of abstract essense).
Now lets suppose that N1 operates at fixed head C+V1 and N2 opearates at a fixed head of C+V2;
Where C is constant, and the head is just some abstract concept similar to pressure in water pipe 
or voltage in electrical network.

By Ohms law, we get ```I = (1/R)*V```, lets say voltage differential is 2 and resistance is 2, 
we should have current I=2/2=1.

Now let us solve the same using FEM. First step is to construct a stiffness matrix K.
Note that K is element-wise reciprocal of R. Lets go ahead and compose matrix R.
We know that the sum of all resistances going into node N1 is r1, same for node N2; hence
R11 = R22 = r1.
Now we can calculate resistaces between nodes, note that sign would be negative.
R12 = -r1; R21 = -r1; and so our total resistance matrix is
```
R = [[r1,-r1],
     [-r1,r1]]
```
Now by doing element-wise reciprocal of resistances, we can obtain stiffness matrix K:
```
K = recipr(R) = 
    [[1/r1, -1/r1],
     [-1/r1, 1/r1]]
```
Finding a solution now is trivial. Lets solve for current, which  in our case is J.
```
from sympy import symbols, Matrix, Eq
RESISTANCE = 5
SUPPLY_VOLTAGE = 5
GROUND_VOLTAGE = 0
c, v1, v2, r1, j1 = symbols('c v1 v2 r1 j1')
r1=RESISTANCE # set known resistance
v1=SUPPLY_VOLTAGE
v2=GROUND_VOLTAGE  # set ground
R = Matrix([[r1,-r1],[-r1,r1]])
K=R.applyfunc(lambda x: 1/x) # find reciprocal of R
V = Matrix([c+v1,c+v2])
J = Matrix([j1,-j1])
sympy.solve(Eq(K*V,J))
```
This would output
```
{j1: 1}
```
In this case I=1, which is the same answer we would expect to see from Ohms law. 
You can verify the answer remains correct by varying program parameters.
Solving for voltage is just as simple:
```
from sympy import symbols, Matrix, Eq
c, v1, v2, r1 = symbols('c v1 v2 r1')
RESISTANCE = 5
CURRENT = 5
GROUND_VOLTAGE = 0
r1 = RESISTANCE # set known resistance
j1 = CURRENT
v2 = GROUND_VOLTAGE  # set ground
R = Matrix([[r1,-r1],[-r1,r1]])
K=K.applyfunc(lambda x: 1/x) # find reciprocal of R
V = Matrix([c+v1,c+v2])
J = Matrix([j1,-j1])
sympy.solve(Eq(K*V,J))
```
In this case V=25, which is again consistent with Ohms law.

Congratulations, you have successfully applied FEM to the simplest possible problem.
