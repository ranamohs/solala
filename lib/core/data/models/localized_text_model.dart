class LocalizedText {
  final String ar;
  final String en;

  LocalizedText({
    required this.ar,
    required this.en,
  });

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      ar: json['ar'] ?? '',
      en: json['en'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'ar': ar,
      'en': en,
    };
  }
}