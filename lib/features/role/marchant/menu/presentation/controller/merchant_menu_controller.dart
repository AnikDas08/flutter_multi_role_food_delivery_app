import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'add_edit_menu_controller.dart';

enum MenuFilter { all, available, unavailable }

class MerchantMenuItemModel {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String itemNumber;
  final String category;
  final String quantityLimit;
  final String description;
  final RxBool isAvailable;

  MerchantMenuItemModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.itemNumber,
    this.category = 'Plomobites',
    this.quantityLimit = 'No Limit',
    this.description = '',
    required bool isAvailable,
  }) : isAvailable = isAvailable.obs;
}

class MerchantMenuController extends GetxController {
  static MerchantMenuController get instance =>
      Get.find<MerchantMenuController>();

  TextEditingController? _searchController;
  TextEditingController get searchController {
    if (_searchController == null) {
      _searchController = TextEditingController(text: searchQuery.value);
      _searchController!.addListener(() {
        searchQuery.value = _searchController!.text.trim();
      });
    }
    return _searchController!;
  }

  final RxString searchQuery = ''.obs;
  final Rx<MenuFilter> selectedFilter = MenuFilter.all.obs;

  final RxList<MerchantMenuItemModel> menuItems = <MerchantMenuItemModel>[
    MerchantMenuItemModel(
      id: '1',
      title: 'Classic Burger',
      price: 12.99,
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300',
      itemNumber: 'Item No: 02',
      category: 'Plomobites',
      quantityLimit: 'No Limit',
      description:
          'Juicy beef patty topped with fresh lettuce, cheddar cheese, pickles, and our signature secret sauce.',
      isAvailable: true,
    ),
    MerchantMenuItemModel(
      id: '2',
      title: 'Margherita Pizza',
      price: 16.50,
      imageUrl:
          'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=300',
      itemNumber: 'Item No: 03',
      category: 'Plomobites',
      quantityLimit: 'No Limit',
      description:
          'Authentic stone-baked pizza with San Marzano tomato sauce, fresh mozzarella, and aromatic basil leaves.',
      isAvailable: true,
    ),
    MerchantMenuItemModel(
      id: '3',
      title: 'Caesar Salad',
      price: 9.99,
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300',
      itemNumber: 'Item No: 04',
      category: 'Plomobites',
      quantityLimit: '15',
      description:
          'Crisp romaine lettuce tossed with parmesan cheese, crunchy garlic croutons, and creamy Caesar dressing.',
      isAvailable: false,
    ),
    MerchantMenuItemModel(
      id: '4',
      title: 'Grilled Chicken',
      price: 16.50,
      imageUrl:
          'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=300',
      itemNumber: 'Item No: 05',
      category: 'PlomoShop',
      quantityLimit: 'No Limit',
      description:
          'Tender marinated chicken breast char-grilled to perfection and served with seasoned roasted vegetables.',
      isAvailable: true,
    ),
    MerchantMenuItemModel(
      id: '5',
      title: 'Chocolate Brownie',
      price: 7.99,
      imageUrl:
          'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=300',
      itemNumber: 'Item No: 06',
      category: 'Plomobites',
      quantityLimit: '20',
      description:
          'Warm fudgy chocolate brownie topped with a scoop of creamy vanilla ice cream and chocolate drizzle.',
      isAvailable: true,
    ),
    MerchantMenuItemModel(
      id: '6',
      title: 'Grilled Salmon',
      price: 9.99,
      imageUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=300',
      itemNumber: 'Item No: 07',
      category: 'PlomoShop',
      quantityLimit: '10',
      description:
          'Fresh Atlantic salmon fillet grilled with lemon herb glaze, served with fresh mixed greens.',
      isAvailable: false,
    ),
  ].obs;

  @override
  void onClose() {
    _searchController?.dispose();
    _searchController = null;
    super.onClose();
  }

  int get totalCount => menuItems.length;
  int get availableCount =>
      menuItems.where((item) => item.isAvailable.value).length;
  int get unavailableCount =>
      menuItems.where((item) => !item.isAvailable.value).length;

  List<MerchantMenuItemModel> get filteredItems {
    return menuItems.where((item) {
      // Filter by availability tab
      if (selectedFilter.value == MenuFilter.available &&
          !item.isAvailable.value) {
        return false;
      }
      if (selectedFilter.value == MenuFilter.unavailable &&
          item.isAvailable.value) {
        return false;
      }

      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final matchesTitle = item.title.toLowerCase().contains(query);
        final matchesItemNo = item.itemNumber.toLowerCase().contains(query);
        return matchesTitle || matchesItemNo;
      }

      return true;
    }).toList();
  }

  void selectFilter(MenuFilter filter) {
    selectedFilter.value = filter;
  }

  void toggleAvailability(MerchantMenuItemModel item) {
    item.isAvailable.value = !item.isAvailable.value;
    AppSnackbar.success(
      title: 'Status Updated',
      message:
          '${item.title} is now ${item.isAvailable.value ? "Available" : "Unavailable"}',
    );
  }

  void editItem(MerchantMenuItemModel item) {
    if (Get.isRegistered<AddEditMenuController>()) {
      Get.find<AddEditMenuController>().initializeWithItem(item);
    }
    Get.toNamed(AppRoutes.addEditMenu, arguments: item);
  }

  void addNewItem() {
    if (Get.isRegistered<AddEditMenuController>()) {
      Get.find<AddEditMenuController>().initializeWithItem(null);
    }
    Get.toNamed(AppRoutes.addEditMenu);
  }
}
