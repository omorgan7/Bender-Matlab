function [vi, vj, vl, vr] = findlocalNBH(vertices, vertex_indices, POI)
%FINDLOCALNBH Summary of this function goes here
%   Detailed explanation goes here
nbh_i = mod(find(vertex_indices==POI),length(vertex_indices));
nbh_h = zeros(length(nbh_i),3);
nbh = zeros(4,2);

for i = 1:length(nbh_i)
    nbh_h(i,:) = vertex_indices(nbh_i(i),:);
end
nbh_u = unique(nbh_h);
nbh_c = [nbh_u,histc(nbh_h(:),nbh_u)];
count = 1;
for i = 1:length(nbh_u)
    if (nbh_c(i,2) ~=1)
        nbh(count,:) = vertices(nbh_u(i,1),:);
        count = count+1;
        if(count == 5)
            break;
        end
    end
end
desiredIndexFlag = 0;
for i = 1:4
   if(nbh(i,:) == vertices(handleIndices(handleIndex),:))
      desiredIndexFlag = i;
      break;
   end
end

if(desiredIndexFlag ==0)
    nbh(i,:) = vertices(POI,:);
end

[~,vl_i] = min(nbh(:,1));
[~,vr_i] = max(nbh(:,1));

vl = nbh(vl_i,:);
vr = nbh(vr_i,:);

for i = 1:4
   if(i == vl_i || i == vr_i || i == desiredIndexFlag)
       continue;
   end
   vj = nbh(i,:);
end
vi = vertices(POI,:);



end

