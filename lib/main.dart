import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'UI/provider/book_provider.dart';
import 'UI/screens/book/list_books.dart';
import 'data/repository/book_firebase_repository.dart';
import 'data/repository/book_repository.dart';

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListBook();
  }
}

void main() async {
  final BookRepository bookRepository = BookFirebaseRepository(
    baseUrl:
        'https://w8-practice-finish-the-crud-default-rtdb.asia-southeast1.firebasedatabase.app/',
    bookCollection: 'books',
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => BookProvider(bookRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const BookApp(),
      ),
    ),
  );
}
