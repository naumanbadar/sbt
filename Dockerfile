FROM openjdk:8

MAINTAINER Nauman Badar

# set correct time zone. In my case it is Stockholm. This is a temporary fix until docker fixes the issue of always getting container with UTC timezone.
ENV TZ=Europe/Stockholm
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \

# some usefull command aliases
&& echo "alias ll='ls -la'" >> /root/.bashrc \
&& echo "alias l=ls" >> /root/.bashrc \


# sbt
#~~~~

# this is required otherwise it will give the error 'E: The method driver /usr/lib/apt/methods/https could not be found.'
# when trying to install sbt in next step.
&& apt-get update \
&& apt-get install -y apt-transport-https \
# now install sbt as per intructions on its website.
&& echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \
&& apt-get update \
&& apt-get install -y sbt

# node
#~~~~~
# node is required for running play tests
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
&& apt-get install -y nodejs
#now export SBT_OPTS="$SBT_OPTS -Dsbt.jse.engineType=Node"
#The above declaration ensures that Node.js is used when executing any sbt-web plugin.
ENV SBT_OPTS "$SBT_OPTS -Dsbt.jse.engineType=Node"

WORKDIR project

