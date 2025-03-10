FROM arm64v8/ubuntu:latest

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y build-essential gdb llvm python3 python3-pip strace

RUN pip install frida-tools --break-system-packages

WORKDIR /workspace
