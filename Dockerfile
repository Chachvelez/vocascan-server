FROM python:3.8-alpine as builder

RUN apk --no-cache add cmake clang clang-dev make gcc g++ libc-dev linux-headers musl-dev perl git

RUN pip install conan

RUN git clone https://github.com/vocascan/vocascan-server.git

WORKDIR /vocascan-server

RUN mkdir build && cd build && conan install -s compiler.libcxx='libstdc++11' .. --build

RUN cmake -DCMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_BUILD_TYPE=Release -S . -B build && cmake --build build

FROM alpine:latest

RUN apk add --no-cache libstdc++

COPY --from=builder /vocascan-server/build/bin/vocascan-server /vocascan-server

CMD ./vocascan-server
