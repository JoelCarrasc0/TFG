function master_slave = computeMasterSlaveNodes(coord,div,c)
    % EN LUGAR DE ENTRAR TODAS LAS COORDENADAS ES RECOMENDABLE ENTRAR LAS
    % COORDENADAS DEL BOUNDARY (ÚNICAS ÚTILES)
    [vert,ymax,ymin,xmax,xmin,xmed] = computeOrderedVertices(coord,c);
    
    function [vert,ymax,ymin,xmax,xmin,xmed] = computeOrderedVertices(coord,c)
        % function: find essential coordinates
        xmax = max(coord(:,1));
        xmin = min(coord(:,1));
        xmed = (xmax-xmin)/2;
        ymax = max(coord(:,2));
        ymin = min(coord(:,2));
        ymed = (ymax-ymin)/2;
        % CONDENSAR ESTAS COORDENADAS EN UN STRUCT
        
        % function: assign coordinated to ordered vertices
        % POSICIONES ORDENADAS DE FORMA ANTIHORARIA
%         vert(1,:) = [xmed-c/2,ymax];
%         vert(2,:) = [xmin,ymed];
%         vert(3,:) = [xmed-c/2,ymin];
%         vert(4,:) = [xmed+c/2,ymin];
%         vert(5,:) = [xmax,ymed];
%         vert(6,:) = [xmed+c/2,ymax];
 
        vert(1,:) = [xmed-c/2,ymax];
        vert(2,:) = [xmed+c/2,ymax];
        vert(3,:) = [xmin,ymed];
        vert(4,:) = [xmax,ymed];
        vert(5,:) = [xmed-c/2,ymin];
        vert(6,:) = [xmed+c/2,ymin];
    end
        
        % Parametrización de rectas
        % Primera recta
        m1 = (vert(3,2)-vert(1,2))/(vert(3,1)-vert(1,1));
        n1 = vert(1,2)-m1*vert(1,1);
        % Segunda recta
        m2 = (vert(6,2)-vert(4,2))/(vert(6,1)-vert(4,1));
        n2 = vert(4,2)-m2*vert(4,1);
        % Tercera recta
        m3 = (vert(4,2)-vert(2,2))/(vert(4,1)-vert(2,1));
        n3 = vert(2,2)-m3*vert(2,1);
        % Cuarta recta
        m4 = (vert(5,2)-vert(3,2))/(vert(5,1)-vert(3,1));
        n4 = vert(3,2)-m4*vert(3,1);
        
        % Hallar los master-slave nodes
        master_slave1 = zeros(div-1,2);
        p_up = 1;
        p_dwn = 1;
        master_slave2 = zeros(div-1,2); %div-1
        q_up = 1;
        q_dwn = 1;
        master_slave3 = zeros(div-1,2); %div-1
        r_up = 1;
        r_dwn = 1;
        tol = 1e-15;
        % Se podria replantear el hecho de hacer x = coord(i,1) e y = coord(i,2)
        % Replantear si hacerlo con elseif
        for i = 1:size(coord,1)
            % Tramo superior e inferior
            if coord(i,2) == ymax
                if (coord(i,1) ~= xmed-c/2) && (coord(i,1) ~= xmed+c/2)
                    master_slave1(p_up,1) = master_slave1(p_up,1)+i;
                    p_up = p_up+1; 
                end
            end
            if coord(i,2) == ymin
                if (coord(i,1) ~= xmed-c/2) && (coord(i,1) ~= xmed+c/2)
                    master_slave1(p_dwn,2) = master_slave1(p_dwn,2)+i;
                    p_dwn = p_dwn+1;
                end
            end  
            % Tramo superior izquierdo e inferior derecho
            if abs(coord(i,2)-m1*coord(i,1)-n1) < tol
                if (coord(i,1) ~= xmin) && (coord(i,2) ~= ymax)
                    master_slave2(q_up,1) = master_slave2(q_up,1)+i;
                    q_up = q_up+1;
                end
            end
            if abs(coord(i,2)-m2*coord(i,1)-n2) < tol
                if (coord(i,1) ~= xmax) && (coord(i,2) ~= ymin)
                    master_slave2(q_dwn,2) = master_slave2(q_dwn,2)+i;
                    q_dwn = q_dwn+1;
                end
            end
            % Tramo superior derecho e inferior izquierdo
            if abs(coord(i,2)-m3*coord(i,1)-n3) < tol
                if (coord(i,1) ~= xmax) && (coord(i,2) ~= ymax)
                    master_slave3(r_up,1) = master_slave3(r_up,1)+i;
                    r_up = r_up+1;
                end
            end
            if abs(coord(i,2)-m4*coord(i,1)-n4) < tol
                if (coord(i,1) ~= xmin) && (coord(i,2) ~= ymin)
                    master_slave3(r_dwn,2) = master_slave3(r_dwn,2)+i;
                    r_dwn = r_dwn+1;
                end
            end
        end
        master_slave([1 div-1],:) = master_slave1([1 div-1],:);
        master_slave([div 2*(div-1)],:) = master_slave2([1 div-1],:);
        master_slave([2*(div-1)+1 3*(div-1)],:) = master_slave3([1 div-1],:);
    end