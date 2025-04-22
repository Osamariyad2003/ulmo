enum LayoutStateStatus { initial, changeBottomNavIndex }

class LayoutState {
  final LayoutStateStatus status;
  final int bottomNavIndex;

  const LayoutState({
    required this.status,
    required this.bottomNavIndex,
  });

  factory LayoutState.initial() => const LayoutState(
    status: LayoutStateStatus.initial,
    bottomNavIndex: 0,
  );

  LayoutState copyWith({
    LayoutStateStatus? status,
    int? bottomNavIndex,
  }) {
    return LayoutState(
      status: status ?? this.status,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
    );
  }
}
