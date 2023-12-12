%%data pre-processing
start1 = 57
last1 = 63
start2 = 43
last2 = 49
dataStruct = importdata('data.txt', ',');
data1 = dataStruct(start1:last1,1:3);
data2 = dataStruct(start2:last2,1:3);
data = vertcat(data1, data2);

labels1 = dataStruct(start1:last1,4);
labels2 = dataStruct(start2:last2,4);
labels = vertcat(labels1, labels2);
buf = [-65,-62,-55]
labelbuf = [11]
data = vertcat(data,buf)
labels= vertcat(labels,labelbuf)
%%

%%data plotting
colors = jet(10);
figure;
scatter3(data(:, 1), data(:, 2), data(:, 3), 30, labels, 'filled'); % 원본 데이터 플롯
hold on;
title('3D 데이터와 k-NN 분류 결과');
xlabel('ap1');
ylabel('ap2');
zlabel('ap3');
legend('ap1', 'ap2', 'ap3', 'Best');
hold off;

%%%
k = 1;
model = fitcknn(data,labels,'NumNeighbors',k,'Standardize',1);
result = predict(model,buf);

%%%
localization
