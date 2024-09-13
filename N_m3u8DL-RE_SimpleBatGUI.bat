::�ǵñ���ΪASNI����

@echo off & setlocal enabledelayedexpansion

::��ʼ
Title N_m3u8DL-RE���ص��� by Lenno 2024.8.21

cd /d %~dp0

::****************************************
::Ŀ¼������ǰ������ʹ��ʱ�鿴
::�����������ļ����������л���ͬ�汾��release0.2.0beta��֧��ad-keyword��Ҫʹ��0.2.1beta��action build��
::����betaΪ0.2.1-20240828��������ʹ�ã��������action build��
set REfile=N_m3u8DL-RE
::set REfile= �Լ��޸�Ϊ��ʹ�õ����ļ�����N_m3u8DL-RE��N_m3u8DL-RE_beta��N_m3u8DL-RE_action

::������ʱ�ļ��洢Ŀ¼
set TempDir=D:\Downloads\New\N_m3u8DL_Temp

::�������Ŀ¼
set SaveDir=D:\Downloads\New

::����ffmpeg.exe·�����������������ļ��е�Program Files��3�㡣
set ffmpeg=ffmpeg.exe
::****************************************

::�˵�����
:menu
cls
ECHO.
ECHO  ����ѡ��
echo.                   
ECHO. **********************************************************
echo.
ECHO  1��m3u8��Ƶ��������
echo.
ECHO  2��m3u8��Ƶ��������
echo.
ECHO  3��ֱ��¼��
echo.
ECHO  4��FFMPEGתΪMP4(copy)
echo.
ECHO. **********************************************************
echo.
ECHO  *��ǰ������������:%REfile%
ECHO  *��ǰ�������Ŀ¼:%SaveDir%
ECHO  *��ǰ������ʱĿ¼:%TempDir%
ECHO  *��ǰ����FFMPEG·��:%ffmpeg%
echo.
ECHO. **********************************************************
echo.
set /p a=�����������Ų��س���1��2��3��4����
cls

if %a%==1 goto m3u8_download
if %a%==2 goto m3u8_batch_download
if %a%==3 goto live_record
if %a%==4 goto ff_converter

::---------------���ò���start---------------
:setting_path
::Ŀ¼������ǰ��ȫ��λ�ã�����ʹ��ʱ�鿴
::���������ļ�input.txt�����������������������output.bat
::input.txt��ʽΪ Ҫ������ļ���,m3u8��������
::inputʾ��   ����ע�⣬�ı�������ҪΪANSI�������룡��
::֩����1,http://xx.xx.m3u8
::֩����2,http://xx.xx.m3u8
set input=input.txt
set output=output.bat
goto :eof

:setting_m3u8_params
::���ù��˹��
set AntiADs=--ad-keyword "\d{1,}o\d{3,4}.ts|\/ad\w{0,}\/"
::������˹���Ƭ --ad-keyword "\d{1,}o\d{3,4}.ts|\/ad\w{0,}\/" ����������볢����ո�ѡ��
::��һ���ؼ��� --ad-keyword "o\d{3,4}.ts$|/ads/"

::����m3u8���ز���
set m3u8_params=--download-retry-count:9 --auto-select:true --check-segments-count:false --no-log:true %AntiADs% --append-url-params:true  -mt:true --mp4-real-time-decryption:true --ui-language:zh-CN

goto :eof


:setting_live_record_params
::����ֱ��¼�Ʋ���
set live_record_params=--no-log:true -mt:true --mp4-real-time-decryption:true --ui-language:zh-CN -sv best -sa best --live-pipe-mux:true --live-keep-segments:false --live-fix-vtt-by-audio:true %live_record_limit% -M format=mp4:bin_path="%ffmpeg%"

goto :eof
::---------------���ò���end---------------

::��ʼ����
:m3u8_download
cls
call :common_input
call :setting_path
call :setting_m3u8_params
call :m3u8_download_print
call :m3u8_downloading
call :when_done
goto :eof

:m3u8_batch_download
cls
call :setting_path
call :batch_input
call :setting_m3u8_params
call :batch_excute
call :when_done
goto :eof

:live_record
call :common_input
call :live_record_input
call :setting_path
call :setting_live_record_params
call :live_record_print
call :live_recording
call :when_done
goto :eof

:ff_converter
call :setting_path
call :set_FFinput
call :set_FFoutput
echo ****ת����****
%ffmpeg% -i  "%FFinName%" -c copy "%FFoutName%" -loglevel warning
echo.
echo *****���*****
echo.
pause
::call :when_done 
goto :eof

::---------------���벿��---------------
:common_input
::�������� �� �ļ���
:set_link
set "link="
set /p "link=����������: "
if "!link!"=="" (
    echo �������벻��Ϊ�գ�
    goto set_link
)

:set_filename 
set "filename="
set /p "filename=�����뱣���ļ���: "
if "!filename!"=="" (
    echo �������벻��Ϊ�գ�
    goto set_filename
)

::�ӱ�ǩ�м���goto :eof������˳��ӱ�ǩ��������ִ�����������������
goto :eof

::�������ز���
::��ȡ�ļ����ϳɲ�����д�����ļ���ִ��
:batch_input
::�������ص��������,�粻�趨��Ĭ��Ϊ��ǰĿ¼��input.txt�����output.bat
:set_batchfile_input
set "batchfile_input="
echo.
ECHO   ����ע�⣬txt�ı�������ҪΪANSI�������룡��
ECHO   ���������������ʧ�����ȼ��input.txt�ļ������Ƿ���ȷ���Լ����ɵ�output.bat�Ƿ���������
echo.
set /p "batchfile_input=��������������������ӵ��ļ���������·��(**.txt,����ȷ����Ĭ�����õ�ǰ�ļ��е�input.txt): "
if "!batchfile_input!" neq "" (
    call :set_FForiName "!batchfile_input!"
    if "!FForiName_ext!" neq "" (
        set "input=!batchfile_input!"
    ) else (
        set "input=!batchfile_input!.txt"
    )
) else (
    set "input=input.txt"
)

:set_batchfile_output
set "batchfile_output="
set /p "batchfile_output=�����뽫�����������bat���ļ���(**.bat,�򲻴���׺��.bat�� ����ȷ����Ĭ�����õ�ǰ�ļ��е�output.bat): "
if "!batchfile_output!" neq "" (
    call :set_FForiName "!batchfile_output!"
    if "!FForiName_ext!" neq "" (
        set "output=!batchfile_output!"
    ) else (
        set "output=!batchfile_output!.bat"
    )
) else (
    set "output=output.bat"
)
goto :eof

:batch_excute
::ƴ������
set string2=--tmp-dir "%TempDir%" --save-dir "%SaveDir%" --ffmpeg-binary-path "%ffmpeg%" %m3u8_params%
::Ԥ����������������ļ�
echo off>%output%

::��ȡ������=������������
set /a count=0
for /F "delims=" %%i in (%input%) do (
	set /a count+=1	
)

set /a cur_line=0
for /F "tokens=1-2 delims=," %%a in (%input%) do (
	set /a cur_line+=1
	set filename=%%a
	set link=%%b
	set title=TITLE "!cur_line!/%count% - !filename!"
	set outstring=%REfile% "!link!" --save-name "!filename!" %string2%
	
	echo !title! >> %output%
	echo !outstring! >> %output%
)
::�������ɵ��ļ���������
cls
ECHO  �������ص�����Ϊ��%input%
ECHO  �������ص�ִ��Ϊ��%output%
echo.
ECHO   ����ע�⣬txt�ı�������ҪΪANSI�������룡��
ECHO   ���������������ʧ�����ȼ��input.txt�ļ������Ƿ���ȷ���Լ����ɵ�output.bat�Ƿ���������
echo.
call %output%
goto :eof

:live_record_input
:set_record_limit
set "record_limit="
set /p "record_limit=������¼��ʱ������(��ʽ��HH:mm:ss, ��Ϊ��): "
if "!record_limit!"=="" (
    set live_record_limit=
) else (
    set live_record_limit=--live-record-limit %record_limit%
    )

goto :eof

::---------------����˵��---------------
::--������ο����ߵ���Ŀ https://github.com/nilaoda/N_m3u8DL-RE
::--tmp-dir <tmp-dir>                      ������ʱ�ļ��洢Ŀ¼
::--save-name <save-name>                  ���ñ����ļ���
::--save-dir <save-dir>                    �������Ŀ¼
::--download-retry-count <number>          ÿ����Ƭ�����쳣ʱ�����Դ��� [default: 3]
::--auto-select                            �Զ�ѡ���������͵���ѹ�� [default: False]
::--ad-keyword                             ѡ����˹��URL
::--check-segments-count                   ���ʵ�����صķ�Ƭ������Ԥ�������Ƿ�ƥ�� [default: True]
::--no-log                                 �ر���־�ļ���� [default: False]
::--append-url-params                      ������Url��Params�������Ƭ, ��ĳЩ��վ������ [default: False]
::-mt, --concurrent-download               ����������ѡ�����Ƶ����Ƶ����Ļ [default: False]
::--mp4-real-time-decryption               ʵʱ����MP4��Ƭ [default: False]
::-M, --mux-after-done <OPTIONS>           ���й������ʱ���Ի������������Ƶ
::--custom-range <RANGE>                   �����ز��ַ�Ƭ. ���� "--morehelp custom-range" �Բ鿴��ϸ��Ϣ
::--ffmpeg-binary-path <PATH>              ffmpeg��ִ�г���ȫ·��, ���� C:\Tools\ffmpeg.exe
::--ui-language <en-US|zh-CN|zh-TW>        ����UI����
::--live-keep-segments                     ¼��ֱ��������ʵʱ�ϲ�ʱ��Ȼ������Ƭ [default: True]
::--live-pipe-mux                          ¼��ֱ��������ʵʱ�ϲ�ʱͨ���ܵ�+ffmpegʵʱ������TS�ļ� [default: False]
::--live-fix-vtt-by-audio                  ͨ����ȡ��Ƶ�ļ�����ʼʱ������VTT��Ļ [default: False]
::--live-record-limit <HH:mm:ss>           ¼��ֱ��ʱ��¼��ʱ������
::-sv, --select-video <OPTIONS>            ͨ��������ʽѡ�����Ҫ�����Ƶ��. ���� "--morehelp select-video" �Բ鿴��ϸ��Ϣ
::-sa, --select-audio <OPTIONS>            ͨ��������ʽѡ�����Ҫ�����Ƶ��. ���� "--morehelp select-audio" �Բ鿴��ϸ��Ϣ
::-ss, --select-subtitle <OPTIONS>         ͨ��������ʽѡ�����Ҫ�����Ļ��. ���� "--morehelp select-subtitle" �Բ鿴��ϸ��Ϣ
::-dv, --drop-video <OPTIONS>              ͨ��������ʽȥ������Ҫ�����Ƶ��.
::-da, --drop-audio <OPTIONS>              ͨ��������ʽȥ������Ҫ�����Ƶ��.
::-ds, --drop-subtitle <OPTIONS>           ͨ��������ʽȥ������Ҫ�����Ļ��.

::---------------�������---------------
:m3u8_download_print
echo.�������%REfile% "%link%" %m3u8_params% --ffmpeg-binary-path %ffmpeg% --tmp-dir %TempDir% --save-dir %SaveDir% --save-name "%filename%"
::��һ��
echo.
goto :eof

:live_record_print
echo.�������%REfile% "%link%" %live_record_params% --tmp-dir %TempDir% --save-dir %SaveDir% --save-name "%filename%"
::��һ��
echo.
goto :eof


::��������
:m3u8_downloading
::��%filename%�����ţ���ֹ�ļ�������ĳЩ���ŵ���·��ʶ�eʧ��
%REfile% "%link%" %m3u8_params% --ffmpeg-binary-path %ffmpeg% --tmp-dir %TempDir% --save-dir %SaveDir% --save-name "%filename%"
goto :eof

:live_recording
%REfile% "%link%" %live_record_params% --tmp-dir %TempDir% --save-dir %SaveDir% --save-name "%filename%"
goto :eof

::���������ͣһ��ʱ��رմ��ڣ���ֹ���б���ʱֱ�ӹرմ��ڡ�
:when_done
set "closeWindowDelay=10"
echo.
echo.
echo  ���ڽ��� %closeWindowDelay% ����Զ��رա�
echo.
title �رյ���ʱ: %closeWindowDelay% ��
set /a closeWindowDelay-=1
timeout /t 1 >nul 2>nul
:closeWindowCountdown
if %closeWindowDelay% gtr 0 (
    title �رյ���ʱ: %closeWindowDelay% ��
    set /a closeWindowDelay-=1
    timeout /t 1 >nul 2>nul
    goto closeWindowCountdown
)
title �رյ���ʱ: 0 ��
timeout /t 1 >nul 2>nul
exit
goto :eof

::---------------FFMPEGת������---------------
:set_FFinput
set "FFinName="
echo ������*��ǰ�����ļ�Ĭ��Ŀ¼:%SaveDir%
set /p "FFinName=������Ҫת�����ļ���(���ļ�����׺): "
if "!FFinName!"=="" (
    echo �������벻��Ϊ�գ�
    goto set_FFinput
)
set FFinName="%SaveDir%\!FFinName!"
cls
goto :eof

:set_FFoutput
set "FFoutName="
echo ������*��ǰ�����ļ�Ĭ��Ŀ¼:%SaveDir%
set /p "FFoutName=������Ҫ������ļ���(���ļ�����׺ eg:mp4,mkv,avi)�����ջس�Ĭ��Ϊԭ�ļ���.mp4(filename.mp4): "
if "!FFoutName!"=="" (
	call :set_FForiName %FFinName%
	set FFoutName="%SaveDir%\!FForiName!.mp4"
) else (
	call :set_FForiName %FFoutName%
	if "!FForiName_ext!"=="" (
	set FFoutName="%SaveDir%\!FFoutName!.mp4"
) else (
	set FFoutName="%SaveDir%\!FFoutName!"
)
)
cls
echo Ҫת�����ļ�Ϊ %FFinName%
echo ת������ļ�Ϊ %FFoutName%
goto :eof

:set_FForiName
set "FForiName=%~n1"
set "FForiName_ext=%~x1"
goto :eof