[v,vi] = loadmesh;
close all
figure(1)
hold on;
x = v(:,1);
v(:,1) = v(:,2);
v(:,2) = -x;
v = v(:,1:2);

for i = 1:length(vi)
    points = vi(i,:);
    DrawBetweenTwoPoints(v(points(1),1:2),v(points(2),1:2));
    DrawBetweenTwoPoints(v(points(2),1:2),v(points(3),1:2));
    DrawBetweenTwoPoints(v(points(3),1:2),v(points(1),1:2));
end

[x,y] = ginput(3);
plot(x,y,'r.','MarkerSize',20);

handleIndices = zeros(3,1);
for j = 1:3
    for i = 1:length(v)
        if((norm(v(i,:) - [x(j), y(j)])^2)<0.01)
            handleIndices(j) = i;
            break;
        end
    end
end

newMove = ginput(1);

for i = 1:3
    if((norm(v(handleIndices(i))-newMove)^2)<=0.5)
        handleIndex = i;
        break;
    end
end
plot(newMove(1),newMove(2),'b.','MarkerSize',20);

w = 1000;

b = zeros(length(v)*2, 1);

for i = 1:3
    if i == handleIndex
        b(2*handleIndices(i)) = w*newMove(1);
        b(2*handleIndices(i)+1) = w*newMove(2);
    else
        b(2*handleIndices(i)) = v(handleIndices(i),1);
        b(2*handleIndices(i)+1) =v(handleIndices(i),2);
    end
end

v_dash = v(:);

[v_i,vj,vl,vr] = findlocalNBH(v,vi,handleIndices(handleIndex));

G = zeros(8,2);
G(1,:) = v_i;
G(2,:) = [v_i(2),-v_i(1)];
G(3,:) = vj;
G(4,:) = [vj(2),-vj(1)];
G(5,:) = vl;
G(6,:) = [vl(2),-vl(1)];
G(7,:) = vr;
G(8,:) = [vr(2),-vr(1)];
H = (G/(G'*G))';

A = sparse(length(v)*2,length(v)*2);

for i = 1:length(vi)
    if(nnz(i==handleIndices))
       A(2*i,2*i) = w;
       A(2*i+1,2*i+1) = w;
    else
        
    end
    
end

