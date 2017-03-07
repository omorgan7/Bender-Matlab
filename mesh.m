function mesh
[v,vertexIndices] = loadmesh;
close all
figure(1)
hold on;
x = v(:,1);
v(:,1) = v(:,2);
v(:,2) = -x;
v = v(:,1:2);

for i = 1:length(vertexIndices)
    points = vertexIndices(i,:);
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

handleIndex = 1;
for i = 2:3
    if((norm(v(handleIndices(i),:)-newMove)^2)<= (norm(v(handleIndices(handleIndex),:)-newMove)^2))
        handleIndex = i;
    end
end
plot(newMove(1),newMove(2),'b.','MarkerSize',20);

w = 1000;
A = zeros(numel(vertexIndices)*2 + 6,numel(v));
b = zeros(numel(vertexIndices)*2 + 6, 1);
for i = 1:3
    if(i == handleIndex)
        b(end-6+2*(i-1)+1) = w*newMove(1);
        b(end-6+2*i) = w*newMove(2);
    else
        b(end-6+2*(i-1)+1) = w*v(handleIndices(i),1);
        b(end-6+2*i) = w*v(handleIndices(i),2);
    end
    A(end-6+2*(i-1)+1,handleIndices(i)*2-1) = w;
    A(end-6+2*i,handleIndices(i)*2) = w;
end

for i = 1:length(vertexIndices)
    for j = 1:3
        [NBH,NBH_indices]=findlocalNBH(v,vertexIndices,vertexIndices(i,j),vertexIndices(i,mod(j,3)+1));
        numIndices = length(NBH_indices);
        edgeArr = zeros(2,numIndices*2);
        G = zeros(numIndices*2,4);
        for k = 1:2:2*numIndices
            G(k,1:2) = NBH{ceil(k/2)};
            G(k+1,1:2) = fliplr(NBH{ceil(k/2)});
            G(k+1,2) = -G(k+1,2);
            G(k:k+1,3:4) = eye(2);
        end
        
        H = (G/(G'*G))';
        H = H(1:2,:);
        edgeArr(:,1:4) = [-1,0,1,0;0,-1,0,1];
        
        edge = NBH{2} - NBH{1};
        edgeMat = [edge(1), edge(2);edge(2),-edge(1)];
        
        h = edgeArr - edgeMat*H;
        for k = 1:numIndices
            A(6*(i-1)+2*j-1,2*NBH_indices(k)-1:2*NBH_indices(k)) = h(1,2*k-1:2*k);
            A(6*(i-1)+2*j,2*NBH_indices(k)-1:2*NBH_indices(k)) = h(2,2*k-1:2*k);
        end
    end
end
newV = ((A'*b)'/(A'*A))';
newV = reshape(newV',[2,length(v)])';
clf
figure(1)
hold on
for i = 1:length(vertexIndices)
    points = vertexIndices(i,:);
    DrawBetweenTwoPoints(newV(points(1),:),newV(points(2),:));
    DrawBetweenTwoPoints(newV(points(2),:),newV(points(3),:));
    DrawBetweenTwoPoints(newV(points(3),:),newV(points(1),:));
end
x(handleIndex) = newMove(1);
y(handleIndex) = newMove(2);
plot(x,y,'r.','MarkerSize',20);

end
