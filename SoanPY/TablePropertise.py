from docx import Document
from docx.oxml import OxmlElement, ns

def convert_path(input_path):
    return input_path.replace('/', '\\')

def config_table_properties(table):
    tbl_pr = table._element.xpath('w:tblPr')[0]

    # Thiết lập chiều rộng 100% cho bảng
    tbl_width = OxmlElement('w:tblW')
    tbl_width.set(ns.qn('w:w'), '5000')  # 5000 tương ứng với 100% trong đơn vị phần nghìn của điểm (twip)
    tbl_width.set(ns.qn('w:type'), 'pct')  # Thiết lập loại là phần trăm
    tbl_pr.append(tbl_width)

    # Căn chỉnh bảng ở giữa
    jc = OxmlElement('w:jc')
    jc.set(ns.qn('w:val'), 'center')
    tbl_pr.append(jc)

    # Thiết lập bọc văn bản là "None"
    tbl_wrap = OxmlElement('w:tblpPr')
    tbl_wrap.set(ns.qn('w:leftFromText'), '0')
    tbl_wrap.set(ns.qn('w:rightFromText'), '0')
    tbl_wrap.set(ns.qn('w:topFromText'), '0')
    tbl_wrap.set(ns.qn('w:bottomFromText'), '0')
    tbl_pr.append(tbl_wrap)

    # Thiết lập khoảng cách từ bên trái (Indent from left)
    indent = OxmlElement('w:tblInd')
    indent.set(ns.qn('w:w'), '0')
    indent.set(ns.qn('w:type'), 'dxa')
    tbl_pr.append(indent)

def main():
    # Đường dẫn cố định tới tài liệu Word
    input_path = r"C:\Users\LENOVO\OneDrive\Desktop\Home\Python\Python\SoanPY\Python.docx"
    path = convert_path(input_path)

    # Mở tài liệu Word đã có sẵn
    doc = Document(input_path)

    # Lặp qua các bảng trong tài liệu
    for table in doc.tables:
        config_table_properties(table)  # Thiết lập các thuộc tính cho mỗi bảng

    # Lưu tài liệu với các thay đổi
    doc.save(path)

if __name__ == "__main__":
    main()
