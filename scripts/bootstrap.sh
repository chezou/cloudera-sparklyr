#!/bin/bash
# Script for bottstrapScript. Set as bootstrapScript on every template
sudo useradd rsuser
sudo sh -c "echo 'rsuser:cloudera' | chpasswd"