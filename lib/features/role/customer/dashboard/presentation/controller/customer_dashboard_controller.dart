import 'package:get/get.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';

class CustomerPopularItem {
  final String id;
  final String title;
  final double rating;
  final String distanceTime;
  final String description;
  final double price;
  final String imageUrl;

  const CustomerPopularItem({
    required this.id,
    required this.title,
    required this.rating,
    required this.distanceTime,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class CustomerRestaurant {
  final String id;
  final String name;
  final double rating;
  final double startingPrice;
  final String description;
  final String deliveryType;
  final String location;
  final String imageUrl;
  final RxBool isFavorite;

  CustomerRestaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.startingPrice,
    required this.description,
    required this.deliveryType,
    required this.location,
    required this.imageUrl,
    bool isFav = false,
  }) : isFavorite = isFav.obs;
}

class CustomerShop {
  final String id;
  final String name;
  final double rating;
  final double startingPrice;
  final String description;
  final String deliveryType;
  final String location;
  final String imageUrl;
  final RxBool isFavorite;

  CustomerShop({
    required this.id,
    required this.name,
    required this.rating,
    required this.startingPrice,
    required this.description,
    required this.deliveryType,
    required this.location,
    required this.imageUrl,
    bool isFav = false,
  }) : isFavorite = isFav.obs;
}

class CustomerDashboardController extends GetxController {
  final RxString userName = 'Jane Cooper'.obs;
  final RxString location = 'New York, D-Block'.obs;
  final RxString balance = '\$24.50'.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt cartCount = 2.obs;

  /// Active Service Category (empty initially: nothing selected)
  final RxString selectedCategory = ''.obs;

  void selectCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = '';
    } else {
      selectedCategory.value = category;
    }
  }

  /// 1. Plomobites Data (Food items & Restaurants)
  final RxList<CustomerPopularItem> popularItems = <CustomerPopularItem>[
    const CustomerPopularItem(
      id: 'item_1',
      title: 'Beef Pizza',
      rating: 4.6,
      distanceTime: '1.3 km - 30 min',
      description: 'A hearty, meaty delight loaded with flavor crust topped with rich cheese...',
      price: 12.99,
      imageUrl: AppImages.beefPizza,
    ),
    const CustomerPopularItem(
      id: 'item_2',
      title: 'Beef Pizza',
      rating: 4.6,
      distanceTime: '1.3 km - 30 min',
      description: 'A hearty, meaty delight loaded with flavor crust topped with rich cheese...',
      price: 12.99,
      imageUrl: AppImages.beefPizza,
    ),
    const CustomerPopularItem(
      id: 'item_3',
      title: 'Smoked Burger',
      rating: 4.8,
      distanceTime: '2.1 km - 25 min',
      description: 'Juicy artisanal beef patty with melted cheese and smoked bacon sauce...',
      price: 9.50,
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80',
    ),
    const CustomerPopularItem(
      id: 'item_4',
      title: 'Crispy Fried Wings',
      rating: 4.7,
      distanceTime: '1.8 km - 20 min',
      description: 'Golden crunchy chicken wings glazed in savory hot garlic sauce...',
      price: 8.50,
      imageUrl:
          'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=500&q=80',
    ),
  ].obs;

  final RxList<CustomerRestaurant> popularRestaurants = <CustomerRestaurant>[
    CustomerRestaurant(
      id: 'rest_1',
      name: 'Chez Panisse Cafe',
      rating: 4.7,
      startingPrice: 5.00,
      description:
          'A hearty, meaty delight loaded with flavor crust topped with rich...',
      deliveryType: 'Free Delivery',
      location: 'Mirpur 10,Dhaka',
      imageUrl: AppImages.chezBurgers,
    ),
    CustomerRestaurant(
      id: 'rest_2',
      name: 'Chez Panisse Cafe',
      rating: 4.7,
      startingPrice: 5.00,
      description:
          'A hearty, meaty delight loaded with flavor crust topped with rich...',
      deliveryType: 'Free Delivery',
      location: 'Mirpur 10,Dhaka',
      imageUrl: AppImages.chezBurgers,
    ),
    CustomerRestaurant(
      id: 'rest_3',
      name: 'Grill & Chill Diner',
      rating: 4.9,
      startingPrice: 7.50,
      description: 'Fire-grilled steaks and skewers with garlic herb butter...',
      deliveryType: 'Free Delivery',
      location: 'Gulshan 2, Dhaka',
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80',
    ),
  ].obs;

  /// 2. PlomoShop Data (Groceries & Grocery Stores)
  final RxList<CustomerPopularItem> plomoShopPopularItems = <CustomerPopularItem>[
    const CustomerPopularItem(
      id: 'shop_item_1',
      title: 'Fresh Organic Milk',
      rating: 4.8,
      distanceTime: '1.0 km - 15 min',
      description: 'Pure whole dairy milk, pasteurized and farm fresh daily...',
      price: 3.50,
      imageUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500&q=80',
    ),
    const CustomerPopularItem(
      id: 'shop_item_2',
      title: 'Farm Fresh Eggs',
      rating: 4.9,
      distanceTime: '1.2 km - 20 min',
      description: 'Organic brown eggs from pasture-raised hens, pack of 12...',
      price: 4.20,
      imageUrl:
          'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=500&q=80',
    ),
    const CustomerPopularItem(
      id: 'shop_item_3',
      title: 'Organic Bananas',
      rating: 4.7,
      distanceTime: '1.5 km - 20 min',
      description: 'Naturally ripened sweet Cavendish bananas by the bunch...',
      price: 2.10,
      imageUrl:
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500&q=80',
    ),
    const CustomerPopularItem(
      id: 'shop_item_4',
      title: 'Fresh Hass Avocado',
      rating: 4.8,
      distanceTime: '2.0 km - 25 min',
      description: 'Creamy Hass avocados rich in healthy omega fats and fiber...',
      price: 5.80,
      imageUrl:
          'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=500&q=80',
    ),
  ].obs;

  final RxList<CustomerRestaurant> plomoShopRestaurants = <CustomerRestaurant>[
    CustomerRestaurant(
      id: 'shop_1',
      name: 'Wanderlust Bazaar',
      rating: 4.7,
      startingPrice: 1.99,
      description:
          'A hearty, fresh grocery produce market loaded with organic fruits & greens...',
      deliveryType: 'Free Delivery',
      location: 'Mirpur 10, Dhaka',
      imageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&q=80',
    ),
    CustomerRestaurant(
      id: 'shop_2',
      name: 'Daily Super Shop',
      rating: 4.8,
      startingPrice: 5.00,
      description:
          'All your daily household essentials, dairy, bakery and fresh groceries...',
      deliveryType: '\$5',
      location: 'Mirpur 10, Dhaka',
      imageUrl:
          'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=600&q=80',
    ),
    CustomerRestaurant(
      id: 'shop_3',
      name: 'Green Harvest Grocers',
      rating: 4.9,
      startingPrice: 3.50,
      description:
          'Locally sourced organic vegetables, farm milk, and seasonal fruits...',
      deliveryType: 'Free Delivery',
      location: 'Dhanmondi 27, Dhaka',
      imageUrl:
          'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=600&q=80',
    ),
  ].obs;

  final RxList<CustomerShop> plomoShops = <CustomerShop>[
    CustomerShop(
      id: 'shop_1',
      name: 'Wanderlust Bazaar',
      rating: 4.7,
      startingPrice: 1.99,
      description:
          'A hearty, meaty delight loaded with flavor crust topped with rich...',
      deliveryType: 'Free Delivery',
      location: 'Mirpur 10, Dhaka',
      imageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&q=80',
    ),
    CustomerShop(
      id: 'shop_2',
      name: 'Daily Shop',
      rating: 4.7,
      startingPrice: 5.00,
      description:
          'A hearty, meaty delight loaded with flavor crust topped with rich...',
      deliveryType: '\$5',
      location: 'Mirpur 10, Dhaka',
      imageUrl:
          'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=600&q=80',
    ),
  ].obs;

  /// Dynamic getters based on active Service Category
  List<CustomerPopularItem> get currentPopularItems =>
      selectedCategory.value == 'PlomoShop'
          ? plomoShopPopularItems
          : popularItems;

  List<CustomerRestaurant> get currentRestaurants =>
      selectedCategory.value == 'PlomoShop'
          ? plomoShopRestaurants
          : popularRestaurants;

  void addToCart(CustomerPopularItem item) {
    cartCount.value++;
    AppSnackbar.success(
      title: 'Added to Cart',
      message: '${item.title} added to your cart.',
    );
  }

  void toggleRestaurantFavorite(String id) {
    final rest = popularRestaurants.firstWhereOrNull((r) => r.id == id) ??
        plomoShopRestaurants.firstWhereOrNull((r) => r.id == id);
    if (rest != null) {
      rest.isFavorite.value = !rest.isFavorite.value;
      if (rest.isFavorite.value) {
        AppSnackbar.success(
          title: 'Saved',
          message: '${rest.name} added to favorites.',
        );
      }
    }
  }

  void toggleShopFavorite(String id) {
    final shop = plomoShops.firstWhereOrNull((s) => s.id == id);
    if (shop != null) {
      shop.isFavorite.value = !shop.isFavorite.value;
      if (shop.isFavorite.value) {
        AppSnackbar.success(
          title: 'Saved',
          message: '${shop.name} added to favorites.',
        );
      }
    }
  }
}
