class Item {
  final int id;         //khai báo id
  final String name;    //khai báo name

  Item({required this.id, required this.name}); //contructor

  factory Item.fromJson(Map<String, dynamic> json) {  //Tạo Item từ một đối tượng dạng json 
                                                      //với biến tên là json (yep, json là tên biến) có cấu trúc là Map<String, dynamic> (key là String, value là dynamic)

    return Item(id: json['id'], name: json['name']);  //Trả về Item (dạng class) với thuộc tính id có giá trị là giá trị của thuộc tính 'id' của biến json
                                                      //                             thuộc tính name có giá trị là giá trị của thuộc tính 'name" của biến json
  }

  //Hàm factory: dùng để tạo đối tượng, cho phép tạo ra 1 đối tượng từ phương thức khác
  //             thay vì sử dụng hàm khởi tạo thông thường
  

  // ở đây, hàm factory có vai trò chỉnh sửa kiểu dữ liệu đầu vào đầu ra
}