FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Bangkok

RUN apt update && apt install -y openssh-server sudo

# สร้าง ssh runtime
RUN mkdir /var/run/sshd

# ===== สร้าง admin =====
RUN useradd -m -s /bin/bash admin && \
    echo "admin:1234" | chpasswd && \
    adduser admin sudo

# ===== สร้าง user_a =====
RUN useradd -m -s /bin/bash user_a && \
    echo "user_a:1234" | chpasswd

# ===== สร้าง user_b =====
RUN useradd -m -s /bin/bash user_b && \
    echo "user_b:1234" | chpasswd

# ===== สร้าง data =====
RUN mkdir -p /data/data_a && \
    mkdir -p /data/data_b

# ตั้ง permission
RUN chown user_a:user_a /data/data_a && \
    chmod 700 /data/data_a

RUN chown user_b:user_b /data/data_b && \
    chmod 700 /data/data_b

RUN chmod 755 /data

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]