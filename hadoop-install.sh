#!/usr/bin/env bash

set -x

HDU='hduser'
HDG='hadoop'
HDHOME='/opt/hadoop'
HDUC="sudo -u ${HDU}"
HDVER="2.4.0"
HADOOP_PACKAGE="http://apache.mirrors.pair.com/hadoop/common/hadoop-${HDVER}/hadoop-${HDVER}.tar.gz"
HDDATA="/data/hadoop"
JAVA_HOME="/usr/lib/jvm/jdk"



# Temporary clean
sudo userdel -r ${HDU}
sudo groupdel ${HDG}


install_packages() {
  sudo apt-get install -y openjdk-7-jdk openssh-server
  sudo ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/lib/jvm/jdk
}


create_user() {
  sudo groupadd ${HDG}
  sudo useradd -d ${HDHOME} -g ${HDG} -G sudo -m -s /bin/bash ${HDU}
}


ssh_keys() {
  ${HDUC} ssh-keygen -t rsa -P '' -f ${HDHOME}/.ssh/id_rsa
  ${HDUC} cp ${HDHOME}/.ssh/id_rsa.pub ${HDHOME}/.ssh/authorized_keys
  ${HDUC} ssh -o "StrictHostKeyChecking no" localhost exit
}

install_hadoop() {
  ${HDUC} curl -so ${HDHOME}/hadoop.tar.gz ${HADOOP_PACKAGE}
  ${HDUC} tar zxf ${HDHOME}/hadoop.tar.gz -C ${HDHOME}
  ${HDUC} rm -f ${HDHOME}/hadoop.tar.gz
  ${HDUC} mv ${HDHOME}/hadoop-${HDVER}/* ${HDHOME} 
  ${HDUC} rmdir ${HDHOME}/hadoop-${HDVER}
}

basic_config() {
  cat << EOF | ${HDUC} tee ${HDHOME}/.bash_profile
source .bashrc
export JAVA_HOME=/usr/lib/jvm/jdk/
export HADOOP_INSTALL=/opt/hadoop
export PATH=\$PATH:\$HADOOP_INSTALL/bin
export PATH=\$PATH:\$HADOOP_INSTALL/sbin
export HADOOP_MAPRED_HOME=\$HADOOP_INSTALL
export HADOOP_COMMON_HOME=\$HADOOP_INSTALL
export HADOOP_HDFS_HOME=\$HADOOP_INSTALL
export YARN_HOME=\$HADOOP_INSTALL
export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_INSTALL/lib/native
export HADOOP_OPTS="-Djava.library.path=\$HADOOP_INSTALL/lib -XX:-PrintWarnings"
EOF

  ${HDUC} sed -i 's:^export JAVA_HOME=.*:export JAVA_HOME='${JAVA_HOME}':' ${HDHOME}/etc/hadoop/hadoop-env.sh
}

hadoop_config() {
  # Core Site
  cat << EOF | ${HDUC} tee ${HDHOME}/etc/hadoop/core-site.xml
<configuration>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
EOF

  # Yarn Site
  cat << EOF | ${HDUC} tee ${HDHOME}/etc/hadoop/yarn-site.xml
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
  </property>
</configuration>
EOF

  # Map Red
  cat << EOF | ${HDUC} tee ${HDHOME}/etc/hadoop/mapred-site.xml
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
EOF

  # HDFS Site
  cat << EOF | ${HDUC} tee ${HDHOME}/etc/hadoop/hdfs-site.xml
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:${HDDATA}/hdfs/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:${HDDATA}/hdfs/datanode</value>
  </property>
</configuration>
EOF

}

data_dir() {
  sudo rm -fr ${HDDATA}
  sudo mkdir -p ${HDDATA}
  sudo mkdir -p ${HDDATA}/hdfs/namenode
  sudo mkdir -p ${HDDATA}/hdfs/datanode
  sudo chown -R ${HDU}:${HDG} ${HDDATA}
}


install_packages
create_user
ssh_keys
install_hadoop
basic_config
hadoop_config
data_dir




