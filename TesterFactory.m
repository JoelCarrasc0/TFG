classdef TesterFactory < handle
    methods (Access = public, Static) 
        function obj = create(type,initialData)
            switch type
                case 'NodesCalculatorTester'
                    obj = NodesCalculatorTester(initialData);
                case 'VertexCoordinatesCalculatorTester'
                    obj = VertexCoordinatesCalculatorTester(initialData);
                case 'BoundaryCoordinatesCalculatorTester'
                    obj = BoundaryCoordinatesCalculatorTester(initialData);
                case 'IntersectionCoordComputerTester'
                    obj = IntersectionCoordComputerTester(initialData);
                case 'MasterSlaveComputerTester'
                    obj = MasterSlaveComputerTester(initialData);
            end
        end
    end
end