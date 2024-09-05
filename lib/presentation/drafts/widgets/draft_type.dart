///
enum DraftType {
  ///
  perpendicular(label: 'Perpendicular drafts'),
  marks(label: 'Draft marks');
  ///
  final String label;
  ///
  const DraftType({required this.label});
}
