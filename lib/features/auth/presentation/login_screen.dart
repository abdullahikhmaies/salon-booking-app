import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../booking/presentation/barber_selection_screen.dart';
import '../../booking/domain/models/barber.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  void _sendOtp() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'الرجاء إدخال اسمك الكريم',
            // Default font is now Cairo from theme
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (_phoneController.text.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'الرجاء إدخال رقم هاتف صحيح',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate OTP sending delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      // Navigate to Barber Selection Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BarberSelectionScreen(
            customerName: _nameController.text.trim(),
            customerPhone: _phoneController.text.trim(),
          ),
        ),
      );
    });
  }

  void _showManagerLoginDialog() {
    final TextEditingController passwordController = TextEditingController();
    bool isAdminLogin = true;
    String? selectedBarberId;
    if (dummyBarbers.isNotEmpty) {
      selectedBarberId = dummyBarbers.first.id;
    }
    bool isError = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'دخول الطاقم',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(
                        value: true,
                        label: Text('إدارة', style: TextStyle(fontSize: 14)),
                      ),
                      ButtonSegment<bool>(
                        value: false,
                        label: Text('حلاق', style: TextStyle(fontSize: 14)),
                      ),
                    ],
                    selected: {isAdminLogin},
                    onSelectionChanged: (Set<bool> newSelection) {
                      setDialogState(() {
                        isAdminLogin = newSelection.first;
                      });
                    },
                  ),
                  if (!isAdminLogin && dummyBarbers.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: dummyBarbers.any((b) => b.id == selectedBarberId)
                          ? selectedBarberId
                          : dummyBarbers.first.id,
                      dropdownColor: Theme.of(context).colorScheme.surface,
                      items: dummyBarbers
                          .map(
                            (b) => DropdownMenuItem(
                              value: b.id,
                              child: Text(b.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => selectedBarberId = val),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'الرمز السري',
                      errorText: isError ? 'الرمز السري غير صحيح!' : null,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    bool isValid = false;
                    // Manager PIN = 1234 , Barber PIN = 0000
                    if (isAdminLogin && passwordController.text == '1234') {
                      isValid = true;
                    }
                    if (!isAdminLogin && passwordController.text == '0000') {
                      isValid = true;
                    }

                    if (isValid) {
                      Navigator.pop(context); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(
                            isAdmin: isAdminLogin,
                            barberId: isAdminLogin ? null : selectedBarberId,
                          ),
                        ),
                      );
                    } else {
                      setDialogState(() {
                        isError = true;
                      });
                    }
                  },
                  child: const Text('دخول'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showReviewDialog() {
    int rating = 5;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'كيف كانت تجربتك اليوم؟ ✂️',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'نرجو تقييم حلاقتك الأخيرة مع صالوننا',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: theme.primaryColor,
                          size: 36,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'أضف تعليقاً (اختياري)...',
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'تخطي',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'شكراً لتقييمك! تم رفع تقييمك للحلاق إضافة لتقييم الصالون ⭐️',
                        ),
                        backgroundColor: theme.primaryColor,
                      ),
                    );
                  },
                  child: const Text('إرسال التقييم'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          image: const DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
            opacity: 0.3, // Opacity lowered so inputs remain very clear
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Real Logo with FadeIn effect
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: child,
                      );
                    },
                    child: Center(
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.8),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/logo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'SK SAMER IKHMIES',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 32,
                      letterSpacing: 2,
                      color: theme.primaryColor, // الذهبي
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'BARBER SHOP',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 16,
                      letterSpacing: 6,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'سجل اسمك ورقم هاتفك لحجز الموعد',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name Input Field
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'اسمك الكريم (مثال: أحمد محمود)',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone Input Field
                  Directionality(
                    textDirection: TextDirection.ltr, // Keep phone number LTR
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(fontSize: 18, letterSpacing: 2),
                      decoration: InputDecoration(
                        hintText: '7X XXX XXXX',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '+962',
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 1,
                                height: 24,
                                color: Colors.white24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    child: _isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text('دخول كزبون'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _showManagerLoginDialog,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    child: Text(
                      'دخول كمدير صالون / حلاق',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Temporary button just for the owner to preview the Review mechanic
                  TextButton.icon(
                    onPressed: _showReviewDialog,
                    icon: const Icon(Icons.star, color: Colors.amberAccent),
                    label: const Text(
                      'تجربة نافذة التقيم للزبائن',
                      style: TextStyle(
                        color: Colors.white54,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
