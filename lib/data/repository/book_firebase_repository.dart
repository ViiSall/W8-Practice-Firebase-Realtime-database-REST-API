import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../model/book.dart';
import '../dto/book_dto.dart';
import 'book_repository.dart';



class BookFirebaseRepository extends BookRepository {
  final String baseUrl;
  String bookCollection;
  BookFirebaseRepository({
    required this.baseUrl,
    required this.bookCollection,
  });

  @override
  Future<List<Book>> getBook() async {
    Uri uri = Uri.parse('$baseUrl/$bookCollection.json');
    final http.Response response = await http.get(uri);
    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to load books');
    }
    final data = json.decode(response.body) as Map<String, dynamic>?;

    if (data == null) return [];
    return data.entries
        .map((entry) => BookDto.fromJson(entry.key, entry.value))
        .toList();
  }

  @override
  Future<Book> addBook({
    required String title,
    required String author,
    required String publisher,
    required int year,
  }) async {
    Uri uri = Uri.parse('$baseUrl/$bookCollection.json');
    final newBookData = {
      'title': title,
      'author': author,
      'publisher': publisher,
      'year': year,
    };
    final http.Response response = await http.post(
      uri,
      body: json.encode(newBookData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to add book');
    }
    final newId = json.decode(response.body)['name'];
    return Book(
      id: newId,
      title: title,
      author: author,
      publisher: publisher,
      year: year,
    );
  }

  @override
  Future<String> deleteBook(String id) async {
    Uri uri = Uri.parse('$baseUrl/$bookCollection/$id.json');
    final http.Response response = await http.delete(uri);
    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to delete book');
    }
    return id;
  }

  @override
  Future<Book> updateBook({
    required String id,
    required String title,
    required String author,
    required String publisher,
    required int year,
  }) async {
    Uri uri = Uri.parse('$baseUrl/$bookCollection/$id.json');
    final updatedBookData = {
      'title': title,
      'author': author,
      'publisher': publisher,
      'year': year,
    };
    final http.Response response = await http.put(
      uri,
      body: json.encode(updatedBookData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to update book');
    }
    return Book(
      id: id,
      title: title,
      author: author,
      publisher: publisher,
      year: year,
    );
  }
}