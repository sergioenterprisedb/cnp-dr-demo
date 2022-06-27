#!/bin/bash
mc alias set myminio/ http://${hostname}:9000 admin password
mc rb myminio/cnp --force
