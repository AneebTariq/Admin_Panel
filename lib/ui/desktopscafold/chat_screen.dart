import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/chat_controller.dart';
import '../../models/chat_model.dart';
import '../../models/usermodel.dart';
import '../../repository/sharedprefrence.dart';

class OrderChatPage extends StatefulWidget {
  static const _bubbleGap = 40.0;
  static const _bubbleRadius = 25.0;
  static const _paddingChatField = 8.0;
  final String requestId;
  final String theirName;
  OrderChatPage({
    required this.requestId,
    required this.theirName,
  });

  @override
  _OrderChatPageState createState() => _OrderChatPageState();
}

class _OrderChatPageState extends State<OrderChatPage> {
  static const _insetM = 15.0;
  final _chatController = TextEditingController();
  final _dbClient = FirebaseDbClient();

  UserModel? user;

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  getUser() async {
    user=await SharedPrefClient().getUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black,),onPressed: (){
            Get.back();
          },),
          centerTitle: true,
          title: Text(widget.theirName,style: TextStyle(
            color: Colors.black
          ),),
          backgroundColor: Colors.white,
          elevation: 2,
        ),
        body: StreamBuilder<List<ChatMsgModel>>(
          stream: _dbClient.getOrderChat(widget.requestId),
          builder: (context, snapshot2) {
            if (snapshot2.hasData) {
              return _buildContent(context, snapshot2.data!, user!.userId);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Widget _buildContent(
      BuildContext context, List<ChatMsgModel> data, String userId) {
    final chatList = data.reversed.toList();
    final textTheme = Theme.of(context).textTheme;
    final chatFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: Colors.blue,
      ),
      borderRadius: BorderRadius.circular(25.0),
    );
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: _insetM,
            ),
            reverse: true,
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              final model = chatList[index];
              return Padding(
                padding: const EdgeInsets.only(
                  top: OrderChatPage._bubbleGap,
                ),
                child: model.senderId! == userId
                    ? _buildChatBubble(context, model.message ?? '')
                    : _buildTheirChatBubble(context, model.message ?? ''),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              right: OrderChatPage._paddingChatField,
              left: OrderChatPage._paddingChatField,
              top: OrderChatPage._paddingChatField,
              bottom: 15.00),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  style: textTheme.bodyText2,
                  decoration: InputDecoration(
                    hintText: 'Send Message',
                    hintStyle: textTheme.bodyText2,
                    border: chatFieldBorder,
                    focusedBorder: chatFieldBorder,
                  ),
                ),
              ),
              GestureDetector(
                child: SizedBox(
                  width: 48,
                  child: Icon(
                    Icons.send,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                onTap: () => _onSend(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(BuildContext context, String msg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.all(_insetM),
              child: Text(
                msg,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color:Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(OrderChatPage._bubbleRadius),
                  topRight: Radius.circular(OrderChatPage._bubbleRadius),
                  bottomLeft: Radius.circular(OrderChatPage._bubbleRadius),
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'Sent',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ],
    );
  }

  void _onSend() async {
    final msg = _chatController.text;
    final user = await SharedPrefClient().getUser();
    final String userId = user.userId;
    if (msg.isNotEmpty) {
      await _dbClient
          .sendMessageOrderChat(
          widget.requestId,
          ChatMsgModel(
            message: msg,
            receiverId: widget.requestId.toString(),
            senderId: userId.toString(),
            dateAndTime: DateTime.now().toString(),

          ))
          .whenComplete(() async {
        _chatController.clear();
       // await Repository().sendMessage(msg);
      });
    }
  }

  Widget _buildTheirChatBubble(BuildContext context, String msg) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.all(_insetM),
              child: Text(
                msg,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(OrderChatPage._bubbleRadius),
                  topRight: Radius.circular(OrderChatPage._bubbleRadius),
                  bottomRight: Radius.circular(OrderChatPage._bubbleRadius),
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'Received',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ],
    );
  }
}