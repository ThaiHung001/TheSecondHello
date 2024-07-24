- StatusCode là mã số mà máy chủ trả về sau mỗi lần app gửi yêu cầu. Nó xác định trạng thái của yêu cầu truyền tải dữ liệu.
### Các mã Status dược dùng tại TheSecondHello:

- 200: yêu cầu đã thành công.
    //server đã tiếp nhận và xử lý yêu cầu từ app

- 201: Created (đã nhận thành công và đã tạo tài nguyên mới)
    //Thông tin về tài nguyên đã tạo sẽ được trả về ở phản hồi (res)
    //Thường mã 201 được sử dụng sau khi gửi yêu cầu POST

- 404: Not Found 
    //Không tìm thấy thông tin mà app yêu cầu trên server
    