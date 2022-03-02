classdef MasterSlaveNodesTester < Tester
    
    properties (Access = private)
        data
    end
    
    properties (Access = protected)
        testName
        corrValues
        calcValues
    end
    
    methods (Access = public)
        
        function obj = MasterSlaveNodesTester(cParams)
            obj.data = cParams;
            obj.testName = 'MasterSlaveNodesComputer';
            obj.loadCorrectValues();
            obj.obtainCalculatedData();
            obj.verify();
        end

    end
    
    methods (Access = protected)
        
        function loadCorrectValues(obj)
            mS = load('master_slave.mat');
            obj.corrValues(1).Matrix = mS.master_slave;
        end
        
        function obtainCalculatedData(obj)
            solution = computeMasterSlaveNodes(obj.data.coord,obj.data.div,obj.data.c);
            obj.calcValues(1).Matrix = solution;
        end
    
    end
    
end