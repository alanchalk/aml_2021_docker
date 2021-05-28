# aml_2021

A Docker image for Cass AML 2021
---
v1:

Based on Neils Borie (ml-docker) but some packages updated and others removed.

In particular vowpal wabbit removed since the requirement for this seem to conflict with catboost (which needs np >= 1.16) and updated versions of sklearn image.


* pandas
* matplotlib
* Seaborn
* scikit-learn
* xgboost
* lightgbm
* catboost
* gensim
* TPOT
* hyperopt
* shap
* skope-rules
* h2o

v2:

Added category_encoders for week 4 material

# Docker Hub
Original source: https://hub.docker.com/r/nielsborie/ml-docker/
