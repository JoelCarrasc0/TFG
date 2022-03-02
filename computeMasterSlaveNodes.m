function masterSlave = computeMasterSlaveNodes(coord,div,c)
    % EN LUGAR DE ENTRAR TODAS LAS COORDENADAS ES RECOMENDABLE ENTRAR LAS
    % COORDENADAS DEL BOUNDARY (ÚNICAS ÚTILES)
    vert = computeOrderedVertices(coord,c);
    
    function vert = computeOrderedVertices(coord,c)
        % function: find essential coordinates
        xmax = max(coord(:,1));
        xmin = min(coord(:,1));
        xmed = (xmax-xmin)/2;
        ymax = max(coord(:,2));
        ymin = min(coord(:,2));
        ymed = (ymax-ymin)/2;
        
        % function: assign coordinated to ordered vertices
        % POSICIONES ORDENADAS DE FORMA ANTIHORARIA
        vert(1,:) = [xmed+c/2,ymax];
        vert(2,:) = [xmed-c/2,ymax];
        vert(3,:) = [xmin,ymed];
        vert(4,:) = [xmed-c/2,ymin];
        vert(5,:) = [xmed+c/2,ymin];
        vert(6,:) = [xmax,ymed];
    end

    [normalVec,interiorNodes] = computeBoundaryMeshes(vert,coord,div);
    
    function [normalVec,interiorNodes] = computeBoundaryMeshes(vert,coord,div)
        normalVec = zeros(size(vert,1),2);
        for iVert = 1:size(vert,1)
            % función de obtención de vertices
            vertexA = vert(iVert,:);
            if iVert == size(vert,1)
                vertexB = vert(1,:);
            else   
                vertexB = vert(iVert+1,:);
            end
            % función de obtención del vector unitario
            vec = vertexB - vertexA;
            mod = norm(vec);
            vecU = vec/mod;
            % función de obtención de la normal (siempre saliente al lado)
            normalVec(iVert,1) = normalVec(iVert,1)+vecU(1,2);
            normalVec(iVert,2) = normalVec(iVert,2)-vecU(1,1);
        end
        
        % Función que calcula todos los vectores posibles hasta el verticeA
        coord2A = zeros(size(coord,1),2*size(vert,1));
        for iVert = 1:size(vert,1)
            % MISMA Función que obtiene los vertices
            vertexA = vert(iVert,:);
            if iVert == size(vert,1)
                vertexB = vert(1,:);
            else   
                vertexB = vert(iVert+1,:);
            end
            for iVec = 1:size(coord,1)
                vertexC = coord(iVec,:);
                % Misma función de obtención del vector unitario (con un swich se puede añadir el filtro impuesto en esta)
                vec = vertexC-vertexA;
                mod = norm(vec);
                if (mod == 0) || ((vertexC(1,1) == vertexB(1,1))&&(vertexC(1,2) == vertexB(1,2)))
                    vecU = zeros(1,2);
                else
                    vecU = vec/mod;
                end
                coord2A(iVec,[2*iVert-1 2*iVert]) = coord2A(iVec,[2*iVert-1 2*iVert])+vecU;
            end
        end
        
        % find nodes with coord2A ortogonal to normal --> interiorNodes
        tol = 10e-6;
        interiorNodes = zeros(div-1,size(normalVec,1));
        for iLine = 1:size(normalVec,1)
            ortoVec = normalVec(iLine,:);
            kpos = 1;
            for iVec = 1:size(coord2A,1) %iVec es coincidente con el node number
                vec = coord2A(iVec,[2*iLine-1 2*iLine]);
                if norm(vec) ~= 0  
                    if abs(dot(ortoVec,vec)) < tol
                        interiorNodes(kpos,iLine) = interiorNodes(kpos,iLine)+iVec;
                        kpos = kpos + 1;
                    end
                end
            end
        end  
        
%         % plot boundary mesh function
%         % SOLO FUNCIONARÁ CUANDO SE INTRODUZCAN LOS NODOS DE LA BOUNDARY
%         % POR LAS COORD
%         sI.coord = coord(nodesI,:) ;
%         nT = length(coord);
%         sI.connec(:,1) = 1:nT;
%         sI.connec(:,2) = [2:nT,1];
%         sI.kFace = -1;
%         m = Mesh(sI);
%         m.plot()

    end

pairs = computePairOfMeshes(normalVec);

    function pairs = computePairOfMeshes(normalVec)
        tol = 10e-6;
        pairs = zeros(size(normalVec,1)/2,2);
        for iSrch = 1:size(normalVec,1)/2
            found = 0;
            k0 = 0;
            while found == 0 
                jSrch = k0+iSrch+1;
                if (normalVec(iSrch,1) == 0) && (normalVec(jSrch,1) == 0)
                    xdiv = -1;
                else
                    xdiv = normalVec(iSrch,1)/normalVec(jSrch,1);
                end
                ydiv = normalVec(iSrch,2)/normalVec(jSrch,2); %En ningún caso la componente y es nula
                if abs(xdiv-ydiv) < tol
                    pairs(iSrch,1) = pairs(iSrch,1)+iSrch;
                    pairs(iSrch,2) = pairs(iSrch,2)+jSrch;
                    found = 1;
                end
                k0 = k0+1;
            end
        end
    end

masterSlave = computeMasterAndSlaves(interiorNodes,pairs);

    function masterSlave = computeMasterAndSlaves(interiorNodes,pairs)
        %función que asigna los nodos sobre las rectas que corresponde
        % HACER UNA FUNCIÓN QUE CALCULE LAS DIMENSIONES
        masterSlave = zeros(size(interiorNodes,1)*size(pairs,1),size(pairs,2));
        aux = 0;
        for ipair = 1:size(pairs,1)
            meshA = pairs(ipair,1);
            meshB = pairs(ipair,2);
            iPos = 1;
            while iPos <= size(interiorNodes,1)
                masterSlave(iPos+aux,1) = masterSlave(iPos+aux,1)+interiorNodes(iPos,meshA);
                masterSlave(iPos+aux,2) = masterSlave(iPos+aux,2)+interiorNodes(iPos,meshB);
                if iPos == size(interiorNodes,1)
                    aux = aux+1;
                end
                iPos = iPos+1;
            end
        end
        %función que pone en la primera fila los nodos con numeración baja
        for iPos = 1:size(masterSlave,1)
            if masterSlave(iPos,1) > masterSlave(iPos,2)
                backup = masterSlave(iPos,1);
                masterSlave(iPos,1) = masterSlave(iPos,2);
                masterSlave(iPos,2) = backup;
            end
        end
    end
end