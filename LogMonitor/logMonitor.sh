#!/bin/dash
################################################################
# Author 
#       Alex.zhong
# Last Modified Date 
#       2015-01-04
# Version 
#       1.1.0
#
# Change Log
# 1.1.0
#				增加脚本运行日志文件功能
# 1.0.0 
#       在指定路径检索最新的一条日志文件，在文件中检索关键词。
#       检索到关键词，即认为程序异常，重启进程。
#       Note： 
#         1、检索最新的日志文件依赖规范的文件命名规则
#         2、脚本依赖crontab的定时任务
#         3、脚本在ubuntu环境下进行过测试
################################################################
# STEP1、Setup the initial environment parameter
PREFIX_PATH=$(cd "$(dirname "$0")"; pwd)
if [ ! -d "${PREFIX_PATH}/log/" ]; then
		mkdir -p "${PREFIX_PATH}/log/"
fi
MONITOR_LOG_PATH="${PREFIX_PATH}/log/event.log"
TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
echo -n "${TIMESTAMP} STEP 1 Setup the initial environment parameter \n" >>${MONITOR_LOG_PATH}
LOG_PATH="/home/alex/Desktop/test/"
EXCEPTION_KEYWORD="CreateRecord failed"
EXCEPTION_FLAG=false
TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
echo -n "${TIMESTAMP} >>>>>目标路径：${LOG_PATH} \n" >>${MONITOR_LOG_PATH}
TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
echo -n "${TIMESTAMP} >>>>>检索关键词：${EXCEPTION_KEYWORD} \n" >>${MONITOR_LOG_PATH}
echo  -n "\n"

# STEP2、Retrive the latest log file
TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
echo -n "${TIMESTAMP} STEP 2 Retrive the latest log file \n" >>${MONITOR_LOG_PATH}
if [ -d "${LOG_PATH}" ]; then
    LATEST_LOG_FILE=`ls ${LOG_PATH}|sort -nr|head -1`
    LATEST_LOG_FILE=${LOG_PATH}${LATEST_LOG_FILE}
    if [ -f ${LATEST_LOG_FILE} ]; then
        TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
				echo -n "${TIMESTAMP} >>>>>待分析文件:${LATEST_LOG_FILE} \n" >>${MONITOR_LOG_PATH}
    fi
else
    TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
		echo -n "${TIMESTAMP} >>>>>路径不存在：${LOG_PATH} \n" >>${MONITOR_LOG_PATH}
    exit 2
fi
echo  -n "\n"

# STEP3、Retrive exception info
TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
echo -n "${TIMESTAMP} STEP 3 Retrive exception info \n" >>${MONITOR_LOG_PATH}
if [ -f "${LATEST_LOG_FILE}" ]; then
    COUNT=`cat ${LATEST_LOG_FILE}|grep "${EXCEPTION_KEYWORD}"|wc -l`
    if [ ${COUNT} -ge 1 ]; then
        EXCEPTION_FLAG=true
        TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
				echo -n "${TIMESTAMP} >>>>>!!!检索到关键信息 \n" >>${MONITOR_LOG_PATH}
    else
        TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
				echo -n "${TIMESTAMP} >>>>>未检索到关键信息！ \n" >>${MONITOR_LOG_PATH}
    fi
else
    TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
		echo -n "${TIMESTAMP} >>>>>日志文件不存在！ \n" >>${MONITOR_LOG_PATH}
    exit 3
fi
echo  -n "\n"

# STEP4、Restart if encounter unexpected exception
TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
echo -n "${TIMESTAMP} STEP 4 Restart if encounter unexpected exception \n" >>${MONITOR_LOG_PATH}
if [ ${EXCEPTION_FLAG} = "true" ]; then
    TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
		echo -n "${TIMESTAMP} >>>>>请写上重启进程的命令 \n" >>${MONITOR_LOG_PATH}
else
    TIMESTAMP=`date +%Y%m%d\ %H:%M:%S`
		echo -n "${TIMESTAMP} >>>>>程序运行正常！ \n" >>${MONITOR_LOG_PATH}
fi
echo  -n "\n" >>${MONITOR_LOG_PATH}
