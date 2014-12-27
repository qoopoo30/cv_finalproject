function output = Take2Match(D, temp, thresh, m,train_files)

D_temp = repmat(D(m,:),[thresh,1]);
temp2 = repmat(temp',[1, length(train_files)]);
index = (D_temp == temp2);
train_temp = repmat(train_files',[thresh,1]);
output = train_temp(index);
fields = {'date', 'bytes', 'isdir', 'datenum'};
output = rmfield(output, fields);

    for k = 1:thresh
        %Take2Match(k).name = train_files(D(m,:)==temp(k)).name;
        if length(output(k).name)>6 && output(k).name(end-6) == '('
            output(k).name = [output(k).name(1:end-7), '.mat'];
        else
            output(k).name = [output(k).name(1:end-4), '.mat'];
        end
    end
    
    output = unique(struct2cell(output));