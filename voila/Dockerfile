FROM continuumio/miniconda3:4.10.3

# files will run from here
WORKDIR /usr/src/app

# keep python running smoothly
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict

# new environment voila-notebook-server
COPY ./requirements.txt .
RUN conda install --file requirements.txt

# mount some shared jupyter notebooks here
WORKDIR /usr/share/voila/notebooks

CMD ["voila"]
