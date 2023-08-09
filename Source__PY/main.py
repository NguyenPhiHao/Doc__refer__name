Birth = [25, 12, 1999]
Address = ["Luong Son", "Bac Binh", "Binh Thuan"]
Information = ["Nguyen Phi Hao", Birth, Address]
print(Information)

# Truy cập Từ ngoài vào trong
Temp = Information[1]
Temp[0] = 20
print(Information)

# Hoặc có thể viết ngắn gọn như sau
Information[1][0] = 10
print(Information)