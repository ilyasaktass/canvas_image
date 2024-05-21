class Books {
  final List<Book> books;

  Books({required this.books});

  factory Books.fromJson(Map<String, dynamic> json) {
    var resultsJson = json['results'] as List;
    List<Book> booksList = resultsJson.map((bookJson) => Book.fromJson(bookJson)).toList();

    return Books(books: booksList);
  }
}

class Book {
  final int bookId;
  final int bookGroupByType;
  final int bookType;
  final String groupStr;
  final String bookName;
  final String? description;
  final String? educationYear;
  final String? category;
  final String? isbn;
  final int classId;
  final String className;
  final int lessonId;
  final String lessonName;
  final String? publisher;
  final String? author;
  final double? price;
  final double? oldPrice;
  final String? shopUrl;
  final int classDisplayOrder;
  final int lessonDisplayOrder;
  final int displayOrder;
  final int displayStartPage;
  final int displayEndPage;
  final String? displayPages;
  final bool hasSolution;
  final bool isActive;
  final bool isActivationCodeRequired;
  final String coverImage;
  final String coverImageUrl;
  final String? bookFlipBookUrl;
  final bool isGroup;
  final int? groupId;
  final bool hasGroup;
  final bool hideLibrary;
  final String? groupTitle;
  final String? accessCode;
  final List<dynamic> bookPages;
  final List<dynamic>? exams;
  final List<dynamic>? bookContents;
  final int id;
  final String guid;
  final DateTime createdOn;
  final DateTime? updateOn;

  Book({
    required this.bookId,
    required this.bookGroupByType,
    required this.bookType,
    required this.groupStr,
    required this.bookName,
    this.description,
    this.educationYear,
    this.category,
    this.isbn,
    required this.classId,
    required this.className,
    required this.lessonId,
    required this.lessonName,
    this.publisher,
    this.author,
    this.price,
    this.oldPrice,
    this.shopUrl,
    required this.classDisplayOrder,
    required this.lessonDisplayOrder,
    required this.displayOrder,
    required this.displayStartPage,
    required this.displayEndPage,
    this.displayPages,
    required this.hasSolution,
    required this.isActive,
    required this.isActivationCodeRequired,
    required this.coverImage,
    required this.coverImageUrl,
    this.bookFlipBookUrl,
    required this.isGroup,
    this.groupId,
    required this.hasGroup,
    required this.hideLibrary,
    this.groupTitle,
    this.accessCode,
    required this.bookPages,
    this.exams,
    this.bookContents,
    required this.id,
    required this.guid,
    required this.createdOn,
    this.updateOn,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['BookId'],
      bookGroupByType: json['BookGroupByType'],
      bookType: json['BookType'],
      groupStr: json['GroupStr'],
      bookName: json['BookName'],
      description: json['Description'],
      educationYear: json['EducationYear'],
      category: json['Category'],
      isbn: json['Isbn'],
      classId: json['ClassId'],
      className: json['ClassName'],
      lessonId: json['LessonId'],
      lessonName: json['LessonName'],
      publisher: json['Publisher'],
      author: json['Author'],
      price: json['Price']?.toDouble(),
      oldPrice: json['OldPrice']?.toDouble(),
      shopUrl: json['ShopUrl'],
      classDisplayOrder: json['ClassDisplayOrder'],
      lessonDisplayOrder: json['LessonDisplayOrder'],
      displayOrder: json['DisplayOrder'],
      displayStartPage: json['DisplayStartPage'],
      displayEndPage: json['DisplayEndPage'],
      displayPages: json['DisplayPages'],
      hasSolution: json['HasSolution'],
      isActive: json['IsActive'],
      isActivationCodeRequired: json['IsActivationCodeRequired'],
      coverImage: json['CoverImage'],
      coverImageUrl: json['CoverImageUrl'],
      bookFlipBookUrl: json['BookFlipBookUrl'],
      isGroup: json['IsGroup'],
      groupId: json['GroupId'],
      hasGroup: json['HasGroup'],
      hideLibrary: json['HideLibrary'],
      groupTitle: json['GroupTitle'],
      accessCode: json['AccessCode'],
      bookPages: json['BookPages'] ?? [],
      exams: json['Exams'],
      bookContents: json['BookContents'],
      id: json['Id'],
      guid: json['Guid'],
      createdOn: DateTime.parse(json['CreatedOn']),
      updateOn: json['UpdateOn'] != null ? DateTime.parse(json['UpdateOn']) : null,
    );
  }
}
