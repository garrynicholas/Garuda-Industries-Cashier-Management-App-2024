import 'package:flutter/material.dart';
import 'package:garuda_industries/Provider/cartprovider.dart';
import 'package:garuda_industries/Views/Admin/purchaseorder.dart';
import 'package:garuda_industries/Views/Admin/salespage.dart';
import 'package:garuda_industries/Views/auth.dart';
import 'package:garuda_industries/Views/Admin/adminhome.dart';
import 'package:provider/provider.dart';

void main() {
  // Initialize flutter engine before execute code
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        routes: {
          '/sales': (context) => SalesPage(),
        },
        home: const AuthScreen(),
      ),
    );
  }
}
