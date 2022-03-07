classdef TesterFactory < handle
    methods (Access = public, Static) 
        function obj = create(type,initialData)
            switch type
                case 'MasterSlaveNodesTester'
                    obj = MasterSlaveNodesTester(initialData);
                case 'SquaredMeshCreatorTester'
                    obj = SquaredMeshCreatorTester(initialData);
                % Proximas clases a testear (poner el case)
            end
        end
    end
end