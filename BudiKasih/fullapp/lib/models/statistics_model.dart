class StatisticsModel {
  final int totalDonasi;
  final int totalUang;
  final int totalBarang;

  StatisticsModel({
    required this.totalDonasi,
    required this.totalUang,
    required this.totalBarang,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalDonasi: json['total_donasi'] ?? 0,
      totalUang: json['total_uang'] ?? 0,
      totalBarang: json['total_barang'] ?? 0,
    );
  }
}