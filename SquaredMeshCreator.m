function SquaredMeshCreator()
    [dim,divUnit,c,theta] = obtainInitialData();
    nsides = obtainPolygonSides(c,theta);
    [coord,vertCoord,boundary,boundNodes,div] = initializeVariables(dim,divUnit,nsides,c); 
    vertCoord = computeVertCoord(vertCoord,c,theta,nsides);
    boundary = computeBoundaryCoord(boundary,vertCoord,c,theta,nsides,div); 
    coord = computeMeshCoord(coord,boundary,nsides,divUnit,div,theta,boundNodes);
    
    
    connec = computeConnectivities(coord);
    plotCoordinates(coord,connec);
    masterSlaveIndex = obtainMasterSlaveNodes(vertCoord,boundary,nsides,div,dim);
    vertIndex(:,1) = 1:nsides;
    plotVertices(vertIndex,coord);
    %plotBoundaryMesh(boundary);
    plotMasterSlaveNodes(masterSlaveIndex,coord);
    %writeFEMreadingfunction(m, meshfilename, Data_prb, Xlength, Ylength);
end

function  [dim,divUnit,c,theta] = obtainInitialData()
% Datos de entrada del programa. COMPLETAMENTE GENERAL
    dim = 2;
    divUnit = 2; %Divisions/length of the side
    c = [2,1];
    theta = [0,90];
end

function nsides = obtainPolygonSides(c,theta)
% Obtención de nº de lados y filtro. COMPLETAMENTE GENERAL
    if length(c) == length(theta)
        nsides = 2*length(c);
    else
        cprintf('red','CRYTICAL ERROR. Vectors c and theta must have the same length\n');
    end
end

function [coord,vertCoord,boundary,boundNodes,div] = initializeVariables(dim,divUnit,nsides,c)
% Inicialización de variables. GENERAL a los casos deseados
div = divUnit*c;
    switch nsides
        case 4
            divA = div(1);
            divB = div(2);
            boundNodes = nsides*(1+1/2*(divA+divB-2));
            nnodes = boundNodes+(divA-1)*(divB-1);
        case 6
            divA = div(1);
            divB = div(2);
            divC = div(3);
            boundNodes = nsides*(1+1/3*(divA+divB+divC-3));
            % NO CORRECTO (MANERA DE OBTENERLO PARA HEXAGONOS IRREGULARES CON DIFERENTES DIVISIONES POR LADO?)
            nnodes = nsides/2*(divA+divB+divC+3)*(divA+divB+divC)+3;
            % Posibilidad de introducir mas polígonos
    end
    vertCoord = zeros(nsides,dim);
    boundary = zeros(boundNodes,dim);
    coord = zeros(nnodes,dim);
end

function vertCoord = computeVertCoord(vertCoord,c,theta,nsides)
% Obtención de los vertices. COMPLETAMENTE GENERAL
    c0 = [0,0];
    for iMaster = 1:nsides/2
        pos = computeThePosition(c0,c(iMaster),theta(iMaster));
        vertCoord(iMaster+1,:) = vertCoord(iMaster+1,:)+pos;
        c0 = pos;
    end
    for iSlave = 1:nsides/2
        pos = computeThePosition(c0,c(iSlave),theta(iSlave)+180);
        if iSlave == nsides/2
            if vertCoord(1,:) ~= pos
                cprintf('red','CRYTICAL ERROR. Vertices computed wrongly \n');
            end
        else
            vertCoord(iMaster+iSlave+1,:) = vertCoord(iMaster+iSlave+1,:)+pos;
            c0 = pos;
        end
    end
end

function boundary = computeBoundaryCoord(boundary,vertCoord,c,theta,nsides,div)
% Obtención de las coord de la boundary. COMPLETAMENTE GENERAL
    boundary(1:nsides,:) = boundary(1:nsides,:)+vertCoord;
    cont = nsides+1;
    for iMaster = 1:nsides/2
        c0 = vertCoord(iMaster,:);
        for iDiv = 1:div(iMaster)-1
            pos = computeThePosition(c0,c(iMaster)/div(iMaster),theta(iMaster));
            boundary(cont,:) = boundary(cont,:)+pos;
            cont = cont+1;
            c0 = pos;
        end
    end
    for iSlave = 1:nsides/2
        c0 = vertCoord(iMaster+iSlave,:);
        for iDiv = 1:div(iSlave)-1
            pos = computeThePosition(c0,c(iSlave)/div(iSlave),theta(iSlave)+180);
            boundary(cont,:) = boundary(cont,:)+pos;
            cont = cont+1;
            c0 = pos;
        end
    end
end

function pos = computeThePosition(c0,c,theta)
    pos = c0+c.*[cosd(theta) sind(theta)];
end

function coord = computeMeshCoord(coord,boundary,nsides,divUnit,div,theta,boundNodes)
% TEST PERFORMANCE
    coord(1:boundNodes,:) = coord(1:boundNodes,:)+boundary;
    contInt = boundNodes+1;
    layer = 1;
    segment = 1/divUnit; % Según la definición de divUnit
    ndiv = div-1;
    while max(ndiv) > 0
        theta0 = theta(nsides/2)-theta(nsides/2-1);
        % La coordenada inicial es característica del ángulo y polígono
        c0 = obtainInitialCoord(segment,theta0,layer);
        if max(ndiv) == 1
            coord(end,:) = c0;
        else
            coord(contInt,:) = c0;
            ndiv = ndiv-1;
            for iMaster = 1:nsides/2
                masterDiv = ndiv(iMaster);
                for iDiv = 1:masterDiv
                    contInt = contInt+1;
                    pos = computeThePosition(c0,segment,theta(iMaster));
                    coord(contInt,:) = coord(contInt,:)+pos;
                    c0 = pos;
                end
            end
            for iSlave = 1:nsides/2
                if iSlave == nsides/2
                    slaveDiv = ndiv-1;
                else
                    slaveDiv = ndiv;
                end
                for iDiv = 1:slaveDiv
                    pos = computeThePosition(c0,segment,theta(iSlave)+180);
                    coord(contInt,:) = coord(contInt,:)+pos;
                    contInt = contInt+1;
                    c0 = pos;
                end
            end
        end
        ndiv = ndiv-2;
        layer = layer+1;
        contInt = contInt+1;
    end
end

function c0 = obtainInitialCoord(segment,theta0,layer)
    if theta0 == 90
        c0 = layer*segment*[1 1];
    else
        % PROBLEMA 3: problema del nodo inicial al no tener 90 grados
    end
    % Con ecuaciones de la recta se puede obtener la intersección
end

% function coord = computeMeshCoord(coord,boundary,nsides,div,sideLength)
%     coord(1:nsides*div,:) = coord(1:nsides*div,:)+boundary;
%     contInt = nsides*div+1;
%     layer = 1;
%     segment = sideLength/div;
%     ndiv = div-1;
%     while ndiv > 0
%         c0 = layer*[segment segment];
%         if ndiv == 1
%             coord(end,:) = c0;
%         else
%             coord(contInt,:) = c0;
%             for iSide = 1:nsides
%                 theta0 = 0;
%                 thetaVar = 360/nsides;
%                 theta = theta0 + (iSide-1)*thetaVar;
%                 if iSide == nsides
%                     nintNode = ndiv-2;
%                 else
%                     nintNode = ndiv-1;
%                 end
%                 for iNode = 1:nintNode
%                     contInt = contInt+1;
%                     coord(contInt,:) = coord(contInt,:)+c0+segment.*[cosd(theta) sind(theta)];
%                     c0 = coord(contInt,:);
%                 end
%             end
%         end
%         ndiv = ndiv-2;
%         layer = layer+1;
%         contInt = contInt+1;
%     end
% end

function connec = computeConnectivities(coord)
    connec = delaunay(coord);
end

function masterSlave = obtainMasterSlaveNodes(vert,boundary,nsides,div,dim)
    masterSlave = computeMasterSlaveNodes(vert,boundary,nsides,div,dim);
end

function plotCoordinates(coord,connec)
    s.coord = coord;
    s.connec = connec;
    m = Mesh(s);
    m.plot();
end
    
function plotVertices(vertexIndex,coord)
    plotNodes(vertexIndex,coord,'blue')
end

%         % plot boundary mesh function
% SE DEBE MODIFICAR
%         sI.coord = coord(nodesI,:) ;
%         nT = length(coord);
%         sI.connec(:,1) = 1:nT;
%         sI.connec(:,2) = [2:nT,1];
%         sI.kFace = -1;
%         m = Mesh(sI);
%         m.plot()


    function plotMasterSlaveNodes(masterSlaveIndex,coord)
    masterIndex = masterSlaveIndex(:,1);
    slaveIndex  = masterSlaveIndex(:,2);
    plotNodes(masterIndex,coord,'green')
    plotNodes(slaveIndex,coord,'red')
    end

function plotNodes(ind,coord,colorValue)
    b = num2str(ind);
    c = cellstr(b);
    dx = 0.01; dy = 0.01;
    x = coord(ind,1)';
    y = coord(ind,2)';
    t = text(x+dx,y+dy,c);
    set(t,'Color',colorValue)
end

