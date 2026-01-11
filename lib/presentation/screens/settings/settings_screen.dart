import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

/// Professional settings screen with support info, notifications, and profile
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0B7A3E),
        title: Text(
          isArabic ? 'الإعدادات' : 'Settings',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          _buildProfileSection(isArabic),

          const SizedBox(height: 24),

          // General Settings
          _buildSectionTitle(isArabic ? 'عام' : 'General', Icons.settings),
          const SizedBox(height: 12),
          _buildLanguageCard(isArabic),
          const SizedBox(height: 12),
          _buildNotificationsCard(isArabic),

          const SizedBox(height: 32),

          // About & Support
          _buildSectionTitle(isArabic ? 'عن التطبيق والدعم' : 'About & Support', Icons.info_outline),
          const SizedBox(height: 12),
          _buildAboutCard(isArabic),
          const SizedBox(height: 12),
          _buildSupportCard(isArabic),

          const SizedBox(height: 32),

          // Logout
          _buildLogoutButton(isArabic),


          const SizedBox(height: 16),
          
          // Delete Account Link
          _buildDeleteAccountButton(isArabic),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileSection(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B7A3E), Color(0xFF0D9B4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B7A3E).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Color(0xFF0B7A3E),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'الملف الشخصي' : 'My Profile',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic ? 'عرض وتعديل المعلومات الشخصية' : 'View and edit your information',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF0B7A3E)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageCard(bool isArabic) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () => _showLanguageDialog(context, isArabic),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.language, color: Colors.blue, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'اللغة' : 'Language',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic ? 'العربية' : 'English',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_active, color: Colors.orange, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'الإشعارات' : 'Notifications',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic 
                      ? _notificationsEnabled ? 'مُفعّلة' : 'مُعطلة'
                      : _notificationsEnabled ? 'Enabled' : 'Disabled',
                  style: TextStyle(
                    fontSize: 14,
                    color: _notificationsEnabled ? Colors.green : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: _notificationsEnabled,
              activeColor: const Color(0xFF0B7A3E),
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[300],
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? (isArabic ? '✓ تم تفعيل الإشعارات' : '✓ Notifications enabled')
                          : (isArabic ? '✗ تم تعطيل الإشعارات' : '✗ Notifications disabled'),
                    ),
                    backgroundColor: value ? Colors.green : Colors.grey[700],
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(bool isArabic) {
    final arabicDescription = '''
نظام QHSE هو تطبيق متكامل لإدارة مخالفات السلامة والصحة والجودة والبيئة. يتيح للمستخدمين تسجيل المخالفات ومتابعتها بسهولة، مع دعم كامل للعمل دون اتصال بالإنترنت. 

المميزات الرئيسية:
• تسجيل المخالفات بالصور والموقع
• نظام متابعة احترافي
• تقارير وإحصائيات تفصيلية
• دعم اللغة العربية والإنجليزية''';

    final englishDescription = '''
QHSE System is a comprehensive app for managing violations in Safety, Health, Quality, and Environment. It allows users to easily record and track violations with full offline support.

Key Features:
• Record violations with photos & location
• Professional tracking system
• Detailed reports and statistics
• Arabic and English support''';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () => _showAboutDialog(context, isArabic),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B7A3E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.info, color: Color(0xFF0B7A3E), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'عن التطبيق' : 'About App',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic ? 'نظام إدارة المخالفات QHSE' : 'QHSE Violation Management System',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.support_agent, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                isArabic ? 'المساعدة والدعم' : 'Help & Support',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Engineer Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildContactRow(
                  Icons.person,
                  isArabic ? 'مهندس' : 'Engineer',
                  isArabic ? 'تامر الجوهري' : 'Tamer ElGohary',
                  Colors.purple,
                ),
                const Divider(height: 24),
                _buildContactRow(
                  Icons.email,
                  isArabic ? 'البريد الإلكتروني' : 'Email',
                  'tgohary@sajco.com.sa',
                  Colors.red,
                  onTap: () => _launchEmail('tgohary@sajco.com.sa'),
                ),
                const Divider(height: 24),
                _buildContactRow(
                  Icons.phone,
                  isArabic ? 'الجوال' : 'Mobile',
                  '00966554063399',
                  Colors.green,
                  onTap: () => _launchPhone('00966554063399'),
                ),
                const Divider(height: 24),
                _buildContactRow(
                  Icons.chat,
                  'WhatsApp',
                  '00966554063399',
                  const Color(0xFF25D366),
                  onTap: () => _launchWhatsApp('00966554063399'),
                ),
                const Divider(height: 24),
                _buildContactRow(
                  Icons.business,
                  isArabic ? 'القسم' : 'Department',
                  isArabic 
                      ? 'إدارة تكنولوجيا المعلومات'
                      : 'IT Department',
                  Colors.blue,
                ),
                const Divider(height: 24),
                _buildContactRow(
                  Icons.location_on,
                  isArabic ? 'المقر' : 'Location',
                  isArabic 
                      ? 'المركز الرئيسي - الملز'
                      : 'Head Office - Al Malaz',
                  Colors.orange,
                ),
                const Divider(height: 24),
                _buildContactRow(
                  Icons.apartment,
                  isArabic ? 'الشركة' : 'Company',
                  isArabic 
                      ? 'شركة شبه الجزيرة للمقاولات'
                      : 'SAJCO – Shibh Al Jazira Contracting Company',
                  const Color(0xFF0B7A3E),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String label,
    String value,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.open_in_new, size: 18, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context, isArabic),
        icon: const Icon(Icons.exit_to_app, size: 24),
        label: Text(
          isArabic ? 'تسجيل الخروج' : 'Logout',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'اختر اللغة' : 'Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
              title: const Text('العربية'),
              onTap: () {
                context.setLocale(const Locale('ar', 'SA'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              onTap: () {
                context.setLocale(const Locale('en', 'US'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, bool isArabic) {
    final arabicDescription = '''نظام QHSE هو تطبيق متكامل لإدارة مخالفات السلامة والصحة والجودة والبيئة. يتيح للمستخدمين تسجيل المخالفات ومتابعتها بسهولة، مع دعم كامل للعمل دون اتصال بالإنترنت.

المميزات الرئيسية:
• تسجيل المخالفات بالصور والموقع
• نظام متابعة احترافي
• تقارير وإحصائيات تفصيلية  
• دعم اللغة العربية والإنجليزية''';

    final englishDescription = '''QHSE System is a comprehensive app for managing violations in Safety, Health, Quality, and Environment. It allows users to easily record and track violations with full offline support.

Key Features:
• Record violations with photos & location
• Professional tracking system
• Detailed reports and statistics
• Arabic and English support''';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0B7A3E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info, color: Color(0xFF0B7A3E)),
            ),
            const SizedBox(width: 12),
            Text(isArabic ? 'عن التطبيق' : 'About App'),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            isArabic ? arabicDescription : englishDescription,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'تسجيل الخروج' : 'Logout'),
        content: Text(
          isArabic 
              ? 'هل أنت متأكد من تسجيل الخروج؟' 
              : 'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close dialog first
              Navigator.pop(context);
              
              // Get auth provider
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              
              // Perform logout
              await authProvider.logout();
              
              // Show success message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isArabic ? 'تم تسجيل الخروج بنجاح' : 'Logged out successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(isArabic ? 'تسجيل الخروج' : 'Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountButton(bool isArabic) {
    return Center(
      child: TextButton.icon(
        onPressed: () => _showDeleteAccountDialog(context, isArabic),
        icon: Icon(Icons.delete_forever, color: Colors.red.withOpacity(0.7), size: 20),
        label: Text(
          isArabic ? 'حذف الحساب' : 'Delete Account',
          style: TextStyle(
            fontSize: 14,
            color: Colors.red.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'حذف الحساب' : 'Delete Account', style: const TextStyle(color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic 
                  ? 'هل أنت متأكد من حذف حسابك نهائياً؟' 
                  : 'Are you sure you want to permanently delete your account?',
            ),
            const SizedBox(height: 8),
            Text(
              isArabic 
                  ? 'سيتم حذف جميع بياناتك ولا يمكن استعادتها.' 
                  : 'All your data will be erased and cannot be recovered.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close dialog first
              Navigator.pop(context);
              
              // Get auth provider
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              
              // Perform deletion
              final success = await authProvider.deleteAccount();
              
              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isArabic ? 'تم حذف الحساب بنجاح' : 'Account deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Navigation to login should be handled by auth state listener or root widget, 
                  // but if not, we might need to push replacement. 
                  // Assuming AuthProvider notifies and listener handles it.
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isArabic ? 'فشل حذف الحساب' : 'Failed to delete account'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(isArabic ? 'حذف نهائي' : 'Delete Permanently'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    await Clipboard.setData(ClipboardData(text: email));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Email copied: $email'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _launchPhone(String phone) async {
    await Clipboard.setData(ClipboardData(text: phone));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Phone copied: $phone'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    await Clipboard.setData(ClipboardData(text: phone));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ WhatsApp number copied: $phone'),
          backgroundColor: const Color(0xFF25D366),
        ),
      );
    }
  }
}
