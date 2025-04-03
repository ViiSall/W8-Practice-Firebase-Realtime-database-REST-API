import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/book.dart';
import '../../provider/book_provider.dart';

class InputBook extends StatefulWidget {
  const InputBook({
    super.key,
    required this.title,
    this.book,
    this.isEditMode = false,
  });

  final String title;
  final Book? book;
  final bool isEditMode;

  @override
  State<InputBook> createState() => _InputBookState();
}

class _InputBookState extends State<InputBook> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _publisherController;
  late final TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title);
    _authorController = TextEditingController(text: widget.book?.author);
    _publisherController = TextEditingController(text: widget.book?.publisher);
    _yearController = TextEditingController(text: widget.book?.year.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void validateAndSave() {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final String author = _authorController.text;
      final String publisher = _publisherController.text;
      final int year = int.tryParse(_yearController.text) ?? 0;

      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      if (widget.isEditMode) {
        Book book = Book(
          id: widget.book?.id ?? '',
          title: title,
          author: author,
          publisher: publisher,
          year: year,
        );
        bookProvider.updateBook(book);
      } else {
        bookProvider.addBook(title, author, publisher, year);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.title} Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Author'),
                controller: _authorController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Author cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Publisher'),
                controller: _publisherController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Publisher cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Year'),
                controller: _yearController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Year cannot be empty';
                  }
                  final int? year = int.tryParse(value);
                  if (year == null || year <= 0 || year > 2025) {
                    return 'Year must be a positive number and not greater than 2026';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: validateAndSave,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
