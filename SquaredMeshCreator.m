function SquaredMeshCreator()
    [dim,div,sideLength,nsides] = obtainInitialData();
    [coord,vert,boundary] = initializeVariables(dim,div,nsides);
    vert = computeVertCoord(vert,sideLength,nsides);
    boundary = computeBoundaryCoord(boundary,vert,sideLength,nsides,div);
    coord = computeMeshCoord(coord,boundary,nsides,div,sideLength);
    connec = computeConnectivities(coord);
    plotCoordinates(coord,connec);
    masterSlave = obtainMasterSlaveNodes(vert,boundary,nsides,div,dim);
    % LA FUNCIÓN DE MOSTRAR ETIQUETAS DE NODOS NO FUNCIONA CORRECTAMENTE
    plotVertices(vert,coord);
    %plotBoundaryMesh(boundary);
    %plotMasterSlaveNodes(masterSlave);
    %writeFEMreadingfunction(m, meshfilename, Data_prb, Xlength, Ylength);
end

function  [dim,div,sideLength,nsides] = obtainInitialData()
    dim = 2;
    div = 2;
    sideLength = 1;
    nsides = 4;
end

function [coord,vert,boundary] = initializeVariables(dim,div,nsides)
    nnodes = div^2+2*div+1;
    vert = zeros(nsides,dim);
    boundary = zeros(nsides*div,dim);
    coord = zeros(nnodes,dim);
end

function vert = computeVertCoord(vert,sideLength,nsides) %GENERAL PARA POLÍGONOS CON LADOS IGUALES
    theta0 = 0;
    thetaVar = 360/nsides;
    c0 = [0,0];
    for iEdge = 2:nsides
        theta = theta0 + (iEdge-2)*thetaVar;
        vert(iEdge,:) = vert(iEdge,:)+c0+sideLength.*[cosd(theta) sind(theta)];
        c0 = vert(iEdge,:);
    end
end

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
    
function plotVertices(vert,coord)
    plotNodes(1:size(vert,1),coord,'green')
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


%     function plotMasterSlaveNodes(masterSlave)
%     end

function plotNodes(ind,coord,colorValue)
    b = num2str(ind);
    c = cellstr(b);
    dx = 0.1; dy = 0.1;
    x = coord(ind,1);
    y = coord(ind,2);
    t = text(x+dx,y+dy,c);
    set(t,'Color',colorValue)
end

%     function plotNodes(ind,nodes,colorValue)
%         b = num2str(ind);
%         c = cellstr(b);
%         dx = 0.1; dy = 0.1;
%         x = nodes(ind,1);
%         y = nodes(ind,2);
%         t = text(x+dx,y+dy,c);
%         set(t,'Color',colorValue)
%     end

