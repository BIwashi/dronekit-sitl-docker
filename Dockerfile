# python公式イメージがDebianなのが原因？
# ubuntuに変更
FROM ubuntu:latest

# keyboard-configuration回避対策
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /home/user/src

RUN apt-get update -y && apt-get upgrade -y

# ubuntu 18.0.4で発生する問題回避 timezone 選択
RUN apt-get install -y tzdata
ENV TZ=Asia/Tokyo

RUN apt-get install -y git
RUN apt-get install -y wget
# pythoｎ
RUN apt-get install -y python3
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-pip

RUN apt-get install -y libxml2-dev
RUN apt-get install -y libxslt-dev
RUN apt-get install -y vim
RUN apt-get install -y sudo
RUN apt-get install -y gpsd
RUN apt-get install -y python-tk
# GQCエラー対策　https://qiita.com/hiconyan/items/2ea4815745164132221b
RUN apt-get install -y kmod
RUN apt-get install -y libfuse2
RUN apt-get install -y curl
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN apt-get autoremove -y


# DroneKitのインストール
# pipではなくpip3でインストール
# RUN pip3 install matplotlib
RUN pip3 install dronekit
RUN pip3 install dronekit-sitl
# USB接続用
RUN pip3 install pyserial

# paho-mqttのインストール
RUN pip3 install paho-mqtt

# drone_delivery.py用
RUN pip3 install simplejson cherrypy jinja2

# dronekitをクローン
# RUN git clone https://github.com/dronekit/dronekit-python.git
# forkをクローン
RUN git clone https://github.com/BIwashi/dronekit-python.git

WORKDIR /home/user/src/dronekit-python

ENV host host.docker.internal

# GUIをホストで実行するための環境変数
ENV DISPLAY host.docker.internal:0.0

# alias設定
RUN echo $'\n\
    alias ll="ls -l"\n\
    alias la="ls -a"\n\
    alias lla="ls -l -a"\n\
    alias python="python3"\n\
    alias pip="pip3"\n\
    function _update_ps1() {\n\
    PS1="$(powerline-shell $?)"\n\
    }\n\
    \n\
    if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then\n\
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"\n\
    fi\n\
    ' >> /home/user/.bashrc

# RUN mkdir -p ~/.config/powerline-shell
# RUN powerline-shell --generate-config > ~/.config/powerline-shell/config.json
# RUN eho '{\n\
#     "segments": [\n\
#     "time",\n\
#     "virtual_env",\n\
#     "username",\n\
#     \n\
#     "ssh",\n\
#     "cwd",\n\
#     "git",\n\
#     "hg",\n\
#     "jobs",\n\
#     \n\
#     "newline"\n\
#     ]\n\
#     }\n\
#     ' >> ~/.config/powerline-shell/config.json



# 接続確認
RUN apt-get install -y x11-apps 
# 接続できていれば、$xeyes で目が表示されるはず

# 各環境変数を設定
ENV USER user
ENV PASS pass

# 一般ユーザーアカウントを追加
RUN useradd -m ${USER}
# 一般ユーザーにsudo権限を付与
RUN gpasswd -a ${USER} sudo
# 一般ユーザーのパスワード設定
RUN echo "${USER}:${PASS}" | chpasswd


# # qtcreator環境
# https://dev.qgroundcontrol.com/master/en/getting_started/index.html
RUN apt-get install -y qtbase5-dev qttools5-dev-tools qt5-default
RUN apt-get install -y qtcreator

# qgc用
# RUN apt-get install -y speech-dispatcher libudev-dev libsdl2-dev
# RUN git clone https://github.com/mavlink/qgroundcontrol.git --recursive
# WORKDIR /usr/src/qgroundcontrol
# RUN git submodule update


# # QGCの設定

# RUN usermod -a -G dialout $USER
# RUN apt-get remove modemmanager -y
# RUN apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
# RUN wget https://s3-us-west-2.amazonaws.com/qgroundcontrol/latest/QGroundControl.AppImage
# RUN chmod +x ./QGroundControl.AppImage



# powerline-shell
WORKDIR /home/user
RUN git clone https://github.com/b-ryan/powerline-shell
WORKDIR /home/user/powerline-shell
RUN python3 setup.py install

# 一般ユーザに切り替える
USER ${USER}



