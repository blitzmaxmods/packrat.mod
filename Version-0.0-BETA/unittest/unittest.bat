@echo off

# Compile the test
C:/BlitzMax/bin/bmk makeapp -r %1.bmx

# Run the test
%1

