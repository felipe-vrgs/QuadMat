
x0 = 2; % Suponha que aqui utilizaremos o x0 para a célula de equilíbrio encontrada
y0 = 2; % Suponha que aqui utilizaremos o y0 para a célula de equilíbrio encontrada
r = 6; % Raio do circulo para a geração dos pontos
 for a=0:35 % Todos os angulos, tendo em vista que 0 e 360 produzem o mesmo resultado
    angle = 10*a;
    newX = x0 + r*cosd(angle);
    newY = y0 + r*sind(angle);
    fprintf('Os novos pontos são: x = %g e y = %g para o angulo %g\n',newX,newY,angle);
 end
 
