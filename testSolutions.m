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
    initialData.c = sideLength;
    initialData.theta = theta;
    initialData.div = unitDiv*sideLength;
    initialData.nvert = nV.nsides;
    initialData.nodes.vert = nV.nsides;
    initialData.nodes.bound = bN.boundNodes;
    initialData.nodes.total = tN.totalNodes;
    initialData.vertCoord = vC.vertCoord;
    
    %TESTERS
    %
    testers = {'NodesCalculatorTester','VertexCoordinatesCalculatorTester','BoundaryCoordinatesCalculatorTester'};
    
    for iTest = 1:length(testers)
        Tester.create(testers{iTest},initialData);
    end

end