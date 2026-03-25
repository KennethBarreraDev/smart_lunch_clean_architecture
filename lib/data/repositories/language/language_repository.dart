import 'package:smart_lunch/core/constants/cache_keys.dart';
import 'package:smart_lunch/data/providers/secure_storage_provider.dart';

class LanguageRepository {

  final StorageProvider storage;

  LanguageRepository(this.storage);


  Future<String?> getSavedLanguage() async {
    return await storage.readValue('language_code');
  }

  Future<void> saveLanguage(String languageCode) async {
    await storage.writeValue(CacheKeys.languageCode, languageCode);
  }
}