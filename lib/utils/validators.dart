class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.trim().length < 2) {
      return 'Title must be at least 2 characters';
    }
    if (value.trim().length > 200) {
      return 'Title must not exceed 200 characters';
    }
    return null;
  }

  static String? validateAuthor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Author is required';
    }
    if (value.trim().length < 2) {
      return 'Author must be at least 2 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Enter a valid number';
    }
    if (price < 0) {
      return 'Price cannot be negative';
    }
    if (price > 9999) {
      return 'Price seems too high';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    if (value.trim().length > 1000) {
      return 'Description must not exceed 1000 characters';
    }
    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Location is required';
    }
    if (value.trim().length < 2) {
      return 'Enter a valid location';
    }
    return null;
  }

  static String? validateIsbn(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final cleaned = value.replaceAll('-', '').replaceAll(' ', '');
    if (cleaned.length != 10 && cleaned.length != 13) {
      return 'ISBN must be 10 or 13 digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return 'ISBN must contain only digits';
    }
    return null;
  }

  static String? validateSearch(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a search term';
    }
    if (value.trim().length < 2) {
      return 'Search term must be at least 2 characters';
    }
    return null;
  }
}
