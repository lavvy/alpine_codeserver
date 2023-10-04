#FROM martinussuherman/alpine:3.13-amd64-glibc    vscody f6aeb74baa96855e41f1d878

#FROM alpine:3.13
FROM alpine:3.14
ARG PB_VERSION=0.18.9

ENV \

   # container/su-exec UID \

   EUID=1001 \

   # container/su-exec GID \

   EGID=1001 \

   # container/su-exec user name \

   EUSER=vscode \

   # container/su-exec group name \

   EGROUP=vscode \

   # should user shell set to nologin? (yes/no) \

   ENOLOGIN=no \

   # container user home dir \

   EHOME=/home/vscode \

   # code-server version \

   #VERSION=3.12.0
   VERSION=4.3.0



   

COPY code-server /usr/bin/

RUN chmod +x /usr/bin/code-server



# Install dependencies

RUN \

   apk --no-cache --update add \

   bash \

   curl \

   git \

   gnupg \

   nodejs nginx unzip ca-certificates s6 docker openssh-client nano gcompat libstdc++  #when u replace glibc image



RUN \

   wget https://github.com/coder/code-server/releases/download/v$VERSION/code-server-$VERSION-linux-amd64.tar.gz && \

   tar x -zf code-server-$VERSION-linux-amd64.tar.gz && \

   rm code-server-$VERSION-linux-amd64.tar.gz && \

   rm code-server-$VERSION-linux-amd64/node && \

   rm code-server-$VERSION-linux-amd64/code-server && \

   rm code-server-$VERSION-linux-amd64/lib/node && \

   mv code-server-$VERSION-linux-amd64 /usr/lib/code-server && \

   sed -i 's/"$ROOT\/lib\/node"/node/g'  /usr/lib/code-server/bin/code-server



# download and unzip PocketBase

ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip

RUN mkdir -p /root/pb

RUN unzip /tmp/pb.zip -d /root/pb/

RUN mkdir -p /root/pb/pb_migrations

RUN mkdir -p /root/pb/pb_hooks



# install flycl

RUN curl -L https://fly.io/install.sh | sh

RUN cp /root/.fly/bin/* /bin

VOLUME /root

EXPOSE 8080

#ENTRYPOINT ["entrypoint-su-exec", "code-server"]

CMD ["code-server"]
#CMD ["/usr/bin/code-server", "--bind-addr", "0.0.0.0:8080"]

#CMD ["/usr/lib/code-server/bin/code-server", "--bind-addr", "0.0.0.0:8080"]

#CMD ["/pb/pocketbase","serve","--http=0.0.0.0:8080"]
