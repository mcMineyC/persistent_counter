import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sp = await SharedPreferences.getInstance();
  runApp(MyApp(sp: sp));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sp;
  MyApp({required this.sp});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistent Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: MyHomePage(sp: sp),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final SharedPreferences sp;
  MyHomePage({required this.sp});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      widget.sp.setInt("counter", _counter);
    });
  }
  void _decrementCounter() {
    setState(() {
      _counter--;
      widget.sp.setInt("counter", _counter);
    });
  }
  void _resetCounter() {
    setState(() {
      _counter = 0;
      widget.sp.setInt("counter", 0);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.sp.containsKey("counter")) {
      _counter = widget.sp.getInt("counter") ?? 0;
    }else{
      widget.sp.setInt("counter", 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child:Text('$_counter'))
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: InkWell(
                  onTap: _incrementCounter,
                  child: Center(child: Icon(Icons.add_rounded, size: 100)),
                )
              )
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: InkWell(
                  onTap: _decrementCounter,
                  child: Center(child: Icon(Icons.remove_rounded, size: 100)),
                )
              )
            ),
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetCounter,
        tooltip: 'Reset',
        child: const Icon(Icons.restart_alt_rounded),
      ),
    );
  }
}
