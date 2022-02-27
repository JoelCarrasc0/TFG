function testSolutions
    %PREAMBLE
    coordinates = load('coord.mat');
    divisions = load('div.mat');  %Algunos datos debería poder escogerlos desde dentro del test
    initialData.coord = coordinates.coord;
    initialData.div = divisions.div;
    
    %TESTERS
    testers = {'MasterSlaveNodesTester'};
    
    for iTest = 1:length(testers)
        Tester.create(testers{iTest},initialData);
    end

end