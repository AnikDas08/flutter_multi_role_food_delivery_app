
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/controller/customer_dashboard_controller.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';
import '../widgets/popular_item_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final CustomerDashboardController dashController =
      Get.find<CustomerDashboardController>();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final SpeechToText _speechToText = SpeechToText();

  final RxString _searchQuery = ''.obs;
  final RxBool _isListening = false.obs;
  final RxBool _speechAvailable = false.obs;
  final RxList<String> _recentSearches =
      <String>['Italian Pizza', 'Italian Pizza', 'Italian Pizza', 'Italian Pizza', 'Italian Pizza', 'Italian Pizza'].obs;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  /// All items aggregated from both plomobites & plomoshop data
  late final List<CustomerPopularItem> _allItems;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 1.0, end: 1.3).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _initSpeech();

    // Merge all searchable items
    _allItems = [
      ...dashController.popularItems,
      ...dashController.plomoShopPopularItems,
    ];

    // Auto-focus the search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _initSpeech() async {
    final available = await _speechToText.initialize(
      onError: (error) {
        _isListening.value = false;
      },
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          _isListening.value = false;
        }
      },
    );
    _speechAvailable.value = available;
  }

  /// Called for every speech result (partial + final)
  void _onSpeechResult(SpeechRecognitionResult result) {
    final words = result.recognizedWords;
    // Use TextEditingValue so cursor is placed at the end of the recognised text
    _searchController.value = TextEditingValue(
      text: words,
      selection: TextSelection.collapsed(offset: words.length),
    );
    // Update the reactive query so Obx rebuilds the results grid
    _searchQuery.value = words;
    if (result.finalResult) {
      _isListening.value = false;
      if (words.trim().isNotEmpty) _addToRecent(words.trim());
    }
  }

  void _startListening() async {
    // Re-initialise if not yet available (e.g. first tap before init completes)
    if (!_speechAvailable.value) {
      await _initSpeech();
      if (!_speechAvailable.value) return; // device doesn't support STT
    }
    _isListening.value = true;
    // partialResults defaults to true in speech_to_text — no extra options needed
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      cancelOnError: false,
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
    _isListening.value = false;
  }

  void _toggleListening() {
    if (_isListening.value) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _onSearchChanged(String value) {
    _searchQuery.value = value;
  }

  void _onSearchSubmitted(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      _addToRecent(trimmed);
    }
  }

  void _addToRecent(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    _recentSearches.remove(trimmed);
    _recentSearches.insert(0, trimmed);
    if (_recentSearches.length > 10) {
      _recentSearches.removeLast();
    }
  }

  void _clearAll() {
    _recentSearches.clear();
  }

  void _tapRecent(String term) {
    _searchController.text = term;
    _searchQuery.value = term;
    _focusNode.unfocus();
  }

  List<CustomerPopularItem> get _filteredItems {
    final q = _searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _allItems
        .where((item) =>
            item.title.toLowerCase().contains(q) ||
            item.description.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.h),

            /// ── App Bar ──────────────────────────────────────
            _buildAppBar(),

            SizedBox(height: 16.h),

            /// ── Content ──────────────────────────────────────
            Expanded(
              child: Obx(() {
                final query = _searchQuery.value.trim();

                if (query.isEmpty) {
                  // No search yet → show "Recent Search"
                  return _buildInitialState();
                }

                final results = _filteredItems;

                if (results.isEmpty) {
                  return _buildEmptyState(query);
                }

                return _buildResultsGrid(results);
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // App Bar
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16.sp,
                color: const Color(0xFF2E0A66),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Search input
          Expanded(
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 14.w),
                  Icon(
                    Icons.search_rounded,
                    color: const Color(0xFF94A3B8),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: _onSearchChanged,
                      onSubmitted: _onSearchSubmitted,
                      textAlignVertical: TextAlignVertical.center,
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        color: const Color(0xFF1E293B),
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        hintText: 'Search for restaurants or dishes',
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),

                  // Voice button
                  Obx(() => GestureDetector(
                        onTap: _toggleListening,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isListening.value
                                  ? _pulseAnimation.value
                                  : 1.0,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 32.w,
                            height: 32.w,
                            margin: EdgeInsets.only(right: 6.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isListening.value
                                  ? const Color(0xFF7C3AED)
                                  : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              _isListening.value
                                  ? Icons.mic_rounded
                                  : Icons.mic_none_rounded,
                              size: 20.sp,
                              color: _isListening.value
                                  ? Colors.white
                                  : const Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Initial State (Recent Searches)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildInitialState() {
    return Obx(() {
      if (_recentSearches.isEmpty) {
        return Center(
          child: Text(
            'No recent searches',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              color: const Color(0xFF94A3B8),
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Recent Search" heading + "Clear All"
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Search',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E0A66),
                  ),
                ),
                GestureDetector(
                  onTap: _clearAll,
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.roboto(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7C3AED),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // Chip grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: _recentSearches.map((term) {
                return GestureDetector(
                  onTap: () => _tapRecent(term),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFF7C3AED),
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      term,
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Results Grid
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildResultsGrid(List<CustomerPopularItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search Results',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                  Text(
                    '${items.length} Results found',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              _buildFilterIcon(),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Grid
        Expanded(
          child: GridView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.68,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return PopularItemCard(
                item: item,
                controller: dashController,
                width: null,
                imageHeight: 100,
              );
            },
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Empty State
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildEmptyState(String query) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search Results',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                  Text(
                    '0 Results found',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              _buildFilterIcon(),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        // Sort By
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Sort By ',
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
              Icon(Icons.sort_rounded,
                  size: 16.sp, color: const Color(0xFF64748B)),
            ],
          ),
        ),

        // Illustration + text
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              Image.asset(
                AppImages.notFound,
                width: 240.w,
                height: 220.h,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.search_off_rounded,
                  size: 80.sp,
                  color: const Color(0xFFE2E8F0),
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                'Not Found!',
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2E0A66),
                ),
              ),

              SizedBox(height: 10.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'Sorry, the keyword you entered cannot be found, please check again or search with another keyword.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Filter Icon Button
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildFilterIcon() {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED),
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.tune_rounded,
        size: 18.sp,
        color: Colors.white,
      ),
    );
  }
}
