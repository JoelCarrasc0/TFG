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
            end
        end
    end
end