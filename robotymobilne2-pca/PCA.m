function [PC,signals] = PCA(X)

[M,N] = size(X);

srednie = mean(X,2);

X = X - repmat(srednie,1,N);

C = 1/(N-1)*X*X';

[PC,V] = eig(C);

V = diag(V);

%size(V)
%figure;
%plot([1:200],V); hold on;

[junk,indeksy] = sort(V,'descend');
V=V(indeksy);
PC=PC(:,indeksy);
%figure;
%stem([1:200],V)
signals=PC'*X;

end