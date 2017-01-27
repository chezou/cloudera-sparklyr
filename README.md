# cloudera-sparklyr

This repo includes:

- scripts for Cloudera Director building sparklyr cluster
- demo of sparklyr analyzing US flights

## Scripts for Cloudera Director

It is based on [director-sparklyr-bootstrap](https://github.com/jordanvolz/director-sparklyr-bootstrap).

If you have a trouble with director-sparklyr-bootstrap with building cluster,
you can set `scripts/bootstrap.sh` for bootstrapScript of every template.

Then, login the gateway node and run `scripts/post_crete_script_on_gateway.sh`.

## Demo: Analyzing US flights

This demo is for [Big Data Analytics Tokyo](http://www.bigdatacon.jp/en/talk/a-data-engineering-and-data-science-platform-based-on-hadoopspark/).

It visualizes US air flights and builds a linear regression model for delay prediction.

- Rmarkdown
  - [Japanese](sources/flight_map.Rmd)
  - [English](sources/flight_map_en.Rmd)

You can also see it in [RPubs](https://rpubs.com/chezou/usflights-en) ([Japanese version](https://rpubs.com/chezou/usflights)).