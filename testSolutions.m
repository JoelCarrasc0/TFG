function testSolutions
    %PREAMBLE
    %Podría cargar todos los datos iniciales desde un solo archivo de datos
    load('vert.mat')
    load('nsides.mat')
    load('bound.mat')
    load('div')
    load('dim')
    initialData.vert = vert;
    initialData.nsides = nsides;
    initialData.bound = bound;
    initialData.div = div;
    initialData.dim = dim;
    
    %TESTERS
    %'SquaredMeshCreatorTester'
    testers = {'MasterSlaveNodesTester'};
    
    for iTest = 1:length(testers)
        Tester.create(testers{iTest},initialData);
    end

end