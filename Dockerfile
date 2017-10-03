FROM alpine:3.6
RUN apk update
RUN apk add darkhttpd markdown grep ffmpeg git sed make bash
RUN adduser -s /bin/bash -h /home/notflix -g notflix -S -D notflix notflix
WORKDIR /home/notflix
VOLUME /home/notflix/videos
COPY . .
RUN make install && make clean
RUN apk del git make
RUN cp /usr/lib/notflix/style.css /usr/lib/notflix/search.js /usr/lib/notflix/script.js .
RUN chown -R notflix /home/notflix
USER notflix
CMD darkhttpd "$HOME" --index contents.html --log "$HOME/darkhttpd.log" --pidfile "$HOME/darkhttpd.pid" --no-server-id
