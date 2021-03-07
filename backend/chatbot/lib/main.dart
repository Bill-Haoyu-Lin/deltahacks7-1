import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

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
  var result_arr = new List(9);
  var position =0;
  var check_ans =0;
  var questions =["What's your age?",
    "Can I have your gender please?\n1)male\n2female\nplease enter in number)",
    "What is your most recent weight in KG?\nyou can divide pound/2.21 to convert",
    "What is your most recent height in cm?\n 1 cm = feet x 30.48",
    "Pulse if known,otherwise enter 0",
    "How often do you go to washroom?\nrate from 1-5,\n1 mean not frequent\n5 means very frequent",
    "How often do you feel Hungry?\nrate from 1-5,\n1 mean not frequent\n5 means very frequent",
    "How often do you feel tired?\nrate from 1-5,\n1 mean not frequent\n5 means very frequent",
    "How often do you drink alcohol?\nrate from 1-5,\n1 mean not frequent\n5 means very frequent",
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
    if(position==9){
      result_arr[position-1]= int.parse(text);
      check_ans=0;
      position=0;
      message.text = "Your result is pretty good"+result_arr.toString();
    }
    if(position!=0&&check_ans!=0){
      message.text = questions[position];
      result_arr[position-1]= int.parse(text);
      position+=1;
    }

    if(text=="1"&& position==0&&check_ans == 1){
      message.text = questions[position];
      position = 1;
    }else if(text=="2"&& position==0&&check_ans == 1){
      message.text = bp_quote[0];
      check_ans = 0;
    }

    if(text == "hello"){
      message.text = "Hello :D\nWhat can I help you with today?\n1)Check health status\n"
          +"2)Learn more about blood pressure\n"
          +"please reply with 1 or 2";
      check_ans = 1;
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
        title: new Text("Flutter and Dialogflow"),
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
