# Cut down version of Niels Borie ML-docker

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
    bokeh==2.3.2 \
    catboost==0.25.1 \
    category_encoders==2.2.2 \
    cython==0.29.23 \
    h5py==3.2.1 \
    hyperopt==0.2.5 \
    ipywidgets==7.6.3 \
    lime==0.2.0.1 \
    lightgbm==3.2.1 \
    matplotlib==3.4.2 \
    numba==0.53.1 \
    numpy==1.19.5 \
    pandas==1.2.4 \
    patsy==0.5.1 \
    scikit-learn==0.24.2 \
    scikit-image==0.18.1 \
    scipy==1.6.3 \
    seaborn==0.11.1 \
    shap==0.39.0 \
    skope-rules==1.0.1 \
    statsmodels==0.12.2 \
    tables==3.6.1 \
    TPOT==0.11.7 \
    tqdm \
    yellowbrick==1.3.post1 \
    xgboost==1.4.2


# --- Install h2o
# RUN $CONDA_DIR/bin/python -m pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o
# --- Install h2o changed to install specific version (from 29/5/2021)
# links for specific versions can be found at https://github.com/h2oai/h2o-3/blob/master/Changes.md
# Particularly necessary because models built on older versions are not guaranteed
# to run on newer versions.  Hence students rebuilding the image could find
# models do not work, unless model is fixed.
RUN $CONDA_DIR/bin/python -m pip install -f pip install http://h2o-release.s3.amazonaws.com/h2o/rel-zipf/2/Python/h2o-3.32.1.2-py2.py3-none-any.whl

# widgets for catboost graphics
RUN $CONDA_DIR/bin/jupyter nbextension install --user --py widgetsnbextension
RUN $CONDA_DIR/bin/jupyter nbextension enable widgetsnbextension --user --py

# --- Install vowpall wabbit (command line only)
# I check in the week 5 docker container that this does not updated any packages
# I found previously that the python API for vw downgrades many packages and
# I also found the command line version OK to use from within a Python notebook
RUN apt-get install -y vowpal-wabbit

# clean up pip cache
RUN rm -rf /root/.cache/pip/*
