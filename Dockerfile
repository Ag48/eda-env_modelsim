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
## Test GCC & G++
RUN which gcc g++; gcc --version; g++ --version
RUN git clone http://git.veripool.org/git/verilator  /tmp/verilator; cd /tmp/verilator; autoconf; ./configure; make; make install
RUN echo "Verilator has installed successfully" 

# for emacs-verilog-mode
RUN yum install -y emacs 

# for modelsim
## modelsim's url ref : https://gist.github.com/zweed4u/ecc03ade1da8c51127a5485830d7a621
RUN yum install -y glib.i686 libX*.i686 ncurses-libs.i686 wget
RUN cd /tmp; wget --spider -nv --timeout 10 -t 1 ${url_donwload_modelsim}; wget -c ${url_donwload_modelsim}
RUN cd /tmp; chmod a+x ${bin_modelsim}; ./${bin_modelsim} --version
RUN cd /tmp; ./${bin_modelsim} --mode unattended --installdir ${path_install_modelsim} --unattendedmodeui minimalWithDialogs 
## for bug in ver.16.0
RUN cd ${path_install_modelsim}/modelsim_ase; ln -s linux linux_rh60
## Test bin
RUN ${path_install_modelsim}/bin/vsim -c -version
RUN echo "ModelSim has installed successflly"
## set modelsim's path to PATH
RUN echo "export PATH=${PATH}:/eda/intelFPGA/16.0/modelsim_ase/bin; echo 'set vsim path to PATH'" >> /etc/bashrc
RUN which vsim
CMD echo "Now running..."
