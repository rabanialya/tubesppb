class DonasiModel {
  final int? id;
  final int? userId;
  final String donatur;
  final String jenis;
  final String detail;
  final String jumlah;
  final String tanggal;
  final String status;
  final String statusVerifikasi;
  final String? petugas;
  final String? bukti;
  final String? catatan;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  DonasiModel({
    this.id,
    this.userId,
    required this.donatur,
    required this.jenis,
    required this.detail,
    required this.jumlah,
    required this.tanggal,
    required this.status,
    required this.statusVerifikasi,
    this.petugas,
    this.bukti,
    this.catatan,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory DonasiModel.fromJson(Map<String, dynamic> json) {
    final donaturStr = json['donatur']?.toString() ?? '';
    final parts = donaturStr.contains('|') 
        ? donaturStr.split('|') 
        : [donaturStr, '', ''];

    return DonasiModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '0'),
      donatur: parts[0],
      jenis: json['jenis']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
      jumlah: json['jumlah']?.toString() ?? '0',
      tanggal: json['tanggal']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
      statusVerifikasi: json['status_verifikasi']?.toString() ?? 'pending',
      petugas: json['petugas']?.toString(),
      bukti: json['bukti']?.toString(),
      catatan: json['catatan']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'donatur': donatur,
      'jenis': jenis,
      'detail': detail,
      'jumlah': jumlah,
      'tanggal': tanggal,
      'status': status,
      'status_verifikasi': statusVerifikasi,
      'petugas': petugas,
      'bukti': bukti,
      'catatan': catatan,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}