import 'package:flutter/material.dart';

import '../../data/repository/book_repository.dart';
import '../../model/book.dart';
import 'async_value.dart';

class BookProvider extends ChangeNotifier {
  final BookRepository _repository;
  AsyncValue<List<Book>>? bookState;

  BookProvider(this._repository) {
    fetchBook();
  }

  bool get isLoading =>
      bookState != null && bookState!.state == AsyncValueState.loading;
  bool get hasData =>
      bookState != null && bookState!.state == AsyncValueState.success;

  void fetchBook() async {
    try {
      bookState = AsyncValue.loading();
      notifyListeners();

      bookState = AsyncValue.success(await _repository.getBook());
    } catch (error) {
      bookState = AsyncValue.error(error);
    }

    notifyListeners();
  }

  void addBook(String title, String author, String publisher, int year) async {
    await _repository.addBook(
      title: title,
      author: author,
      publisher: publisher,
      year: year,
    );

    fetchBook();
  }

  void deleteBook(String id) async {
    await _repository.deleteBook(id);
    fetchBook();
  }

  void updateBook(Book book) async {
    await _repository.updateBook(
      id: book.id,
      title: book.title,
      author: book.author,
      publisher: book.publisher,
      year: book.year,
    );
    fetchBook();
  }
}