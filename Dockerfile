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
# RUN $CONDA_DIR/bin/python -m pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o
# --- Install h2o changed to install specific version (from 29/5/2021)
# links for specific versions can be found at https://github.com/h2oai/h2o-3/blob/master/Changes.md
# Particularly necessary because models built on older versions are not guaranteed
# to run on newer versions.  Hence students rebuilding the image could find
# models do not work, unless model is fixed.
RUN $CONDA_DIR/bin/python -m pip install -f pip install http://h2o-release.s3.amazonaws.com/h2o/rel-zipf/2/Python/h2o-3.32.1.2-py2.py3-none-any.whl

# --- category_encoders deliberately added here and not above so as not to
# change the pip solver for above package versions.  A pip install
# of  category_encoders inside of the v1 container showed no packages
# were updated and I would like to ensure this here too.
RUN $CONDA_DIR/bin/python -m pip install \
    category_encoders


# clean up pip cache
RUN rm -rf /root/.cache/pip/*
