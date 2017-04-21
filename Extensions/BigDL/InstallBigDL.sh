#!/bin/bash
# Install Instructions Courtesy: Sergey Ermolin from Intel
/anaconda/bin/pip install wordcloud
/anaconda/bin/pip install tensorboard
cd /opt
git clone https://github.com/intel-analytics/BigDL.git
cd BigDL
bash make-dist.sh -P spark_2.0
cat > run_notebook.sh << EOF
#!/bin/bash
#setup paths
BigDL_HOME=/opt/BigDL

export PYTHONPATH=\${BigDL_HOME}/pyspark/dl:\${PYTHONPATH}

#use local mode or cluster mode
#MASTER=spark://xxxx:7077 
MASTER="local[4]"
PYTHON_API_ZIP_PATH=\${BigDL_HOME}/dist/lib/bigdl-0.2.0-SNAPSHOT-python-api.zip
BigDL_JAR_PATH=\${BigDL_HOME}/dist/lib/bigdl-0.2.0-SNAPSHOT-jar-with-dependencies.jar
export PYTHONPATH=\${PYTHON_API_ZIP_PATH}:\${PYTHONPATH}
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="notebook --notebook-dir=~/notebooks  --ip=* "
source \${BigDL_HOME}/dist/bin/bigdl.sh

source activate root

\${SPARK_HOME}/bin/pyspark \\
    --master \${MASTER} \\
    --driver-cores 5  \\
    --driver-memory 10g  \\
    --total-executor-cores 8  \\
    --executor-cores 1  \\
    --executor-memory 10g \\
    --conf spark.akka.frameSize=64 \\
  --properties-file \${BigDL_HOME}/dist/conf/spark-bigdl.conf \\
    --py-files \${PYTHON_API_ZIP_PATH} \\
    --jars \${BigDL_JAR_PATH} \\
    --conf spark.driver.extraClassPath=\${BigDL_JAR_PATH} \\
    --conf spark.executor.extraClassPath=bigdl-0.2.0-SNAPSHOT-jar-with-dependencies.jar
EOF
chmod +x run_notebook.sh
