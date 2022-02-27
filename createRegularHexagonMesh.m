function createRegularHexagonMesh()
meshfilename = 'test2d_micro_joel_PRUEBA_hexagon.m';
Data_prb = {'''TRIANGLE''','''SI''','''2D''','''Plane_Stress''','''ELASTIC''','''MICRO'''};
ndim = 2;
c = 1;
div = 2; % Divisiones por lado del hexagono
% Tres divisiones equivalen a cuatro nodos por lado 
ydiv = div;
xdiv = div;
nnodes = 3*(div+1)*div+1;
coord = zeros(nnodes,ndim); %Se debe cambiar el número de prueba
row = 1;
for jdiv = 0:ydiv
    for idiv = 0:xdiv
        coord(row,1) = coord(row,1) + 0.5*c + c/div*idiv - 0.5*c/div*jdiv;
        coord(row,2) = coord(row,2) + 2*c*0.866 - 0.866*c/div*jdiv;
        row = row+1;
    end
    xdiv = xdiv+1;
end
xdiv = xdiv-1;
for jdiv = 1:ydiv
    xdiv = xdiv-1;
    for idiv = 0:xdiv
        coord(row,1) = coord(row,1) + c/div*idiv + 0.5*c/div*jdiv;
        coord(row,2) = coord(row,2) + c*0.866 - 0.866*c/div*jdiv;
        row = row+1;
    end
end
connec = delaunay(coord);
s.coord = coord;
s.connec = connec;
m = Mesh(s);
m.plot();
computeMasterSlaveNodes(coord,div);

    function computeMasterSlaveNodes(coord,div) %La primera componente es x y la segunda y
        % Posiciones básicas
        xmax = max(coord(:,1));
        xmin = min(coord(:,1));
        ymax = max(coord(:,2));
        ymin = min(coord(:,2));
        ymed = (ymax+ymin)/2;
        
        % Posiciones de los 6 puntos básicos
        min1 = 1e5;
        max2 = 0;
        min5 = 1e5;
        max6 = 0;
        for i = 1:size(coord,1)
            if coord(i,2) == ymax
                if coord(i,1) < min1
                    min1 = coord(i,1);
                end
                if coord(i,1) > max2
                    max2 = coord(i,1);
                end
            elseif coord(i,2) == ymin %Encontrar min5 y max5 es indiferente ya que son iguales que min1 y max2 respectivamente
                if coord(i,1) < min5
                    min5 = coord(i,1);
                end
                if coord(i,1) > max6
                    max6 = coord(i,1);
                end
            end
        end
        pos(1,:) = [min1,ymax];
        pos(2,:) = [max2,ymax];
        pos(3,:) = [xmin,ymed];
        pos(4,:) = [xmax,ymed];
        pos(5,:) = [min5,ymin];
        pos(6,:) = [max6,ymin];
        
        % Parametrización de rectas
        % Primera recta
        m1 = (pos(3,2)-pos(1,2))/(pos(3,1)-pos(1,1));
        n1 = pos(1,2)-m1*pos(1,1);
        % Segunda recta
        m2 = (pos(6,2)-pos(4,2))/(pos(6,1)-pos(4,1));
        n2 = pos(4,2)-m2*pos(4,1);
        % Tercera recta
        m3 = (pos(4,2)-pos(2,2))/(pos(4,1)-pos(2,1));
        n3 = pos(2,2)-m3*pos(2,1);
        % Cuarta recta
        m4 = (pos(5,2)-pos(3,2))/(pos(5,1)-pos(3,1));
        n4 = pos(3,2)-m4*pos(3,1);
        
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
                if (coord(i,1) ~= min1) && (coord(i,1) ~= max2)
                    master_slave1(p_up,1) = master_slave1(p_up,1)+i;
                    p_up = p_up+1; 
                end
            end
            if coord(i,2) == ymin
                if (coord(i,1) ~= min5) && (coord(i,1) ~= max6)
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
        % Falta crear la unión entre los master_slave en uno solo
    end


end