import 'package:expense_tracker/provider/category/tools/category_hive_provider.dart';
import 'package:expense_tracker/data/repositories/category_repo.dart';
import 'package:riverpod/riverpod.dart';

final categoryRepoProvider = Provider<CategoryRepo>((ref) {
  final box = ref.read(categoriesBoxProvider);
  return CategoryRepo(box);
});
