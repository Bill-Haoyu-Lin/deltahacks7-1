import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Example Dialogflow Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: new HomePageDialogflow(),
    );
  }
}

class HomePageDialogflow extends StatefulWidget {
  HomePageDialogflow({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageDialogflow createState() => new _HomePageDialogflow();
}

class _HomePageDialogflow extends State<HomePageDialogflow> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  List<int> result_diabete = new List(9);
  List<int> result_stroke = new List(10);
  var position =0;
  var check_ans =0;
  var start_pos =0;
  var choose_stoke = -1;
  var index_value =1;
  var test = 1;
  var pass5 = 0;
  var determine = "Do you smoke?\n1) yes\n2) no";
  var questions_stroke =["What's your age?",
    "Can I have your gender please?\n1)male\n2female\nplease enter in number)",
    "What is your most recent weight in KG?\nyou can divide pound/2.21 to convert",
    "What is your most recent height in cm?\n 1 cm = feet x 30.48",
    "Pulse if known,otherwise enter 0",
    "How often do you feel numbness?\nrate from 1-3,\n1 mean not frequent\n3 means very frequent",
    "How often do you see things in double?\nrate from 1-3,\n1 mean not frequent\n3 means very frequent",
    "How often do you have trouble seeing things?\nrate from 1-3,\n1 mean not frequent\n3 means very frequent",
    "How often do you feel dizzy?\nrate from 1-3,\n1 mean not frequent\n3 means very frequent",
    "How often do you have headace?\nrate from 1-3,\n1 mean not frequent\n3 means very frequent",
  ];
  var questions_diabete =["What's your age?",
    "Can I have your gender please?\n1)male\n2female\nplease enter in number)",
    "What is your most recent weight in KG?\nyou can divide pound/2.21 to convert",
    "What is your most recent height in cm?\n 1 cm = feet x 30.48",
    "Pulse if known,otherwise enter 0",
    "How often do you go to washroom?\nrate from 1-3,\n1 mean not frequent\n3 means very frequent",
    "How often do you feel Hungry?\nrate from 1-3,\n1 mean not frequent\n3 means very frequent",
    "How often do you feel tired?\nrate from 1-3,\n1 mean not frequent\n3 means very frequent",
    "How often do you drink alcohol?\nrate from 1-3,\n1 mean not frequent\n3 means very frequent",
  ];
  var bp_quote=[
    "Do you know that the best drink for lowering blood pressure is Tomato juice?",
  ];
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void Response(text) async {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Bot",
      type: false,
    );

    if(position==10&&choose_stoke ==0){
      result_diabete[position-1]= int.parse(text)-2;
      check_ans=0;
      position=0;
      start_pos=0;

      Map<String, List<int>> data =  {
        'ans' : [76,0,75,175,100,-1,0,1,0,1]
      };
      String body = jsonEncode(data);
      var response = await http.post(
          new Uri.http("localhost:5000", ''),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      var data_back=jsonDecode(response.body);
      message.text = "You have a "+data_back["response"][0]+" risk on getting "+
          data_back["response"][1]+"\n Here are our suggestions"+data_back["response"][2];

    }else if(position==11&&choose_stoke ==1){
      result_stroke[position-2]= int.parse(text)-2;
      check_ans=0;
      position=0;
      start_pos=0;
      Map<String, List<int>> data =  {
      'ans' : [76,0,75,175,100,-1,0,1,0,1]
      };
      String body = jsonEncode(data);
      var response = await http.post(
      new Uri.http("localhost:5000", ''),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
      var data_back=jsonDecode(response.body);
      message.text = "You have a "+data_back["response"][0]+" risk on getting "+
      data_back["response"][1]+"\n Here are our suggestions"+data_back["response"][2];
    }

    if(position==6&&choose_stoke==-1){
      if(text == "1"){
        choose_stoke=1;
        message.text = questions_stroke[position-1];
      }else{
        choose_stoke=0;
        message.text = questions_diabete[position-1];
      }
      position+=1;
    }else if(position!=0&&check_ans!=0){
      if(choose_stoke ==0){
        message.text = questions_diabete[position-index_value+1+pass5]+position.toString();
        result_diabete[position-index_value+1+pass5]= int.parse(text)-2;
        position+=1;
      }else if(position == 5){
        message.text = determine;
        index_value = 3;
        pass5 = 1;
        position+=1;
      }else{
        message.text = questions_stroke[position-index_value+1+pass5]+position.toString();
        result_stroke[position-index_value+1+pass5]= int.parse(text)-2;
        position+=1;


      }
    }

    if(text=="1"&& position==0&&check_ans == 1){
      message.text = questions_diabete[0];
      position = 1;
    }else if(text=="2"&& position==0&&check_ans == 1){
      message.text = bp_quote[0];
      check_ans = 0;
      start_pos=1;
    }

    if(text == "hello"){
      message.text = "Hello :D\nWhat can I help you with today?\n1)Check health status\n"
          +"2)Learn more about blood pressure\n"
          +"please reply with 1 or 2";
      check_ans = 1;
      start_pos=1;
    }

    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "User",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    Response(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Flutter and Blood Health Demo"),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(child: new Text('B')),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(
            child: new Text(
              this.name[0],
              style: new TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
