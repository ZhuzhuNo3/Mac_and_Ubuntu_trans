#!/bin/bash

# macOS Catalina 10.15.4 (19E287)

# Mac shell命令需求: netcat ssh pbcopy

# 自定义的监听的端口 需要与虚拟机中设置的相同
PORT=2333
# user@host 或者 ~/.ssh/config中的Host | 用于ssh
YOURHOST=z

# 用typora打开虚拟机里的md文档
function typora_open()
{
    scp $YOURHOST:$1 ~/.typora_temp >/dev/null
    ssh $YOURHOST "rm -rf ~/openTypora"
    md_dir=${1%/*}/
    md_name=${1##*/}
    now_file=~/.typora_temp/${md_name}
    old_file=~/.typora_temp/${md_name}.old
    cp $now_file $old_file
    (read -n 1 < $now_file) || echo > $now_file;
    open -a Typora $now_file
    osascript -e 'tell application "Typora" to activate'
    sleep 5
    # 检测文件是否修改并同步更新
    while ( ! [ x`osascript -e 'tell application "Typora" to id of every window whose visible is true and name is "'$md_name'"'` = x ] )
    do
        sleep 2
        (diff $now_file $old_file >/dev/null 2>&1) || (cp $now_file $old_file; scp $old_file $YOURHOST:$1 >/dev/null)
        sleep 2
    done
    (diff $now_file $old_file >/dev/null 2>&1) || scp $now_file $YOURHOST:$md_dir >/dev/null
    rm $now_file $old_file
}

function listening()
{
    while true
    do
        # nc 命令很魔幻 少用
        i=`nc -l $PORT |cat`
        if [ x"$i" = x"copy" ];then
            ssh $YOURHOST "cat ~/remote_cp_tmp" |pbcopy
            ssh $YOURHOST "rm -rf ~/remote_cp_tmp"
        elif [ x"$i" = x"exit" ] || [ x"$i" = x ];then
            exit 0
        elif [ x"$i" = x"trans" ];then
            filedir=`ssh $YOURHOST "cat ~/transFile"`
            ssh $YOURHOST "rm -rf ~/transFile"
            # 下载到默认文件夹
            scp $YOURHOST:$filedir ~/Downloads
        elif [ x"$i" = x"typora" ];then
            md_dir=`ssh $YOURHOST "cat ~/openTypora"`
            # 长命令放入后台转变成守护进程
            typora_open $md_dir >/dev/null 2>&1 &
            disown
        fi
    done &
}

# 开启后台进程
listening
# 这一句是我的虚拟机开机命令
multipass start zz
# 连接虚拟机
ssh $YOURHOST
# 关闭后台进程
(echo -n "exit"|nc 127.0.0.1 $PORT)
