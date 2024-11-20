folderPath = 'Instances_V1.1'; 

xmlFiles = dir(fullfile(folderPath, '*.xml'));
num_xml_file = 2;

xmlFilePath = fullfile(folderPath, xmlFiles(num_xml_file).name);

try
    xmlContent = xmlread(xmlFilePath);
    xmlData = xml2struct(xmlContent);
    
    disp(['File read: ', xmlFiles(num_xml_file).name]);
catch ME
    disp(['Error reading the file: ', xmlFiles(num_xml_file).name]);
    disp(ME.message);
end
