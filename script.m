clear
% Parametros
L1 = 5;
L2 = 6.25;
L3 = 6.25;
L4 = 5;
L5 = 4; %bancada

% origen coordenadas
X0 = 5;
Y0 = 0;

% coordenadas primer pivote
O1x = 0;
O1y = 0;

% coordenadas segundo pivote
O2x = O1x+L5;
O2y = 0;

name = '';

% cambiar el numero para seleccionar animacion a realizar
selector = 3;
if (selector == 0)
    data = readtable('cuadrado.csv');
    name = 'cuadrado.gif';
    title_name = 'Cuadrado';
    
elseif (selector == 1)
    data = readtable('triangulo.csv');
    name = 'triangulo.gif';
    title_name = 'Triangulo';
    
elseif (selector == 2)
    data = readtable('circulo.csv');
    name = 'circulo.gif';
    title_name = 'Circulo';
    
elseif (selector == 3)
    data = readtable('uvg.csv');
    name = 'uvg.gif';
    title_name = 'UVG';
    
elseif (selector == 4)
    data = readtable('seno.csv');
    name = 'seno.gif';
    title_name = 'Seno';
    
elseif (selector == 5)
    data = readtable('iniciales.csv');
    name = 'iniciales.gif';
    title_name = 'Iniciales';
end

[bx, by] = point(data.theta1, L1, O1x+X0, O1y+Y0);

t2 = theta2(data.Px, data.Py, O1x+X0, O1y+Y0, L1, data.theta1);

[px, py] = point(t2, L2, bx, by);


[dx, dy] = point(data.theta4, L4, O2x+X0, O2y+Y0);

t3 = theta3(data.Px, data.Py, O2x+X0, O2y+Y0, L4, data.theta4);

[px2, py2] = point(t3, L3, dx, dy);


figure('Color', 'white')
% format: plot([ x1_start, x2_start, x3_start; x1_end, x2_end, x3_end],[ y1_start, y2_start, y3_start; y1_end, y2_end, y3_end])
hh1 = plot([O1x+X0, O2x+X0, bx(1), dx(1); bx(1), dx(1), px(1), px2(1)],[O1y+Y0, O2y+Y0, by(1), dy(1); by(1), dy(1), py(1), py2(1)]);
title(title_name);
grid on

axis equal
axis([-2.5 15 0 12])

an = animatedline;

%% Loop through by changing XData and YData
for id = 1:size(data,1)
    
    % Update graphics data. This is more efficient than recreating plots.
    set(hh1(1), 'XData', [O1x+X0, bx(id)], 'YData', [O1y+Y0, by(id)])
    set(hh1(2), 'XData', [O2x+X0, dx(id)], 'YData', [O2y+Y0, dy(id)])
    set(hh1(3), 'XData', [bx(id), px(id)], 'YData', [by(id), py(id)])
    set(hh1(4), 'XData', [dx(id), px2(id)], 'YData', [dy(id), py2(id)])
    
    addpoints(an, px(id),  py(id));
    
    % Get frame as an image
    f = getframe(gcf);
    
    % Create a colormap for the first frame. For the rest of the frames,
    % use the same colormap
    if id == 1
        [mov(:,:,1,id), map] = rgb2ind(f.cdata, 256, 'nodither');
    else
        mov(:,:,1,id) = rgb2ind(f.cdata, map, 'nodither');
    end
    
end

% Create animated GIF
imwrite(mov, map, name, 'DelayTime', 0, 'LoopCount', inf)


%% Funciones 

function [x, y] = point(theta, L, x0, y0)

    x = L*cosd(theta)+x0;
    
    y = L*sind(theta)+y0;

end

function t2 = theta2(px, py, dx1, dy1, L1, theta1)

    t2 = atan2d(py-dy1-L1*sind(theta1), px-dx1-L1*cosd(theta1));

end

function t3 = theta3(px, py, dx2, dy2, L2, theta2)

    t3 = atan2d(py-dy2-L2*sind(theta2), px-dx2-L2*cosd(theta2));
    
end
