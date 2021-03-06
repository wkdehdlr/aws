#!/bin/bash
BUILD_JAR=$(ls /home/ec2-user/build/*.jar)
JAR_NAME=$(basename $BUILD_JAR)
PROFILE=$(</home/ec2-user/profile.txt)
chmod +x /home/ec2-user/build/start.sh
chmod +x /home/ec2-user/build/stop.sh
echo "> build 파일명: $JAR_NAME" >> /home/ec2-user/deploy/deploy.log

echo "> build 파일 복사" >> /home/ec2-user/deploy/deploy.log
DEPLOY_PATH=/home/ec2-user/deploy/
cp $BUILD_JAR $DEPLOY_PATH

echo "> 현재 실행중인 애플리케이션 pid 확인" >> /home/ec2-user/deploy/deploy.log
CURRENT_PID=$(pgrep -f $JAR_NAME)

if [ -z $CURRENT_PID ]
then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다." >> /home/ec2-user/deploy/deploy.log
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

DEPLOY_JAR=$DEPLOY_PATH$JAR_NAME
echo "> DEPLOY_JAR 배포"    >> /home/ec2-user/deploy/deploy.log
echo "> 현재 active profile $PROFILE " >> /home/ec2-user/deploy/deploy.log
nohup java -jar -Dspring.profiles.active=$PROFILE $DEPLOY_JAR >> /home/ec2-user/deploy/deploy.log 2>/home/ec2-user/deploy/deploy_err.log &