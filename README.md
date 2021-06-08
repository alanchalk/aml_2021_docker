# aml_2021

A Docker image for Cass AML 2021
---
tag: latest (this is a bad tag name and it is not the latest image)

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

tag: week 4

- Added category_encoders for week 4 material
- Fixed version of h2o

tag: week 5

- Added catboost dependencies for graphics
- Fixed versions of main packages
- Tidied dockerfile

tag: week 6
- Added vowpal wabbit (command line only)


# Docker Hub
Original source: https://hub.docker.com/r/nielsborie/ml-docker/
