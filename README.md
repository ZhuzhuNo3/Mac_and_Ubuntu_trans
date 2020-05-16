# Mac_and_Ubuntu_trans
使用nc命令以及ssh完成虚拟机和Mac主机之间信息交换，简单又粗暴的方法 （主要是为了方便自己复制vim中的内容）

### 需求

Mac和Ubuntu中都要有的shell命令：nc ssh

主机中的软件：（不是必须）Typora

### 功能

1. 在虚拟机中编辑vim时可以使用ctrl+c快捷键将选中的文本放入Mac的剪贴板
2. 在虚拟机中使用 `typora filename.md` 可以在Mac中用typora软件打开markdown文档（前提是你有typora）
3. 在虚拟机中使用 `trans filename` 可以将文件传输到Mac的Downloads目录

### 使用方式

1. linkz.sh 放在主机的任意目录（我习惯用在配置文件中加alias的方式使用脚本）

2. ubuntu_linkz 放在虚拟机的 `/usr/local/bin/` 目录中

3. 修改linkz.sh中第八行和第十行的内容，如 `PORT=2333` 以及 `YOURHOST="hostname@196.168.64.3"` 

    PORT：用来运行 `nc` 命令的端口号，需要和ubuntu_linkz文件中的统一

    YOURHOST：使用 `ssh` 登录虚拟机时所使用的地址

4. 修改ubuntu_linkz中第七行和第九行的内容，如 `gateway=192.168.64.1` 以及 `port=2333`

    gateway可通过在虚拟机中使用 `echo $SSH_CONNECTION |sed "s/ .*//g"` 查看

5. 在主机当前使用的shell的配置文件中（如 .bashrc 或 .zshrc）添加

    ```shell
    # example
    alias zz='~/Code/linkz.sh'
    ```

    在虚拟机当前使用的shell的配置文件中添加

    ```shell
    # example
    alias typora="ubuntu_linkz typora" # 使用typora加上md文档名在Mac中打开文档
    alias trans="ubuntu_linkz trans" # 使用trans加上文件名将文件传输至Mac本地
    ```

    在你的vim配置文件（.vimrc）中添加，（即，使用 `ctrl+c` 将当前选中的文本复制到 Mac 的剪贴板中）

    ```vim
    vmap <C-C> :'<,'>!ubuntu_linkz copy<cr>u
    ```

6. 在terminal中使用第五步中在主机的shell配置文件里添加的快捷命令（如：`zz`）登录你的Ubuntu虚拟机就可以用啦（也可以自己添加一些代码啥的，反正这个是很容易看懂的笨方法:full_moon_with_face:）

7. 没了( ´▽｀)



PS: my_completion 是bash的自动补全，用于在使用typora的时候，用tab键能够联想出md文档。

​	存放位置里面有写(/ω＼)

