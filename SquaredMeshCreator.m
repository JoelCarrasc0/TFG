function SquaredMeshCreator()
    [dim,div,c,theta] = obtainInitialData();
    nsides = obtainPolygonSides(c,theta,div);
    [coord,vertCoord,boundary] = initializeVariables(dim,div,nsides); 
    vertCoord = computeVertCoord(vertCoord,c,theta,nsides); 
    
    boundary = computeBoundaryCoord(boundary,vertCoord,sideLength,nsides,div);
    coord = computeMeshCoord(coord,boundary,nsides,div,sideLength);
    connec = computeConnectivities(coord);
    plotCoordinates(coord,connec);
    masterSlaveIndex = obtainMasterSlaveNodes(vertCoord,boundary,nsides,div,dim);
    vertIndex(:,1) = 1:nsides;
    plotVertices(vertIndex,coord);
    %plotBoundaryMesh(boundary);
    plotMasterSlaveNodes(masterSlaveIndex,coord);
    %writeFEMreadingfunction(m, meshfilename, Data_prb, Xlength, Ylength);
end

function  [dim,div,c,theta] = obtainInitialData()
% Datos de entrada del programa. COMPLETAMENTE GENERAL
    dim = 2;
    div = [2,2,2]; % PROBLEMA 1: Dilema de las divisiones. DEBERIA SER DATO DE ENTRADA O 
    % SOLO IMPONER LAS DIVISIONES DEL PRIMER LADO Y OBTENER LAS DEMÁS POR 
    % RELACIÓN LINEAL ENTRE LA LONGITUD DE LOS LADOS
    c = [1,1,1];
    theta = [0,60,120];
end

function nsides = obtainPolygonSides(c,theta,div)
% Obtención de nº de lados y filtro. COMPLETAMENTE GENERAL
    if length(c) == length(theta) && length(c) == length(div)
        nsides = 2*length(c);
    else
        cprintf('red','CRYTICAL ERROR. Vectors c, theta and div must have the same length\n');
    end
end

function [coord,vertCoord,boundary] = initializeVariables(dim,div,nsides)
% Inicialización de variables principales. NO ES GENERAL (nnodes variable)
    divA = div(1);
    divB = div(2);
    boundNodes = nsides*(1+1/2*(divA+divB-2)); %Válido para cuatro lados
    nnodes = boundNodes+(divA-1)*(divB-1); %Válido para cuatro lados
    %PROBLEMA 2: NO ES POSIBLE UNIFICAR TODOS LOS CALCULOS DE NNODES
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

function pos = computeThePosition(c0,c,theta)
    pos = c0+c.*[cosd(theta) sind(theta)];
end

% function vert = computeVertCoord(vert,sideLength,nsides) %GENERAL PARA POLÍGONOS CON LADOS IGUALES
%     theta0 = 0;
%     thetaVar = 360/nsides;
%     c0 = [0,0];
%     for iEdge = 2:nsides
%         theta = theta0 + (iEdge-2)*thetaVar;
%         vert(iEdge,:) = vert(iEdge,:)+c0+sideLength.*[cosd(theta) sind(theta)];
%         c0 = vert(iEdge,:);
%     end
% end

function boundary = computeBoundaryCoord(boundary,vert,sideLength,nsides,div) %GENERAL PARA POLÍGONOS CON LADOS IGUALES
    boundary(1:nsides,:) = boundary(1:nsides,:)+vert;
    contInt = nsides+1;
    for iSide = 1:nsides
        theta0 = 0;
        thetaVar = 360/nsides;
        c0 = vert(iSide,:);
        theta = theta0 + (iSide-1)*thetaVar;
        for iNode = 1:div-1
            segment = sideLength/div;
            boundary(contInt,:) = boundary(contInt,:)+c0+segment.*[cosd(theta) sind(theta)];
            c0 = boundary(contInt,:);
            contInt = contInt+1;
        end
    end
end

function coord = computeMeshCoord(coord,boundary,nsides,div,sideLength)
    coord(1:nsides*div,:) = coord(1:nsides*div,:)+boundary;
    contInt = nsides*div+1;
    layer = 1;
    segment = sideLength/div;
    ndiv = div-1;
    while ndiv > 0
        c0 = layer*[segment segment];
        if ndiv == 1
            coord(end,:) = c0;
        else
            coord(contInt,:) = c0;
            for iSide = 1:nsides
                theta0 = 0;
                thetaVar = 360/nsides;
                theta = theta0 + (iSide-1)*thetaVar;
                if iSide == nsides
                    nintNode = ndiv-2;
                else
                    nintNode = ndiv-1;
                end
                for iNode = 1:nintNode
                    contInt = contInt+1;
                    coord(contInt,:) = coord(contInt,:)+c0+segment.*[cosd(theta) sind(theta)];
                    c0 = coord(contInt,:);
                end
            end
        end
        ndiv = ndiv-2;
        layer = layer+1;
        contInt = contInt+1;
    end
end

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

