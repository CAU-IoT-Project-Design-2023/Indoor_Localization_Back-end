A = 1; % 상태 전이 행렬
H = 1; % 측정 행렬
Q = 1; % 프로세스 노이즈 공분산   
R = 15; % 측정 노이즈 공분산
x_hat = 0; % 초기 상태 추정값
P = 13; % 초기 추정 오차 공분산

%% 
filename = '9/result/correct1';
data = xlsread(filename, 'rssi');
%
result = []
%% 
for i = 2:4
    measured_rssi = data(:,i)
    x_hat = measured_rssi(1)
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
    result = [result,median(measured_rssi)]
    % 결과 시각화
    % 결과 시각화
%    figure;
%    plot(measured_rssi, 'b+', 'DisplayName', 'Measured RSSI');
%    hold on;
%    plot(filtered_rssi, 'r', 'LineWidth', 2, 'DisplayName', 'Filtered RSSI');
%    legend('Location', 'best');
%    xlabel('Time');
%    ylabel('RSSI');
%    title('Kalman Filter for RSSI Data');
%    grid on;
end
please = doKNNPrediction(result(1),result(2),result(3))
disp(result)