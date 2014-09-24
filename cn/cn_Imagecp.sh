#!/bin/dash
#author alex.zhong
#date 2014-09-09
#version 1.0.5
################################################################
# Change log
# 1.0.5 
#       增加重签名功能:resign脚本参数的支持
# 1.0.4 
#       修改了最后压缩包输出的文件名格式
# 1.0.3 
#       精简ImageBin的打包内容
################################################################

# define feature option
PROJECT_DAFAULT=lo1
PROJECT_PATH=$(cd "$(dirname "$0")"; pwd)

RESIGN_ENABLE=false
QUICK_IMAGE_ENABLE=false

# add a shell script parameter feature support
if [ $# -ge 1 ]; then
  for op in $*
  do
    case ${op} in
      "resign") 
	#echo "we will resign the project image."
	RESIGN_ENABLE=true;;
      "quick") 
	#echo "compress image in quick mode."
	QUICK_IMAGE_ENABLE=true;;
      *) 
	echo "${op} is not valid parameter!"
	exit 1
    esac
  done
fi

echo -n "1、请输入项目名[eg:${PROJECT_DAFAULT}]:"
read PROJECT

IMAGESET="ImageBin"
IMAGETAR_PREFIX="ImageBin_${PROJECT}_"

if [ -z ${PROJECT} ]; then
  echo ">>>未输入项目名！默认: ${PROJECT_DAFAULT}"
  PROJECT=${PROJECT_DAFAULT}
  #exit 1
fi

if [ ! -d "./out/target/product/${PROJECT}" ]; then
  echo ">>>工程: ${PROJECT} 不存在"
  exit 2
fi

# it will re-sign the system image directly if RESIGN_ENABLE==false
if [ ${RESIGN_ENABLE} = "true" ]; then
  echo ">>>签名将花费2～3分钟，请耐心等待"
  ./mk ${PROJECT} sign-image
  echo ">>>签名已完成"
else
  # original sign procedure
  if [ ! -d "./out/target/product/${PROJECT}/signed_bin/" ]; then
    echo -n ">>>Image未签名，是否现在签名 Y or N:"
    read SIGN
    if [ ${SIGN}=Y -o ${SIGN}=y ]; then
      echo ">>>签名将花费2～3分钟，请耐心等待"
      ./mk ${PROJECT} sign-image
      echo ">>>签名已完成"
    else
      exit 3
    fi
  fi
fi

if [ -d "${IMAGESET}" ]; then
  rm -rf "${IMAGESET}"
fi
echo ""

#BIN_COUNT=find . -maxdepth 1 -type f -name '${IMAGETAR_PREFIX}*.tar.gz' -print| wc -l
#if [ ${BIN_COUNT:-0} -ge 1 ]; then
echo "2、删除旧文件"
rm -rf ${IMAGETAR_PREFIX}*.tar.gz
echo ">>>文件已删除"
#fi
echo ""

echo "3、Image拷贝"
mkdir -p "${IMAGESET}"
echo ">>>开始拷贝 out/target/product/${PROJECT}/signed_bin/boot-sign.img"
cp -L out/target/product/${PROJECT}/signed_bin/boot-sign.img ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/signed_bin/cache-sign.img"
cp -L out/target/product/${PROJECT}/signed_bin/cache-sign.img ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/signed_bin/EBR1-sign"
cp -L out/target/product/${PROJECT}/signed_bin/EBR1-sign ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/signed_bin/lk-sign.bin"
cp -L out/target/product/${PROJECT}/signed_bin/lk-sign.bin ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/signed_bin/logo-sign.bin"
cp -L out/target/product/${PROJECT}/signed_bin/logo-sign.bin ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/signed_bin/MBR-sign"
cp -L out/target/product/${PROJECT}/signed_bin/MBR-sign ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/MT6572_Android_scatter.txt"
cp -L out/target/product/${PROJECT}/MT6572_Android_scatter.txt ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/preloader_${PROJECT}.bin"
cp -L out/target/product/${PROJECT}/preloader_${PROJECT}.bin ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/signed_bin/recovery-sign.img"
cp -L out/target/product/${PROJECT}/signed_bin/recovery-sign.img ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/signed_bin/secro-sign.img"
cp -L out/target/product/${PROJECT}/signed_bin/secro-sign.img ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/signed_bin/system-sign.img"
cp -L out/target/product/${PROJECT}/signed_bin/system-sign.img ${IMAGESET}
echo ">>>开始拷贝 out/target/product/${PROJECT}/signed_bin/userdata-sign.img"
cp -L out/target/product/${PROJECT}/signed_bin/userdata-sign.img ${IMAGESET}
echo ">>>文件拷贝完成"
echo ""

echo "4、文件压缩"
echo ">>>开始压缩.."
TARDATE=`date +%Y%m%d-%H%M`
cd ${IMAGESET}
TARFILE=${IMAGETAR_PREFIX}${TARDATE}.tar.gz
tar czvf ${PROJECT_PATH}/${TARFILE} *
#cd ${PROJECT_PATH}
echo ""
echo "5、完成"
echo ">>>目标文件: ${TARFILE}"
