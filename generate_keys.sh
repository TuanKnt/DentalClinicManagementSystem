#!/bin/bash

# Khai báo danh sách theo định dạng "hậu_tố_file_key:email_hoặc_tên"
ACCOUNTS=(
    "dung:dungnguyen231056"
    "tuan:tuanknhe161046@fpt.edu.vn"
    "thai:nguyenthai15090"
    "wolf:wolfsama2006@gmail.com"
    "kien:Kienphan216"
)

echo "Bắt đầu tạo hàng loạt SSH Keys..."
echo "--------------------------------"

for acc in "${ACCOUNTS[@]}"; do
    KEY_NAME="${acc%%:*}"
    EMAIL="${acc#*:}"
    FILE_PATH="$HOME/.ssh/id_ed25519_$KEY_NAME"
    
    echo "-> Đang xử lý: $KEY_NAME ($EMAIL)"
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$FILE_PATH" -N "" >/dev/null 2>&1
    echo "   Đã tạo thành công: $FILE_PATH"
done

echo "--------------------------------"
echo "Hoàn tất sinh khóa!"
