const express = require('express')
//app configuration
    const app = express() 
    const port = 1406;
//middleware confiuration
    app.use(express.json())
// define item list 
    let itemList = [
        {id: 1,  name: "hello"},
        // {id: 2,  name: "hi"},
        // {id: 3,  name: "goodluck"}
    ]
//api routes                                            //res là response: dữ liệu trả về cho app
//CRUD operations                                       //req là resquest: dữ liệu app gửi lên server
    ///////////read
    //tại link /app/v1/items, in ra itemList 
    //nói cách khác là gửi itemList lên  trên cơ sở dữ liệu
    app.get('/api/v1/items', (req,res) => {
        return res.json(itemList);  //trả về itemList
    })
    ////////create
    //truy cập vào đường link của itemList, tạo 1 phần tử mới
    // id là độ dài của itemList + 1
    // name là giá trị thuộc tính name của dữ liệu gửi lên (req.body)
    app.post('/api/v1/items', (req,res) => {
        let newItem = {                 // Tạo ra 1 Item có thuộc tính là id
            id: itemList.length + 1,
            name: req.body.name                                 //req.body: lưu trữ dữ liệu gửi lên server.js
        }                                                       //VD: tạo ra 1 app (tên appHello), dữ liệu của appHello gửi lên sẽ tạm lưu ở req.body
        itemList.push(newItem)                                  
        
        res.status(201).json(newItem)   // Mã status 201: Created (tạo dữ liệu thành công)                       
    })                                  // json(newItem) gửi dữ liệu newItem dưới dạng json (json là dạng dữ liệu để lưu trữ)
    ////////////update
    // tìm đến item bằng id, dùng url             //chúng ta có thể dùng url để tìm item, VD: ..item/3 -> tìm đến item có id = 3 
    // gán dữ liệu muốn update vào biến updatedItem 
    // lọc dữ liệu bằng id (vì mỗi phần tử chỉ có 1 id duy nhất)
    // nếu tìm thấy sẽ thay thế phần tử bằng updatedItem
    // nếu không sẽ báo lỗi
    app.put('/api/v1/items/:id', (req,res) => {                          //req.params.id: tìm ':id' ở trên url (req.params: đọc)
        let itemId = +req.params.id;
        let updatedItem = {
            id: itemId,
            name: req.body.name
        };
        let index = itemList.findIndex(item => item.id === itemId)      //findIndex sẽ tìm vị trí của phần tử đầu tiên thỏa mãn điều kiện, bắt đầu đếm từ 1
                                                                        //findIndex sẽ trả về là -1 nếu không tìm thấy 
        if (index  !== -1 ) {   //trường hợp tìm thấy item    
            itemList[index] = updatedItem;  //update nó
            res.json(updatedItem)
        } else {                // Nếu không tìm thấy item, trả về thông báo
            res.status(404).json({message: "Item not found "})  //mã status 404: not found (không tìm được thông tin người dùng yêu cầu)
        }
    })
    ////////delete
    //cũng tìm item bằng id qua url 
    //tìm vị trí của nó bằng findIndex và id vừa lấy được
    //xóa nó
    //nếu không tìm thấy item thì thông báo
    app.delete('/api/v1/items/:id', (req,res) => {
        let itemId = +req.params.id;                             //gán id lấy từ url vào itemId
        let index = itemList.findIndex(item => item.id === itemId)  

        if (index !== -1) {     //tìm thấy phần tử
            let deletedItem = itemList.splice(index,1)          // hàm splice, xóa phần tử ở vị trí index, xóa 1 phần tử tính từ vị trí index và lưu phần tử đó vào deletedItem
            res.json(deletedItem[0]);                           //trả về app phần từ vừa xóa (chắc là để thông báo)
        } else {                //nếu không tìm thấy
            res.status(404).json({message: "Item not found "})  //thông báo ko tìm thấy
        }
    })
//listeners
app.listen(port, () => {
    console.log(`http://localhost:${port}/api/v1/items`);       // Đặt luôn đường link tìm kiếm cho nhanh
})