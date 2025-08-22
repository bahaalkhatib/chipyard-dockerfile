FROM ubuntu:22.04 as base

LABEL org.opencontainers.image.authors="https://groups.google.com/forum/#!forum/chipyard"

WORKDIR /root

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget git ca-certificates

RUN wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh" 
RUN bash Miniforge3-Linux-x86_64.sh -b -p /opt/conda

SHELL ["/bin/bash", "-cl"]

RUN git clone https://github.com/ucb-bar/chipyard.git && \
    cd chipyard && \
	git checkout HEAD 

RUN cd chipyard && \ 
    source "/opt/conda/etc/profile.d/conda.sh" && \ 
    conda activate base && \ 
    ./build-setup.sh riscv-tools -s 2 -s 3 -s 4 -s 5 -s 6 -s 7 -s 8 -s 9 && \
    source env.sh && \ 
    cd scripts && ./generate-conda-lockfiles.sh && \ 
    cd .. && ./build-setup.sh riscv-tools -s 1 -s 9

CMD ["/bin/sh"]
