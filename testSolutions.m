function testSolutions
    %PREAMBLE
    coordinates = load('coord.mat');
    divisions = load('div.mat');  %Algunos datos debería poder escogerlos desde dentro del test
    sideLength = load('c.mat');
    initialData.coord = coordinates.coord;
    initialData.div = divisions.div;
    initialData.c = sideLength.c;
    
    %TESTERS
    testers = {'SquaredMeshCreatorTester','MasterSlaveNodesTester'};
    
    for iTest = 1:length(testers)
        Tester.create(testers{iTest},initialData);
    end

end