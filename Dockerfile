FROM alpine:latest
ARG LUA_V
RUN apk add --update --no-cache \
    lua${LUA_V} \
    lua${LUA_V}-dev \
    luarocks \
    luarocks${LUA_V} \
&& apk add --no-cache --virtual .build-deps gcc libc-dev \
&& luarocks-${LUA_V} install busted \
&& apk del --purge .build-deps \
&& rm -rf /var/cache/apk/* /tmp/*
WORKDIR /root
CMD ["busted"]