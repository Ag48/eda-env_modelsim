# Build stage
FROM stomoki/eda-env_emacs-verilog-mode AS building

ARG version_modelsim="16.0"
ARG build_modelsim="211"
ARG bin_modelsim="ModelSimSetup-${version_modelsim}.0.${build_modelsim}-linux.run"
ARG url_donwload_modelsim="http://download.altera.com/akdlm/software/acdsinst/${version_modelsim}/${build_modelsim}/ib_installers/${bin_modelsim}"
ARG path_install_modelsim="/tmp"
WORKDIR /tmp

# for modelsim
## modelsim's url ref : https://gist.github.com/zweed4u/ecc03ade1da8c51127a5485830d7a621
## installation process ref: https://fpga.kice.tokyo/design/centos7-modelsim
RUN yum update -y \
  && yum install -y \
    glib.i686 \
    glib-devel.i686 \
    libX11-devel.i686 \
    libXext-devel.i686 \
    libXft-devel.i686 \
    ncurses-libs.i686
# RUN wget --spider -nv --timeout 10 -t 1 ${url_donwload_modelsim} 
RUN wget -c -nv ${url_donwload_modelsim} \
  && chmod a+x ${bin_modelsim}
# COPY ./${bin_modelsim} /tmp
RUN ./${bin_modelsim} --mode unattended --installdir ${path_install_modelsim} --unattendedmodeui none
## for bug in ver.16.0
RUN cd ${path_install_modelsim}/modelsim_ase; ln -s linux linux_rh60
## Delete Altera Cell Library to reduce image size
RUN rm -rf ${path_install_modelsim}/modelsim_ase/altera
## Test bin
RUN ${path_install_modelsim}/modelsim_ase/bin/vsim -c -version


# Deploy 
FROM stomoki/eda-env_emacs-verilog-mode:v2
COPY --from=building /tmp/modelsim_ase /vsim-ase
RUN yum update -y \
  && yum install -y \
    glibc.i686 \
    libXext-devel.i686 \
    libXft-devel.i686 \
    ncurses-libs.i686 \
    zlib \
  && yum groupinstall -y "X Window System" \
  && yum clean all
RUN echo "export PATH=${PATH}:/vsim-ase/bin; echo 'set vsim path to PATH'" >> /etc/bashrc 
ENV PATH="/vsim-ase/bin:${PATH}"
# check install 
RUN vsim -c -version
# add user 'eda' & change uid + gid for writable authority in Linux Docker
# RUN useradd -u 1000 -c 'for eda test' -s /bin/bash -d /home/eda eda \
#   && echo 'eda:I1oveEDA' |chpasswd \
#   && groupmod -g 1000 eda
# RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
#   && /etc/init.d/sshd start
RUN /etc/init.d/sshd start
EXPOSE 22

CMD /usr/sbin/sshd -D
