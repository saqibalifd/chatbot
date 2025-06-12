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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: height * .03, left: width * .05, right: width * .05),
                child: _messageAppBar(width),
              ),
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
                padding: EdgeInsets.symmetric(horizontal: width * .03),
                child: TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                      hintText: 'Write yur message',
                      hintStyle: GoogleFonts.nunito(
                          textStyle: TextStyle(
                        fontSize: 13,
                      )),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            if (messageController.text.isNotEmpty) {
                              messageProvider
                                  .sendMessage(messageController.text.trim());
                              messageController.clear();
                            }
                          },
                          child: Image.asset('assets/icons/sendbutton.png'))),
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
        Image.asset('assets/icons/botIcon.png'),
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
}
