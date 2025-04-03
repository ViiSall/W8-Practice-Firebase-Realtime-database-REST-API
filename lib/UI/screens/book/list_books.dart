import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/book.dart';
import '../../provider/book_provider.dart';
import '../widgets/input_book.dart';

class ListBook extends StatelessWidget {
  const ListBook({super.key});

  void _onAddPressed(BuildContext context) {
    final BookProvider bookProvider = context.read<BookProvider>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputBook(title: "Add", isEditMode: false),
      ),
    );
    bookProvider.fetchBook();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    Widget content = Text('');
    if (bookProvider.isLoading) {
      content = CircularProgressIndicator();
    } else if (bookProvider.hasData) {
      List<Book> bookList = bookProvider.bookState!.data!;

      if (bookList.isEmpty) {
        content = Error() as Widget;
      } else {
        content = ListView.builder(
          itemCount: bookList.length,
          itemBuilder:
              (context, index) => ListTile(
                title: Text(bookList[index].title),
                subtitle: Text(
                  "Author: ${bookList[index].author} - Publisher: ${bookList[index].publisher} - ${bookList[index].year}",
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed:
                      () => {bookProvider.deleteBook(bookList[index].id)},
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => InputBook(
                            title: "Edit",
                            book: bookList[index],
                            isEditMode: true,
                          ),
                    ),
                  );
                },
              ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => _onAddPressed(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(child: content),
    );
  }
}
