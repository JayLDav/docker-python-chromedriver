FROM python:3.7-alpine3.8

# update apk repo
RUN echo "http://dl-4.alpinelinux.org/alpine/v3.8/main" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.8/community" >> /etc/apk/repositories

# install chromedriver
RUN apk update
RUN apk add chromium chromium-chromedriver

# install selenium
RUN pip install selenium==3.13.0

# install pandas
RUN apk add make automake gcc g++ subversion git python3-dev	
RUN pip install numpy
RUN pip install pandas

 # install civis
RUN pip install civis

# install Pillow requirements
RUN apk add build-base python-dev py-pip jpeg-dev zlib-dev
ENV LIBRARY_PATH=/lib:/usr/lib
RUN pip install Pillow

# Add sudo, because we need it to kill the swap memory every so often
# http://www.yourownlinux.com/2013/10/how-to-free-up-release-unused-cached-memory-in-linux.html
RUN apk --no-cache add sudo

#Run in Civis Jupyter notebook
RUN pip install civis-jupyter-notebook && \
    civis-jupyter-notebooks-install

# Add Tini
ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENV DEFAULT_KERNEL python3  # set to one of python3, python2 or ir
EXPOSE 8888
WORKDIR /root/work
ENTRYPOINT ["/tini", "--"]
CMD ["civis-jupyter-notebooks-start"]
