import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const WelcomePage(title: 'Basic Task Management App'),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    Future<FirebaseApp> _initializeFirebase() async {
      FirebaseApp firebaseApp = await Firebase.initializeApp();
      return firebaseApp;
    }
    FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginPage(title: 'Login Page');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center (
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Welcome!',
                style: TextStyle(
                  color:Colors.deepOrangeAccent,
                  fontSize:44.0,
                  fontWeight: FontWeight.bold,
                )
              ),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(title: 'Login Page')),
          );
        },
        tooltip: 'Go to Login Page',
        child: const Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static Future<User?> loginUsingEmailPassword({required String email, required String password, required BuildContext content}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e){
      if (e.code == "user-not=found") {
        print("No User found for that email");
      }
    }
    return user;
}

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Login to Your Account',
              style: TextStyle(
                color: Colors.deepOrangeAccent,
                fontSize: 28.0,
                fontWeight:FontWeight.bold,
              )
            ),
            SizedBox(
              height: 44.0,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "User Email",
                prefixIcon: Icon(Icons.mail, color: Colors.deepOrange,)
              ),
            ),
            SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "User Password",
                prefixIcon: Icon(Icons.lock, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Text(
              "Don't Remember your Password?",
              style: TextStyle(color: Colors.black38),
            ),
            const SizedBox(
              height: 88.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Colors.deepOrange,
                elevation: 0.0,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                onPressed: () async {
                  User? user = await loginUsingEmailPassword(email: _emailController.text, password: _passwordController.text, content: context);
                  print(user);
                  if(user == null){
                    print("null user");
                  }
                  if(user != null){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(title: 'Home Page')));
                  }
                },
                child: Text("Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight:FontWeight.bold,
                ))
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 12.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                  fillColor: Colors.deepOrange,
                  elevation: 0.0,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ToDoList(title: 'To-Do List')));
                  },
                  child: Text("To-Do List",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight:FontWeight.bold,
                      ))
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                  fillColor: Colors.deepOrange,
                  elevation: 0.0,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Reminders(title: 'Reminders')));
                  },
                  child: Text("Reminders",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight:FontWeight.bold,
                      ))
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToDoList extends StatefulWidget {
  ToDoList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<String> _todos = <String>[];

  void _addToDoItem(String item) {
    setState(() {
      _todos.add(item);
    });
  }

  Widget _buildToDoItem(String item) {
    return ListTile(title: Text(item));
  }

  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a To-Do'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your New To-Do'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addToDoItem(_textFieldController.text);
                var timestamp = new DateTime.now().millisecondsSinceEpoch;
                FirebaseDatabase.instance.ref().child("Items/To-Dos/td" + timestamp.toString()).set( {
                  "Task" : _textFieldController.text
                }
                ).then((value) {
                  print("Successfully added the to-do.");
                  _textFieldController.clear();
                }).catchError((error) {
                  print("Failed to add. " + error.toString());
                });
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
    },
    );
  }

  List<Widget> _getItems() {
    final List<Widget> _toDoWidgets = <Widget>[];
    for (String item in _todos) {
      _toDoWidgets.add(_buildToDoItem(item));
    }
    return _toDoWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),

      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _getItems()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ));
  }
}

class Reminders extends StatefulWidget {
  Reminders({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<String> _todos = <String>[];

  void _addReminder(String item) {
    setState(() {
      _todos.add(item);
    });
  }

  Widget _buildReminder(String item) {
    return ListTile(title: Text(item));
  }

  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a Reminder'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your New Reminder'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addReminder(_textFieldController.text);
                var timestamp = new DateTime.now().millisecondsSinceEpoch;
                FirebaseDatabase.instance.ref().child("Items/Reminders/rem" + timestamp.toString()).set( {
                  "Task" : _textFieldController.text
                }
                ).then((value) {
                  print("Successfully added the reminder.");
                  _textFieldController.clear();
                }).catchError((error) {
                  print("Failed to add. " + error.toString());
                });
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  List<Widget> _getItems() {
    final List<Widget> _remWidgets = <Widget>[];
    for (String item in _todos) {
      _remWidgets.add(_buildReminder(item));
    }
    return _remWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),

        ),
        body: ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            children: _getItems()),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add),
        ));
  }
}
