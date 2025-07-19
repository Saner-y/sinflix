part of "../core.dart";

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Locale get locale => Localizations.localeOf(this);
}

extension ThemeExtension on BuildContext {
  ThemeData get currentThemeData => Theme.of(this);
}

extension MediaQueryExtension on BuildContext {
  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;
  double get lowValue => height * 0.012;
  double get normalValue => height * 0.02;
  double get mediumValue => height * 0.04;
  double get highValue => height * 0.07;
  double get bigValue => height * 0.1;
  double get hugeValue => height * 0.6;
}

extension MediaQueryExtensionDynamic on BuildContext {
  double getDynamicHeight(double percent) => height*(percent/100);
  double getDynamicWidth(double percent) => width*(percent/100);
}

extension PaddingExtensionAll on BuildContext {
  EdgeInsets get paddingMin => EdgeInsets.all(lowValue*0.5);
  EdgeInsets get paddingLow => EdgeInsets.all(lowValue);
  EdgeInsets get paddingNormal => EdgeInsets.all(normalValue);
  EdgeInsets get paddingMedium => EdgeInsets.all(mediumValue);
  EdgeInsets get paddingHigh => EdgeInsets.all(highValue);
  EdgeInsets get paddingHuge => EdgeInsets.all(hugeValue);
  EdgeInsets get paddingZero => EdgeInsets.zero;
}

extension PaddingExtensionSymetric on BuildContext {
  EdgeInsets get paddingLowVertical => EdgeInsets.symmetric(vertical: lowValue);
  EdgeInsets get paddingNormalVertical =>
      EdgeInsets.symmetric(vertical: normalValue);
  EdgeInsets get paddingMediumVertical =>
      EdgeInsets.symmetric(vertical: mediumValue);
  EdgeInsets get paddingHighVertical =>
      EdgeInsets.symmetric(vertical: highValue);
  EdgeInsets get paddingHugeVertical =>
      EdgeInsets.symmetric(vertical: hugeValue);
  EdgeInsets get paddingLowHorizontal =>
      EdgeInsets.symmetric(horizontal: lowValue);
  EdgeInsets get paddingNormalHorizontal =>
      EdgeInsets.symmetric(horizontal: normalValue);
  EdgeInsets get paddingMediumHorizontal =>
      EdgeInsets.symmetric(horizontal: mediumValue);
  EdgeInsets get paddingHighHorizontal =>
      EdgeInsets.symmetric(horizontal: highValue);
  EdgeInsets get paddingBigHorizontal =>
      EdgeInsets.symmetric(horizontal: bigValue);
  EdgeInsets get paddingHugeHorizontal =>
      EdgeInsets.symmetric(horizontal: hugeValue);
  EdgeInsets get paddingHugeHorizontalMediumVertical =>
      EdgeInsets.symmetric(horizontal: hugeValue, vertical: mediumValue);
  EdgeInsets get paddingHighHorizontalLowVertical =>
      EdgeInsets.symmetric(horizontal: highValue, vertical: lowValue);
  EdgeInsets get paddingMediumHorizontalLowVertical =>
      EdgeInsets.symmetric(horizontal: mediumValue, vertical: lowValue);
  EdgeInsets get paddingMediumVerticalLowHorizontal =>
      EdgeInsets.symmetric(horizontal: lowValue, vertical: mediumValue);
  EdgeInsets get paddingMediumBottomOnly =>
      EdgeInsets.only(bottom: mediumValue);
}

extension DurationExtension on BuildContext {
  Duration get lowDuration => const Duration(milliseconds: 500);
  Duration get normalDuration => const  Duration(seconds: 1);
}

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    final localization = AppLocalization.of(this);
    return localization?.translate(key) ?? key;
  }

  Widget trRichText(String key, {TextStyle? defaultStyle, TextStyle? underlineStyle}) {
    final text = tr(key);

    if (key == "agree_terms") {
      final locale = Localizations.localeOf(this);
      String underlineText;

      if (locale.languageCode == 'tr') {
        underlineText = "okudum ve kabul ediyorum";
      } else {
        underlineText = "read and agree";
      }

      final parts = text.split(underlineText);

      if (parts.length == 2) {
        return RichText(
          text: TextSpan(
            style: defaultStyle ?? TextStyle(color: Colors.black),
            children: [
              TextSpan(text: parts[0]),
              TextSpan(
                text: underlineText,
                style: (underlineStyle ?? TextStyle(color: Colors.black)).copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
              TextSpan(text: parts[1]),
            ],
          ),
        );
      }
    }

    return Text(text, style: defaultStyle);
  }
}

extension StringValidation on String {
  bool get isValidEmail => ValidationUtils.isValidEmail(this);

  ValidationResult validateEmailWithContext(BuildContext context) =>
    ValidationUtils.validateEmail(this, context);

  ValidationResult validatePasswordWithContext(BuildContext context) =>
    ValidationUtils.validatePassword(this, context);

  ValidationResult validateNameWithContext(BuildContext context) =>
    ValidationUtils.validateName(this, context);

}
