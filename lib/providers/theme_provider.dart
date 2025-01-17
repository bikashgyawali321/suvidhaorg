import 'package:flutter/material.dart';
import 'package:suvidha/services/custom_hive.dart';

extension ColorX on String {
  Color get toColor => pastelCardColor[hashCode % pastelCardColor.length];
}

const primary = Colors.pink;
const primaryDark = Color(0xFF0A1543);
const secondary = Colors.grey;
const suvidhaWhite = Color(0xFFE5E5E5);
const pastelCardColor = [
  Color(0xFF9B6F6B), // Much Darker Soft Peach
  Color(0xFF6B8B8A), // Much Darker Pale Mint Green
  Color(0xFF6E4A7B), // Much Darker Light Lavender
  Color(0xFF8C6B3C), // Much Darker Soft Apricot
  Color(0xFF5F6F8D), // Much Darker Light Periwinkle
  Color(0xFF7A5B3F), // Much Darker Pastel Beige
  Color(0xFF4F6C78), // Much Darker Soft Sky Blue
  Color(0xFF6A5A3F), // Much Darker Light Sand
  Color(0xFF4D6B4D), // Much Darker Pale Sage Green
  Color(0xFF6F5C5D), // Much Darker Soft Blush Pink
  Color(0xFF8C6B6E), // Much Darker Soft Rose
  Color(0xFF7B9B8B), // Much Darker Light Sage
  Color(0xFFB86B5A), // Much Darker Soft Coral Peach
  Color(0xFF6B8BCC), // Much Darker Soft Baby Blue
  Color(0xFF8C6B9B), // Much Darker Light Mauve
  Color(0xFFB76B6B), // Much Darker Pale Pink
  Color(0xFF6BCC76), // Much Darker Light Lime Green
  Color(0xFF6BB4B6), // Much Darker Soft Mint
  Color(0xFF6B8C8C), // Much Darker Soft Aqua
  Color(0xFFB76B8C), // Much Darker Soft Pastel Pink
  Color(0xFF8C7B6B), // Much Darker Soft Vanilla
  Color(0xFF9B7B8C), // Much Darker Soft Lilac
  Color(0xFF7B8C8B), // Much Darker Light Teal Green
  Color(0xFFB76B7C), // Much Darker Soft Blush
  Color(0xFF6B8CB4), // Much Darker Soft Powder Blue
  Color(0xFF8C7B6B), // Much Darker Light Cream
  Color(0xFF6B9B8C), // Much Darker Light Sage Grey
  Color(0xFFB76B8C), // Much Darker Light Pastel Pink
  Color(0xFF8C6B9B), // Much Darker Light Lavender Grey
  Color(0xFF6B8C6B), // Much Darker Soft Pale Green
];
class ThemeProvider extends ChangeNotifier {
  late ThemeMode _themeMode;
  final CustomHive customHive = CustomHive();

  ThemeProvider() {
    _themeMode = ThemeMode.dark;
    _getThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  //get saved theme mode
  Future<void> _getThemeMode() async {
    _themeMode = await customHive.getThemeMode();
    notifyListeners();
  }

  //save theme
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    customHive.saveThemeMode(themeMode);
    notifyListeners();
  }
}
