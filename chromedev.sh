#!/bin/bash

# 清除 hdc fport
while IFS= read -r line; do
    if [[ $line != *"[Empty]"* ]]; then
        hdc fport rm "$line"
    fi
done < <(hdc fport ls)

# 设置 devtools 参数
#hdc shell param set web.debug.devtools true
#if [ $? -ne 0 ]; then
#    echo "Error: Failed to set devtools parameter."
#    exit 1
#fi

# 获取 devtools 的域套接字名称
#SOCKET_NAME=$(hdc shell "cat /proc/net/unix | grep devtools") # 老版系统
SOCKET_NAME=$(hdc shell "ps -ef | grep 'com.advanced.temp'") # 新版系统
if [ -z "$SOCKET_NAME" ]; then
    echo "Error: Failed to get the domain socket name of devtools."
    exit 1
fi

# 提取进程ID
#PID=$(echo "$SOCKET_NAME" | awk -F '_' '{print $4}')  # 老版系统
PID=$(echo "$SOCKET_NAME" | awk 'NR==1 {print $2}') # 新版系统
if [ -z "$PID" ]; then
    echo "Error: Failed to extract process ID."
    exit 1
fi

# 添加映射
hdc fport tcp:9222 localabstract:webview_devtools_remote_"$PID"
if [ $? -ne 0 ]; then
    echo "Error: Failed to add mapping."
    exit 1
fi

# 检查映射
hdc fport ls

# 10秒后关闭窗口
sleep 10
