import 'package:canvas_image/screens/home/books_screen.dart';
import 'package:flutter/material.dart';
import 'package:canvas_image/models/classes.dart';
import 'package:canvas_image/services/api_services.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ClassesScreenState();
  }
}

class _ClassesScreenState extends State<ClassesScreen> {
  late Future<Classes?> _classesFuture;

  @override
  void initState() {
    super.initState();
    _classesFuture = ApiService.getClasses();
  }

  Future<void> _getBooksAndNavigate(int classId, bool showUserFavoriteBooks) async {
    final booksResponse = await ApiService.getBooks(classId, showUserFavoriteBooks);
    if (booksResponse != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BooksScreen(books: booksResponse.books),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:  Text('Kitaplar yüklenemedi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Classes?>(
        future: _classesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Veri bulunamadı'));
          } else {
            final classes = snapshot.data!.results;
            return ListView.builder(
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final classItem = classes[index];
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      classItem.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _getBooksAndNavigate(classItem.id, true),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
