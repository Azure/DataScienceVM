#!/bin/bash

mkdir speech_commands
cd speech_commands
wget https://download.tensorflow.org/data/speech_commands_v0.01.tar.gz --no-check-certificate
tar xvzf speech_commands_v0.01.tar.gz

