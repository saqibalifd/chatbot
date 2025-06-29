import 'package:chatbot/constants/app_colors.dart';
import 'package:chatbot/constants/app_icons.dart';
import 'package:chatbot/constants/app_images.dart';
import 'package:chatbot/provider/message_provider.dart';
import 'package:chatbot/provider/theme_provider.dart';
import 'package:chatbot/theme/theme_data.dart';
import 'package:chatbot/widgets/empty_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final themeData = themeProvider.isDarkMode
        ? ApparenceKitThemeData.dark()
        : ApparenceKitThemeData.light();

    return Scaffold(
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: height * .05, left: width * .05, right: width * .05),
                child: _messageAppBar(width, height),
              ),
              Container(
                width: double.infinity,
                height: height * .001,
                color: AppColors.greyColor,
              ),
              Expanded(
                child: messageProvider.messages.isEmpty
                    ? EmptyChatWidget()
                    : ListView.builder(
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
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: isUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                BubbleSpecialOne(
                                  isSender: isUser,
                                  color: isUser
                                      ? Colors.blue
                                      : AppColors.primaryColor,
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
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 20),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                ),

              // Text field + Send button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .03),
                child: TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                      hintText: 'Write your message',
                      hintStyle: GoogleFonts.nunito(
                          textStyle: TextStyle(
                        fontSize: 13,
                      )),
                      fillColor: themeData.colors.primary,
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
                          child: Image.asset(AppIcons.sendButton))),
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _messageAppBar(double width, double height) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.botProfile,
              height: height * .08,
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
        ),
        IconButton(
          icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => themeProvider.toggleTheme(),
        ),
      ],
    );
  }
}
