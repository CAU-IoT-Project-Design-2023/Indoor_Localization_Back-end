function result = calculateKalman()
% 칼만 필터 파라미터 설정
A = 1; % 상태 전이 행렬
H = 1; % 측정 행렬
Q = 0.1; % 프로세스 노이즈 공분산
R = 3; % 측정 노이즈 공분산
x_hat = 0; % 초기 상태 추정값
P = 3; % 초기 추정 오차 공분산

%% 
filename = 'rssi_data.xls';
data = xlsread(filename, 'rssi');
result = [];
%% 
for i = 2:4
    measured_rssi = data(:,i);
    x_hat = measured_rssi(1);
    filtered_rssi = zeros(size(measured_rssi));
    for k = 1:length(measured_rssi)
        % 예측 단계
        x_hat_minus = A * x_hat;
        P_minus = A * P * A' + Q;
    
        % 업데이트 단계
        K = P_minus * H' / (H * P_minus * H' + R);
        x_hat = x_hat_minus + K * (measured_rssi(k) - H * x_hat_minus);
        P = (1 - K * H) * P_minus;
    
        filtered_rssi(k) = x_hat;
    end
    result = [result,median(measured_rssi)];
    % 결과 시각화
end

disp(result)

