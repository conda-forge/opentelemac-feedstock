#!/usr/bin/env bash

# TELEMAC home directory
export HOMETEL=$SRC_DIR/opentelemac

# Configure PATH and PYTHONPATH
export PATH=$HOMETEL/scripts/python3:$PATH
export PYTHONPATH=$HOMETEL/scripts/python3

#linux
if [[ $(uname) == Linux ]]; then
   # Configuration file
   export SYSTELCFG=$HOMETEL/configs/systel.debian.cfg
   export USETELCFG=gnu.shared
#OSX
elif [[ $(uname) == Darwin ]]; then
   # Configuration file
   cp $RECIPE_DIR/configs/systel.macos.cfg $HOMETEL/configs/systel.macos.cfg
   export SYSTELCFG=$HOMETEL/configs/systel.macos.cfg
   export USETELCFG=gfort-mpich
fi
# Set TELEMAC version in systel.cfg
sed -i "/^modules:/a version:    $TELEMAC_VERSION" "$SYSTELCFG"

# Name of the configuration to use
export LD_LIBRARY_PATH=$HOMETEL/builds/$USETELCFG/wrap_api/lib:$HOMETEL/builds/$USETELCFG/lib

compile_telemac.py

mkdir -p $PREFIX/opentelemac/configs                     #1 Copy configs
mkdir -p $PREFIX/opentelemac/builds                      #2 Copy builds
mkdir -p $PREFIX/opentelemac/scripts                     #3 Copy scripts
mkdir -p $PREFIX/opentelemac/sources                     #4 Copy sources
cp -r $SYSTELCFG $PREFIX/opentelemac/configs             #1
cp -r $HOMETEL/builds/* $PREFIX/opentelemac/builds       #2
cp -r $HOMETEL/scripts/* $PREFIX/opentelemac/scripts     #3
cp -r $HOMETEL/sources/* $PREFIX/opentelemac/sources     #4

# AUTO activate /deactivate environments variables for TELEMAC
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
