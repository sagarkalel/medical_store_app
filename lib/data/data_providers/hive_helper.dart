import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/hive_constants.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class HiveHelper {
  static Future<void> initHive() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);

    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());

    // Open boxes
    await Hive.openBox<UserModel>(HiveConstants.userBox);
    await Hive.openBox<ProductModel>(HiveConstants.productBox);
    await Hive.openBox(HiveConstants.authBox);

    // Initialize default users if not exist
    await _initializeDefaultUsers();

    // Initialize sample products if in debug mode
    if (kDebugMode) {
      await _initializeSampleProducts();
    }
  }

  static Future<void> _initializeDefaultUsers() async {
    final userBox = Hive.box<UserModel>(HiveConstants.userBox);
    if (userBox.isEmpty) {
      // Add admin user
      final adminUser = UserModel(
        username: 'admin',
        password: 'admin123',
        isAdmin: true,
      );
      await userBox.put(adminUser.id, adminUser);

      // Add regular user
      final regularUser = UserModel(
        username: 'user',
        password: 'user123',
        isAdmin: false,
      );
      await userBox.put(regularUser.id, regularUser);
    }
  }

  static Future<void> _initializeSampleProducts() async {
    final productBox = Hive.box<ProductModel>(HiveConstants.productBox);

    if (productBox.isEmpty) {
      final List<ProductModel> sampleProducts = [
        ProductModel(
          name: 'Paracetamol',
          description: 'Pain reliever and fever reducer',
          price: 5.99,
          discountPercentage: 10.0,
          brand: 'MediBrand',
          imageUrls: [
            'assets/images/paracetamol_1.png',
            'assets/images/paracetamol_2.png',
          ],
          category: 'Pain Relief',
          stockQuantity: 100,
          dosage:
              'Take 1-2 tablets every 4-6 hours as needed, not exceeding 8 tablets in 24 hours',
          uses:
              'Relief from headache, toothache, backache, period pain, cold and flu symptoms',
          sideEffects:
              'Rarely, but may include rash, blood disorders, liver damage with overdose',
          expiryDate: DateTime.now().add(const Duration(days: 365)),
          prescriptionRequired: false,
        ),
        ProductModel(
          name: 'Amoxicillin',
          description: 'Antibiotic used to treat bacterial infections',
          price: 12.50,
          discountPercentage: 0.0,
          brand: 'PharmaCure',
          imageUrls: [
            'assets/images/amoxicillin_1.jpg',
            'assets/images/amoxicillin_2.jpg',
          ],
          category: 'Antibiotics',
          stockQuantity: 50,
          dosage:
              '250-500mg three times daily for 7-10 days depending on infection',
          uses:
              'Treatment of respiratory infections, urinary tract infections, skin infections',
          sideEffects:
              'Diarrhea, nausea, skin rash, vomiting, allergic reactions',
          expiryDate: DateTime.now().add(const Duration(days: 730)),
          prescriptionRequired: true,
        ),
        ProductModel(
          name: 'Vitamin D3',
          description: 'Supports bone health and immune function',
          price: 8.25,
          discountPercentage: 15.0,
          brand: 'VitaPlus',
          imageUrls: [
            'assets/images/vitamin_d3_1.jpg',
            'assets/images/vitamin_d3_2.jpg',
          ],
          category: 'Vitamins & Supplements',
          stockQuantity: 200,
          dosage: 'One 1000 IU tablet daily with food',
          uses:
              'Supports bone and muscle health, immune function, calcium absorption',
          sideEffects: 'Rarely causes nausea, vomiting, constipation, weakness',
          expiryDate: DateTime.now().add(const Duration(days: 900)),
          prescriptionRequired: false,
        ),
        ProductModel(
          name: 'Cetirizine Hydrochloride',
          description: 'Fast-acting allergy relief tablets',
          price: 7.99,
          discountPercentage: 5.0,
          brand: 'AllerFree',
          imageUrls: [
            'assets/images/cetirizine_1.jpg',
            'assets/images/cetirizine_2.jpg',
          ],
          category: 'Allergy',
          stockQuantity: 85,
          dosage: '10mg once daily, with or without food',
          uses: 'Relieves symptoms of hay fever and year-round allergies',
          sideEffects: 'Drowsiness, dry mouth, fatigue, sore throat',
          expiryDate: DateTime.now().add(const Duration(days: 548)),
          prescriptionRequired: false,
        ),
        ProductModel(
          name: 'Omeprazole',
          description: 'Acid reducer for heartburn relief',
          price: 14.50,
          discountPercentage: 0.0,
          brand: 'GastroHealth',
          imageUrls: [
            'assets/images/omeprazole_1.jpg',
            'assets/images/omeprazole_2.jpg',
          ],
          category: 'Digestive Health',
          stockQuantity: 45,
          dosage: '20mg once daily before eating',
          uses: 'Treats frequent heartburn, acid reflux, GERD',
          sideEffects: 'Headache, abdominal pain, diarrhea, nausea',
          expiryDate: DateTime.now().add(const Duration(days: 420)),
          prescriptionRequired: true,
        ),
        ProductModel(
          name: 'Metformin Hydrochloride',
          description: 'Oral diabetes medicine',
          price: 9.75,
          discountPercentage: 10.0,
          brand: 'DiaCare',
          imageUrls: [
            'assets/images/metformin_1.jpg',
            'assets/images/metformin_2.jpg',
          ],
          category: 'Diabetes',
          stockQuantity: 60,
          dosage: '500mg twice daily with meals',
          uses: 'Controls high blood sugar in type 2 diabetes',
          sideEffects: 'Nausea, vomiting, diarrhea, metallic taste',
          expiryDate: DateTime.now().add(const Duration(days: 670)),
          prescriptionRequired: true,
        ),
        ProductModel(
          name: 'Hydrocortisone Cream',
          description: 'Anti-itch cream for skin irritation',
          price: 6.25,
          discountPercentage: 15.0,
          brand: 'DermaCare',
          imageUrls: [
            'assets/images/hydrocortisone_1.jpg',
            'assets/images/hydrocortisone_2.jpg',
          ],
          category: 'Skin Care',
          stockQuantity: 120,
          dosage: 'Apply thin layer to affected area 1-4 times daily',
          uses: 'Treats minor skin irritations, rashes, eczema',
          sideEffects: 'Burning, itching, dryness at application site',
          expiryDate: DateTime.now().add(const Duration(days: 730)),
          prescriptionRequired: false,
        ),
        ProductModel(
          name: 'Loratadine',
          description: 'Non-drowsy allergy relief tablets',
          price: 8.50,
          discountPercentage: 0.0,
          brand: 'ClearAll',
          imageUrls: [
            'assets/images/loratadine_1.jpg',
            'assets/images/loratadine_2.jpg',
          ],
          category: 'Allergy',
          stockQuantity: 95,
          dosage: '10mg once daily',
          uses: 'Relieves sneezing, runny nose, itchy/watery eyes',
          sideEffects: 'Headache, dry mouth, fatigue, nervousness',
          expiryDate: DateTime.now().add(const Duration(days: 600)),
          prescriptionRequired: false,
        ),
        ProductModel(
          name: 'Simvastatin',
          description: 'Cholesterol-lowering tablets',
          price: 18.99,
          discountPercentage: 5.0,
          brand: 'CardioSafe',
          imageUrls: [
            'assets/images/simvastatin_1.jpg',
            'assets/images/simvastatin_2.jpg',
          ],
          category: 'Cardiovascular',
          stockQuantity: 35,
          dosage: '20mg once daily at bedtime',
          uses: 'Lowers bad cholesterol and triglycerides',
          sideEffects: 'Muscle pain, constipation, abdominal pain',
          expiryDate: DateTime.now().add(const Duration(days: 550)),
          prescriptionRequired: true,
        ),
        ProductModel(
          name: 'Insulin Syringes',
          description: '1ml disposable insulin syringes',
          price: 22.00,
          discountPercentage: 0.0,
          brand: 'SafeShot',
          imageUrls: [
            'assets/images/syringes_1.jpg',
            'assets/images/syringes_2.jpg',
          ],
          category: 'Diabetes',
          stockQuantity: 200,
          dosage: 'As prescribed by physician',
          uses: 'Insulin administration for diabetes management',
          sideEffects: 'Possible injection site reactions',
          expiryDate: DateTime.now().add(const Duration(days: 1095)),
          prescriptionRequired: true,
        ),
        ProductModel(
          name: 'Baby Diapers',
          description: 'Hypoallergenic newborn diapers',
          price: 12.99,
          discountPercentage: 20.0,
          brand: 'TinyCare',
          imageUrls: [
            'assets/images/diapers_1.jpg',
            'assets/images/diapers_2.jpg',
          ],
          category: 'Baby Care',
          stockQuantity: 300,
          dosage: 'Change every 2-3 hours or as needed',
          uses: 'Baby hygiene and skin protection',
          sideEffects: 'Rare allergic reactions to materials',
          expiryDate: DateTime.now().add(const Duration(days: 1800)),
          prescriptionRequired: false,
        ),
        ProductModel(
          name: 'Hand Sanitizer',
          description: 'Alcohol-based germ protection',
          price: 4.99,
          discountPercentage: 10.0,
          brand: 'PureHands',
          imageUrls: [
            'assets/images/sanitizer_1.jpg',
            'assets/images/sanitizer_2.jpg',
          ],
          category: 'Hygiene',
          stockQuantity: 150,
          dosage: 'Apply palm-sized amount and rub hands until dry',
          uses: 'Kills 99.9% of common germs',
          sideEffects: 'Dry skin with excessive use',
          expiryDate: DateTime.now().add(const Duration(days: 730)),
          prescriptionRequired: false,
        ),
        ProductModel(
          name: 'Multivitamin Tablets',
          description: 'Complete daily vitamin supplement',
          price: 15.50,
          discountPercentage: 0.0,
          brand: 'VitaBoost',
          imageUrls: [
            'assets/images/multivitamin_1.jpg',
            'assets/images/multivitamin_2.jpg',
          ],
          category: 'Vitamins & Supplements',
          stockQuantity: 180,
          dosage: 'One tablet daily with food',
          uses: 'Supports overall health and immunity',
          sideEffects: 'Mild stomach upset in sensitive individuals',
          expiryDate: DateTime.now().add(const Duration(days: 800)),
          prescriptionRequired: false,
        ),
      ];
      for (var product in sampleProducts) {
        await productBox.put(product.id, product);
      }
    }
  }

  // Generic CRUD operations
  static T? get<T>(String boxName, dynamic key) {
    final box = Hive.box<T>(boxName);
    return box.get(key);
  }

  static List<T> getAll<T>(String boxName) {
    final box = Hive.box<T>(boxName);
    return box.values.toList();
  }

  static Future<void> put<T>(String boxName, dynamic key, T value) async {
    final box = Hive.box<T>(boxName);
    await box.put(key, value);
  }

  static Future<void> delete<T>(String boxName, dynamic key) async {
    final box = Hive.box<T>(boxName);
    await box.delete(key);
  }

  static Future<void> clear<T>(String boxName) async {
    final box = Hive.box<T>(boxName);
    await box.clear();
  }
}
