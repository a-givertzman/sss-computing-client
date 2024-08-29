///
/// Enum of three main planes for
/// orthogonal projections.
enum FigurePlane { xy, yz, xz }
// ;
//   ///
//   const FigurePlane();
//   ///
//   factory FigurePlane.from(String text) => switch (text.toLowerCase().trim()) {
//         'xy' => FigurePlane.xy,
//         'yz' => FigurePlane.yz,
//         'xz' => FigurePlane.xz,
//         _ => throw Exception(),
//       };