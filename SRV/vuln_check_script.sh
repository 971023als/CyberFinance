#!/bin/bash

# function.sh 파일을 소스로 가져옴
. function.sh

# 로그 파일 이름 설정 (SCRIPTNAME이 스크립트의 이름을 올바르게 반환하는지 확인 필요)
TMP1=`SCRIPTNAME`.log

# 로그 파일 초기화
> $TMP1

# 001부터 174까지 순회하면서 파일명 생성 및 실행
for i in $(seq -w 1 174); do
  filename="SRV-$i.sh"
  echo "Executing $filename" >> $TMP1  # 실행 메시지를 로그 파일에 추가
  # 실제 파일 실행. 파일에 실행 권한이 있는지 확인 필요
  ./"$filename"
done
