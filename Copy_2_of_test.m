%%data pre-processing
start = 1
last = 7
dataStruct = importdata('data.txt', ',');
data = dataStruct(start:last,1:3);

labels = dataStruct(start:last,4);

%%

%%data plotting
colors = jet(10);
figure;
scatter3(data(:, 1), data(:, 2), data(:, 3), 30, labels, 'filled'); % 원본 데이터 플롯
hold on;
title('3D 데이터와 k-NN 분류 결과');
xlabel('x');
ylabel('y');
zlabel('z');
legend('x', 'y', 'z', 'Best');
hold off;

%%%
k = 1;
model = fitcknn(data,labels,'NumNeighbors',k,'Standardize',1);
result = predict(model,buf);

%%%
localization
