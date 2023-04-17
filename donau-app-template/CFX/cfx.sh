#!/bin/bash

#########处理输入参数#########
if [ $# != 3 ]; then
	echo "Usage: Parameter mismatch."
	exit 1
else
    FDISPLAY=$1
	NP=$2
	DEF_FILE=$3
	RES_FILE=$4
fi
ln ${DEF_FILE} .

HOSTLIST=`cat ${CCS_ALLOC_FILE} |awk '{print $1,$2}'  |tr '\n' ','|sed 's/ /*/g'`
HOSTLIST=${HOSTLIST%,*,}

###组装mpirun命令,应用命令所在目录按照实际路径修改
if [ "x${RES_FILE}" != "x" ]; then
ln ${RES_FILE} .
    RUN_CMD="/usr/bin/exagear -- /share/software/apps/Ansys20230228/ansys_inc/v201/CFX/bin/cfx5solve -def ${DEF_FILE} -INI-FILE ${RES_FILE} -par -par-dist $HOSTLIST -start-method  'Open MPI Distributed Parallel' -partition $NP"
else
	RUN_CMD="/usr/bin/exagear -- /share/software/apps/Ansys20230228/ansys_inc/v201/CFX/bin/cfx5solve -def ${DEF_FILE} -par -par-dist $HOSTLIST -start-method  'Open MPI Distributed Parallel' -partition $NP"
fi

echo $RUN_CMD
eval $RUN_CMD
ret=$?

exit $ret