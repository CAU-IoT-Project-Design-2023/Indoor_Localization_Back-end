function result = doKNNPrediction(x,y,z)
%DOKNNPREDICTION 이 함수의 요약 설명 위치
%   자세한 설명 위치
kResult = calculateKalman()
k = 1
buf = [x,y,z]
disp(buf)
%% data setup
dataStruct = importdata('data.txt', ',');
data = dataStruct(:,1:3);

labels = dataStruct(:,4);
%%

%%
model = fitcknn(data,labels,'NumNeighbors',k,'Standardize',1);
result = predict(model,buf);

end
