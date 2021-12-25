#!/bin/bash
if [ $1x == "--global"x ] ; then
  GLOBAL_OPT=--global
  GITATTR=$(git config ${GLOBAL_OPT} --path core.attributesfile)
  if [ ${GITATTR}x == x ] ; then
    GITATTR=${HOME}/.config/git/attributes
  fi
else
  GLOBAL_OPT=
  GIT_ROOT=$(git rev-parse --show-cdup)
  GITATTR=${GIT_ROOT}.gitattributes
fi

PCBDIFF_KEY=pcbdiff
SCHDIFF_KEY=schdiff

# Setup PCB diff tool
git config ${GLOBAL_OPT} diff.${PCBDIFF_KEY}.command $(dirname $0)/git-diff-pcb-local.sh
git config ${GLOBAL_OPT} --bool diff.${PCBDIFF_KEY}.prompt false

# Setup Schematic diff tool
git config ${GLOBAL_OPT} diff.${SCHDIFF_KEY}.command $(dirname $0)/git-diff-sch-local.sh
git config ${GLOBAL_OPT} --bool diff.${SCHDIFF_KEY}.prompt false


grep -q ${PCBDIFF_KEY} ${GITATTR} 2>/dev/null \
  || echo "*.kicad_pcb diff=${PCBDIFF_KEY}" >> ${GITATTR}

grep -q ${SCHDIFF_KEY} ${GITATTR} 2>/dev/null \
  || echo "*.sch diff=${SCHDIFF_KEY}" >> ${GITATTR}
