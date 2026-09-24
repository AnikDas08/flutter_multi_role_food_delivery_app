import 'package:get/get.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

enum DriverStatusFilter { all, available, offline }

class DriverModel {
  final String id;
  final String name;
  final String phone;
  final String imageUrl;
  final bool isAvailable;
  final RxBool isAssigned;
  final String vehicle;
  final String email;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.isAvailable,
    this.vehicle = '',
    this.email = '',
    bool isAssigned = false,
  }) : isAssigned = isAssigned.obs;
}

class MerchantDriversController extends GetxController {
  static MerchantDriversController get instance =>
      Get.find<MerchantDriversController>();

  final Rx<DriverStatusFilter> selectedFilter = DriverStatusFilter.all.obs;

  final RxList<DriverModel> drivers = <DriverModel>[
    DriverModel(
      id: '1',
      name: 'Michael Rodriguez',
      phone: '+1 (555) 123-4567',
      imageUrl:
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200',
      isAvailable: true,
    ),
    DriverModel(
      id: '2',
      name: 'Sarah Johnson',
      phone: '+1 (555) 987-6543',
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      isAvailable: false,
    ),
    DriverModel(
      id: '3',
      name: 'David Chen',
      phone: '+1 (555) 456-7890',
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      isAvailable: true,
    ),
    DriverModel(
      id: '4',
      name: 'Emma Wilson',
      phone: '+1 (555) 321-0987',
      imageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
      isAvailable: false,
    ),
    DriverModel(
      id: '5',
      name: 'James Thompson',
      phone: '+1 (555) 654-3210',
      imageUrl:
          'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=200',
      isAvailable: true,
    ),
    DriverModel(
      id: '6',
      name: 'Lisa Martinez',
      phone: '+1 (555) 789-0123',
      imageUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200',
      isAvailable: false,
    ),
  ].obs;

  String get filterLabel {
    switch (selectedFilter.value) {
      case DriverStatusFilter.available:
        return 'Available';
      case DriverStatusFilter.offline:
        return 'Offline';
      case DriverStatusFilter.all:
      default:
        return 'All Status';
    }
  }

  List<DriverModel> get filteredDrivers {
    switch (selectedFilter.value) {
      case DriverStatusFilter.available:
        return drivers.where((d) => d.isAvailable).toList();
      case DriverStatusFilter.offline:
        return drivers.where((d) => !d.isAvailable).toList();
      case DriverStatusFilter.all:
      default:
        return drivers;
    }
  }

  void setFilter(DriverStatusFilter filter) {
    selectedFilter.value = filter;
  }

  void assignDriver(DriverModel driver) {
    if (!driver.isAvailable) {
      AppSnackbar.error(
        title: 'Driver Offline',
        message: '${driver.name} is currently offline and cannot be assigned.',
      );
      return;
    }

    driver.isAssigned.value = !driver.isAssigned.value;
    if (driver.isAssigned.value) {
      AppSnackbar.success(
        title: 'Driver Assigned',
        message: '${driver.name} has been assigned to the active order.',
      );
    } else {
      AppSnackbar.info(
        title: 'Driver Unassigned',
        message: '${driver.name} has been unassigned.',
      );
    }
  }

  void addDriver({
    required String name,
    required String phone,
    String email = '',
    String vehicle = '',
    String? imagePath,
    bool isAvailable = true,
  }) {
    final newDriver = DriverModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      imageUrl: (imagePath != null && imagePath.isNotEmpty)
          ? imagePath
          : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
      isAvailable: isAvailable,
      vehicle: vehicle,
      email: email,
    );
    drivers.insert(0, newDriver);
    drivers.refresh();
  }
}
