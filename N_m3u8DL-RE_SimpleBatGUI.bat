::记得保存为ASNI编码

@echo off & setlocal enabledelayedexpansion

::开始
Title N_m3u8DL-RE下载调用 by Lenno 2024.8.21

cd /d %~dp0

::****************************************
::目录设置提前，方便使用时查看
::设置主程序文件名，方便切换不同版本，release0.2.0beta不支持ad-keyword，要使用0.2.1beta或action build版
::最新beta为0.2.1-20240828，已正常使用，无需更换action build版
set REfile=N_m3u8DL-RE
::set REfile= 自己修改为所使用的主文件名，N_m3u8DL-RE，N_m3u8DL-RE_beta，N_m3u8DL-RE_action

::设置临时文件存储目录
set TempDir=D:\Downloads\New\N_m3u8DL_Temp

::设置输出目录
set SaveDir=D:\Downloads\New

::设置ffmpeg.exe路徑。从批处理所在文件夹到Program Files共3层。
set ffmpeg=ffmpeg.exe
::****************************************

::菜单部分
:menu
cls
ECHO.
ECHO  下载选项
echo.                   
ECHO. **********************************************************
echo.
ECHO  1、m3u8视频单个下载
echo.
ECHO  2、m3u8视频批量下载
echo.
ECHO  3、直播录制
echo.
ECHO  4、FFMPEG转为MP4(copy)
echo.
ECHO. **********************************************************
echo.
ECHO  *当前设置主程序名:%REfile%
ECHO  *当前设置输出目录:%SaveDir%
ECHO  *当前设置临时目录:%TempDir%
ECHO  *当前设置FFMPEG路径:%ffmpeg%
echo.
ECHO. **********************************************************
echo.
set /p a=请输入操作序号并回车（1、2、3、4）：
cls

if %a%==1 goto m3u8_download
if %a%==2 goto m3u8_batch_download
if %a%==3 goto live_record
if %a%==4 goto ff_converter

::---------------设置部分start---------------
:setting_path
::目录设置提前到全局位置，方便使用时查看
::设置输入文件input.txt，和输出的批量下载批处理output.bat
::input.txt格式为 要保存的文件名,m3u8下载链接
::input示例   ！！注意，文本编码需要为ANSI否则乱码！！
::蜘蛛侠1,http://xx.xx.m3u8
::蜘蛛侠2,http://xx.xx.m3u8
set input=input.txt
set output=output.bat
goto :eof

:setting_m3u8_params
::设置过滤广告
set AntiADs=--ad-keyword "\d{1,}o\d{3,4}.ts|\/ad\w{0,}\/"
::加入过滤广告分片 --ad-keyword "\d{1,}o\d{3,4}.ts|\/ad\w{0,}\/" 如出现问题请尝试清空该选项
::另一个关键字 --ad-keyword "o\d{3,4}.ts$|/ads/"

::设置m3u8下载参数
set m3u8_params=--download-retry-count:9 --auto-select:true --check-segments-count:false --no-log:true %AntiADs% --append-url-params:true  -mt:true --mp4-real-time-decryption:true --ui-language:zh-CN

goto :eof


:setting_live_record_params
::设置直播录制参数
set live_record_params=--no-log:true -mt:true --mp4-real-time-decryption:true --ui-language:zh-CN -sv best -sa best --live-pipe-mux:true --live-keep-segments:false --live-fix-vtt-by-audio:true %live_record_limit% -M format=mp4:bin_path="%ffmpeg%"

goto :eof
::---------------设置部分end---------------

::开始下载
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
echo ****转换中****
%ffmpeg% -i  "%FFinName%" -c copy "%FFoutName%" -loglevel warning
echo.
echo *****完成*****
echo.
pause
::call :when_done 
goto :eof

::---------------输入部分---------------
:common_input
::输入链接 和 文件名
:set_link
set "link="
set /p "link=请输入链接: "
if "!link!"=="" (
    echo 错误：输入不能为空！
    goto set_link
)

:set_filename 
set "filename="
set /p "filename=请输入保存文件名: "
if "!filename!"=="" (
    echo 错误：输入不能为空！
    goto set_filename
)

::子标签中加上goto :eof命令即可退出子标签，不继续执行它下面的其它命令
goto :eof

::批量下载部分
::读取文件，合成参数，写入新文件并执行
:batch_input
::批量下载的输入输出,如不设定，默认为当前目录的input.txt，输出output.bat
:set_batchfile_input
set "batchfile_input="
echo.
ECHO   ！！注意，txt文本编码需要为ANSI否则乱码！！
ECHO   ！！如果批量下载失败请先检查input.txt文件编码是否正确，以及生成的output.bat是否正常！！
echo.
set /p "batchfile_input=请输入包含批量下载链接的文件名或完整路径(**.txt,留空确认则默认设置当前文件夹的input.txt): "
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
set /p "batchfile_output=请输入将输出批量下载bat的文件名(**.bat,或不带后缀名.bat。 留空确认则默认设置当前文件夹的output.bat): "
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
::拼接命令
set string2=--tmp-dir "%TempDir%" --save-dir "%SaveDir%" --ffmpeg-binary-path "%ffmpeg%" %m3u8_params%
::预先清理可能重名的文件
echo off>%output%

::获取总行数=待下载任务数
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
::调用生成的文件进行下载
cls
ECHO  批量下载的输入为：%input%
ECHO  批量下载的执行为：%output%
echo.
ECHO   ！！注意，txt文本编码需要为ANSI否则乱码！！
ECHO   ！！如果批量下载失败请先检查input.txt文件编码是否正确，以及生成的output.bat是否正常！！
echo.
call %output%
goto :eof

:live_record_input
:set_record_limit
set "record_limit="
set /p "record_limit=请输入录制时长限制(格式：HH:mm:ss, 可为空): "
if "!record_limit!"=="" (
    set live_record_limit=
) else (
    set live_record_limit=--live-record-limit %record_limit%
    )

goto :eof

::---------------参数说明---------------
::--更多请参考作者的项目 https://github.com/nilaoda/N_m3u8DL-RE
::--tmp-dir <tmp-dir>                      设置临时文件存储目录
::--save-name <save-name>                  设置保存文件名
::--save-dir <save-dir>                    设置输出目录
::--download-retry-count <number>          每个分片下载异常时的重试次数 [default: 3]
::--auto-select                            自动选择所有类型的最佳轨道 [default: False]
::--ad-keyword                             选项过滤广告URL
::--check-segments-count                   检测实际下载的分片数量和预期数量是否匹配 [default: True]
::--no-log                                 关闭日志文件输出 [default: False]
::--append-url-params                      将输入Url的Params添加至分片, 对某些网站很有用 [default: False]
::-mt, --concurrent-download               并发下载已选择的音频、视频和字幕 [default: False]
::--mp4-real-time-decryption               实时解密MP4分片 [default: False]
::-M, --mux-after-done <OPTIONS>           所有工作完成时尝试混流分离的音视频
::--custom-range <RANGE>                   仅下载部分分片. 输入 "--morehelp custom-range" 以查看详细信息
::--ffmpeg-binary-path <PATH>              ffmpeg可执行程序全路径, 例如 C:\Tools\ffmpeg.exe
::--ui-language <en-US|zh-CN|zh-TW>        设置UI语言
::--live-keep-segments                     录制直播并开启实时合并时依然保留分片 [default: True]
::--live-pipe-mux                          录制直播并开启实时合并时通过管道+ffmpeg实时混流到TS文件 [default: False]
::--live-fix-vtt-by-audio                  通过读取音频文件的起始时间修正VTT字幕 [default: False]
::--live-record-limit <HH:mm:ss>           录制直播时的录制时长限制
::-sv, --select-video <OPTIONS>            通过正则表达式选择符合要求的视频流. 输入 "--morehelp select-video" 以查看详细信息
::-sa, --select-audio <OPTIONS>            通过正则表达式选择符合要求的音频流. 输入 "--morehelp select-audio" 以查看详细信息
::-ss, --select-subtitle <OPTIONS>         通过正则表达式选择符合要求的字幕流. 输入 "--morehelp select-subtitle" 以查看详细信息
::-dv, --drop-video <OPTIONS>              通过正则表达式去除符合要求的视频流.
::-da, --drop-audio <OPTIONS>              通过正则表达式去除符合要求的音频流.
::-ds, --drop-subtitle <OPTIONS>           通过正则表达式去除符合要求的字幕流.

::---------------输出部分---------------
:m3u8_download_print
echo.下载命令：%REfile% "%link%" %m3u8_params% --ffmpeg-binary-path %ffmpeg% --tmp-dir %TempDir% --save-dir %SaveDir% --save-name "%filename%"
::空一行
echo.
goto :eof

:live_record_print
echo.下载命令：%REfile% "%link%" %live_record_params% --tmp-dir %TempDir% --save-dir %SaveDir% --save-name "%filename%"
::空一行
echo.
goto :eof


::下载命令
:m3u8_downloading
::将%filename%加引号，防止文件名带有某些符号导致路径识別失败
%REfile% "%link%" %m3u8_params% --ffmpeg-binary-path %ffmpeg% --tmp-dir %TempDir% --save-dir %SaveDir% --save-name "%filename%"
goto :eof

:live_recording
%REfile% "%link%" %live_record_params% --tmp-dir %TempDir% --save-dir %SaveDir% --save-name "%filename%"
goto :eof

::下载完成暂停一段时间关闭窗口，防止运行报错时直接关闭窗口。
:when_done
set "closeWindowDelay=10"
echo.
echo.
echo  窗口将在 %closeWindowDelay% 秒后自动关闭。
echo.
title 关闭倒计时: %closeWindowDelay% 秒
set /a closeWindowDelay-=1
timeout /t 1 >nul 2>nul
:closeWindowCountdown
if %closeWindowDelay% gtr 0 (
    title 关闭倒计时: %closeWindowDelay% 秒
    set /a closeWindowDelay-=1
    timeout /t 1 >nul 2>nul
    goto closeWindowCountdown
)
title 关闭倒计时: 0 秒
timeout /t 1 >nul 2>nul
exit
goto :eof

::---------------FFMPEG转换部分---------------
:set_FFinput
set "FFinName="
echo 已设置*当前设置文件默认目录:%SaveDir%
set /p "FFinName=请输入要转换的文件名(带文件名后缀): "
if "!FFinName!"=="" (
    echo 错误：输入不能为空！
    goto set_FFinput
)
set FFinName="%SaveDir%\!FFinName!"
cls
goto :eof

:set_FFoutput
set "FFoutName="
echo 已设置*当前设置文件默认目录:%SaveDir%
set /p "FFoutName=请输入要保存的文件名(带文件名后缀 eg:mp4,mkv,avi)，留空回车默认为原文件名.mp4(filename.mp4): "
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
echo 要转换的文件为 %FFinName%
echo 转换后的文件为 %FFoutName%
goto :eof

:set_FForiName
set "FForiName=%~n1"
set "FForiName_ext=%~x1"
goto :eof