

### NOTE
Mục đích của TheSecondHello là để làm tài liệu tham khảo cho: CRUD giữa nodejs và flutter
Toàn bộ comment được Nguyễn Thái Hùng tạo ra
Để dễ nhìn dễ hiểu, xin vui lòng cài các Extension sau (không cài chả sao):
    Better Comments - A: Aaron Bond   (Thêm màu cho comment)
    TODO Highlight - A: Wayou Liu   (Làm nổi bật các từ quan trọng)    
    indent-rainbow - A: oderwat 
Thêm đoạn code phía dưới vào settings.json để hiện màu do NTH custom


    "todohighlight.isEnable": true,
    "todohighlight.isCaseSensitive": true,
    "todohighlight.keywords": [
        {
            "text": " NOTE: ",
            "color": "#f700ff",
            "border": "1px solid #f700ff",
            "borderRadius": "2px",
            "backgroundColor": "rgba(0,0,0,.2)",
        },
        {
            "text": " DONE ",
            "color": "#1bff00",
            "border": "1px solid #1bff00",
            "borderRadius": "2px",
            "backgroundColor": "rgba(0,0,0,.2)",
            //other styling properties goes here ... 
        }
    ],

    "better-comments.tags": [
        {   //! 
            "tag": "!",
            "color": "#FF2D00",
            "strikethrough": false,
            "underline": false,
            "backgroundColor": "transparent",
            "bold": false,
            "italic": false
        },
        {   //?
            "tag": "?",
            "color": "#3498DB",
            "strikethrough": false,
            "underline": false,
            "backgroundColor": "transparent",
            "bold": false,
            "italic": false
        },
        {   //*
            "tag": "*",
            // "color": "#98C379",
            "color": "#647e61",
            "strikethrough": false,
            "underline": false,
            "backgroundColor": "transparent",
            "bold": false,
            "italic": false
        },
        {   // |._.| NOTE CỦA NTH 
            "tag": "|._.|",
            "color": "#00fffb",
            "strikethrough": false,
            "underline": false,
            "backgroundColor": "transparent",
            "bold": false,
            "italic": false
        },
        {   // |orangeTag|
            "tag": "|orangeTag|",
            "color": "#FF8C00",
            "strikethrough": false,
            "underline": false,
            "backgroundColor": "transparent",
            "bold": false,
            "italic": false
        },
        {   // |yellowTag| 
            "tag": "|yellowTag|",
            "color": "#f0ff00",
            "strikethrough": false,
            "underline": false,
            "backgroundColor": "transparent",
            "bold": false,
            "italic": false
        },
    ]