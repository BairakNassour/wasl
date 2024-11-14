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
  bool isloading=false;
  late List<NotesModel?> _futureMessages;
  final MessageController _messageController = MessageController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // تعديل هنا ليكون النوع void
  void _loadMessages() {
   
      _messageController.fetchMessages().then((onValue){
        print("onValue   $onValue");
        _futureMessages = onValue!;
         setState(() {
         isloading=true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: 
        
        Column(
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
                      Icons.arrow_forward,
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
            isloading?
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _loadMessages();
                  },
               
                   
        
                      child: ListView.builder(
                        itemCount: _futureMessages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color:_futureMessages[index]?.status.toString()=="1"? Colors.transparent:Colors.grey[300],
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
                                _futureMessages[index]?.sender != null
                                    ? (_futureMessages[index]?.sender!.firstname.toString() ?? '') + ' ' + (_futureMessages[index]?.sender!.lastname.toString() ?? '')
                                    : 'غير معروف',
                              ),
                              subtitle: Text(_futureMessages[index]?.title.toString() ?? 'رسالة بدون محتوى'),
                              trailing: Container(
                                width: 90,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        DateFormat('yyyy-MM-dd \n HH:mm').format(DateTime.parse(_futureMessages[index]!.createdAt.toString(),)),
                                      ),SizedBox(width: 5),
                                    Icon(Icons.arrow_forward, size: 10),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessageDetailsPage(message: _futureMessages[index]!),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    
                ),
              ),
            ):Expanded(
              child: CircularProgressIndicator(),
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
