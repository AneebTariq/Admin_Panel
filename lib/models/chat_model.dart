class ChatMsgModel {
  String? dateAndTime;
  String? message;
  String? receiverId;
  String? senderId;

  ChatMsgModel({this.dateAndTime, this.message, this.receiverId, this.senderId});

  ChatMsgModel.fromJson(Map<String, dynamic> json) {
    dateAndTime = json['date_and_time'];
    message = json['message'];
    receiverId = json['receiver_id'];
    senderId = json['sender_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_and_time'] = this.dateAndTime;
    data['message'] = this.message;
    data['receiver_id'] = this.receiverId;
    data['sender_id'] = this.senderId;
    return data;
  }
}