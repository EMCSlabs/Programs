function [pred, new_Hidden_Cell_Memory, new_Hidden_Activation, new_Output_Activation] =...
    forward_LSTM(models, frame_count, input_type, input_stream, hidden_Cell_Memory_List, hidden_Activation_List)
% LSTM forward calculation
% 2017-03-08 jkang
%
% ** Notes **
% input_type: {'articulation', 'acoustics'}
% size(input_stream): (1 x feature) % row vector
% size(pred): (1 x feature) % row vector
% frame_count: 0, 1, 2, etc.

% input compress
sigmoid = @(a,x) 1./(1 + exp(a*x));
if strcmp(input_type, 'articulation')
    in_coeff = -0.1;
    out_coeff = -0.25;
    input_Activation = sigmoid(in_coeff,input_stream);
elseif strcmp(input_type, 'acoustics')
    in_coeff = -0.25;
    out_coeff = -0.1;
    input_Activation = sigmoid(in_coeff,input_stream);
end

weightMatrix_IH_Input = models.weightMatrix_IH_Input;
weightMatrix_HH_Input = models.weightMatrix_HH_Input;
biasMatrix_H_Input = models.biasMatrix_H_Input;
weightMatrix_IH_Output = models.weightMatrix_IH_Output;
weightMatrix_HH_Output = models.weightMatrix_HH_Output;
biasMatrix_H_Output = models.biasMatrix_H_Output;
weightMatrix_IH_Forget = models.weightMatrix_IH_Forget;
weightMatrix_HH_Forget = models.weightMatrix_HH_Forget;
biasMatrix_H_Forget = models.biasMatrix_H_Forget;
weightMatrix_IH_Storage = models.weightMatrix_IH_Storage;
weightMatrix_HH_Storage = models.weightMatrix_HH_Storage;
biasMatrix_H_Storage = models.biasMatrix_H_Storage;
weightMatrix_HO = models.weightMatrix_HO;
biasMatrix_O = models.biasMatrix_O;

if frame_count < 1
    % initial hidden storage
    new_Hidden_Storage = tanh(input_Activation*weightMatrix_IH_Storage) + biasMatrix_H_Storage;
    new_Hidden_Input_Gate = sigmoid(-1,input_Activation*weightMatrix_IH_Input) + biasMatrix_H_Input;
    new_Hidden_Forget_Gate = sigmoid(-1,input_Activation*weightMatrix_IH_Forget) + biasMatrix_H_Forget;
    new_Hidden_Output_Gate = sigmoid(-1,input_Activation*weightMatrix_IH_Output) + biasMatrix_H_Output;
    new_Hidden_Cell_Memory = new_Hidden_Storage.*new_Hidden_Input_Gate; % hadamard product
    new_Hidden_Activation = new_Hidden_Output_Gate.*tanh(new_Hidden_Cell_Memory); % hadamard product
    new_Output_Activation = sigmoid(-1,new_Hidden_Activation*weightMatrix_HO) + biasMatrix_O;  % sigmoid compress on output activation
    
    hidden_Cell_Memory_List = {};
    hidden_Activation_List = {};
    output_Activation_List = {};
    
    hidden_Cell_Memory_List{1} = new_Hidden_Cell_Memory;
    hidden_Activation_List{1} = new_Hidden_Activation;
    output_Activation_List{1} = new_Output_Activation;
    pred = real(log(1./new_Output_Activation - 1)/out_coeff); % (feature x example)

elseif frame_count >= 1
    % forward calculation
    new_Hidden_Storage = tanh(input_Activation*weightMatrix_IH_Storage +...
        hidden_Activation_List*weightMatrix_HH_Storage + biasMatrix_H_Storage);
    new_Hidden_Input_Gate = sigmoid(-1,input_Activation*weightMatrix_IH_Input +...
        hidden_Activation_List*weightMatrix_HH_Input + biasMatrix_H_Input);
    new_Hidden_Forget_Gate = sigmoid(-1,input_Activation*weightMatrix_IH_Forget +...
        hidden_Activation_List*weightMatrix_HH_Forget + biasMatrix_H_Forget);
    new_Hidden_Output_Gate = sigmoid(-1,input_Activation*weightMatrix_IH_Output + ...
        hidden_Activation_List*weightMatrix_HH_Output + biasMatrix_H_Output);
    new_Hidden_Cell_Memory = new_Hidden_Storage.*new_Hidden_Input_Gate +...
        new_Hidden_Forget_Gate.*hidden_Cell_Memory_List; % hadamard product
    new_Hidden_Activation = new_Hidden_Output_Gate.*tanh(new_Hidden_Cell_Memory); % hadamard product
    new_Output_Activation = sigmoid(-1,new_Hidden_Activation*weightMatrix_HO + biasMatrix_O); % sigmoid compress on output activation
    
%     hidden_Cell_Memory_List{end+1} = new_Hidden_Cell_Memory;
%     hidden_Activation_List{end+1} = new_Hidden_Activation;
%     output_Activation_List{end+1} = new_Output_Activation;
    
    % reverse sigmoid
    pred = log(1./new_Output_Activation - 1)/out_coeff; % (feature x example)
end
