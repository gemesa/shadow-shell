FROM arm64v8/ubuntu:latest

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y build-essential gdb llvm

WORKDIR /workspace
