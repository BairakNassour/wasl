import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasl/component/Color.dart';
import 'package:wasl/controller/getMessagesController.dart';
import 'package:wasl/model/MessagesModel.dart';
import 'package:wasl/view/MessageDetails.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late Future<List<NotesModel>?> _futureMessages;
  final MessageController _messageController = MessageController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // تعديل هنا ليكون النوع void
  void _loadMessages() {
    setState(() {
      _futureMessages = _messageController.fetchMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // الجزء العلوي مع الخلفية
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/background.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
        
            // عنوان الصفحة
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'الرسائل',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: globalcolor, // لون العنوان
                ),
              ),
            ),
        
            // قائمة الرسائل
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _loadMessages();
                  },
                  child: FutureBuilder<List<NotesModel>?>(
                    future: _futureMessages,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('حدث خطأ أثناء جلب البيانات'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('لا توجد رسائل متاحة'));
                      }
        
                      List<NotesModel> messages = snapshot.data!;
                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          NotesModel message = messages[index];
                          return Container(
                            decoration: BoxDecoration(
                              color:message.status.toString()=="1"? Colors.transparent:Colors.grey[300],
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.zero,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: Image.asset("assets/messageicon.png"),
                              title: Text(
                                message.sender != null
                                    ? (message.sender!.firstname ?? '') + ' ' + (message.sender!.lastname ?? '')
                                    : 'غير معروف',
                              ),
                              subtitle: Text(message.title ?? 'رسالة بدون محتوى'),
                              trailing: Container(
                                width: 65,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        DateFormat('yyyy-MM-dd \n HH:mm').format(DateTime.parse(message.createdAt.toString(),)),
                                      ),SizedBox(width: 5),
                                    Icon(Icons.arrow_forward, size: 10),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessageDetailsPage(message: message),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        
            // الجزء السفلي الأخضر
            Container(
              height: 40,
              width: double.infinity,
              color: globalcolor, // اللون الأخضر السفلي
            ),
          ],
        ),
      ),
    );
  }
}
