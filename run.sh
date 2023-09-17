#!/bin/bash
clear
cd harbour/src
hbmk2 -fullstatic cms.hbp cms.hbc -ocms 
cd ../../
docker-compose exec cms ./cms