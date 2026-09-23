import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'merchant_menu_controller.dart';

class AddEditMenuController extends GetxController {
  static AddEditMenuController get instance =>
      Get.find<AddEditMenuController>();

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemNoController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityLimitController =
      TextEditingController();
  final TextEditingController itemDescriptionController =
      TextEditingController();

  final Rx<String?> selectedCategory = Rx<String?>('Plomobites');
  final List<String> categories = const [
    'Plomobites',
    'PlomoShop',
  ];

  final Rx<String?> selectedImagePath = Rx<String?>(null);
  final Rx<String?> existingImageUrl = Rx<String?>(null);
  final ImagePicker _picker = ImagePicker();

  MerchantMenuItemModel? editingItem;
  bool get isEditing => editingItem != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    initializeWithItem(args is MerchantMenuItemModel ? args : null);
  }

  void initializeWithItem(MerchantMenuItemModel? item) {
    editingItem = item;
    if (item != null) {
      itemNameController.text = item.title;
      itemNoController.text = item.itemNumber
          .replaceAll(RegExp(r'Item\s*No:?\s*', caseSensitive: false), '')
          .trim();
      priceController.text = item.price.toStringAsFixed(2);
      selectedCategory.value =
          item.category.isNotEmpty ? item.category : 'Plomobites';
      quantityLimitController.text = item.quantityLimit.isNotEmpty
          ? item.quantityLimit
          : 'No Limit';
      itemDescriptionController.text = item.description;
      existingImageUrl.value = item.imageUrl;
      selectedImagePath.value = null;
    } else {
      itemNameController.clear();
      if (Get.isRegistered<MerchantMenuController>()) {
        final nextNo = MerchantMenuController.instance.totalCount + 1;
        itemNoController.text = '${nextNo < 10 ? '0' : ''}$nextNo';
      } else {
        itemNoController.clear();
      }
      priceController.clear();
      selectedCategory.value = 'Plomobites';
      quantityLimitController.text = 'No Limit';
      itemDescriptionController.clear();
      existingImageUrl.value = null;
      selectedImagePath.value = null;
    }
  }

  @override
  void onClose() {
    itemNameController.dispose();
    itemNoController.dispose();
    priceController.dispose();
    quantityLimitController.dispose();
    itemDescriptionController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file != null) {
        selectedImagePath.value = file.path;
      }
    } catch (e) {
      AppSnackbar.error(
        title: 'Error',
        message: 'Failed to pick image: $e',
      );
    }
  }

  void submit() {
    final name = itemNameController.text.trim();
    if (name.isEmpty) {
      AppSnackbar.error(
        title: 'Required Field',
        message: 'Please enter item name',
      );
      return;
    }

    final priceText = priceController.text.replaceAll('\$', '').trim();
    final price = double.tryParse(priceText) ?? 12.99;

    final itemNoText = itemNoController.text.trim();
    final int nextCount = Get.isRegistered<MerchantMenuController>()
        ? MerchantMenuController.instance.totalCount + 1
        : 1;
    final itemNumber = itemNoText.isNotEmpty
        ? (itemNoText.toLowerCase().startsWith('item no')
            ? itemNoText
            : 'Item No: $itemNoText')
        : 'Item No: ${nextCount < 10 ? '0' : ''}$nextCount';

    final category = selectedCategory.value ?? 'Plomobites';
    final quantityLimit = quantityLimitController.text.trim().isNotEmpty
        ? quantityLimitController.text.trim()
        : 'No Limit';
    final description = itemDescriptionController.text.trim();

    if (Get.isRegistered<MerchantMenuController>()) {
      final menuCtrl = MerchantMenuController.instance;
      if (isEditing && editingItem != null) {
        final index =
            menuCtrl.menuItems.indexWhere((it) => it.id == editingItem!.id);
        if (index != -1) {
          final updatedImageUrl =
              (selectedImagePath.value != null &&
                      selectedImagePath.value!.isNotEmpty)
                  ? selectedImagePath.value!
                  : (existingImageUrl.value ?? editingItem!.imageUrl);

          menuCtrl.menuItems[index] = MerchantMenuItemModel(
            id: editingItem!.id,
            title: name,
            price: price,
            imageUrl: updatedImageUrl,
            itemNumber: itemNumber,
            category: category,
            quantityLimit: quantityLimit,
            description: description,
            isAvailable: editingItem!.isAvailable.value,
          );
          menuCtrl.menuItems.refresh();
        }
      } else {
        final newImageUrl = (selectedImagePath.value != null &&
                selectedImagePath.value!.isNotEmpty)
            ? selectedImagePath.value!
            : 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300';

        menuCtrl.menuItems.add(
          MerchantMenuItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: name,
            price: price,
            imageUrl: newImageUrl,
            itemNumber: itemNumber,
            category: category,
            quantityLimit: quantityLimit,
            description: description,
            isAvailable: true,
          ),
        );
        menuCtrl.menuItems.refresh();
      }
    }

    Get.back();

    AppSnackbar.success(
      title: isEditing ? 'Item Updated' : 'Item Added',
      message: isEditing
          ? '$name has been updated successfully'
          : '$name has been added to the menu',
    );
  }
}
