FROM continuumio/miniconda3:4.10.3

# files will run from here
WORKDIR /usr/src/app

# keep python running smoothly
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict
RUN conda install -y mamba=0.15.3
RUN mamba install -y voila=0.2.14
RUN mamba install -y notebook=6.4.4

WORKDIR /usr/share/voila

CMD ["voila"]
