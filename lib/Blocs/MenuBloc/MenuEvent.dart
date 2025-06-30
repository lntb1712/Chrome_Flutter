abstract class MenuEvent {}

class MenuChangeEvent extends MenuEvent {
  final int selectedIndex;

  MenuChangeEvent(this.selectedIndex);
}
