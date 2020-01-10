FROM stomoki/eda-env_modelsim:7-lite
RUN yum update -y && \
  yum install -y python3 && \
  yum clean all
RUN pip3 --no-cache-dir install vunit_hdl
