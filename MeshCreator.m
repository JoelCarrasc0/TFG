classdef MeshCreator < handle
    
    properties (Access = public)
        c
        theta
        div
        nodes
    end
    
    methods (Access = public)
        
        function obj = MeshCreator(cParams)
            obj.init(cParams);
        end
        
        function computeMeshNodes(obj)
            obj.obtainDimensions();
            
            
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.c = cParams.sideLength;
            obj.theta = cParams.theta;
            obj.div = cParams.divUnit*obj.c;
        end
        
        function obtainDimensions(obj)
            s.nvert = 2*lenght(obj.c);
            s.div = obj.div;
            a = NodesCalculator.create(s);
            obj.nodes.vert = a.nvert;
            obj.nodes.bound = a.boundNodes;
            obj.nodes.total = a.totalNodes;
        end
        
    end
    
    
    
end