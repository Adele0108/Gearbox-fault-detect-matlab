function [opt_theta, predict_labels,accuracy] = run_SAE_once(images_Train, labels_Train, ...
    images_Test, labels_Test, ... % ����
    architecture, ...
    option_SAE, option_BPNN, ...
    is_disp_network, is_disp_info,save_model)
%����SAE���� �� ����һ�� SAE

%% ѵ��SAE
theta_SAE = train_SAE(images_Train, labels_Train, architecture, option_SAE); % ѵ��SAE
if is_disp_network
    % չʾ�����м������ȡ��feature
    display_network(reshape(theta_SAE(1 : 784 * 400), 400, 784));
    display_network((reshape(theta_SAE(1 : 784 * 400), 400, 784)' * ...
        reshape(theta_SAE(784 * 400 + 1 : 784 * 400 + 400*200 ), 200, 400)')');
end
if is_disp_info
    % �� δ΢����SAE���� ����Ԥ��
    predict_labels = predict_NN(images_Train, architecture, theta_SAE, option_BPNN);
    accuracy = get_accuracy_rate(predict_labels, labels_Train);
    disp(['accuracy(no fine-tune) on train dataset is ', num2str(accuracy * 100), '%']);
    
    predict_labels = predict_NN( images_Test, architecture, theta_SAE, option_BPNN );
    accuracy = get_accuracy_rate( predict_labels, labels_Test );
    disp(['accuracy(no fine-tune) on test dataset is ', num2str(accuracy * 100), '%']);
end

%% BP fine-tune
[opt_theta, ~] = train_BPNN( images_Train, labels_Train, theta_SAE, architecture, option_BPNN );
if is_disp_network
    % չʾ�����м������ȡ��feature
    display_network(reshape(opt_theta(1 : 784 * 400), 400, 784) );
    display_network((reshape(opt_theta(1 : 400 * 784), 400, 784)' * ...
        reshape(opt_theta(784 * 400 + 1 : 784 * 400 + 400*200 ), 200, 400)')' );
end
%% �� fine-tune��SAE ����Ԥ��
if is_disp_info
    predict_labels = predict_NN(images_Train, architecture, opt_theta, option_BPNN);
    accuracy = get_accuracy_rate(predict_labels, labels_Train);
    disp(['accuracy( fine-tune) on train dataset is ', num2str(accuracy * 100), '%']);
end
predict_labels = predict_NN( images_Train, architecture, opt_theta, option_BPNN);
% disp(['�����������Ϊ',num2str(predict_labels)])
accuracy = get_accuracy_rate( predict_labels, labels_Train );
disp(['accuracy( fine-tune) on train dataset is ', num2str(accuracy * 100), '%'] );
predict_labels = predict_NN( images_Test, architecture, opt_theta, option_BPNN);
accuracy = get_accuracy_rate( predict_labels, labels_Test );
disp(['accuracy( fine-tune) on test dataset is ', num2str(accuracy * 100), '%']);% pppppppppppppppppppppp
save(strcat('./model/opt_theta',num2str(save_model)),'opt_theta');
if is_disp_info
    disp(['accuracy( fine-tune) on test dataset is ', num2str(accuracy * 100), '%']);
end

end


