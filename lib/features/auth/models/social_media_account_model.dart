enum SOCIAL_MEDIA_PROVIDER { GOOGLE }

class SocialMediaAccount {
  final String provider;
  final String accountId;

//<editor-fold desc="Data Methods">
  const SocialMediaAccount({
    required this.provider,
    required this.accountId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SocialMediaAccount &&
          runtimeType == other.runtimeType &&
          provider == other.provider &&
          accountId == other.accountId);

  @override
  int get hashCode => provider.hashCode ^ accountId.hashCode;

  @override
  String toString() {
    return 'SocialMediaAccount{' +
        ' provider: $provider,' +
        ' accountId: $accountId,' +
        '}';
  }

  SocialMediaAccount copyWith({
    String? provider,
    String? accountId,
  }) {
    return SocialMediaAccount(
      provider: provider ?? this.provider,
      accountId: accountId ?? this.accountId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'provider': this.provider,
      'accountId': this.accountId,
    };
  }

  factory SocialMediaAccount.fromMap(Map<String, dynamic> map) {
    return SocialMediaAccount(
      provider: map['provider'] as String,
      accountId: map['accountId'] as String,
    );
  }

//</editor-fold>
}
