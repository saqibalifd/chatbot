import 'package:chatbot/constants/app_colors.dart';
import 'package:chatbot/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Scroll to bottom when messages change
    final provider = Provider.of<MessageProvider>(context);
    provider.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        excludeHeaderSemantics: true,
        title: const Text("Chat Bot"),
        backgroundColor: Colors.white,
      ),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  itemCount: messageProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = messageProvider.messages[index];
                    final isUser = message['isUser'];
                    final time = message['time'];

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          BubbleSpecialOne(
                            isSender: isUser,
                            color:
                                isUser ? Colors.blue : const Color(0XFFE5E5E5),
                            seen: true,
                            text: message['text'],
                            tail: true,
                            textStyle: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0XFF000000),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 20),
                            child: Text(
                              time,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0XFF808080),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Typing indicator
              if (messageProvider.isTyping)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        messageProvider.responseText,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),

              // Text field + Send button
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.green, width: 2),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.emoji_emotions_outlined),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FloatingActionButton(
                      heroTag: "send_button",
                      onPressed: () {
                        if (messageController.text.isNotEmpty) {
                          messageProvider
                              .sendMessage(messageController.text.trim());
                          messageController.clear();
                        }
                      },
                      backgroundColor: const Color(0XFF25D366),
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.send),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _messageAppBar(double width) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets\icons\botIcon.png'),
        ),
        SizedBox(
          width: width * .02,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat Bot',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: Color(0xff3ABF38),
                ),
                SizedBox(
                  width: width * .01,
                ),
                Text(
                  'Online',
                  style: GoogleFonts.nunito(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff3ABF38)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Widget _myMessages(double height, double width, String message) {
  //   return ConstrainedBox(
  //     constraints: BoxConstraints(
  //       maxWidth: width * 0.6,
  //     ),
  //     child: Container(
  //       padding: EdgeInsets.all(20),
  //       margin: EdgeInsets.symmetric(vertical: 5),
  //       decoration: BoxDecoration(
  //           color: Colors.blue,
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20),
  //               bottomLeft: Radius.circular(20),
  //               bottomRight: Radius.circular(20))),
  //       child: Text(
  //         message,
  //         style: GoogleFonts.inter(
  //           fontSize: 14,
  //           color: Colors.white,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _otherMessages(double height, double width, String message) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //     children: [
  //       CircleAvatar(
  //         radius: 10,
  //         backgroundColor: Colors.transparent,
  //         backgroundImage: AssetImage(widget.image),
  //       ),
  //       SizedBox(
  //         width: width * .01,
  //       ),
  //       ConstrainedBox(
  //         constraints: BoxConstraints(
  //           maxWidth: width * 0.6,
  //         ),
  //         child: Container(
  //           padding: EdgeInsets.all(20),
  //           margin: EdgeInsets.symmetric(vertical: 5),
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(20),
  //                   topRight: Radius.circular(20),
  //                   bottomRight: Radius.circular(20))),
  //           child: Text(
  //             message,
  //             style: GoogleFonts.inter(
  //               fontSize: 14,
  //               color: Colors.black,
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _messageField(double height, double width) {
  //   return TextFormField(
  //     controller: _messageController,
  //     decoration: InputDecoration(
  //         hintText: 'Write yur message',
  //         hintStyle: GoogleFonts.nunito(
  //             textStyle: TextStyle(
  //           fontSize: 13,
  //         )),
  //         fillColor: Colors.white,
  //         filled: true,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(50),
  //           borderSide: BorderSide.none,
  //         ),
  //         suffixIcon: Image.asset('assets/icons/send.png')),
  //   );
  // }
}
