import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

const Color primaryColor = Colors.blue;

/// The main application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo',
        primaryColor: primaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintStyle: TextStyle(fontFamily: 'Cairo'),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

/// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                  builder: (_) => const AccountTypeSelectionScreen()),
            );
          }
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.shopping_cart, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _animation,
              child: const Text(
                'Xsine',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Button for selecting account type.
class AccountTypeButton extends StatelessWidget {
  final String label;
  final String accountType;

  const AccountTypeButton({
    required this.label,
    required this.accountType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        minimumSize: const Size(200, 50),
      ),
      onPressed: () {
        if (accountType == 'normal') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (_) => ChangeNotifierProvider<NormalUserData>(
                create: (_) => NormalUserData(),
                child: HomeScreen(accountType: accountType),
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
                builder: (_) => HomeScreen(accountType: accountType)),
          );
        }
      },
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}

/// Account type selection screen.
class AccountTypeSelectionScreen extends StatelessWidget {
  const AccountTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Text(
                'يرجى إختيار نوع الحساب المناسب لك للمتابعة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  // ignore: deprecated_member_use
                  color: primaryColor.withOpacity(0.8),
                ),
              ),
            ),
            const AccountTypeButton(label: 'حساب عادي', accountType: 'normal'),
            const SizedBox(height: 20),
            const AccountTypeButton(label: 'حساب المحل', accountType: 'store'),
            const SizedBox(height: 20),
            const AccountTypeButton(
                label: 'حساب التوصيل', accountType: 'delivery'),
          ],
        ),
      ),
    );
  }
}

/// The Normal User Data Model
class NormalUserData extends ChangeNotifier {
  String _username = 'المستخدم العادي';
  String _email = 'user@example.com';
  final String _profileImageUrl =
      'https://picsum.photos/200'; // صورة محلية بديلة
  final List<String> _followedStoreIds = <String>['store_1', 'store_3'];
  final List<String> _notifications = <String>[
    'تخفيض 20% في متجر الإلكترونيات على الهواتف!',
    'متجر الأحلام أضاف منتجات جديدة في قسم الملابس.',
    'تذكير: احصل على نقاط مضاعفة اليوم!',
  ];

  static const Map<String, Map<String, String>> _mockStores =
      <String, Map<String, String>>{
    'store_1': {
      'name': 'متجر الأحلام',
      'image': 'https://picsum.photos/200/200?random=1'
    },
    'store_2': {
      'name': 'المركز التجاري الكبير',
      'image': 'https://picsum.photos/200/200?random=2'
    },
    'store_3': {
      'name': 'متجر الإلكترونيات',
      'image': 'https://picsum.photos/200/200?random=3'
    },
    'store_4': {
      'name': 'ملابس الموضة',
      'image': 'https://picsum.photos/200/200?random=4'
    },
    'store_5': {
      'name': 'سوبر ماركت الوفاء',
      'image': 'https://picsum.photos/200/200?random=5'
    },
  };

  String get username => _username;
  String get email => _email;
  String get profileImageUrl => _profileImageUrl;
  List<String> get followedStoreIds =>
      List<String>.unmodifiable(_followedStoreIds);
  List<String> get notifications => List<String>.unmodifiable(_notifications);

  void updateProfile({required String newUsername, required String newEmail}) {
    if (_username != newUsername || _email != newEmail) {
      _username = newUsername;
      _email = newEmail;
      notifyListeners();
    }
  }

  void followStore(String storeId) {
    if (!_followedStoreIds.contains(storeId)) {
      _followedStoreIds.add(storeId);
      notifyListeners();
      addNotification('أنت الآن تتابع ${getStoreNameById(storeId)}!');
    }
  }

  void unfollowStore(String storeId) {
    if (_followedStoreIds.remove(storeId)) {
      notifyListeners();
      addNotification('لقد ألغيت متابعة ${getStoreNameById(storeId)}.');
    }
  }

  void addNotification(String message) {
    _notifications.insert(0, message);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  String getStoreNameById(String storeId) {
    return _mockStores[storeId]?['name'] ?? 'محل غير معروف';
  }

  String getStoreImageById(String storeId) {
    return _mockStores[storeId]?['image'] ??
        'https://picsum.photos/200/200?random=1';
  }

  List<String> getAllAvailableStores() {
    return _mockStores.keys.toList();
  }
}

/// App bar for the Home Screen.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;

  const HomeAppBar({
    required this.searchController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      title: Row(
        children: <Widget>[
          const Text('Xsine',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث عن',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                // ignore: deprecated_member_use
                fillColor: Colors.white.withOpacity(0.3),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// General button
class AppButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final Size? minimumSize;

  const AppButton({
    required this.text,
    required this.color,
    required this.onPressed,
    this.minimumSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: minimumSize,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

/// Action buttons
class HomeActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const HomeActionButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(250, 40),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 20),
            const SizedBox(width: 4),
            Text(text, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class HomeNarrowButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const HomeNarrowButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(119, 40),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 20),
            const SizedBox(width: 4),
            Text(text, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

/// Home Body
class HomeBody extends StatelessWidget {
  final VoidCallback onEarnMoneyPressed;
  final VoidCallback onSmartShoppingPressed;
  final VoidCallback onFavoritesPressed;
  final VoidCallback onDiscountsPressed;

  const HomeBody({
    required this.onEarnMoneyPressed,
    required this.onSmartShoppingPressed,
    required this.onFavoritesPressed,
    required this.onDiscountsPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'اكتشف أفضل العروض\nمنتجات مميزة وبسعر رائع',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 8),
          HomeActionButton(
            text: 'متابعة المحل',
            icon: Icons.store,
            color: primaryColor,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('وظيفة متابعة المحل غير مفعلة حاليًا.')),
              );
            },
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HomeNarrowButton(
                text: 'مفضلة',
                icon: Icons.favorite,
                color: Colors.red,
                onPressed: onFavoritesPressed,
              ),
              const SizedBox(width: 6),
              HomeNarrowButton(
                text: 'تخفيض',
                icon: Icons.local_offer,
                color: Colors.green,
                onPressed: onDiscountsPressed,
              ),
            ],
          ),
          const SizedBox(height: 5),
          HomeActionButton(
            text: 'إضغط للربح المال',
            icon: Icons.monetization_on,
            color: Colors.orange,
            onPressed: onEarnMoneyPressed,
          ),
          const SizedBox(height: 5),
          HomeActionButton(
            text: 'تسوق بذكاء الإصطناعي',
            icon: Icons.smart_toy,
            color: Colors.purple,
            onPressed: onSmartShoppingPressed,
          ),
        ],
      ),
    );
  }
}

/// Bottom Navigation
class HomeBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavigationBar({
    required this.selectedIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      currentIndex: selectedIndex,
      onTap: onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الحساب'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الولايات'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'أقرب محل لك'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
      ],
    );
  }
}

/// Dialog Option
class DialogOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DialogOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(title),
      onTap: () async {
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 10));
        onTap();
      },
    );
  }
}

/// Home Screen
class HomeScreen extends StatefulWidget {
  final String accountType;
  const HomeScreen({super.key, required this.accountType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 3;
  late final TextEditingController _searchController;
  late List<String> _filteredStates;
  final TextEditingController _chatController = TextEditingController();

  static const List<String> _states = <String>[
    'أدرار',
    'الشلف',
    'الأغواط',
    'أم البواقي',
    'باتنة',
    'بجاية',
    'بسكرة',
    'بشار',
    'البليدة',
    'البويرة',
    'تمنراست',
    'تبسة',
    'تلمسان',
    'تيارت',
    'تيزي وزو',
    'الجزائر',
    'الجلفة',
    'جيجل',
    'سطيف',
    'سعيدة',
    'سكيكدة',
    'سيدي بلعباس',
    'عنابة',
    'قالمة',
    'قسنطينة',
    'المدية',
    'مستغانم',
    'المسيلة',
    'معسكر',
    'ورقل',
    'وهران',
    'البيض',
    'إليزي',
    'برج بوعريريج',
    'بومرداس',
    'الطارف',
    'تندوف',
    'تيسمسيلت',
    'الوادي',
    'خنشلة',
    'سوق أهراس',
    'تيبازة',
    'ميلة',
    'عين الدفلى',
    'النعامة',
    'عين تموشنت',
    'غرداية',
    'غليزان',
    'تيميمون',
    'برج باجي مختار',
    'أولاد جلال',
    'بني عباس',
    'عين صالح',
    'عين قزام',
    'تقرت',
    'جانت',
    'المغير',
    'المنيعة'
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredStates = List<String>.from(_states);
    _searchController.addListener(_filterStates);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  void _filterStates() {
    setState(() {
      _filteredStates = _states
          .where((String state) => state.contains(_searchController.text))
          .toList();
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        _showAccountDialogBasedOnType();
        break;
      case 1:
        _showStatesSheet();
        break;
      case 2:
        _showGpsLocationDialog();
        break;
    }
  }

  void _showAccountDialogBasedOnType() {
    switch (widget.accountType) {
      case 'normal':
        _showNormalAccountDialog();
        break;
      case 'store':
        _showStoreAccountDialog();
        break;
      case 'delivery':
        _showDeliveryAccountDialog();
        break;
    }
  }

  void _showNormalAccountDialog() {
    _showDialog(
      title: 'حساب عادي',
      children: <Widget>[
        const Text('خيارات الحساب العادي', textAlign: TextAlign.center),
        const SizedBox(height: 10),
        DialogOptionTile(
            icon: Icons.person,
            title: 'عرض الملف الشخصي',
            onTap: () {
              final NormalUserData userData =
                  Provider.of<NormalUserData>(context, listen: false);
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (_) =>
                        ChangeNotifierProvider<NormalUserData>.value(
                            value: userData,
                            child: const NormalUserProfileScreen())),
              );
            }),
        DialogOptionTile(
            icon: Icons.store,
            title: 'المحلات المتابعة',
            onTap: () {
              final NormalUserData userData =
                  Provider.of<NormalUserData>(context, listen: false);
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (_) =>
                        ChangeNotifierProvider<NormalUserData>.value(
                            value: userData,
                            child: const FollowedStoresScreen())),
              );
            }),
        DialogOptionTile(
            icon: Icons.notifications,
            title: 'الإشعارات',
            onTap: () {
              final NormalUserData userData =
                  Provider.of<NormalUserData>(context, listen: false);
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (_) =>
                        ChangeNotifierProvider<NormalUserData>.value(
                            value: userData,
                            child: const NotificationsScreen())),
              );
            }),
        const SizedBox(height: 10),
        AppButton(
            text: 'خروج من الحساب',
            color: Colors.grey[700]!,
            onPressed: _logout,
            minimumSize: const Size(double.infinity, 40)),
      ],
    );
  }

  void _showStoreAccountDialog() => _showDialog(
        title: 'حساب المحل',
        children: <Widget>[
          const Text('مهام حساب المحل', textAlign: TextAlign.center),
          const SizedBox(height: 10),
          AppButton(
              text: 'إدارة واجهة المحل',
              color: Colors.blue[800]!,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) => const ManageStoreInterfaceScreen()));
              },
              minimumSize: const Size(double.infinity, 40)),
          const SizedBox(height: 10),
          AppButton(
              text: 'إدارة المنتجات',
              color: Colors.green[700]!,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) => const ManageProductsScreen()));
              },
              minimumSize: const Size(double.infinity, 40)),
          const SizedBox(height: 10),
          AppButton(
              text: 'خروج من الحساب',
              color: Colors.grey[700]!,
              onPressed: _logout,
              minimumSize: const Size(double.infinity, 40)),
        ],
      );

  void _showDeliveryAccountDialog() => _showDialog(
        title: 'حساب التوصيل',
        children: <Widget>[
          const Text('مهام حساب التوصيل', textAlign: TextAlign.center),
          const SizedBox(height: 10),
          AppButton(
              text: 'قائمة الطلبات',
              color: primaryColor,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) =>
                            const DeliveryDashboardScreen(initialTabIndex: 0)));
              },
              minimumSize: const Size(double.infinity, 40)),
          const SizedBox(height: 10),
          AppButton(
              text: 'تأكيد التوصيل',
              color: primaryColor,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) =>
                            const DeliveryDashboardScreen(initialTabIndex: 2)));
              },
              minimumSize: const Size(double.infinity, 40)),
          const SizedBox(height: 10),
          AppButton(
              text: 'خروج من الحساب',
              color: Colors.grey[700]!,
              onPressed: _logout,
              minimumSize: const Size(double.infinity, 40)),
        ],
      );

  void _logout() async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 10));
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
              builder: (_) => const AccountTypeSelectionScreen()));
    }
  }

  void _showAIDialog() {
    _showDialog(
      title: 'خدمات الذكاء الإصطناعي',
      children: <Widget>[
        DialogOptionTile(
            icon: Icons.chat,
            title: 'روبوت دردشة',
            onTap: () => _showChatbotDialog()),
        DialogOptionTile(
            icon: Icons.recommend,
            title: 'توصيات المنتجات',
            onTap: () => _showRecommendationsDialog()),
      ],
    );
  }

  void _showChatbotDialog() {
    String? response;
    _showDialog(
      title: 'روبوت الدردشة',
      scrollable: true,
      children: <Widget>[
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _chatController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                    hintText: 'تفضل...كيف أساعدك',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              AppButton(
                  text: 'إرسال',
                  color: primaryColor,
                  onPressed: () {
                    setState(() {
                      response = _getChatbotResponse(_chatController.text);
                      _chatController.clear();
                    });
                  },
                  minimumSize: const Size(double.infinity, 40)),
              if (response != null) ...<Widget>[
                const SizedBox(height: 10),
                Text(response!, textAlign: TextAlign.center)
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getChatbotResponse(String query) {
    final String lowerQuery = query.toLowerCase();
    if (lowerQuery.contains('مرحبا') || lowerQuery.contains('اهلا')) {
      return 'أهلاً بك! كيف يمكنني مساعدتك اليوم؟';
    }
    if (lowerQuery.contains('اسمي')) return 'أنت المستخدم العادي، أليس كذلك؟';
    if (lowerQuery.contains('المحلات')) return 'أنت تتابع متاجر رائعة!';
    return 'عذرًا، لم أفهم استفسارك.';
  }

  void _showRecommendationsDialog() {
    _showDialog(
      title: 'توصيات المنتجات',
      children: <Widget>[
        const Text('إليك بعض المنتجات المقترحة:', textAlign: TextAlign.center),
        const SizedBox(height: 10),
        ...<String>['هاتف ذكي X1', 'قميص رجالي', 'قهوة فاخرة'].map((p) =>
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(p, textAlign: TextAlign.center))),
      ],
    );
  }

  void _showStatesSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            const Text('اختر الولاية',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)),
            const SizedBox(height: 20),
            TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                    hintText: 'ابحث عن ولاية', prefixIcon: Icon(Icons.search))),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredStates.length,
                itemBuilder: (_, i) => ListTile(
                    title: Text(_filteredStates[i], textAlign: TextAlign.right),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('تم اختيار: ${_filteredStates[i]}')));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGpsLocationDialog() {
    _showDialog(
      title: 'تحديد الموقع',
      children: <Widget>[
        const Text('السماح بالوصول إلى الموقع؟', textAlign: TextAlign.center),
        const SizedBox(height: 20),
        AppButton(
            text: 'تحديد الموقع',
            color: primaryColor,
            onPressed: () {
              Navigator.pop(context);
              _showCategorySelectionDialog();
            },
            minimumSize: const Size(double.infinity, 40)),
      ],
    );
  }

  void _showCategorySelectionDialog() {
    _showDialog(
      title: 'اختر فئة',
      children: <String>['ملابس', 'إلكترونيات', 'مأكولات']
          .map((c) => DialogOptionTile(
              icon: Icons.category,
              title: c,
              onTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('تم اختيار: $c')));
              }))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(searchController: _searchController),
      body: HomeBody(
        onEarnMoneyPressed: () => Navigator.push<void>(context,
            MaterialPageRoute<void>(builder: (_) => const EarnMoneyScreen())),
        onSmartShoppingPressed: _showAIDialog,
        onFavoritesPressed: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('لا توجد مفضلة'))),
        onDiscountsPressed: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('لا توجد عروض'))),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
          selectedIndex: _selectedIndex, onTap: _onBottomNavTapped),
    );
  }

  void _showDialog(
      {String title = '',
      required List<Widget> children,
      bool scrollable = false}) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: title.isEmpty
            ? null
            : Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
        content: scrollable
            ? SingleChildScrollView(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: children))
            : Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

/// Earn Money Screen
class EarnMoneyScreen extends StatelessWidget {
  const EarnMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('اربح معنا المال',
              style: TextStyle(color: Colors.white))),
      body: const Center(child: Text('شاشة كسب المال - تحت التطوير')),
    );
  }
}

/// Manage Store Interface Screen
class ManageStoreInterfaceScreen extends StatelessWidget {
  const ManageStoreInterfaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('إدارة واجهة المحل',
              style: TextStyle(color: Colors.white))),
      body: const Center(child: Text('إدارة المحل - تحت التطوير')),
    );
  }
}

/// Manage Products Screen
class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('إدارة المنتجات',
              style: TextStyle(color: Colors.white))),
      body: const Center(child: Text('إدارة المنتجات - تحت التطوير')),
    );
  }
}

/// Normal User Profile Screen
class NormalUserProfileScreen extends StatelessWidget {
  const NormalUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('الملف الشخصي',
              style: TextStyle(color: Colors.white))),
      body: const Center(child: Text('الملف الشخصي - تحت التطوير')),
    );
  }
}

/// Followed Stores Screen
class FollowedStoresScreen extends StatelessWidget {
  const FollowedStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('المحلات المتابعة',
              style: TextStyle(color: Colors.white))),
      body: const Center(child: Text('المحلات المتابعة - تحت التطوير')),
    );
  }
}

/// Notifications Screen
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title:
              const Text('الإشعارات', style: TextStyle(color: Colors.white))),
      body: const Center(child: Text('الإشعارات - تحت التطوير')),
    );
  }
}

/// Delivery Dashboard Screen
class DeliveryDashboardScreen extends StatelessWidget {
  final int initialTabIndex;
  const DeliveryDashboardScreen({super.key, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('لوحة التوصيل',
              style: TextStyle(color: Colors.white))),
      body: const Center(child: Text('لوحة التوصيل - تحت التطوير')),
    );
  }
}

