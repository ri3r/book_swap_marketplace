import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_listing.dart';

class SearchFilters {
  final BookCategory? category;
  final ListingType? type;

  const SearchFilters({this.category, this.type});

  SearchFilters copyWith({
    Object? category = _sentinel,
    Object? type = _sentinel,
  }) {
    return SearchFilters(
      category: category == _sentinel ? this.category : category as BookCategory?,
      type: type == _sentinel ? this.type : type as ListingType?,
    );
  }
}

// Sentinel so copyWith can explicitly set null
const Object _sentinel = Object();

class SearchFiltersNotifier extends StateNotifier<SearchFilters> {
  SearchFiltersNotifier() : super(const SearchFilters());

  void setCategory(BookCategory? category) {
    state = state.copyWith(category: category);
  }

  void setType(ListingType? type) {
    state = state.copyWith(type: type);
  }
}

final searchFiltersProvider =
    StateNotifierProvider<SearchFiltersNotifier, SearchFilters>(
  (ref) => SearchFiltersNotifier(),
);
