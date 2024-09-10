///
/// Enum of draft types
enum DraftType {
  ///
  /// Drafts on perpendicular.
  perpendicular(label: 'Perpendicular drafts'),
  ///
  /// Drafts on ship depth marks.
  marks(label: 'Draft marks');
  ///
  /// Label text for draft type.
  final String label;
  ///
  const DraftType({required this.label});
}
