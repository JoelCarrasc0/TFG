function testSolutions
    %PREAMBLE
    % test for the squaredMesh with sideLength = 1 and unitDiv = 2
    sideLength = [1,1];
    theta = [0,90];
    unitDiv = 3;
    nV = load('nvert.mat');
    initialData.sideLength = sideLength;
    initialData.theta = theta;
    initialData.div = unitDiv*sideLength;
    initialData.nvert = nV.nsides;
    
    %TESTERS
    %'SquaredMeshCreatorTester', 'MasterSlaveNodesTester'
    testers = {'NodesCalculatorTester'};
    
    for iTest = 1:length(testers)
        Tester.create(testers{iTest},initialData);
    end

end