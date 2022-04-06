function testSolutions
    %PREAMBLE
    % test for the squaredMesh with sideLength = 1 and unitDiv = 3
    sideLength = [1,1];
    theta = [0,90];
    unitDiv = 3;
    nV = load('nvert.mat');
    bN = load('boundNodes.mat');
    tN = load('totalNodes.mat');
    vC = load('vertCoord.mat');
    b = load('boundary.mat');
    c = load('coord.mat');
    initialData.c = sideLength;
    initialData.theta = theta;
    initialData.div = unitDiv*sideLength;
    initialData.nvert = nV.nsides;
    initialData.nodes.vert = nV.nsides;
    initialData.nodes.bound = bN.boundNodes;
    initialData.nodes.total = tN.totalNodes;
    initialData.vertCoord = vC.vertCoord;
    initialData.boundCoord = b.boundary;
    initialData.coord = c.coord;
    
    %TESTERS
   testers = {'NodeCoordinatesComputerTester'};
%     testers = { 'NodesCalculatorTester','VertexCoordinatesCalculatorTester',...
%     'BoundaryCoordinatesCalculatorTester','IntersectionCoordComputerTester',...
%     'MasterSlaveComputerTester','QuadrilateralNodesCalculatorTester'};
    
    for iTest = 1:length(testers)
        Tester.create(testers{iTest},initialData);
    end

end