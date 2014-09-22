# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fileutils'
require 'rubygems'
include FileUtils

if ENV['BUILD_API'] == '1' then
  # Build Javadoc

  cd("..")

  java8_doc_fix = ""

  java_ver = Gem::Version.new(`java -version 2>&1 | awk -F '"' '/version/ {print $2}'`.gsub('_', '.'))

  if java_ver > Gem::Version.new("1.8") then
    puts "Detected Java8, adding -Xdoclint:none"
    java8_doc_fix = '-DadditionalJOption="-Xdoclint:none"'
  end

  puts "Running mvn clean install -DskipTests"
  puts `mvn clean install -DskipTests`

  puts "Generating Javadoc"
  puts `mvn javadoc:aggregate -Pdocs-and-source $JAVA8JAVADOCFIX -Dmaven.javadoc.failOnError=false -Dquiet=true -Dheader="<a href=\"/docs/0.6-incubating/\" target=\"_top\"><h1>Back to Flink Documentation</h1></a>"`
  
  cd("docs")

  mkdir_p "api"

  source = "../target/site/apidocs"
  dest = "api/java/"

  puts "cp -r " + source + "/. " + dest
  cp_r(source + "/.", dest)

end