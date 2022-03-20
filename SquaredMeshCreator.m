function SquaredMeshCreator()
    [dim,divUnit,c,theta] = obtainInitialData();
    nsides = obtainPolygonSides(c,theta);
    [coord,vertCoord,boundary,boundNodes,div] = initializeVariables(dim,divUnit,nsides,c); %Falta establecer nnodes para coord
    vertCoord = computeVertCoord(vertCoord,c,theta,nsides);
    boundary = computeBoundaryCoord(boundary,vertCoord,c,theta,nsides,div); 
    coord = computeMeshCoord(nsides,vertCoord,divUnit,c,boundary,boundNodes,coord,div);
    connec = computeConnectivities(coord);
    plotCoordinates(coord,connec);
    
    masterSlaveIndex = obtainMasterSlaveNodes(vertCoord,boundary,nsides,div,dim); %%PENDIENTE DE REVISIÓN. SOLO ERA FUNCIONAL PARA POLIGONOS DE LADOS IGUALES
    vertIndex(:,1) = 1:nsides;
    plotVertices(vertIndex,coord);
    %plotBoundaryMesh(boundary);
    plotMasterSlaveNodes(masterSlaveIndex,coord);
    %writeFEMreadingfunction(m, meshfilename, Data_prb, Xlength, Ylength);
end

function  [dim,divUnit,c,theta] = obtainInitialData()
% Datos de entrada del programa. COMPLETAMENTE GENERAL
    dim = 2;
    divUnit = 3; %Divisions/length of the side
    c = [2,1,2];
    theta = [0,60,90];
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
            % CORREGIR PARA EL NUEVO CASO DE CÁLCULO DE COORD
            nnodes = nsides/2*(divA+divB+divC+3)*(divA+divB+divC)+3;
            % Posibilidad de introducir mas polígonos
    end
    vertCoord = zeros(nsides,dim);
    boundary = zeros(boundNodes,dim);
    coord = zeros(103,dim);
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

function coord = computeMeshCoord(nsides,vertCoord,divUnit,c,boundary,boundNodes,coord,div)
coord(1:boundNodes,:) = coord(1:boundNodes,:)+boundary;
intNode = boundNodes+1;
    switch nsides
        case 4
        % Compute coords by intersections
            vA = vertCoord(2,:)-vertCoord(1,:);
            mA = norm(vA);
            vA = vA/mA;
            vB = vertCoord(3,:)-vertCoord(2,:);
            mB = norm(vB);
            vB = vB/mB;
            nodesX = divUnit*c(1)-1;
            nodesY = divUnit*c(2)-1;
            for jNodes = 1:nodesY
                pB = boundary(boundNodes+1-jNodes,:);
                for iNodes = 1:nodesX
                    pA = boundary(nsides+iNodes,:);
                    if vA(1) == 0
                        x = pB(1);
                        y = (x-pA(1))*vB(2)/vB(1)+pA(2);
                    elseif vB(1) == 0
                        x = pA(1);
                        y = (x-pB(1))*vA(2)/vA(1)+pB(2);
                    else
                        x = (pB(2)-pA(2)+pA(1)*vB(2)/vB(1)+pB(1)*vA(2)/vA(1))/(vB(2)/vB(1)-vA(2)/vA(1));
                        y = (x-pB(1))*vA(2)/vA(1)+pB(2);
                    end
                    coord(intNode,:) = coord(intNode,:)+[x y];
                    intNode = intNode+1;
                end
            end

        case 6
        % Compute coords by diagonals
        % Sitúa el nodo central
        vA = vertCoord(4,:)-vertCoord(1,:);
        pA = vertCoord(1,:);
        centerVec = vA/2;
        O = pA+centerVec;
        coord(intNode,:) = coord(intNode,:)+O;
        % Cálculo de las divisiones a aplicar por recta
        diagDiv = max(div);
        div = div-1;
        intNode = intNode+1;
        % Aplicación de las divisiones por cada semirecta
        for iDiv = 1:diagDiv-1
            for iDiag = 1:nsides
                diagA = O-vertCoord(iDiag,:);
                vecDiv = iDiv*diagA/diagDiv;
                pos = vertCoord(iDiag,:)+vecDiv;
                coord(intNode,:) = coord(intNode,:)+pos;
                intNode = intNode+1;
            end
            % Aplicar aquí los nodos internos a las rectas
            newVert = coord(intNode-nsides:intNode-1,:);
            for iMaster = 1:nsides/2
                vertA = newVert(iMaster,:);
                vertB = newVert(iMaster+1,:);
                for intDiv = 1:div(iMaster)-1
                    sideVec = intDiv*(vertB-vertA)/div(iMaster);
                    sidePos = vertA+sideVec;
                    coord(intNode,:) = coord(intNode,:)+sidePos;
                    intNode = intNode+1;
                end
            end
            for iSlave = 1:nsides/2
                if iSlave == nsides/2
                    vertA = newVert(end,:);
                    vertB = newVert(1,:);
                else
                    vertA = newVert(iMaster+iSlave,:);
                    vertB = newVert(iMaster+iSlave+1,:);
                end
                for intDiv = 1:div(iSlave)-1
                    sideVec = intDiv*(vertB-vertA)/div(iMaster);
                    sidePos = vertA+sideVec;
                    coord(intNode,:) = coord(intNode,:)+sidePos;
                    intNode = intNode+1;
                end
            end
            div = div-1;
        end
    end
end
% TEST PERFORMANCE AND CORRECT ERRORS


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

