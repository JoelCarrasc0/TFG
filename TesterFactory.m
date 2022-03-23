classdef TesterFactory < handle
    methods (Access = public, Static) 
        function obj = create(type,initialData)
            switch type
                case 'MasterSlaveNodesTester'
                    obj = MasterSlaveNodesTester(initialData);
                case 'SquaredMeshCreatorTester'
                    obj = SquaredMeshCreatorTester(initialData);
                case 'NodesCalculatorTester'
                    obj = NodesCalculatorTester(initialData);
            end
        end
    end
end