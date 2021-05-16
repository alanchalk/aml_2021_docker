# Cut down version of Niels Borie ML-docker

#FROM jupyter/tensorflow-notebook:f4c0193bbc96
FROM jupyter/minimal-notebook:f4c0193bbc96
LABEL maintainer="Alan CHALK"

USER root

# --- Install python-tk htop python-boost
RUN apt-get update && \
    apt-get install -y --no-install-recommends python-tk software-properties-common htop libboost-all-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# --- Install dependency gcc/g++
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test

# --- Install gcc/g++
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc-7 g++-7 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# --- Update alternatives
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

RUN $CONDA_DIR/bin/python -m pip install \
    pandas \
    matplotlib \
    scipy \
    seaborn \
    scikit-learn \
    scikit-image \
    cython \
    patsy \
    statsmodels \
    numba \
    bokeh \
    h5py \
    tables \
    hyperopt \
    tqdm \
    tpot \
    yellowbrick \
    skope-rules \
    shap \
    lime \
    lightgbm \
    catboost \
    xgboost


# --- Install h2o
RUN $CONDA_DIR/bin/python -m pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o

# --- Conda xgboost, lightgbm, catboost
#RUN conda install --quiet --yes \
#    'boost' \
#    'lightgbm' \
#    'xgboost' \
#    'catboost' && \
#    conda clean -tipsy && \
#    fix-permissions $CONDA_DIR && \
#    fix-permissions /home/$NB_USER

# clean up pip cache
RUN rm -rf /root/.cache/pip/*
