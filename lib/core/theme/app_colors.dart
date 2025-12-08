import 'package:flutter/material.dart';

/// Primary Colors (الألوان الأساسية)
class AppColors {
  // Primary Green Theme
  static const Color primary = Color(0xFF16A34A);        // Green-600
  static const Color primaryDark = Color(0xFF15803D);    // Green-700
  static const Color primaryLight = Color(0xFF22C55E);   // Green-500
  
  // Background Colors
  static const Color background = Color(0xFFF8FAFC);     // Slate-50
  static const Color surface = Color(0xFFFFFFFF);        // White
  static const Color cardBg = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);    // Slate-900
  static const Color textSecondary = Color(0xFF64748B);  // Slate-500
  static const Color textMuted = Color(0xFF94A3B8);      // Slate-400
  
  // Border Colors
  static const Color border = Color(0xFFE2E8F0);         // Slate-200
  static const Color borderLight = Color(0xFFF1F5F9);    // Slate-100
}

/// QHSE Domain Colors (ألوان التصنيفات)
class QHSEColors {
  // Safety (السلامة) - Red
  static const Color safety = Color(0xFFEF4444);         // Red-500
  static const Color safetyLight = Color(0xFFFEE2E2);    // Red-100
  static const Color safetyDark = Color(0xFFDC2626);     // Red-600
  
  // Health (الصحة المهنية) - Emerald
  static const Color health = Color(0xFF10B981);         // Emerald-500
  static const Color healthLight = Color(0xFFD1FAE5);    // Emerald-100
  static const Color healthDark = Color(0xFF059669);     // Emerald-600
  
  // Quality (الجودة) - Blue
  static const Color quality = Color(0xFF3B82F6);        // Blue-500
  static const Color qualityLight = Color(0xFFDBEAFE);   // Blue-100
  static const Color qualityDark = Color(0xFF2563EB);    // Blue-600
  
  // Environment (البيئة) - Amber/Orange
  static const Color environment = Color(0xFFF59E0B);    // Amber-500
  static const Color environmentLight = Color(0xFFFEF3C7); // Amber-100
  static const Color environmentDark = Color(0xFFD97706); // Amber-600
}

/// Status Colors (ألوان الحالات)
class StatusColors {
  // Violation Statuses
  static const Color draft = Color(0xFF94A3B8);          // Slate-400
  static const Color pending = Color(0xFFF59E0B);        // Amber-500
  static const Color underReview = Color(0xFFF97316);    // Orange-500
  static const Color approved = Color(0xFF22C55E);       // Green-500
  static const Color closed = Color(0xFF3B82F6);         // Blue-500
  static const Color rejected = Color(0xFFEF4444);       // Red-500
  
  // Severity Levels
  static const Color low = Color(0xFF22C55E);            // Green-500
  static const Color medium = Color(0xFFF59E0B);         // Amber-500
  static const Color high = Color(0xFFF97316);           // Orange-500
  static const Color critical = Color(0xFFEF4444);       // Red-500
  
  // Category Colors
  static const Color minor = Color(0xFF22C55E);          // Green
  static const Color semiMajor = Color(0xFFF59E0B);      // Amber
  static const Color major = Color(0xFFEF4444);          // Red
}

/// Role Colors (ألوان الأدوار)
class RoleColors {
  static const Color admin = Color(0xFF9333EA);          // Purple
  static const Color ceo = Color(0xFFD97706);            // Amber
  static const Color hseManager = Color(0xFF2563EB);     // Blue
  static const Color safetyManager = Color(0xFFF97316);  // Orange
  static const Color qualityManager = Color(0xFF6366F1); // Indigo
  static const Color healthManager = Color(0xFFEC4899);  // Pink
  static const Color environmentManager = Color(0xFF22C55E); // Green
  static const Color safetyOfficer = Color(0xFFFB923C);  // Orange-400
  static const Color qualityOfficer = Color(0xFF818CF8); // Indigo-400
  static const Color healthOfficer = Color(0xFFF472B6);  // Pink-400
  static const Color environmentOfficer = Color(0xFF4ADE80); // Green-400
  static const Color projectManager = Color(0xFF64748B); // Slate
  static const Color user = Color(0xFF6B7280);           // Gray
}
