import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animations.dart';
import '../../../core/constants/app_icons.dart';
import '../../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        // Navigate to dashboard - the app widget will handle this automatically
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'login_failed'.tr()),
            backgroundColor: StatusColors.rejected,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isArabic = context.locale.languageCode == 'ar';
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      body: Row(
        children: [
          // Left Panel - Company Info (Hidden on mobile)
          if (!isMobile) _buildLeftPanel(isArabic),
          
          // Right Panel - Login Form
          Expanded(
            child: _buildLoginForm(authProvider, isArabic),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPanel(bool isArabic) {
    return Container(
      width: 480,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B7A3E), // Dark green
            Color(0xFF0D9448), // Medium green
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // Company Logo with Animation
            AppAnimations.scaleIn(
              duration: AppAnimations.slow,
              child: AppAnimations.shimmer(
                duration: const Duration(milliseconds: 2000),
                child: Container(
                  width: 140,
                  height: 140,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.shield_rounded,
                          size: 70,
                          color: Color(0xFF0B7A3E),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 28),
            
            // Company Name with Animation
            AppAnimations.slideIn(
              duration: AppAnimations.slow,
              begin: const Offset(0, 0.2),
              child: Text(
                isArabic ? 'شركة شبه الجزيرة للمقاولات' : 'SAJCO – Shibh Al Jazira Contracting Company',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // System Description
            Text(
              isArabic 
                  ? 'نظام إدارة مخالفات السلامة والجودة' 
                  : 'Safety & Quality Violation Management System',
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // System Title
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                isArabic ? 'نظام QHSE متكامل' : 'Complete QHSE System',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // QHSE Icons
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildQhseIcon(Icons.shield_outlined, isArabic ? 'السلامة' : 'Safety'),
                _buildQhseIcon(Icons.medical_services_outlined, isArabic ? 'الصحة' : 'Health'),
                _buildQhseIcon(Icons.verified_outlined, isArabic ? 'الجودة' : 'Quality'),
                _buildQhseIcon(Icons.eco_outlined, isArabic ? 'البيئة' : 'Environment'),
              ],
            ),
            
            const SizedBox(height: 36),
            
            // System Features Title
            Text(
              isArabic ? 'مميزات النظام' : 'System Features',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Features Grid
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildFeatureCard(Icons.description_outlined, 
                    isArabic ? 'التقارير' : 'Reports', 
                    isArabic ? '171 نوع مخالفة' : '171 Violation Types'),
                _buildFeatureCard(Icons.business_outlined, 
                    isArabic ? 'إدارة المشاريع' : 'Projects', 
                    isArabic ? '13 دور وظيفي' : '13 Job Roles'),
                _buildFeatureCard(Icons.school_outlined, 
                    isArabic ? 'التدريب' : 'Training', 
                    isArabic ? 'برامج متخصصة' : 'Specialized'),
                _buildFeatureCard(Icons.bar_chart_outlined, 
                    isArabic ? 'الإحصائيات' : 'Statistics', 
                    isArabic ? 'تحليلات متقدمة' : 'Advanced'),
                _buildFeatureCard(Icons.notifications_outlined, 
                    isArabic ? 'الإشعارات' : 'Notifications', 
                    isArabic ? 'فورية' : 'Real-time'),
                _buildFeatureCard(Icons.build_outlined, 
                    isArabic ? 'المعدات' : 'Equipment', 
                    isArabic ? 'إدارة كاملة' : 'Full Management'),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Bottom Tagline
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      isArabic ? 'السلامة أولاً - نظام أمن وصحي متكامل' : 'Safety First - Complete Security & Health System',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildQhseIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Mobile Header with Professional Description
  Widget _buildMobileHeader(bool isArabic) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B7A3E),
            Color(0xFF0D9448),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              // Logo with Animation
              AppAnimations.scaleIn(
                duration: AppAnimations.slow,
                child: Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.shield_rounded,
                          size: 40,
                          color: Color(0xFF0B7A3E),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Company Name
              Text(
                isArabic ? 'شركة شبه الجزيرة للمقاولات' : 'SAJCO',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 4),
              
              // System Description
              Text(
                isArabic 
                    ? 'نظام إدارة مخالفات السلامة والجودة' 
                    : 'Safety & Quality Violation System',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // QHSE Icons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMobileQhseIcon(Icons.shield_outlined, isArabic ? 'السلامة' : 'Safety'),
                  const SizedBox(width: 16),
                  _buildMobileQhseIcon(Icons.medical_services_outlined, isArabic ? 'الصحة' : 'Health'),
                  const SizedBox(width: 16),
                  _buildMobileQhseIcon(Icons.verified_outlined, isArabic ? 'الجودة' : 'Quality'),
                  const SizedBox(width: 16),
                  _buildMobileQhseIcon(Icons.eco_outlined, isArabic ? 'البيئة' : 'Env'),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Feature Chips
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildMobileChip(Icons.description_outlined, isArabic ? '171 مخالفة' : '171 Types'),
                  _buildMobileChip(Icons.business_outlined, isArabic ? 'المشاريع' : 'Projects'),
                  _buildMobileChip(Icons.notifications_outlined, isArabic ? 'إشعارات' : 'Alerts'),
                  _buildMobileChip(Icons.bar_chart_outlined, isArabic ? 'تقارير' : 'Reports'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileQhseIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(AuthProvider authProvider, bool isArabic) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Mobile Header with Professional Description
            if (isMobile) _buildMobileHeader(isArabic),
            
            // Login Form
            Padding(
              padding: EdgeInsets.all(isMobile ? 24 : 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo (only on desktop, mobile has it in header)
                      if (!isMobile)
                        Center(
                          child: AppAnimations.scaleIn(
                            duration: AppAnimations.verySlow,
                            child: Container(
                              width: 120,
                              height: 120,
                              margin: const EdgeInsets.only(bottom: 32),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppTheme.largeRadius,
                                boxShadow: [
                                  AppTheme.coloredShadow(
                                    AppTheme.primaryGreen,
                                    opacity: 0.15,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: AppTheme.largeRadius,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.shield_rounded,
                                      size: 60,
                                      color: AppTheme.primaryGreen,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Welcome Text (smaller on mobile since we have header)
                      AppAnimations.slideIn(
                        duration: AppAnimations.slow,
                        begin: const Offset(0, 0.1),
                        child: Column(
                          children: [
                            Text(
                              isArabic ? 'تسجيل الدخول' : 'Sign In',
                              style: (isMobile ? AppTheme.heading2 : AppTheme.heading1).copyWith(
                                color: AppTheme.primaryGreen,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isArabic 
                                  ? 'أدخل بياناتك للمتابعة'
                                  : 'Enter your credentials to continue',
                              style: AppTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: isMobile ? 24 : 40),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      labelText: isArabic ? 'البريد الإلكتروني' : 'Email',
                      hintText: 'admin@sajco.com.sa',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0B7A3E), width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isArabic ? 'البريد الإلكتروني مطلوب' : 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return isArabic ? 'البريد الإلكتروني غير صحيح' : 'Invalid email';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      labelText: isArabic ? 'كلمة السر' : 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0B7A3E), width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isArabic ? 'كلمة السر مطلوبة' : 'Password is required';
                      }
                      if (value.length < 6) {
                        return isArabic 
                            ? 'كلمة السر يجب أن تكون 6 أحرف على الأقل'
                            : 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 32),

                  // Login Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B7A3E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isArabic ? 'تسجيل الدخول' : 'Sign In',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  isArabic ? Icons.arrow_back : Icons.arrow_forward,
                                  size: 20,
                                ),
                              ],
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Divider with "Or"
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          isArabic ? 'أو' : 'Or',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // Create Account Button
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isArabic ? 'التسجيل قريباً' : 'Registration coming soon'),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0B7A3E),
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isArabic ? 'إنشاء حساب جديد' : 'Create New Account',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Forgot Password Link
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isArabic 
                                ? 'استعادة كلمة السر قريباً'
                                : 'Password recovery coming soon'
                          ),
                        ),
                      );
                    },
                    child: Text(
                      isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Language Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLanguageButton(
                        label: 'العربية',
                        isSelected: isArabic,
                        onTap: () {
                          if (!isArabic) {
                            context.setLocale(const Locale('ar', 'SA'));
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildLanguageButton(
                        label: 'English',
                        isSelected: !isArabic,
                        onTap: () {
                          if (isArabic) {
                            context.setLocale(const Locale('en', 'US'));
                          }
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Footer
                  Text(
                    '© 2024 SAJCO. All rights reserved.',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0B7A3E) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0B7A3E) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
