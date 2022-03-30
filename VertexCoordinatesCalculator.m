classdef VertexCoordinatesCalculator < handle
    
    properties (Access = private)
%         c
%         theta
%         nodes
    end
    
    properties (Access = public)
        c
        theta
        nodes
        vertCoord
    end
    
    methods (Access = public)
        
        function obj = VertexCoordinatesCalculator(cParams)
            obj.init(cParams);
            obj.computeVertex();
        end
        
        function computeVertex(obj)
            obj.obtainMasterVertex();
            obj.obtainSlaveVertex();
        end
        
    end
    
    methods (Access = public)
        
        function init(obj,cParams)
            obj.c = cParams.c;
            obj.theta = cParams.theta;
            obj.nodes = cParams.nodes;
            obj.vertCoord = zeros(cParams.nodes.vert,2);
        end
        
        function obtainMasterVertex(obj)
            c0 = [0,0];
            for iMaster = 1:obj.nodes.vert/2
                pos = computeThePosition(c0,obj.c(iMaster),obj.theta(iMaster));
                obj.vertCoord(iMaster+1,:) = obj.vertCoord(iMaster+1,:)+pos;
                c0 = pos;
            end
        end
        
        function obtainSlaveVertex(obj)
            for iSlave = 1:obj.nodes.vert/2
                pos = computeThePosition(c0,obj.c(iSlave),obj.theta(iSlave)+180);
                if iSlave == obj.nodes.vert/2
                    if obj.vertCoord(1,:) ~= pos
                        cprintf('red','CRYTICAL ERROR. Vertices computed wrongly \n');
                    end
                else
                    iMaster = obj.nodes.vert/2;
                    obj.vertCoord(iMaster+iSlave+1,:) = obj.vertCoord(iMaster+iSlave+1,:)+pos;
                    c0 = pos;
                end
            end
        end
        
    end
    
    methods (Static)
        
        function pos = computeThePosition(c0,c,theta)
            pos = c0+c.*[cosd(theta) sind(theta)];
        end
        
    end
    
end
% COMPUTE POSITION FALLA. DEBE SER POR EL ACCESO A LA FUNCIÓN