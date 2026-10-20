class FeedbackEntry {
  const FeedbackEntry({
    required this.id,
    required this.name,
    required this.message,
    required this.createdAt,
  });

  factory FeedbackEntry.create({
    required String name,
    required String message,
  }) {
    final now = DateTime.now();
    final trimmed = name.trim();
    return FeedbackEntry(
      id: now.microsecondsSinceEpoch.toString(),
      name: trimmed.isEmpty ? 'Anonymous' : trimmed,
      message: message.trim(),
      createdAt: now,
    );
  }

  final String id;
  final String name;
  final String message;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FeedbackEntry.fromJson(Map<String, dynamic> json) => FeedbackEntry(
        id: json['id'] as String,
        name: json['name'] as String? ?? 'Anonymous',
        message: json['message'] as String,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}
