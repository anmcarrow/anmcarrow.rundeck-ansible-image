#!/bin/bash

PROJECT_NAME="anmcarrow"
IMAGE_NAME="rundeck-ansible"

time docker build -t ${PROJECT_NAME}/${IMAGE_NAME} .

exit 0
