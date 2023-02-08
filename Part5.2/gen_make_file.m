
function gen_make_file(include_path, source_folder, modelName, blockName, codeGenTarget, exeFlag)
	
	
	%Đọc các tham số từ mô hình (modelName) và chuyển đổi các đường dẫn (include_path, source_folder, và csPath) 
	%từ dấu chấm phẩy "" thành dấu gạch chéo "/". Nó cũng xác định xem công cụ xây dựng (buildTool) 
	%đang sử dụng là "GHS Compiler" hay không (isGHS).*/

    
	
    vlabPath = get_param(modelName, 'VlabPath');
    %ghsPath = get_param(modelName, 'GHSPath'); % Remove this comment when support GHS compiler
    ghsPath   = ''; % Remove this line when support GHS compiler
    ostmClock = get_param(modelName, 'OSTMPCLK');
    devSeries = get_param(modelName, 'DeviceSeries');
    csPath    = get_param(modelName, 'CSPath');
    buildTool = get_param(modelName, 'BuildTool');
    
    isGHS = strcmp(buildTool, 'GHS Compiler');
    
    include_path  = strrep(include_path,'\','/');
    source_folder = strrep(source_folder,'\','/');
    csPath        = strrep(csPath,'\','/');
    
% ---------------------GIẢI THÍCH---------------------------
%   vlabPath = get_param(modelName, 'VlabPath');    	Đọc giá trị của tham số VlabPath trong mô hình modelName.
%   ghsPath = get_param(modelName, 'GHSPath');      	Đọc giá trị của tham số GHSPath trong mô hình modelName.
%   
%	ostmClock = get_param(modelName, 'OSTMPCLK'); 		Đọc giá trị của tham số OSTMPCLK trong mô hình modelName.
%   devSeries = get_param(modelName, 'DeviceSeries'); 	Đọc giá trị của tham số DeviceSeries trong mô hình modelName.
%   csPath = get_param(modelName, 'CSPath'); 			Đọc giá trị của tham số CSPath trong mô hình modelName.
%   buildTool = get_param(modelName, 'BuildTool'); 		Đọc giá trị của tham số BuildTool trong mô hình modelName.
%   
%	isGHS = strcmp(buildTool, 'GHS Compiler'); 		    So sánh giá trị của tham số buildTool với chuỗi 'GHS Compiler'. Nếu giá trị trùng nhau, giá trị của isGHS sẽ là 1, 
%                                                       nếu không trùng nhau, giá trị của isGHS sẽ là 0.
%
%   include_path  = strrep(include_path,'\','/');       Sử dụng hàm strrep để thay thế ký tự '\' trong chuỗi include_path thành '/'.
%   source_folder = strrep(source_folder,'\','/');      Sử dụng hàm strrep để thay thế ký tự '\' trong chuỗi source_folder thành '/'.
%   csPath        = strrep(csPath,'\','/');             Sử dụng hàm strrep để thay thế ký tự '\' trong chuỗi csPath thành '/'.




%	----------------------------------------------------------------------------------------------------------------------
%	---------------------------------------------------------------------------------------------------------------------
%	Đoạn code này trong Matlab sử dụng hàm find_system để tìm kiếm các đối tượng có chế độ MaskType trong model hoặc subsystem cho trước (codeGenTarget).
%   Hàm find_system sẽ trả về danh sách các đối tượng tìm được với từng MaskType tùy chọn.
%
%   Ví dụ:
%   Biến ADCList sẽ chứa danh sách các đối tượng có MaskType là "ADCH".
%   Biến PortInList sẽ chứa danh sách các đối tượng có MaskType là "Port_In".
%   ...

    ADCList     = find_system(codeGenTarget, 'MaskType', 'ADCH');
    PortInList  = find_system(codeGenTarget, 'MaskType', 'Port_In');
    PortOutList = find_system(codeGenTarget, 'MaskType', 'Port_Out');
    CANOutList  = find_system(codeGenTarget, 'MaskType', 'CAN_Transmission');
    CANInList   = find_system(codeGenTarget, 'MaskType', 'CAN_Reception');
    RLIN3nSendList    = find_system(codeGenTarget, 'MaskType', 'RLIN3n_send');
    RLIN3nReceiveList = find_system(codeGenTarget, 'MaskType', 'RLIN3n_receive');
    
%--------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------
 


%   Đoạn code này là một đoạn Matlab code, chứa các hàm tìm kiếm, so sánh và lấy thông tin từ một hệ thống đã được xác định trước.

%   TAUDList = find_system(codeGenTarget, 'MaskType', 'TAUD');: Hàm find_system sẽ tìm kiếm các thành phần có loại mặt nạ là 'TAUD' trong hệ thống xác định bởi biến codeGenTarget. Kết quả được lưu trữ trong biến TAUDList.
%   taudChannel = 0;: Khởi tạo giá trị cho biến taudChannel là 0.
%   if ~isempty(TAUDList): Nếu mảng TAUDList không trống (tìm thấy các thành phần có loại mặt nạ là 'TAUD'), thì sẽ tiến hành các hành động bên trong if.
%   taudMode = get_param(TAUDList, 'mode');: Lấy giá trị của thuộc tính 'mode' từ các thành phần trong mảng TAUDList bằng hàm get_param.
%   if strcmp(taudMode, "Triangle PWM Output"): So sánh giá trị của biến taudMode với chuỗi 'Triangle PWM Output' bằng hàm strcmp. Nếu giá trị bằng, thì sẽ thực hiện hành động bên trong if.
%   taudChannel = get_taud_channel([pwd '\SC_project\src\smc_gen\Config_TAUD01\Config_TAUD01.c']);: Lấy giá trị từ hàm get_taud_channel với đường dẫn đến tệp 'Config_TAUD01

    
	TAUDList = find_system(codeGenTarget, 'MaskType', 'TAUD');
    taudChannel = 0;
    if ~isempty(TAUDList) % isempty: Xác định xem mảng có trống không (1 Trống, 0 Không trống)
    taudMode = get_param(TAUDList, 'mode');		
        if strcmp(taudMode, "Triangle PWM Output") %So sánh chuỗi 
            taudChannel = get_taud_channel([pwd '\SC_project\src\smc_gen\Config_TAUD01\Config_TAUD01.c']);
        else
            taudChannel = get_taud_channel([pwd '\SC_project\src\smc_gen\Config_TAUD0\Config_TAUD0.c']);
        end
    else 
    end
	
	
%--------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------
%   Đoạn code trên dùng để xác định thư mục chứa các tập tin chung tùy thuộc vào dòng thiết bị (device series) đang sử dụng. Nếu biến devSeries bằng RH850/F1KM-S1,
%   biến commonFileFolder sẽ được gán bằng 'Common_files_F1KM_S1'. Nếu biến devSeries bằng RH850/F1KM-S4, biến commonFileFolder sẽ được gán bằng 'Common_files_F1KM_S4'.
%   Trong trường hợp khác, biến commonFileFolder sẽ trống.
	
    %if isGHS
    %    buildTool = 'GHS';
    %else
    %    buildTool = 'Renesas';
    %end
	
	
    buildTool = 'Renesas';
    
    if strcmp(devSeries, 'RH850/F1KM-S1')		
        commonFileFolder = 'Common_files_F1KM_S1';
    elseif strcmp(devSeries, 'RH850/F1KM-S4')
        commonFileFolder = 'Common_files_F1KM_S4';			
    % elseif strcmp(devSeries, 'RH850/E2M')
    %   commonFileFolder = 'Common_files_E2M';
    % elseif strcmp(devSeries, 'RH850/U2A')
    %   commonFileFolder = 'Common_files_U2A';
    else
    end
    
    renesasCommonFile = [include_path '/' buildTool '/' commonFileFolder]; % Lấy địa chỉ File
    
    MatlabFile = [matlabroot '/simulink/include/solver_zc.h'];
    SrcFile = [renesasCommonFile '/include/solver_zc.h'];
    if ~exist(SrcFile, 'file')                                     %Kiểm tra sự tồn tại của biến, tập lệnh, hàm, thư mục hoặc lớp
        copyfile(MatlabFile,fileparts(SrcFile));
    end
    
    if strcmp(devSeries, 'RH850/F1KM-S4') && exeFlag == 1
        % Modify content of r_cg_intvector.c files
        modify_sc_source(source_folder, codeGenTarget);
    end
	
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 03
    %% ID: ET_VPF_V1.00.00_CD_Req_03_005
    %% Reference: {ET_VPF_V1.00.00_UD_Req_03_001, ET_VPF_V1.00.00_UD_Req_03_002, ET_VPF_V1.00.00_UD_Req_03_004, ET_VPF_V1.00.00_UD_Req_03_006, ET_VPF_V1.00.00_UD_Req_03_007}
    if exeFlag == 2
        % Generate peripheral_config.c
        gen_peripheral_config(source_folder, devSeries, codeGenTarget, taudChannel);
        
        % Generate iodefine.h
        if strcmp(devSeries, 'RH850/F1KM-S1')
            cmd = [csPath '/Utilities/IOHeaderGenerator/df2iodef.exe -df=' csPath '/Device/RH850/Devicefile/DR7F701685.DVF -o=' source_folder '/iodefine.h -def=off -f'];
        elseif strcmp(devSeries, 'RH850/F1KM-S4')
            cmd = [csPath '/Utilities/IOHeaderGenerator/df2iodef.exe -df=' csPath '/Device/RH850/Devicefile/DR7F701650.DVF -o=' source_folder '/iodefine.h -def=off -f'];
        else
        end
        system(cmd);
    end
	
	
	
	
	
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 03 - End    
    % Generate the template make file
    %if isGHS
    %    srcFolder = [include_path '/GHS/make/template'];
    %else
    %    srcFolder = [include_path '/Renesas/make/template'];
    %end
    srcFolder = [include_path '/Renesas/make/template'];
    dstFolder = [include_path '/make/template'];
    if ~exist([include_path '/make'], 'dir')
        mkdir([include_path '/make']);
    end
    copyfile(srcFolder, dstFolder);
    
	
	
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 02
    %% ID: ET_VPF_V1.00.00_CD_Req_02_020
    %% Reference: {ET_VPF_V1.00.00_UD_Req_02_001, ET_VPF_V1.00.00_UD_Req_02_002, ET_VPF_V1.00.00_UD_Req_02_003, ET_VPF_V1.00.00_UD_Req_02_004, ET_VPF_V1.00.00_UD_Req_02_005, ET_VPF_V1.00.00_UD_Req_02_006, ET_VPF_V1.00.00_UD_Req_02_007, ET_VPF_V1.00.00_UD_Req_02_008, ET_VPF_V1.00.00_UD_Req_02_009} 
    
    CANReplayList =  find_system(modelName, 'MaskType', 'CAN Replay');
    for i = 1 : numel(CANReplayList)
        currentBlock = CANReplayList{i};
        fileName = get_param(currentBlock, 'FullPathFileName');
        filePath = which(fileName);
        
        srcFolder = filePath;
        dstFolder = [source_folder '/' fileName];
        copyfile(srcFolder, dstFolder);
    end
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 02 - End
    
    %% GEN MAKEFILE FOR BUILDING C CODE
    generate_main_make_file(include_path, source_folder);
    
    %%%%%% Copy wrapper file to source folder
    if ~isempty(ADCList)
        adcWrapper = which('get_ADC_data_wrapper.c');
        copyfile (adcWrapper, [source_folder '/get_ADC_data_wrapper.c']);
    end
    
    if ~isempty(PortInList)
        getPortWrapper = which ('get_Port_Data_wrapper.c');
        copyfile (getPortWrapper, [source_folder '/get_Port_Data_wrapper.c']);
    end
    
    if ~isempty(PortOutList)
        setPortWrapper = which ('set_Port_Data_wrapper.c');
        copyfile (setPortWrapper, [source_folder '/set_Port_Data_wrapper.c']);
    end
    
    if ~isempty(CANOutList)
        fileName = which ('CAN_Transmission_wrapper.c');
        copyfile (fileName, [source_folder '/CAN_Transmission_wrapper.c']);
    end
    
    if ~isempty(CANInList)
        fileName = which ('CAN_Reception_wrapper.c');
        copyfile (fileName, [source_folder '/CAN_Reception_wrapper.c']);
    end
    
    if ~isempty(CANInList)
        src = [renesasCommonFile '/src/tx_trigger.py'];
        copyfile (src, [source_folder '/tx_trigger.py']);
    end
    
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 04
    %% ID: ET_VPF_V1.00.00_CD_Req_04_004
    %% Reference: {ET_VPF_V1.00.00_UD_Req_04_001, ET_VPF_V1.00.00_UD_Req_04_002, ET_VPF_V1.00.00_UD_Req_04_004, ET_VPF_V1.00.00_UD_Req_04_008}
    if ~isempty(RLIN3nSendList)
        UARTSendWrapper = which ('UART_Send_wrapper.c');
        copyfile (UARTSendWrapper, [source_folder '/UART_Send_wrapper.c']);
    end
    
    if ~isempty(RLIN3nReceiveList)
        UARTReceiveWrapper = which ('UART_Receive_wrapper.c');
        copyfile (UARTReceiveWrapper, [source_folder '/UART_Receive_wrapper.c']);
    end
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 04 - End   

    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 03
    %% ID: ET_VPF_V1.00.00_CD_Req_03_006
    %% Reference: {ET_VPF_V1.00.00_UD_Req_03_001, ET_VPF_V1.00.00_UD_Req_03_002, ET_VPF_V1.00.00_UD_Req_03_004, ET_VPF_V1.00.00_UD_Req_03_006, ET_VPF_V1.00.00_UD_Req_03_003} 
    if ~isempty(TAUDList)
        TAUDwrapper = which ('get_TAUD_Data_wrapper.c');
        copyfile (TAUDwrapper, [source_folder '/get_TAUD_Data_wrapper.c']);
    end
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 03 - End 

    %% GEN MAKEFILE
    disp('### Generating configuration file');
    
    Gen_config_file(include_path, source_folder, csPath, ghsPath, isGHS, devSeries, renesasCommonFile);
    disp('### Done');
    
    % GEN etvpf_main.c
    gen_etvpf_main(source_folder, blockName, devSeries, codeGenTarget);
    
    % GEN MAKEFILE CONFIG
    disp('### Generating application make file');
    Gen_application_makefile(include_path, source_folder);
    disp('### Done');
    
    % GENERATE PYTHON FILES
    %%%%%%%%%%%%%%%%%%%%%% 1 %%%%%%%%%%%%%%%%%%%%%%%%%%
    matlab_dir = matlabroot;
    disp('### Generating vlab execution file');
    
    % Get the main generated c file that contain the step function.
    text = fileread([source_folder '/modelsources.txt']);
    fileList = strsplit(text, '\n');
    mainFile = fileList{1};
    mainFile = strtrim(mainFile);
    mainFilePath = [source_folder '/' mainFile];
  
    [functionLabelList, stepFuncLabel] = get_function_label_list(mainFilePath);

    gen_Testbench_ETVPF(matlab_dir, source_folder, modelName, functionLabelList, stepFuncLabel, codeGenTarget,taudChannel);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%% 2 %%%%%%%%%%%%%%%%%%%%%%%%%%
    % -----------------------------------
    global ETVPF_SAMPLING_TIME
    
    fixedStepVal = get_param(modelName, 'FixedStep');
    if ischar(fixedStepVal)
        fixedStepVal = evalin('base',[fixedStepVal ';']);
        fixedStepVal = num2str(fixedStepVal);
    end
    ETVPF_SAMPLING_TIME = fixedStepVal;
    quantum = str2num(fixedStepVal)*1000;
    
    Gen_python_sim(source_folder, modelName, codeGenTarget);
    
    pclk = ostmClock;
    gen_ostm_define(source_folder, quantum, pclk);
    
    % Generate renesas linker file
    if ~isGHS
        generate_Renesas_linker_file(csPath, source_folder, isGHS, devSeries, renesasCommonFile);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    VREF = 3.3;
    Gen_Stim_Driver(source_folder,VREF);
    
    gen_global_database(source_folder, codeGenTarget);
    disp('### Done');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % close the converted model before converting
    convertedModel = [modelName '_etvpf'];
    if bdIsLoaded(convertedModel)
        close_system(convertedModel, 0);
    end
    
    %copy model file to generated folder
    src = [source_folder '/../' modelName '.slx'];
    dst = [source_folder '/' modelName '_etvpf.slx'];
    copyfile (src, dst);
    
    % Gen the simlib
    open_system(new_system('simlib'));
    load_system('simulink');
    sfunction = find_system('simulink', 'blocktype', 'M-S-Function');
    add_block(sfunction{1}, 'simlib/VLAB Bridge');
    set_param('simlib/VLAB Bridge', 'FunctionName', 'com_vlab');
    currentDir = pwd;
    cd(source_folder);
    codeGenAfter = strrep(codeGenTarget, modelName, [modelName '_etvpf']);
    convert_etvpf_model(codeGenAfter)
    cd(currentDir);
    %% END GENERATING FILES.
end

function generate_main_make_file(include_path, source_folder)
    disp('### Generating makefile');
    fid = fopen([include_path '/Makefile'],'w');
    fprintf(fid,'FOLDER = %s\n',source_folder);
    fprintf(fid,'%s\n','INPUT_SAMPLE_FILE="./$(TEST_FILE).c"');
    fprintf(fid,'%s\n','LOG_PATH = $(FOLDER)/log');
    fprintf(fid,'%s\n','.PHONY: clean run_sample_python run_sample_matlab');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','BUILD_LOG = Build.log');
    fprintf(fid,'%s\n','PYTHON_TEST_RESULT_LOG = TestResult_Python.log');
    fprintf(fid,'%s\n','PYTHON_TEST_RESULT_LOG = TestResult_Python.log');
    fprintf(fid,'%s\n','TARGET_OBJ = target.out');
    fprintf(fid,'%s\n','TEST_FAILED = "TEST_FAILED"');
    fprintf(fid,'%s\n','MAKE = /usr/bin/make');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','# Cleaning targets');
    fprintf(fid,'%s\n','clean:');
    fprintf(fid,'%s\n','	@echo "*********************************************************************"');
    fprintf(fid,'%s\n','	@rm -fv $(FOLDER)/target.*');
    fprintf(fid,'%s\n','	@rm -fv $(FOLDER)/.ErrorFlag1');
    fprintf(fid,'%s\n','	@rm -fv $(FOLDER)/.ErrorFlag2');
    fprintf(fid,'%s\n','	@rm -fv $(FOLDER)/*.{o,dbo,ao,mak,log}');
    fprintf(fid,'%s\n','	@rm -fv $(FOLDER)/log/*.{log,LOG}');
    fprintf(fid,'%s\n','	@rm -rfv Report_*.{xls,csv} $(DEBUGGING)');
    fprintf(fid,'%s\n','	@mkdir -p $(LOG_PATH)');
    fprintf(fid,'%s\n','	@echo "### Clean was executed ###"');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','# Build and run cosimulation');
    fprintf(fid,'%s\n','run_python: $(FOLDER)/$(TARGET_OBJ)');
    fprintf(fid,'%s\n','	@echo "*********************************************************************"');
    fprintf(fid,'%s\n','	@echo "Running co-simulation ..."');
    fprintf(fid,'	@cd $(FOLDER)\n');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','$(FOLDER)/$(TARGET_OBJ):');
    fprintf(fid,'%s\n','	@echo "*********************************************************************"');
    fprintf(fid,'%s\n','	@cd $(FOLDER)/ && [ -e .ErrorFlag1 ] || ( $(MAKE) -f Makefile $(TARGET_OBJ) SAMPLE_FILE=$(INPUT_SAMPLE_FILE) || touch .ErrorFlag2 ) |& tee log/$(BUILD_LOG)');
    fprintf(fid,'%s\n','	@[ -e $(FOLDER)/.ErrorFlag1 ] || \');
    fprintf(fid,'%s\n','	echo -n "Exit status of Target Build: " | tee -a $(FOLDER)/log/$(BUILD_LOG);');
    fprintf(fid,'%s\n','	@[ -e $(FOLDER)/.ErrorFlag1 ] || \');
    fprintf(fid,'%s\n','	if [ -e $(FOLDER)/.ErrorFlag2 ]; then echo "FALSE"; \');
    fprintf(fid,'%s\n','	  else echo "TRUE"; fi | tee -a $(FOLDER)/log/$(BUILD_LOG)');
    fprintf(fid,'%s','');	
    fclose(fid);
    disp('### Done');
end
function gen_ostm_define(source_folder, quantum, pclk)
    fid = fopen([source_folder '/OSTM_define.h'], 'w');
    fprintf(fid,'#define SAMPLING_TIME_MS        %d\n',quantum);
    fprintf(fid,'#define PCLK                    %d\n', pclk);
    fclose (fid);
end

function Gen_config_file(include_path, source_folder, csPath, ghsPath, isGHS, devSeries, renesasCommonFile)
    % List dependence c files
    fileList = dir([source_folder '\*.c']);
    
    [listSize, ~] = size(fileList);
    
    includeCFilesStr = '';
    for i = 1 : listSize
        if ~strcmp(fileList(i).name, 'etvpf_main.c')
            includeCFilesStr = [includeCFilesStr source_folder '/' fileList(i).name ' '];
        end
    end
    
    % List dependence asm files
    %if isGHS
    %    suffix = '850';
    %else
    %    suffix = 'asm';
    %end
    suffix = 'asm';
    asmPath = [renesasCommonFile '/startup'];
    fileList = dir([asmPath '/*.' suffix]);
    
    [listSize, ~] = size(fileList);
    
    includeAsmFilesStr = '';
    for i = 1 : listSize
        includeAsmFilesStr = [includeAsmFilesStr asmPath '/' fileList(i).name ' '];
    end
    
    % Determine build tool and linker tool.
    %if isGHS
    %    build_tool_path = [ghsPath '/ccrh850.exe'];
    %    linker_tool_path = [ghsPath '/ccrh850.exe'];
    %else
    %    % The Renesas Compiler version is changed every CS+ version.
    %    % Also have more version in the CC-RH folder.
    %    % Need to discuss with REL.
    %    % Below is the lastest version in CS+ E8.04.00
    %    
    buildToolPath = [csPath '/CC-RH/'];
    latestVersion = get_target_build_tool(buildToolPath);
    
    ccrhPath = [csPath '/CC-RH/' latestVersion '/bin'];
    build_tool_path = [ccrhPath '/ccrh.exe'];
    linker_tool_path = [ccrhPath '/rlink.exe'];
    %end
    build_tool_path = strrep(build_tool_path, ' ', '\ ');
    linker_tool_path = strrep(linker_tool_path, ' ', '\ ');
    build_tool_path = strrep(build_tool_path, '(', '\(');
    linker_tool_path = strrep(linker_tool_path, '(', '\(');
    
    build_tool_path = strrep(build_tool_path, ')', '\)');
    linker_tool_path = strrep(linker_tool_path, ')', '\)');
    
    % Gen config file
    fid = fopen([include_path '/Config.mak'],'w');
    fprintf(fid,'CCN=%s\n',build_tool_path);
    fprintf(fid,'ASMN=%s\n',build_tool_path);
    fprintf(fid,'LINKERN=%s\n',linker_tool_path);
    fprintf(fid,'GHS_COMPILER_OPTION_FILE=%s/compiler/rh850_r4_2_2_defs.mak\n', renesasCommonFile);
    scGenPath = [source_folder '\..\SC_project\src\smc_gen'];
    scGenFolderList = dir (scGenPath);
    [listSize, ~] = size(scGenFolderList);
    
    includeSCpath = '';
    includeSCCFilesStr = '';
    
    for i = 3 : listSize
        targetFolder = [scGenFolderList(i).folder '\' scGenFolderList(i).name];
        includeSCpath = [includeSCpath targetFolder ' '];
        % find the C file in each folder.
        
        % List dependence c files
        [~, folderName] = fileparts(targetFolder);
        if strcmp(folderName, 'general')
            %include specific file
            if strcmp(devSeries, 'RH850/F1KM-S1') || strcmp(devSeries, 'RH850/F1KM-S4')
                includeFiles = sprintf('%s/r_cg_intvector.c %s/r_cg_cgc.c %s/r_cg_cgc_user.c ', targetFolder, targetFolder, targetFolder);
            % elseif strcmp(devSeries, 'RH850/U2A')
            %     includeFiles = sprintf('%s/r_cg_intc_PE0.c %s/r_cg_intvector_PE0.c %s/r_cg_cgc.c %s/r_cg_cgc_user.c ', targetFolder, targetFolder, targetFolder, targetFolder);
            else
                
            end
            includeSCCFilesStr = [includeSCCFilesStr includeFiles];
        else
            fileList = dir([targetFolder '\*.c']);
            
            [listSize, ~] = size(fileList);
            
            for j = 1 : listSize
               includeSCCFilesStr = [includeSCCFilesStr targetFolder '/' fileList(j).name ' '];
            end
        end
    end
    
    % change \ to / in the file path
    includeSCCFilesStr = strrep(includeSCCFilesStr, '\', '/');
    includeSCpath = strrep (includeSCpath, '\', '/');
    fprintf(fid,'CC_INCLUDE_PATH+=%s/include %s %s\n', renesasCommonFile, source_folder, includeSCpath);
    fprintf(fid,'ASM_INCLUDE_PATH+=%s/startup\n', renesasCommonFile);
    %if isGHS
    %    if strcmp(devSeries, 'RH850/F1KM-S1')
    %        fprintf(fid,'LNKFILE+=%s/Linker/link_directive_F1KM_S1.ld\n', renesasCommonFile);
    %    elseif strcmp(devSeries, 'RH850/F1KM-S4')
    %        fprintf(fid,'LNKFILE+=%s/Linker/link_directive_F1KM_S4.ld\n', renesasCommonFile);
    %    % elseif strcmp(devSeries, 'RH850/U2A')
    %    %   fprintf(fid,'LNKFILE+=%s/Linker/App_E2X_Sample.ld %s/Linker/App_Common_Sample.ld\n', renesasCommonFile, renesasCommonFile);
    %    else
    %        
    %    end
    %end
    fprintf(fid,'ASM_FILES_TO_BUILD+=%s\n',includeAsmFilesStr);

    CANFileList = sprintf('%s/src/Config_CAN_Reception.c %s/src/Config_CAN_Reception_user.c %s/src/Config_CAN_Transmission.c %s/src/Config_CAN_Transmission_user.c %s/src/Config_CAN_Common.c', renesasCommonFile, renesasCommonFile, renesasCommonFile, renesasCommonFile, renesasCommonFile);
    fprintf(fid,'CC_FILES_TO_BUILD+= %s/src/define_interrupt.c %s/src/Test_Environment.c %s %s %s\n', renesasCommonFile, renesasCommonFile, includeCFilesStr, includeSCCFilesStr, CANFileList);

    fclose(fid);
end


function Gen_application_makefile(include_path, source_folder)
    % Generate application makefile
    contents = {};
    fid = fopen([include_path '/make/template'],'r');
    while ~feof(fid)
        line = fgetl(fid);
        if(strcmp(line, 'CONFIG_MAKE = configFile'))
            contents{end+1} = strrep(line,'configFile',[include_path '/Config.mak']); 
        elseif(strcmp(line,'MAKE_DEPEND = MakeDepend.mak'))
            contents{end+1} = strrep(line,'MAKE_DEPEND = MakeDepend.mak',sprintf('MAKE_DEPEND = %s/MakeDepend.mak',source_folder)); 
        else
            contents{end+1} = line;
        end
        
    end    
    fclose(fid);
    
    fid = fopen([source_folder '/Makefile'],'w');
    for i = 1:length(contents)
        fprintf(fid,'%s\n',contents{i});
    end
        
    fclose(fid);
end

function Gen_python_sim(source_folder, modelName, codeGenTarget)
    devSeries = get_param(modelName, 'DeviceSeries');
    
    fid = fopen([source_folder '/sim.py'],'w');
    fprintf(fid,'import vlab\n');
    fprintf(fid,'\n');
    fprintf(fid,'vlab.instantiate(component=''SARADStimulusDriver'',name=''StimDriver0'')\n');
    fprintf(fid,'\n');
    if strcmp(devSeries, 'RH850/F1KM-S1')
        fprintf(fid,'vlab.connect(("RH850","ADCA0VREFH"),("StimDriver0","ADCH0VREFH"))\n');
    elseif  strcmp(devSeries, 'RH850/F1KM-S4')
        fprintf(fid,'vlab.connect(("RH850","ADCA0VREFH"),("StimDriver0","ADCH0VREFH"))\n');
        fprintf(fid,'vlab.connect(("RH850","ADCA1VREFH"),("StimDriver0","ADCH1VREFH"))\n');
    % elseif strcmp(devSeries, 'RH850/E2M')
    %   fprintf(fid,'vlab.connect(("RH850","AVREFH0"),("StimDriver0","ADCH0VREFH"))\n');
    %   fprintf(fid,'vlab.connect(("RH850","AVREFH1"),("StimDriver0","ADCH1VREFH"))\n');
    %   fprintf(fid,'vlab.connect(("RH850","AVREFH2"),("StimDriver0","ADCH2VREFH"))\n');
    %   fprintf(fid,'vlab.connect(("RH850","AVREFH3"),("StimDriver0","ADCH3VREFH"))\n');
    % elseif strcmp(devSeries, 'RH850/U2A')
    %   fprintf(fid,'vlab.connect(("RH850","A0VREFH"),("StimDriver0","ADCH0VREFH"))\n');
    %   fprintf(fid,'vlab.connect(("RH850","A1VREFH"),("StimDriver0","ADCH1VREFH"))\n');
    %   fprintf(fid,'vlab.connect(("RH850","A2VREFH"),("StimDriver0","ADCH2VREFH"))\n');
    else
        
    end
    
    fprintf(fid,'vlab.stub(''StimDriver0'')\n');
    CANOutList = find_system(codeGenTarget, 'MaskType', 'CAN_Transmission');
    CANInList = find_system(codeGenTarget, 'MaskType', 'CAN_Reception');
    
    nubmerOfCAN = numel(CANInList) + numel(CANOutList);
    if nubmerOfCAN > 0
        fprintf(fid,'# ENGINE = token\n');
        fprintf(fid,'RSCAN_NUM_CHANNELS = %d\n', nubmerOfCAN);
        fprintf(fid,'vlab.write_attribute(''RH850.PFRH850.RSCAN0.ENGINE'', ''token'')\n');
        fprintf(fid,'\n');
        fprintf(fid,'# Instantiate the CAN token bus router\n');
        if ~isempty(CANOutList) && isempty(CANInList)
            fprintf(fid,'CAN_BUS = vlab.instantiate(vlab.component(name=''CANTokenBusRouter'', module=''rh850.CANTokenBusRouter''), ''CAN_BUS'', args=[vlab.NAME, RSCAN_NUM_CHANNELS])\n');
            fprintf(fid,'vlab.connect(vlab.STUB, ("CAN_BUS", "RESETN"), default=True)\n');
            fprintf(fid,'vlab.connect(vlab.STUB, ("CAN_BUS", "RESET"), default=False)\n');
            fprintf(fid,'\n');
        else
            fprintf(fid,'CAN_BUS = vlab.instantiate(vlab.component(name=''CANTokenBusRouter'', module=''rh850.CANTokenBusRouter''), ''CAN_BUS'', args=[vlab.NAME, RSCAN_NUM_CHANNELS+1])\n');
            fprintf(fid,'vlab.connect(vlab.STUB, ("CAN_BUS", "RESETN"), default=True)\n');
            fprintf(fid,'vlab.connect(vlab.STUB, ("CAN_BUS", "RESET"), default=False)\n');
            fprintf(fid,'\n');
            fprintf(fid,'vlab.instantiate("tx_trigger","CANTxTrigger0")\n');
            fprintf(fid,'vlab.connect(vlab.STUB, ("CANTxTrigger0","TRIGGER"))\n');

            fprintf(fid,'vlab.connect(("CANTxTrigger0","TOKEN_TX_CTRL"), ("CAN_BUS","IN_TX_CTRL",0))\n');
            fprintf(fid,'vlab.connect(("CANTxTrigger0","TOKEN_TX_DATA"), ("CAN_BUS","IN_TX_DATA",0))\n');
        end      
        % Generate RX
        if ~isempty(CANOutList) && isempty(CANInList)
            connectCTRLStr = '';
            connectDATAStr = '';
        else
            connectCTRLStr = '("CANTxTrigger0","TOKEN_RX_CTRL")';
            connectDATAStr = '("CANTxTrigger0","TOKEN_RX_DATA")';
        end
        countPort = 1;
        countPort_TX_only = 0;
        if ~isempty(CANOutList)
            for i = 1 : numel (CANOutList)
                channelNo = get_param(CANOutList{i}, 'can_channel');
                
                if isempty(CANInList)
                    fprintf(fid,'vlab.connect((''RH850'',''RSCAN0_TOKEN_TX_CTRL%s''), (''CAN_BUS'',''IN_TX_CTRL'', %d))\n', channelNo, countPort_TX_only);
                    fprintf(fid,'vlab.connect((''RH850'',''RSCAN0_TOKEN_TX_DATA%s''), (''CAN_BUS'',''IN_TX_DATA'', %d))\n', channelNo, countPort_TX_only);
                    if isempty(connectCTRLStr) && isempty(connectDATAStr)
                        connectCTRLStr = [connectCTRLStr ' ("RH850","RSCAN0_TOKEN_RX_CTRL' channelNo '")'];
                        connectDATAStr = [connectDATAStr ' ("RH850","RSCAN0_TOKEN_RX_DATA' channelNo '")'];
                    else
                        connectCTRLStr = [connectCTRLStr ', ("RH850","RSCAN0_TOKEN_RX_CTRL' channelNo '")'];
                        connectDATAStr = [connectDATAStr ', ("RH850","RSCAN0_TOKEN_RX_DATA' channelNo '")'];
                    end
                    countPort_TX_only = countPort_TX_only + 1;
                else
                    fprintf(fid,'vlab.connect((''RH850'',''RSCAN0_TOKEN_TX_CTRL%s''), (''CAN_BUS'',''IN_TX_CTRL'', %d))\n', channelNo, countPort);
                    fprintf(fid,'vlab.connect((''RH850'',''RSCAN0_TOKEN_TX_DATA%s''), (''CAN_BUS'',''IN_TX_DATA'', %d))\n', channelNo, countPort);
                    connectCTRLStr = [connectCTRLStr ', ("RH850","RSCAN0_TOKEN_RX_CTRL' channelNo '")'];
                    connectDATAStr = [connectDATAStr ', ("RH850","RSCAN0_TOKEN_RX_DATA' channelNo '")'];
                    countPort = countPort + 1;
                end
            end
        end
        
        if ~isempty(CANInList)
            for i = 1 : numel (CANInList)
                channelNo = get_param(CANInList{i}, 'can_channel');
                fprintf(fid,'vlab.connect((''RH850'',''RSCAN0_TOKEN_TX_CTRL%s''), (''CAN_BUS'',''IN_TX_CTRL'', %d))\n',channelNo, countPort);
                fprintf(fid,'vlab.connect((''RH850'',''RSCAN0_TOKEN_TX_DATA%s''), (''CAN_BUS'',''IN_TX_DATA'', %d))\n', channelNo, countPort);
                connectCTRLStr = [connectCTRLStr ',("RH850","RSCAN0_TOKEN_RX_CTRL' channelNo '")'];
                connectDATAStr = [connectDATAStr ',("RH850","RSCAN0_TOKEN_RX_DATA' channelNo '")'];
                
                countPort = countPort + 1;
            end
        end
        
        fprintf(fid,'vlab.connect(("CAN_BUS","OUT_RX_CTRL"), [%s])\n', connectCTRLStr);
        fprintf(fid,'vlab.connect(("CAN_BUS","OUT_RX_DATA"), [%s])\n', connectDATAStr);
    end
    fclose(fid);
end

function Gen_Stim_Driver(source_folder, VREF)
    fid = fopen([source_folder '/SARADStimulusDriver.py'],'w');
    
    fprintf(fid,'# Copyright (C) Australian Semiconductor Technology Company (ASTC). 2013.\n');
    fprintf(fid,'# All Rights Reserved.\n');
    fprintf(fid,'#\n');
    fprintf(fid,'# This is unpublished proprietary source code of the Australian Semiconductor\n'); 
    fprintf(fid,'# Technology Company (ASTC).  The copyright notice does not evidence any actual\n');
    fprintf(fid,'# or intended publication of such source code.\n');
    fprintf(fid,'\n');
    fprintf(fid,'import sysc\n');
    fprintf(fid,'import vlab\n');
    fprintf(fid,'\n');
    fprintf(fid,'class SARADStimulusDriver(sysc.sc_module):\n');
    fprintf(fid,'\n');
    fprintf(fid,'    def __init__(self, name):\n');
    fprintf(fid,'        sysc.sc_module.__init__(self, name)\n');
    fprintf(fid,'        # Reference voltage\n');
    fprintf(fid,'        self.ADCH0VREFH = sysc.sc_out_double(''ADCH0VREFH'')\n');
    fprintf(fid,'        self.ADCH1VREFH = sysc.sc_out_double(''ADCH1VREFH'')\n');
    fprintf(fid,'        \n');
    fprintf(fid,'    # Simulation callbacks\n');
    fprintf(fid,'    def before_end_of_elaboration(self):\n');
    fprintf(fid,'        # Initialize ports\n');
    fprintf(fid,'        self.ADCH0VREFH.write(%d)\n',VREF);
    fprintf(fid,'        self.ADCH1VREFH.write(%d)\n',VREF);
    fprintf(fid,'        pass\n');
    fprintf(fid,'\n');
    fprintf(fid,'    def end_of_elaboration(self):\n');
    fprintf(fid,'        pass\n');
    fprintf(fid,'\n');
    fprintf(fid,'    def start_of_simulation(self):\n');
    fprintf(fid,'        pass\n');
    fprintf(fid,'\n');
    fprintf(fid,'    def end_of_simulation(self):\n');
    fprintf(fid,'        pass\n');
    fprintf(fid,'\n');
    
    fclose(fid);
end

function gen_etvpf_main(source_folder, blockName, devSeries, codeGenTarget)

    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 04
    %% ID: ET_VPF_V1.00.00_CD_Req_04_005
    %% Reference: {ET_VPF_V1.00.00_UD_Req_04_001, ET_VPF_V1.00.00_UD_Req_04_002, ET_VPF_V1.00.00_UD_Req_04_004, ET_VPF_V1.00.00_UD_Req_04_008}
    % ET-VPF F1KM Product Version - V1.00.00 - Req. Supporting ADC unit 1  for F1KM-S4
    % ID: ET_VPF_V1.00.00_CD_Req_ADCUnit1_003 
    % Reference: {ET_VPF_V1.00.00_UD_Req_ADCUnit1_003, ET_VPF_V1.00.00_UD_Req_ADCUnit1_007} 
    ADCList = find_system(codeGenTarget, 'MaskType', 'ADCH');  
    adcUnitList = get_param(ADCList, 'unit');
    adcUnit0 = [];
    adcUnit1 = [];
    for i = 1:numel(adcUnitList)

        if isequal(cell2mat(adcUnitList(i)),'0')
            adcUnit0 = ADCList(i);        
        end
        if isequal(cell2mat(adcUnitList(i)),'1')
            adcUnit1 = ADCList(i);
        end
    end
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. Supporting ADC unit 1  for F1KM-S4 - End
    PortInList = find_system(codeGenTarget, 'MaskType', 'Port_In');
    PortOutList = find_system(codeGenTarget, 'MaskType', 'Port_Out');
    CANInList = find_system(codeGenTarget, 'MaskType', 'CAN_Reception');
    CANOutList = find_system(codeGenTarget, 'MaskType', 'CAN_Transmission');
    RLIN3nSendList = find_system(codeGenTarget, 'MaskType', 'RLIN3n_send');
    RLIN3nReceiveList = find_system(codeGenTarget, 'MaskType', 'RLIN3n_receive');

    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 03
    %% ID: ET_VPF_V1.00.00_CD_Req_03_007
    %% Reference: {ET_VPF_V1.00.00_UD_Req_03_001, ET_VPF_V1.00.00_UD_Req_03_002, ET_VPF_V1.00.00_UD_Req_03_004, ET_VPF_V1.00.00_UD_Req_03_006} 
    TAUDList = find_system(codeGenTarget, 'MaskType', 'TAUD');
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 03 - End  

    fid = fopen([source_folder '/etvpf_main.c'],'w');
    fprintf(fid,'/*******************************************************************************\n');
    fprintf(fid,'    Demo code for ET-VPF tasks\n');
    fprintf(fid,'*******************************************************************************/\n');
    fprintf(fid,'\n');
    fprintf(fid,'/* Include Section */\n');
    fprintf(fid,'#include "r_cg_macrodriver.h"\n');
    fprintf(fid,'#include "Test_Environment.h"\n');
    if ~isempty(PortInList) || ~isempty(PortOutList)
        fprintf(fid,'#include "Config_PORT.h"\n');
    end

    % ET-VPF F1KM Product Version - V1.00.00 - Req. Supporting ADC unit 1  for F1KM-S4
    % ID: ET_VPF_V1.00.00_CD_Req_ADCUnit1_004 
    % Reference: {ET_VPF_V1.00.00_UD_Req_ADCUnit1_003, ET_VPF_V1.00.00_UD_Req_ADCUnit1_007} 
    if ~isempty(ADCList) % Only add this line if ADC S-Function existed
        if ~isempty(adcUnit0)
            fprintf(fid,'#include "Config_ADCA0.h"\n');
        end
        if ~isempty(adcUnit1)
            fprintf(fid,'#include "Config_ADCA1.h"\n');
        end
    end
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. Supporting ADC unit 1  for F1KM-S4 - End
    
    fprintf(fid,'#include "%s.h"\n', blockName);

    for i = 1 : numel (RLIN3nSendList)
        unitNo = get_param(RLIN3nSendList{i}, 'RLIN3_unit');
        fprintf(fid,'#include "Config_UART%s.h"\n', unitNo);
    end
    
    for i = 1 : numel (RLIN3nReceiveList)
        unitNo = get_param(RLIN3nReceiveList{i}, 'RLIN3_unit');
        fprintf(fid,'#include "Config_UART%s.h"\n', unitNo);
    end
    
    % CAN Reception
    if ~isempty(CANInList)
        fprintf(fid,'#include "Config_CAN_Reception.h"\n');
    end
    
    % CAN Transmission
    if ~isempty(CANOutList)
        fprintf(fid,'#include "Config_CAN_Transmission.h"\n');
    end
    
    if ~isempty(CANInList) || ~isempty(CANOutList)
        fprintf(fid,'#include "r_cg_can.h"\n');
    end
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 03
    %% ID: ET_VPF_V1.00.00_CD_Req_03_008
    %% Reference: {ET_VPF_V1.00.00_UD_Req_03_001, ET_VPF_V1.00.00_UD_Req_03_002, ET_VPF_V1.00.00_UD_Req_03_004, ET_VPF_V1.00.00_UD_Req_03_006} 
    if ~isempty(TAUDList)
        mode = get_param(TAUDList, 'mode');
        if strcmp(mode, "Triangle PWM Output")
            fprintf(fid,'#include "Config_TAUD01.h"\n');
        elseif strcmp(mode, "PWM Output")
            fprintf(fid,'#include "Config_TAUD0.h"\n');
        end    
    end
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 03 - End  
    fprintf(fid,'    \n');
    fprintf(fid,'/* Function Definitions */\n');
    fprintf(fid,'int main(void)\n');
    fprintf(fid,'{  \n');
    fprintf(fid,'   // MCU init\n');
    fprintf(fid,'   Mcu_Init();\n');
    fprintf(fid,'   %s_initialize();\n', blockName);
    
    fprintf(fid,'   \n');
    % Generate Port initialization source code
    if ~isempty(PortInList) || ~isempty(PortOutList)
        fprintf(fid,'   // Init PORT\n');
        fprintf(fid,'   R_Config_PORT_Create();\n');
    end
    fprintf(fid,'   \n');
    % Generate ADC initialization source code
    % ET-VPF F1KM Product Version - V1.00.00 - Req. Supporting ADC unit 1  for F1KM-S4
    % ID: ET_VPF_V1.00.00_CD_Req_ADCUnit1_005 
    % Reference: {ET_VPF_V1.00.00_UD_Req_ADCUnit1_003, ET_VPF_V1.00.00_UD_Req_ADCUnit1_007}     
    if ~isempty(ADCList)
        fprintf(fid,'   // Init ADC\n');
        if ~isempty(adcUnit0)
            fprintf(fid,'R_Config_ADCA0_Create();\n');
        end
        if ~isempty(adcUnit1)
            fprintf(fid,'R_Config_ADCA1_Create();\n');
        end
    end
    fprintf(fid,'\n');
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. Supporting ADC unit 1  for F1KM-S4 - End
    
    % Generate TAUD initialization source code
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 03
    %% ID: ET_VPF_V1.00.00_CD_Req_03_009
    %% Reference: {ET_VPF_V1.00.00_UD_Req_03_001, ET_VPF_V1.00.00_UD_Req_03_002, ET_VPF_V1.00.00_UD_Req_03_004, ET_VPF_V1.00.00_UD_Req_03_006} 
    if ~isempty(TAUDList)
        fprintf(fid,'   // Init TAUD\n');
        if strcmp(devSeries, 'RH850/F1KM-S1') || strcmp(devSeries, 'RH850/F1KM-S4')
            mode = get_param(TAUDList, 'mode');
            if strcmp(mode, "Triangle PWM Output")
                fprintf(fid,'    R_Config_TAUD01_Create();\n');
            elseif strcmp(mode, "PWM Output")
                fprintf(fid,'    R_Config_TAUD0_Create();\n');
            end    
        else
            
        end
    end
    fprintf(fid,'\n');
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 03 - End  
    % Generate RLIN3 initialization source code
    fprintf(fid,'   // Init UART Transmission\n');
    for i = 1 : numel (RLIN3nSendList)
        unitNo = get_param(RLIN3nSendList{i}, 'RLIN3_unit');
        fprintf(fid,'   R_Config_UART%s_Create();\n', unitNo);
        fprintf(fid,'   R_Config_UART%s_Start();\n', unitNo);
    end
    fprintf(fid,'   \n');
    % Generate RLIN3 initialization source code
    fprintf(fid,'   // Init UART Reception\n');
    for i = 1 : numel (RLIN3nReceiveList)
        unitNo = get_param(RLIN3nReceiveList{i}, 'RLIN3_unit');
        fprintf(fid,'   R_Config_UART%s_Create();\n', unitNo);
        fprintf(fid,'   R_Config_UART%s_Start();\n', unitNo);
    end
    %% ET-VPF F1KM Product Version - V1.00.00 - Req. 04 - End
    
    if ~isempty(CANOutList) || ~isempty(CANInList)
        fprintf(fid,'   CAN_Common_Init();\n');
    end
    if ~isempty(CANOutList)
        fprintf(fid,'   // Init CAN Transmission\n');
        
        for i = 1 : numel (CANOutList)
           unitNo = get_param(CANOutList{i}, 'can_channel');
           fprintf(fid,'   R_Config_CAN%s_Transmission_Create();\n', unitNo);

        end
        fprintf(fid,'   \n');
    end
    
    if ~isempty(CANInList)
        fprintf(fid,'   // Init CAN Reception\n');
        for i = 1 : numel (CANInList)
           unitNo = get_param(CANInList{i}, 'can_channel');
           fprintf(fid,'   R_Config_CAN%s_Reception_Create();\n', unitNo);

        end
        fprintf(fid,'   \n');
    end
    
    if ~isempty(CANOutList) || ~isempty(CANInList)
        fprintf(fid,'   CAN_Common_operating_Init();\n');
    end
    if ~isempty(CANOutList)
        fprintf(fid,'   // Init CAN Transmission\n');
        for i = 1 : numel (CANOutList)
           unitNo = get_param(CANOutList{i}, 'can_channel');

           fprintf(fid,'   R_Config_CAN%s_Transmission_Start();\n', unitNo);
        end
        fprintf(fid,'   \n');
    end
    
    if ~isempty(CANInList)
        fprintf(fid,'   // Init CAN Reception\n');
        for i = 1 : numel (CANInList)
           unitNo = get_param(CANInList{i}, 'can_channel');

           fprintf(fid,'   R_Config_CAN%s_Reception_Start();\n', unitNo);
        end
        fprintf(fid,'   \n');
    end
    
    % Start OSTM
    fprintf(fid,'   // Init OSTM\n');
    fprintf(fid,'   R_OSTM0_Create();\n');
    fprintf(fid,'   R_OSTM0_Start();\n');
    fprintf(fid,'   \n');
    
    fprintf(fid,'\n');
    fprintf(fid,'    EI();\n');
    fprintf(fid,'    while(1);\n');
    fprintf(fid,'}\n');
    fprintf(fid,'\n');
    fprintf(fid,'#ifdef __CCRH__\n');
    if strcmp(devSeries, 'RH850/F1KM-S1') || strcmp(devSeries, 'RH850/F1KM-S4')
        fprintf(fid,'#pragma interrupt eiint84\n');
        fprintf(fid,'void eiint84(void)\n');
    % elseif strcmp(devSeries, 'RH850/U2A')
    %     fprintf(fid,'#pragma interrupt eiint199\n');
    %     fprintf(fid,'void eiint199(void)\n');
    else
        
    end
    fprintf(fid,'{\n');
    fprintf(fid,'   %s_step();\n', blockName);
    fprintf(fid,'}\n');
    fprintf(fid,'#endif\n');
    fprintf(fid,'\n');
    % fprintf(fid,'#ifdef __ghs__\n');
    % fprintf(fid,'// OSTM handler\n');
    % if strcmp(devSeries, 'RH850/F1KM-S1') || strcmp(devSeries, 'RH850/F1KM-S4')
    %     fprintf(fid,'__interrupt void eiint84(void)\n');
    % % elseif strcmp(devSeries, 'RH850/U2A')
    % %   fprintf(fid,'__interrupt void eiint199(void)\n');
    % else
    %     
    % end
    % fprintf(fid,'{\n');
    % fprintf(fid,'   %s_step();\n', blockName);
    % fprintf(fid,'}\n');
    % fprintf(fid,'#endif\n');
    fprintf(fid,'/* End of the file */\n');
    fclose(fid);

end

function generate_Renesas_linker_file(csPath, source_folder, isGHS, devSeries, renesasCommonFile)

    fid = fopen([source_folder '/build.clnk'],'w');
    
    currentDir = pwd;
    scGenPath = [currentDir '/SC_project/src/smc_gen'];
    scGenFolderList = dir (scGenPath);
    [listSize, ~] = size(scGenFolderList);
    
    % Generate the list object file
    % List of c files
    for i = 3 : listSize
        targetFolder = [scGenFolderList(i).folder '/' scGenFolderList(i).name];
        [~, folderName] = fileparts(targetFolder);
        if strcmp(folderName, 'general')
            fprintf(fid,'-input=r_cg_cgc.o\n');
            fprintf(fid,'-input=r_cg_cgc_user.o\n');
            fprintf(fid,'-input=r_cg_intvector.o\n');
        else
            fileList = dir([targetFolder '/*.c']);
            [listSize, ~] = size(fileList);
            
            for j = 1 : listSize
                fileName = fileList(j).name;
                objName = strrep(fileName, '.c', '.o');
                fprintf(fid,'-input=%s\n', objName);
            end
        end
    end
    
    fileList = dir([source_folder '/*.c']);
    [listSize, ~] = size(fileList);
    
    for i = 1 : listSize
        fileName = fileList(i).name;
        objName = strrep(fileName, '.c', '.o');
        fprintf(fid,'-input=%s\n', objName);
    end
    
    fileList = dir([renesasCommonFile '/src/*.c']);
    [listSize, ~] = size(fileList);
    
    for i = 1 : listSize
        fileName = fileList(i).name;
        objName = strrep(fileName, '.c', '.o');
        fprintf(fid,'-input=%s\n', objName);
    end
    
    % List dependence asm files
    %if isGHS
    %    suffix = '.850';
    %else
    %    suffix = '.asm';
    %end
    suffix = '.asm';
    asmPath = [renesasCommonFile '/startup'];
    fileList = dir([asmPath '/*' suffix]);
    [listSize, ~] = size(fileList);
    
    for i = 1 : listSize
        fileName = fileList(i).name;
        objName = strrep(fileName, suffix, '.ao');
        fprintf(fid,'-input=%s\n', objName);
    end
    
    buildToolPath = [csPath '/CC-RH/'];
    latestVersion = get_target_build_tool(buildToolPath);
    
    fprintf(fid,'-debug\n');
    fprintf(fid,'-nocompress\n');
    fprintf(fid,'-output=target.out\n');
    fprintf(fid,'-library=%s\\CC-RH\\%s\\lib\\v850e3v5\\rhs8n.lib\n', csPath, latestVersion);
    fprintf(fid,'-library=%s\\CC-RH\\%s\\lib\\v850e3v5\\libmalloc.lib\n', csPath, latestVersion);
    fprintf(fid,'-list=target.map\n');
    if strcmp(devSeries, 'RH850/F1KM-S1')
        fprintf(fid,'-start=RESET/00000000,EIINTTBL.const,.const,.INIT_DSEC.const,.INIT_BSEC.const,.text,.data/00000200,.data.R,.bss,.stack.bss/FEBE0000\n');
    elseif strcmp(devSeries, 'RH850/F1KM-S4')
        fprintf(fid,'-start=RESET/00000000,EIINTTBL.const,.const,.INIT_DSEC.const,.INIT_BSEC.const,.text,.data/00000200,.data.R,.bss,.stack.bss/FEBC0000\n');
    else
        fprintf(fid,'-start=RESET_NORMAL,EIINTTBL_NORMAL,.const.cmn,.const,.INIT_DSEC.const,.INIT_BSEC.const,.text,.data/00000000,RESET,EIINTTBL/08000000,.stack.bss/FDC00000,.data.R,.bss/FE000000\n');
    end
    
    fprintf(fid,'-rom=.data=.data.R\n');
    fprintf(fid,'-memory=high\n');
    fprintf(fid,'-nologo\n');
    fprintf(fid,'-end\n');
    fprintf(fid,'-input=target.out\n');
    fprintf(fid,'-output=target.abs\n');
    fprintf(fid,'-form=stype\n');
    fprintf(fid,'-exit\n');
    fclose(fid);
end



%%--------------------------------------------------------------------------------------------------------------------------------------------
%%--------------------------------------------------------------------------------------------------------------------------------------------
%% ET-VPF F1KM Product Version - V1.00.00 - Req. 02
%% ID: ET_VPF_V1.00.00_CD_Req_02_005
%% Reference: {ET_VPF_V1.00.00_UD_Req_02_001, ET_VPF_V1.00.00_UD_Req_02_002, ET_VPF_V1.00.00_UD_Req_02_003, ET_VPF_V1.00.00_UD_Req_02_004, ET_VPF_V1.00.00_UD_Req_02_005, ET_VPF_V1.00.00_UD_Req_02_006, ET_VPF_V1.00.00_UD_Req_02_007, ET_VPF_V1.00.00_UD_Req_02_008, ET_VPF_V1.00.00_UD_Req_02_009}


% +    Đoạn mã Matlab trên là một hàm có tên "gen_global_database", nó được sử dụng để tạo một tệp python "global_database.py".
%             Trong hàm này, nó mở một tệp mới "global_database.py" để ghi dữ liệu vào.
% +    Tiếp theo, hàm tìm tất cả các thành phần có kiểu "CAN_Transmission" trong "codeGenTarget" và ghi vào tệp "global_database.py" 
%             với dữ liệu là giá trị của kênh CAN.
% +    Cuối cùng, hàm tìm tất cả các thành phần có kiểu "TAUD" trong "codeGenTarget" và ghi vào tệp "global_database.py" 
%             với dữ liệu là giá trị của TAUD.
% +    Sau khi hoàn thành việc ghi dữ liệu, hàm đóng tệp "global_database.py".

function gen_global_database(source_folder, codeGenTarget)
   fid = fopen([source_folder '/global_database.py'], 'w');
   %% ET-VPF F1KM Product Version - V1.00.00 - Req. 04
   %% ID: ET_VPF_V1.00.00_CD_Req_04_006
   %% Reference: {ET_VPF_V1.00.00_UD_Req_04_001, ET_VPF_V1.00.00_UD_Req_04_002, ET_VPF_V1.00.00_UD_Req_04_004, ET_VPF_V1.00.00_UD_Req_04_008}
   % Find all unit of used RLIN3
   RLIN3nSendList = find_system(codeGenTarget, 'MaskType', 'RLIN3n_send');
   for i = 1 : numel (RLIN3nSendList)
       unitNo = get_param(RLIN3nSendList{i}, 'RLIN3_unit');
       fprintf(fid,'val_double_RLIN3%s = 1.00\n', unitNo);
   end
   %% ET-VPF F1KM Product Version - V1.00.00 - Req. 04 - End
   % find all unit of used rlin3
   fprintf(fid,'id = 0\n');
   fprintf(fid,'data = []\n');
   fprintf(fid,'isExt = False\n');
   fprintf(fid,'isRemote = False\n');
   CANOutList = find_system(codeGenTarget, 'MaskType', 'CAN_Transmission');
   for i = 1 : numel (CANOutList)
        canChannel = get_param(CANOutList{i},"can_channel");
        fprintf(fid,'val_double_can%s = 0.0\n', canChannel);
   end
   
   fprintf(fid,'taud_data = []\n');
   TAUDList = find_system(codeGenTarget, 'MaskType', 'TAUD');
   for i = 1 : numel (TAUDList)
        %canChannel = get_param(CANOutList{i},"can_channel");
        fprintf(fid,'val_double_taud = 0.0\n');
   end
   fclose (fid);
end
%% ET-VPF F1KM Product Version - V1.00.00 - Req. 02 - End
%% ET-VPF F1KM Product Version - V1.00.00 - Req. 01 - End