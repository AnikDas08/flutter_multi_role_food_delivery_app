import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class DriverBankAccount {
  final String id;
  final String bankName;
  final String country;
  final String accountHolder;
  final String accountNumber;
  final String fullAccountNumber;
  final String accountType; // 'Savings' or 'Current'
  final bool isVerified;

  DriverBankAccount({
    required this.id,
    required this.bankName,
    required this.country,
    required this.accountHolder,
    required this.accountNumber,
    required this.fullAccountNumber,
    required this.accountType,
    required this.isVerified,
  });

  DriverBankAccount copyWith({
    String? id,
    String? bankName,
    String? country,
    String? accountHolder,
    String? accountNumber,
    String? fullAccountNumber,
    String? accountType,
    bool? isVerified,
  }) {
    return DriverBankAccount(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      country: country ?? this.country,
      accountHolder: accountHolder ?? this.accountHolder,
      accountNumber: accountNumber ?? this.accountNumber,
      fullAccountNumber: fullAccountNumber ?? this.fullAccountNumber,
      accountType: accountType ?? this.accountType,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class DriverLinkedAccountsController extends GetxController {
  final RxString selectedAccountId = '1'.obs;

  final RxList<DriverBankAccount> accounts = <DriverBankAccount>[
    DriverBankAccount(
      id: '1',
      bankName: 'BNU',
      country: 'Timor-Leste',
      accountHolder: 'Cabonaro Unipessoal Lda',
      accountNumber: '**** 54433',
      fullAccountNumber: '99887766554433',
      accountType: 'Savings',
      isVerified: true,
    ),
    DriverBankAccount(
      id: '2',
      bankName: 'Mandiri',
      country: 'Timor-Leste',
      accountHolder: 'Cabonaro Unipessoal Lda',
      accountNumber: '**** 7842',
      fullAccountNumber: '11223344557842',
      accountType: 'Current',
      isVerified: false,
    ),
    DriverBankAccount(
      id: '3',
      bankName: 'BNCTL',
      country: 'Timor-Leste',
      accountHolder: 'Cabonaro Unipessoal Lda',
      accountNumber: '**** 7842',
      fullAccountNumber: '55667788997842',
      accountType: 'Current',
      isVerified: true,
    ),
  ].obs;

  void selectAccount(String id) {
    selectedAccountId.value = id;
  }

  void removeAccount(String id) {
    final account = accounts.firstWhereOrNull((a) => a.id == id);
    if (account == null) return;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFEE2E2),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 24,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Remove Bank Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to remove ${account.bankName} (${account.accountNumber})?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        accounts.removeWhere((a) => a.id == id);
                        if (selectedAccountId.value == id && accounts.isNotEmpty) {
                          selectedAccountId.value = accounts.first.id;
                        }
                        AppSnackbar.success(
                          title: 'Account Removed',
                          message: '${account.bankName} account has been removed.',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Remove',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addNewAccount({
    required String bankName,
    required String accountHolder,
    required String accountNumber,
    required String accountType,
  }) {
    final cleanNumber = accountNumber.trim();
    final maskedNumber = cleanNumber.length > 4
        ? '**** ${cleanNumber.substring(cleanNumber.length - 4)}'
        : cleanNumber;

    final newAcc = DriverBankAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bankName: bankName,
      country: 'Timor-Leste',
      accountHolder: accountHolder.trim().isEmpty
          ? 'Cabonaro Unipessoal Lda'
          : accountHolder.trim(),
      accountNumber: maskedNumber,
      fullAccountNumber: cleanNumber,
      accountType: accountType,
      isVerified: false,
    );

    accounts.add(newAcc);
    AppSnackbar.success(
      title: 'Bank Account Added',
      message: '$bankName account added and pending verification.',
    );
  }
}
