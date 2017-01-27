#!/bin/bash
# This script is for CentOS 7

#install R with EPEL
sudo yum install -y epel-release
## If it doesn't work, use following:
# wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# sudo rpm -Uvh epel-release-latest-7*.rpm
sudo yum install -y wget texlive texlive-epsf texinfo texinfo-tex libcurl-devel R

#install rstudio-server
wget https://download2.rstudio.org/rstudio-server-rhel-1.0.44-x86_64.rpm
sudo yum -y install --nogpgcheck rstudio-server-rhel-1.0.44-x86_64.rpm
sudo service rstudio-server start

#setup SPARK_HOME env variable
sudo sh -c "echo 'SPARK_HOME=/opt/cloudera/parcels/CDH/lib/spark/' >> /usr/lib64/R/etc/Renviron"

echo "Installing R packages"
#install packages
# Rscript -e 'update.packages(ask = FALSE)'
for pkgname in sparklyr nycflights13 ggplot2 dplyr maps geosphere
do
    sudo Rscript -e 'if(!require("'$pkgname'", character.only = TRUE, quietly = TRUE)) install.packages("'$pkgname'", dependencies = TRUE, repos="https://cran.r-project.org")'
done

sudo -u hdfs hdfs dfs -mkdir /user/rsuser
sudo -u hdfs hdfs dfs -chown rsuser:rsuser /user/rsuser
