#!/bin/bash

trap "sudo chown -R root:root ~/Documents/iphone_pictures/" EXIT

sudo chown -R $USER:$USER ~/Documents/iphone_pictures/
sleep infinity

