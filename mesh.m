[v,vi] = loadmesh;
close all
figure(1)
hold on;
x = v(:,1);
v(:,1) = v(:,2);
v(:,2) = -x;

for i = 1:length(vi)
    points = vi(i,:);
    DrawBetweenTwoPoints(v(points(1),1:2),v(points(2),1:2));
    DrawBetweenTwoPoints(v(points(2),1:2),v(points(3),1:2));
    DrawBetweenTwoPoints(v(points(3),1:2),v(points(1),1:2));
end