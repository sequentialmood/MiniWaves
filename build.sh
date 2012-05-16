#!/bin/bash

### configuration de MXMLC   ###
################################
 
#répertoire d'installation de MXMLC
#si le chemin est déjà  dans la variable d'environnement path, laissez la valeur vide
MXMLHOME=/Volumes/DATA/TOOLZ/AS/FLEX_SDK/4.0.0/

#mode DEBUG du compilateur
debug=true

incremental=true
generated=false

#encoding des fichiers AS
encoding=UTF-8

################################
### configuration du projet  ###
################################
 
#le classpath du projet (dossier contenant le code source)
classpath=src
 
#point d'entrée de l'application
mainclass=Main.as
 
#le SWF qui sera créé à  la compilation
swf=wwwroot/Main.swf
 
#description du projet
description=WaveForms
 
#auteur du projet
author=encaps

#Librairie SWC du projet
libs=lib

#######################################
### configuration du SWF de sortie  ###
#######################################

width=800

height=800

framerate=32

bgcolor=0xFFFFFF

#######################################
### configuration du FLASH PLAYER   ###
#######################################

flashplayer=/Volumes/DATA/TOOLZ/AS/PLAYERS/FP10_DEBUG.app/Contents/MacOS/Flash\ Player\ Debugger

#######################################
### COMPILATION					    ###
#######################################
path=`dirname $0`
echo "<p> :: REMOVING PREVIOUS FILE :: </p>"
rm $swf
echo "<p> :: MXMLC COMPILATION :: </p>"
$MXMLHOME/bin/mxmlc   -o $swf -sp $path/$classpath -library-path $path/$libs/MinimalComps.swc -default-size $width $height -default-frame-rate $framerate -default-background-color $bgcolor -debug=$debug  -strict=$strict -incremental=$incremental -static-link-runtime-shared-libraries=true -- $path/$classpath/$mainclass  
echo "<p> :: DISPLAY IN PLAYER ::</p> "
open  $swf