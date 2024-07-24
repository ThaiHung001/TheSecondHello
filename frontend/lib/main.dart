import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/item.dart';
//* Tệp http/http.dart trong package http chứa các lớp và hàm liên quan đến việc thực hiện các yêu cầu HTTP (HTTP requests) trong ứng dụng Flutter
//* Nói hẳn ra là ko có tệp http thì app ko thể làm việc với server được
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  //* Tạo frontend cho widget Home
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}
//! từ phần này sẽ bắt đầu phân tích, phần bên trên quá dễ hiểu rồi 

class _HomeState extends State<Home> {
  //* Tạo backend cho widget Home
  //?/////////////////////// XỬ LÍ THÔNG TIN //////////////////////////
  //*tạo ra biến lưu đường link đến server
  final String serverUrl = 'http://192.168.207.203:1406';
  //*Tạo đối tượng TextEditingController và gán nó vào nameController
  //* Mục đích là để lưu trữ value của input (lưu giá trị người dùng nhập vào)
  final nameController = TextEditingController();
  //Read  DONE  
  //* NOTE: async và await: thực hiện các công việc bất đồng bộ
  //* async sẽ chạy tất cả code trong 1 function cùng 1 lúc mà ko đợi bất kỳ đoạn code nào, trừ khi gặp await
  //* await sẽ khiến chương trình tạm dừng hoạt động đến khi nó chạy xong (tức là khi nào lấy xong, truyền biến xong thì mới chạy tiếp)
  //* việc dùng async và await sẽ giúp sắp xếp thứ tự chạy code, cũng giúp tiếp kiệm thời gian xử lí 
  //*VD:
  //* cho async vào trước 1 funtion, function đó sẽ lấy giá trị cho biến i từ 1 server, sau đó sẽ console.log() ra i; i+1; i+2;...;i+10 
  //* đặt await vào trước dòng lệnh lấy giá trị cho i, async sẽ đợi cho đến khi lấy xg cho i thì xử lí và in ra i -> i+10 cùng 1 lúc, thay vì chạy từng dòng 
  Future<List<Item>> fetchItems() async {

    //*  dùng http.get để gửi lệnh lấy thông tin ở đường link bên dưới, truyền vào biến response (response có thể là bất cứ loại thông tin j)
    //* bản chất http.get là gọi hàm app.get trên server.js
    final response = await http.get(Uri.parse('$serverUrl/api/v1/items'));
    if (response.statusCode == 200) {
      //*lấy status (1 loại mã của http để thông báo, báo lỗi) của response, '== 200' tức là trong trường hợp lấy thông tin thành công
      //*body của response chứa nội dung phản hồi (VD: List, dictionary, Text,....)
      //*jsonDecode giúp chuyển từ dạng json về ngôn ngữ Dart
      //*rồi trả thông tin đó vào itemList<main.dart>
      final List<dynamic> itemList = jsonDecode(response.body);
      //*itemList<main.dart> đang chứa thông tin của itemList<server.js>, cả 3 dòng code bên dưới là chuyển từ dạng json về dạng class Item,
      //*sau đó truyền vào biến items, dùng toList() để chuyển thành dạng List
      //*Nói cách khác: itemList<server.js> -> itemList<main.dart> -> items
      final List<Item> items = itemList.map((item) {
        return Item.fromJson(item);
      }).toList();
      //*nếu lấy thành công thì biên dịch nó ra items (dạng List)
      return items;
    } else {
      //*nếu lấy thông tin không thành công
      //*throw: thông báo lỗi cho phần xử lí khác của ứng dụng
      //*throw Exception("Text"): dừng thực thi mã và chuyển đến phần ngoại lệ, phần Text bên trong là in ra console.log
      throw Exception("Failed to fetch items.");
    }
  }

  //Create   DONE    
  //*truyền vào biến name dạng String
  Future<Item> addItem(String name) async {
    final response = await http.post(
        //*http.post: gửi dữ liệu lên server, chính xác hơn là gọi hàm app.post trên server
        //*Lấy địa chỉ server
        Uri.parse('$serverUrl/api/v1/items'),
        //*headers phía dưới cho biết dữ liệu gửi đi từ app lên server là dạng json
        //*nói cách khác là thông báo cho server biết kiểu dữ liệu gửi là json
        headers: {
          'Content-Type': 'application/json',
        },
        //*fact: đây là body thường được thấy ở các dòng code khác (VD: res.body, req.body,....)
        //*chuyển dữ liệu dart -> json bằng jsonEncode
        body: jsonEncode({'name': name}));
    if (response.statusCode == 201) {
      //*Nếu mà đã tạo thành công (mã = 201)
      //*vì body của response đã dùng jsonEncode (đã chuyển qua dạng json) nên giờ phải dùng jsonDecode (chuyển lại về dạng dart)
      //*NOTE: jsonDecode chỉ là để giải mã, chứ bản chất vẫn là json
      //*VD tác dụng của jsonDecode: cho 1 đoạn tiếng Pháp, dùng từ điển để hiểu nó, nhưng mình vẫn thấy nó là tiếng Pháp, ko phải tiếng việt
      //*gán dữ liệu json đã được giải mã (để Dart đọc được) vào biến tên json
      final dynamic json = jsonDecode(response.body);
      //*chuyển dữ liệu json thành dạng Item (class) bằng hàm fromJson, gán dữ liệu đã chuyển vào biến item
      //*Như kiểu dùng gg dịch để chuyển tiếng Pháp thành tiếng Việt trong ví dụ trên
      final Item item = Item.fromJson(json);
      //*trả về item
      return item;
    } else {
      //*Nếu tạo không thành công
      //*Dừng toàn bộ chương trình bằng throw
      //*dùng Exception để thông báo (vì Exception là ngoại lệ nên sẽ không bị dừng)
      throw Exception("Failed to add item");
    }
  }

  //Update  DONE    
  //*truyền vào id và giá trị muốn item đổi thành (name của item sẽ thành biến name)
  Future<void> updateItem(int id, String name) async {
    //*http.put: được sử dụng để cập nhật hoặc tạo mới một tài nguyên trên máy chủ
    //*khi gửi yêu cầu put, nó sẽ lấy dữ liệu được gửi lên để cập nhật hoặc tạo mới (nếu dữ liệu chưa có) dữ liệu trên máy chủ
    //*Hay còn có thể hiểu là gọi hàm app.put ở server.js
    final response = await http.put(
        //*dùng link có thêm id để phân biệt
        //*nếu không có id, nó sẽ sửa lại cả kho dữ liệu thay vì 1 phần tử trên đấy
        Uri.parse('$serverUrl/api/v1/items/$id'),
        headers: {
          //*thông báo kiểu dữ liệu gửi lên là json
          'Content-Type': 'application/json',
        },
        //*phiên dịch ngôn ngữ dart thành json
        body: jsonEncode({'name': name}));
    //*nếu update không thành công thì sẽ báo lỗi
    if (response.statusCode != 200) {
      throw Exception('Failed to update item');
    }
    //*thực ra chúng ta có thể đặt thêm trường hợp nếu update thành công thì thông báo, nhwung thế sẽ phải thêm dòng status ở server.js (khá là phiền và không cần thiết)
    //*không thêm thì máy chủ sẽ gửi về theo mặc định: 200  + nội dung lỗi (khá khó để truy xuất và đặt điều kiện)
  }

  //Delete  DONE   
  Future<void> deleteItem(int id) async {
    //* chúng ta sẽ dùng  put vì put là để cập nhật dữ liệu
    //* nên việc chúng ta cần làm bây giờ là xóa dữ liệu đó khỏi itemList<server.js>
    final response =
        await http.delete(Uri.parse('$serverUrl/api/v1/items/$id'));

    if (response.statusCode != 200) {
      //* Nếu trường hợp yêu cầu khôgn thành công
      throw Exception("Failed to delete item"); //* Báo lỗi
    }
    //* ở deleteItem, chúng ta không cần gửi gì hết, vì khi chạy nó sẽ truy cập thẳng vào phần tử cần xóa
    //* chính xác hơn, đường link sẽ là thứ chúng ta gửi lên server
  }

  //?///////////////////////////GIAO DIỆN//////////////////////////////
  @override
  Widget build(BuildContext context) {
    //* tạo Scaffold vì bên trên đã có MaterialApp()
    return Scaffold(
      //* tạo SafeArea và nút tạo item ngang hàng, 3 chức năng: Update, Read, Delete  sẽ nằm bên trong SafeArea
      body: SafeArea(
        //* Column() dùng để hiển thị các widget con của nó theo chiều dọc
        child: Column(
          children: [
            //* FutureBuilder sẽ theo dõi future (ở đây là fetchItems()), mỗi khi future có sự thay đổi thì sẽ build lại giao diện theo trạng thái mới của future
            //* Nhưng thỉnh thoảng FutureBuilder không cập nhật, nên tốt nhất mỗi lần future gặp sự kiện khiến nó thay đổi, ta nên thêm setState() vào để thông báo cho FutureBuilder
            FutureBuilder(
              //* future: thứ mà FutureBuilder() sẽ theo dõi trạng thái
              future: fetchItems(),
              //* builder: phụ trách việc xây dựng lại giao diện mỗi lần future có sự thay đổi
              //* nói ngắn gọn là giao diện của FutureBuilder()
              //* context để xây dựng giao diện
              //* snapshot là biến lưu trữ trạng thái của future (hiện là giá trị trả về của fetchItems(), tức là items )
              builder: (context, snapshot) {
                if (snapshot.hasData) { //* trong trường hợp snapshot có giá trị 
                  return ListView.builder(
                      shrinkWrap: true, //* khiến kích thước ListView co lại, vừa đủ cho content bên trong, nếu là false, ListView chiếm 1 khoảng w x h không giới hạn
                      //* itemCount: số lượng phần tử trong ListView, ở đây itemCount = số lượng phần tử có trong snapshot.data (là items trả về của fetchItems())
                      itemCount: snapshot.data!.length, //* dấu '!' tức là khẳng định snapshot.data không bao giờ có giá trị null 
                                                        //* toán tử khẳng định '!' rất hữu ích vì có những hàm, widget yêu cầu khai báo thêm trường hợp giá trị trong đấy là null
                      //* itemBuilder: được gọi ra mỗi lần hiển thị 1 phần tử trong danh sách
                      //* dùng context để xây giao diện
                      //* index là vị trí của phần tử trong ListView (tính từ 0)
                      //* nói cách khác, itemBuilder là vòng lặp for với số lần lặp là giá trị của itemCount
                      itemBuilder: (context, index) {
                        //* bắt đầu vòng lặp for mang tên 'itemBuilder'
                        final item = snapshot.data![index];//* lấy phần tử trong items
                        return ListTile(  //*tạo ra một ListTile: widget giao diện của phần tử trong ListView 
                            title: Text(item.name), 
                            //* trailing: căn content bên trong sang bên phải của widget cha (ở đây tức là 2 cái icon phía dưới sẽ nằm bên phải của ListTile)
                            trailing: Row(  //* căn các phần tử con theo hàng ngang, tương đương 'display: flex' bên css 
                              //* mainAxisSize:  xác định kích thước của trục chính (main axis) của một widget.
                              //* trục chính của Row() là ngang, Column() là dọc
                              mainAxisSize: MainAxisSize.min, //* MainAxisSize.min: widget sẽ cố gắng thu gọn widget lại hết mức có thể, chỉ vừa đủ cho content bên trong
                              children: [
                                IconButton( //* tạo nút để xóa item 
                                    onPressed: () async {   //* dùng async và await để sắp xếp thứ tự thực hiện: xóa xong mới cập nhật và làm mới widget
                                      //* gọi hàm xóa phần tử, truyền vào thuộc tính id của item để truy tìm phần tử trên itemList
                                      await deleteItem(item.id);
                                      //* thông báo cho widget để cập nhật, làm mới widget (refresh)
                                      setState(() {});
                                    },
                                    //* thiết kế giao diện nút xóa 
                                    icon: const Icon(Icons.delete)),
                                IconButton( 
                                    onPressed: () {
                                      showDialog( //* giống ở phía dưới đã giải thích, cũng là hiện ra 1 pop-up để đổi tên thôi
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog( //* giao diện pop-up
                                              title: const Text('Edit item'),
                                              content: TextFormField(
                                                controller: nameController, //* lấy value của TextFormField truyền vào nameController (nameController = TextEditingController())
                                                decoration:
                                                    const InputDecoration(labelText: 'Item name'),  //* ::placeholder
                                              ),
                                              actions: [    //* Tạo ra 2 nút hủy và xác nhận
                                                TextButton( //* nút hủy
                                                  onPressed: () {
                                                    Navigator.pop(context);   //* tắt pop-up
                                                  },
                                                  child: const Text('Cancel'),  //* thiết kế giao diện nút hủy 
                                                ),
                                                TextButton( //* Nút xác nhận
                                                  onPressed: () {
                                                    updateItem(item.id, nameController.text); //* truyền id item và name (thứ muốn thay đổi) vào hàm updateItem, item khai báo bên trên
                                                    setState(() { //* thông báo cập nhật, nói cách khác là render lại
                                                      nameController.clear(); //* clear dữ liệu của nameController cho các công việc khác
                                                    });
                                                    Navigator.pop(context); //* tắt pop-up
                                                  },
                                                  child: const Text('Edit'),  //* thiết kế giao diện nút Edit
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.edit)),
                              ],
                            ));
                      });
                } else if (snapshot.hasError) { //* trường hợp snapshot có lỗi (snapshot khác rỗng)
                  //* hiện lỗi ra màn hình
                  return Center(child: Text(snapshot.error.toString()));
                } else {  //* trường hợp khác, thường là snapshot ko có dữ liệu, cũng ko có lỗi 
                          //* tức là snapshot rỗng, nói cách khác là chưa nhận được dữ liệu/lỗi từ server

                  //* trả về 1 cái biểu tượng loadding
                  return const Center(child: CircularProgressIndicator());
                }
            })
          ],
      )),
      //* FloatingActionButton (FAB) nằm ở layer riêng, trên cùng, nên chúng ta có thể tùy chỉnh vị trí của FAB mà ko lo sắp xếp các widget khác
      //* mặc định thì FAB sẽ nằm ở góc dưới bên phải màn hình
      floatingActionButton: FloatingActionButton(
          //* tạo nút tạo item, đảm nhiệm chức năng: Add
          onPressed: () {
            //* showDialog() dùng để hiện ra 1 hội thoại lên màn hình, hay còn gọi là pop-up
            showDialog(
              //* context dùng để đặt vị trí cho pop-up showDialog
              //* context: context tức là vị trí mặc định: ở giữa màn hình
              context: context,
              //* hàm builder để xây dựng nội dung của hộp thoại
              builder: (context) {
                //* AlertDialog là widget thiết kế giao diện của hội thoại
                //* Lưu ý: showDialog() đúng là để hiển thị hội thoại, nhưng giao diện như nào thì phải phụ thuộc vào hàm builder
                //*NOTE: AlertDialog chia thành 3 phần trên-content-dưới như là header-body-footer của html 
                return AlertDialog(
                  //* Đặt tiêu đề cho pop-up
                  title: const Text('Add item'),  
                  //* content là để hiển thị nôi dung của hội thoại
                  //* TextFormField tương đương input của hmtl
                  content: TextFormField(
                    //* hàm controller để quản lý value của input
                    controller: nameController,   //* nameController = TextEditingController()
                                                  //* TextEditingController() (TEC) để lấy value và điều khiển value, 
                                                  //* Lưu ý: TEC() không thể truyền giá trị vào bên trong nó mà phải gán 1 biến bằng TEC()
                                                  //* hiểu đơn giản TEC như là 1 class, trong đó có chức năng thu thập value của input và thay đổi, điều khiển value đó
                    //* InputDecoration tương đương ::placholder
                    decoration: const InputDecoration(labelText: 'Item name'),  
                  ),
                  actions: [
                    TextButton( //* Tạo ra nút hủy
                        onPressed: () {
                          //* đóng hội thoại khi bấm 
                          Navigator.pop(context); 
                        },
                        //* hiện ra nút hủy ra ngoài màn hình (tên là 'Cancel')
                        child: const Text('Cancel')),
                    TextButton(  //* tạo ra nút xác nhận (done)
                        onPressed: () {
                          //* khi bấm sẽ chạy Future addItem(), truyền vào đấy value lấy từ input là nameController.text
                          addItem(nameController.text);
                          //* hàm setState sẽ thông báo cho widget (hoặc cho app) là thông tin bên trong đã bị thay đổi, cần làm mới để cập nhật
                          //* hiểu đơn giản là chạy xong code bên trong sẽ làm mới trang (với content đã được thay đổi)
                          setState(() {
                            //* hàm clear() sẽ xóa giá trị của nameController (trước đó nameController Lưu name của item muốn thêm)
                            nameController.clear();
                          });
                          //* tắt hội thoại (tắt pop-up)
                          Navigator.pop(context);
                        },
                        //* hiện nút xác nhận thêm ra ngoài màn hình (tên là 'Add')
                        child: const Text('Add')),
                  ],
                );
              });
          },
          //* xây dựng giao diện của FAB
          //* ở đây là hiển thị ra 1 icon add
          child: const Icon(Icons.add)),
    );
  }
}

