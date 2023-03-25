FROM 'openjdk-17-jdk-alpine'
RUN 'sudo apt update -y'
RUN 'sudo apt install openjdk-11-jdk'
LABEL 'author=sai'
