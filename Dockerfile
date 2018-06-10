FROM centos:6

ARG version_modelsim="16.0"
ARG build_modelsim="211"
ARG bin_modelsim="ModelSimSetup-${version_modelsim}.0.${build_modelsim}-linux.run"
ARG url_donwload_modelsim="http://download.altera.com/akdlm/software/acdsinst/${version_modelsim}/${build_modelsim}/ib_installers/${bin_modelsim}"
ARG path_install_modelsim="/eda/intelFPGA/${version_modelsim}"

RUN yum update -y
RUN \rm /etc/localtime; ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN useradd -c 'for eda test' -s /bin/bash -d /home/eda eda
RUN echo "User 'eda' has generated successfully" 
# apply packages
RUN yum install -y epel-release 
# for verilator
RUN yum install -y git gcc gcc-c++ autoconf flex bison
RUN which gcc; gcc --version
RUN which g++; g++ --version
RUN git clone http://git.veripool.org/git/verilator  /tmp/verilator; cd /tmp/verilator; autoconf; ./configure; make; make install
RUN echo "Verilator has installed successfully" 

# for emacs-verilog-mode
RUN yum install -y emacs 

# for modelsim
## modelsim's url ref : https://gist.github.com/zweed4u/ecc03ade1da8c51127a5485830d7a621
RUN yum install -y glib.i686 libX*.i686 ncurses-libs.i686 wget
RUN wget --spider -nv --timeout 10 -t 1 ${url_donwload_modelsim}; wget ${url_donwload_modelsim} /tmp
RUN cd /tmp; ./${bin_modelsim} --mode unattended --accept_eula 1 --installdir ${path_install_modelsim} --unattendedmodeui minimal 
# for bug in ver.16.0
RUN cd ${path_install_modelsim}; ln -s linux linux_rh60

CMD echo "Now running..."
