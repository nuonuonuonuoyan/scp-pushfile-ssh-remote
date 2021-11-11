set -eux

SSHDIR="$HOME/.ssh"
KNOWN_HOSTS="$HOME/.ssh/known_hosts"
ID_RSA="$HOME/.ssh/id_rsa"
ID_RSA_SCP="$HOME/.ssh/id_rsa_scp"
EXCLUDE_LIST_STR=$INPUT_EXCLUDE
EXCLUDE_LIST=`echo $EXCLUDE_LIST_STR|sed -e 's/[[:space:]]//g'`
oldIFS=$IFS
IFS=","
EXCLUDES=($EXCLUDE_LIST)

if [ $INPUT_SOURCE == "" ]
then 
   sh -c "exit 1"
elif [ $INPUT_SOURCE == "/" ]
then 
   SOURCE="$GITHUB_WORKSPACE/"
else
   SOURCE="$GITHUB_WORKSPACE/$INPUT_SOURCE"
fi

if [ ! -d $SSHDIR ]
then
   mkdir "$SSHDIR"
   chmod 700 "$SSHDIR"
fi

if [ ! -f "$KNOWN_HOSTS" ]
then
  touch "$KNOWN_HOSTS"
  chmod 600 "$KNOWN_HOSTS"
fi
if [ $INPUT_KEY != "" ]
then 
   touch "$ID_RSA"
   echo "$INPUT_KEY" > "$ID_RSA"
   chmod 600 "$ID_RSA"
fi

touch "$ID_RSA_SCP"
echo "$INPUT_SCP_KEY" > "$ID_RSA_SCP"
chmod 600 "$ID_RSA_SCP"

echo "$INPUT_COMMAND" > $HOME/command.sh
echo "exit \$?" >> $HOME/command.sh

sh -c "cd $SOURCE"
for ((i=0;i<${#EXCLUDES[@]};i++))
do
   sh -c "rm -rf ${EXCLUDES[$i]}"
done 

sh -c "scp -i $ID_RSA_SCP -o StrictHostKeyChecking=no -P ${INPUT_PORT} -r $SOURCE ${INPUT_USER}@${INPUT_HOST}:${INPUT_TARGET}"
if [ $? -eq 0 ]
then
   echo "项目已成功拷贝到服务器相应目录下"
   echo "开始连接远程服务器..."
   if [ $INPUT_KEY != "" ]
   then 
      sh -c "ssh -i $ID_RSA -o StrictHostKeyChecking=no -p $INPUT_PORT ${INPUT_USER}@${INPUT_HOST} < $HOME/command.sh"
   else
      sh -c "sshpass -p $INPUT_PASSWORD ssh -o StrictHostKeyChecking=no -p $INPUT_PORT ${INPUT_USER}@${INPUT_HOST} < $HOME/command.sh"
   fi
fi 


