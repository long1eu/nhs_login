class NhsDisplay {
  const NhsDisplay._(this.value);

  final String value;

  static const NhsDisplay page = NhsDisplay._('page');

  static const NhsDisplay touch = NhsDisplay._('touch');

  @Deprecated('Value not supported in this version.')
  static const NhsDisplay popup = NhsDisplay._('popup');

  @Deprecated('Value not supported in this version.')
  static const NhsDisplay wap = NhsDisplay._('wap');

  static const List<NhsDisplay> values = <NhsDisplay>[
    page,
    touch,
    popup,
    wap,
  ];

  @override
  String toString() => value;
}
