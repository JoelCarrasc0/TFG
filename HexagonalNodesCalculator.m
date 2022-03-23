classdef HexagonalNodesCalculator < NodesCalculator

    properties (Access = protected)
        nvert
        div
    end
    
    properties (Access = public)
        boundNodes
        totalNodes
    end
    
    methods (Access = protected)
        
        function obj = HexagonalNodesCalculator(cParams)
            obj.init(cParams);
            obj.computeBoundaryNodes();
            obj.computeTotalNodes();
        end
        
    end
    
    methods (Access = private)
        
        function computeTotalNodes(obj)
            obj.totalNodes = 0;
            sideNodes = obj.div-1;
            while max(sideNodes) >= 1
                for i = 1:length(sideNodes)
                    if sideNodes(i) <= 0
                        sideNodes(i) = 0;
                    end
                end
                obj.totalNodes = obj.totalNodes+obj.nvert+sum(2*sideNodes);
                sideNodes = sideNodes-1;
            end
            obj.totalNodes = obj.totalNodes+obj.nvert+1;
        end
        
    end

end