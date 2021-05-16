# Based on Niels Borie ML-docker

FROM jupyter/tensorflow-notebook:115f07f1a4ac

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

# --- Install h2o
RUN $CONDA_DIR/bin/python -m pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o

# --- Conda xgboost, lightgbm, catboost, h2o, gensim, mlxtend
RUN conda install --quiet --yes \
    'boost' \
    'lightgbm' \
    'xgboost' \
    'catboost' \
    'gensim' \
    'mlxtend' \
    'tabulate' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


# --- Install (vowpalwabbit), hyperopt, tpot, sklearn-deap, yellowbrick, spacy
RUN $CONDA_DIR/bin/python -m pip install hyperopt \
					 deap \
					 update_checker \
					 tqdm \
					 stopit \
					 scikit-mdr \
					 skrebate \
					 tpot \
					 sklearn-deap \
					 yellowbrick \
					 spacy \
					 gplearn \
					 kmapper \
           skope-rules \
					 shap \
					 lime


RUN $CONDA_DIR/bin/python -m pip install git+https://github.com/hyperopt/hyperopt.git

RUN $CONDA_DIR/bin/python -m pip uninstall scikit-learn -y
RUN $CONDA_DIR/bin/python -m pip uninstall pandas -y
RUN $CONDA_DIR/bin/python -m pip uninstall scipy -y
RUN $CONDA_DIR/bin/python -m pip uninstall statsmodels -y

RUN $CONDA_DIR/bin/python -m pip install --upgrade Cython

RUN $CONDA_DIR/bin/python -m pip install scikit-learn \
                                         pandas \
                                         scipy \
                                         missingno

RUN $CONDA_DIR/bin/python -m pip install git+git://github.com/statsmodels/statsmodels.git



# clean up pip cache
RUN rm -rf /root/.cache/pip/*
