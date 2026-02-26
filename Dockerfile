# (ส่วนเริ่มต้นเหมือนเดิม: FROM, ENV, apt install)
FROM ubuntu:latest
ENV TZ=Asia/Bangkok
RUN apt update && apt install -y openssh-server sudo

# สร้าง ssh runtime
RUN mkdir /var/run/sshd

# ฟังก์ชันช่วยตั้งค่า SSH Directory (เพื่อให้โค้ดดูสะอาดขึ้น)
# สร้าง .ssh และไฟล์ authorized_keys พร้อมตั้ง Permission
# 700 สำหรับโฟลเดอร์ .ssh และ 600 สำหรับไฟล์ authorized_keys (สำคัญมาก ถ้าไม่ตั้งแบบนี้ SSH จะไม่อนุญาตให้ใช้ Key)

# ===== สร้าง admin =====
RUN useradd -m -s /bin/bash admin && \
    echo "admin:1234" | chpasswd && \
    adduser admin sudo && \
    mkdir -p /home/admin/.ssh && \
    touch /home/admin/.ssh/authorized_keys && \
    chown -R admin:admin /home/admin/.ssh && \
    chmod 700 /home/admin/.ssh && \
    chmod 600 /home/admin/.ssh/authorized_keys

# ===== สร้าง user_a =====
RUN useradd -m -s /bin/bash user_a && \
    echo "user_a:1234" | chpasswd && \
    mkdir -p /home/user_a/.ssh && \
    touch /home/user_a/.ssh/authorized_keys && \
    chown -R user_a:user_a /home/user_a/.ssh && \
    chmod 700 /home/user_a/.ssh && \
    chmod 600 /home/user_a/.ssh/authorized_keys

# ===== สร้าง user_b =====
RUN useradd -m -s /bin/bash user_b && \
    echo "user_b:1234" | chpasswd && \
    mkdir -p /home/user_b/.ssh && \
    touch /home/user_b/.ssh/authorized_keys && \
    chown -R user_b:user_b /home/user_b/.ssh && \
    chmod 700 /home/user_b/.ssh && \
    chmod 600 /home/user_b/.ssh/authorized_keys

# ===== สร้าง data และตั้ง Permission (ตามเดิมของคุณ) =====
RUN mkdir -p /data/data_a && mkdir -p /data/data_b
RUN chown user_a:user_a /data/data_a && chmod 700 /data/data_a
RUN chown user_b:user_b /data/data_b && chmod 700 /data/data_b
RUN chmod 755 /data

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]