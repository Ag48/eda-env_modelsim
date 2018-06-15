FROM stomoki/eda-env_varilator_emacs-verilog-mode

ARG version_modelsim="16.0"
ARG build_modelsim="211"
ARG bin_modelsim="ModelSimSetup-${version_modelsim}.0.${build_modelsim}-linux.run"
ARG url_donwload_modelsim="http://download.altera.com/akdlm/software/acdsinst/${version_modelsim}/${build_modelsim}/ib_installers/${bin_modelsim}"
ARG path_install_modelsim="/eda/intelFPGA/${version_modelsim}"

# for modelsim
## modelsim's url ref : https://gist.github.com/zweed4u/ecc03ade1da8c51127a5485830d7a621
RUN yum update -y && yum install -y glib.i686 libX*.i686 ncurses-libs.i686
RUN yum groupinstall -y "X Window System"
RUN cd /tmp; wget --spider -nv --timeout 10 -t 1 ${url_donwload_modelsim}; wget -c -nv ${url_donwload_modelsim}
# RUN cd /tmp; chmod a+x ${bin_modelsim}; ./${bin_modelsim} --version
RUN sync
RUN cd /tmp; chmod a+x ${bin_modelsim}; ./${bin_modelsim} --mode unattended --installdir ${path_install_modelsim} --unattendedmodeui none
RUN rm /tmp/${bin_modelsim}
## for bug in ver.16.0
RUN cd ${path_install_modelsim}/modelsim_ase; ln -s linux linux_rh60
## Test bin
RUN ${path_install_modelsim}/modelsim_ase/bin/vsim -c -version
RUN echo "ModelSim has installed successflly"
## set modelsim's path to PATH
RUN echo "export PATH=${PATH}:/eda/intelFPGA/16.0/modelsim_ase/bin; echo 'set vsim path to PATH'" >> /etc/bashrc; source /etc/bashrc; which vsim
