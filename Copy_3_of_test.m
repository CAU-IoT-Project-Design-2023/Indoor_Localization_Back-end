%%data pre-processing

dataStruct = importdata('data.txt', ',');
data = dataStruct(:,1:3);

tensor = data(:,2)
mean_tensor = mean(tensor);
var_tensor = var(tensor);
z_scores = (tensor - mean_tensor) / sqrt(var_tensor);
desired_var = 1.5 * var_tensor;
scaled_tensor = sqrt(desired_var) * z_scores;
result_tensor = scaled_tensor + mean_tensor;

labels = dataStruct(:,4);

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
legend('x', 'y', 'z', 'Best');
hold off;

%%%
k = 1;
model = fitcknn(data,labels,'NumNeighbors',k,'Standardize',1);
result = predict(model,buf);

%%%
localization
