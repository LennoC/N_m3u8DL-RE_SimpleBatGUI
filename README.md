# N_m3u8DL-RE_SimpleBatGUI
简单的批处理调用N_m3u8DL-RE进行下载，预设单个下载、批量下载、录播下载。

## 说明
设置了个人常用参数。其余参数自行到相应标签添加。
### 使用方法
将N_m3u8DL-RE.exe, ffmpeg.xe, N_m3u8DL-RE_SimpleBatGUI.bat 放到同一个文件夹下，运行bat文件N_m3u8DL-RE_SimpleBatGUI.bat。

## 主程序
[N_m3u8DL-RE](https://github.com/nilaoda/N_m3u8DL-RE)
> 本项目附带一个action编译版本，追求稳定请到原项目下载release版本。

## ffmpeg 混流合并文件需要
ffmpeg下载:
- https://github.com/BtbN/FFmpeg-Builds/releases
- https://github.com/shinchiro/mpv-winbuild-cmake
- https://github.com/zhongfly/mpv-winbuild
> 下载ffmpeg.exe即可

## 其他广告过滤关键词
[m3u8_downloader/ignore_url_list.txt](https://github.com/leavjenn/leavjenn.github.io/blob/master/m3u8_downloader/ignore_url_list.txt)
> 下载的批处理里已加入常规广告过滤关键词，有更多需求的请自行寻找过滤关键词。

## 主要代码来自以下项目，我加入了批量下载的部分。感谢作者。
[N_m3u8DL-RE-Bat-Generator](https://github.com/dupontjoy/N_m3u8DL-RE-Bat-Generator)
> 该项目后来改为分离式设置文件，相对直观易用。

## 相关项目推荐
在线网页生成完整命令@RikaCelery [N_m3u8DL-RE Command Generator](https://rikacelery.github.io/N_m3u8DL-RE_Command_Generator)
