%% Data file

Data_prb = {
'TRIANGLE' ;
'SI' ;
'2D' ;
'Plane_Stress' ;
'ELASTIC' ;
'MICRO' ;
};


coord = [
1 0 0 0
2 0 0.25 0
3 0 0.5 0
4 0 0.75 0
5 0 1 0
6 0.25 0 0
7 0.25 0.25 0
8 0.25 0.5 0
9 0.25 0.75 0
10 0.25 1 0
11 0.5 0 0
12 0.5 0.25 0
13 0.5 0.5 0
14 0.5 0.75 0
15 0.5 1 0
16 0.75 0 0
17 0.75 0.25 0
18 0.75 0.5 0
19 0.75 0.75 0
20 0.75 1 0
21 1 0 0
22 1 0.25 0
23 1 0.5 0
24 1 0.75 0
25 1 1 0
];

pointload = [
];



connec = [
1 9 4 8
2 3 2 7
3 18 17 22
4 19 18 23
5 13 8 12
6 6 2 1
7 3 8 4
8 6 7 2
9 16 21 17
10 11 12 7
11 7 6 11
12 8 3 7
13 18 19 14
14 4 9 5
15 12 8 7
16 14 10 9
17 13 9 8
18 10 5 9
19 14 15 10
20 14 19 15
21 24 25 20
22 24 19 23
23 13 12 17
24 20 19 24
25 20 15 19
26 22 17 21
27 18 13 17
28 14 13 18
29 14 9 13
30 12 11 16
31 12 16 17
32 23 18 22
];

%% Variable Prescribed
% Node 	 Dimension 	 Value

dirichlet_data = [
1 1 0
1 2 0
5 1 0
5 2 0
21 1 0
21 2 0
25 1 0
25 2 0
];


%% Force Prescribed
% Node 	 Dimension 	 Value

pointload_complete = [
];


%% Volumetric Force
% Element 	 Dimension 	 Force_Dim

Vol_force = [
];


%% Group Elements
% Element 	 Group_num

Group = [
];


%% Group Elements
% Elements that are considered holes initially
% Element

Initial_holes = [
];


%% Boundary Elements
% Elements that can not be removed
% Element

Boundary_elements = [
];


%% Micro Gauss Post
% Element

Micro_gauss_post = [
];


%% Master-Slave

Master_slave = [
2 22
3 23
4 24
6 10
11 15
16 20
];

%% Nodes Solid
% Nodes that must remain
% Nodes

% nodesolid = 1;


%% External Border Elements
% Detect the elements that define the edge of the domain
% Element 	 Node(1) 	 Node(2)

External_border_elements = [
];


%% External Border Nodes
% Detect the nodes that define the edge of the domain
% Node 	 

External_border_nodes = [
];


%% Materials
% Materials that have been used
% Material_Num 	 Mat_density 	 Young_Modulus 	 Poisson

Materials = [
];