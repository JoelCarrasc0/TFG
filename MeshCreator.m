classdef MeshCreator < handle
    
    properties (Access = private)
        c
        theta
        div
        nodes
    end
    
    properties (Access = public)
        coord
        connec
    end
    
    methods (Access = public)
        
        function obj = MeshCreator(cParams)
            obj.init(cParams);
        end
        
        function computeMeshNodes(obj)
            obj.obtainDimensions();
            obj.computeNodeCoordinates();
            obj.connectNodes();
%             obj.obtainMasterSlaveNodes();
%             obj.plotCoordinates();
        end
        
%         function plotLabelsOfNodes(obj)
%             
%         end
%         
%         function createPreprocessArchive(obj)
%             obj.writeFEMreadingArchive();
%         end
        
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
        
        function computeNodeCoordinates(obj)
            s.c = obj.c;
            s.theta = obj.theta;
            s.div = obj.div;
            s.nodes = obj.nodes;
            a = NodeCoordinatesComputer(s);
            a.computeCoordinates();
            obj.coord = a.totalCoord;
        end
        
        function connectNodes(obj)
            obj.connec = delaunay(obj.coord);
        end
        
%         function obtainMasterSlaveNodes(obj)
%             
%         end
%         
%         function plotCoordinates(coord,connec)
%             s.coord = coord;
%             s.connec = connec;
%             m = Mesh(s);
%             m.plot();
%         end
%         
    end

end