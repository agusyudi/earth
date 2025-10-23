class ApiBaseResponse {
  final bool? status;
  final String? message;
  final dynamic data;
  final int? totalpage;
  final int? totalrecord;
  final int? currentpage;
  final double? executionTime;
  final int? affectedRow;

  ApiBaseResponse({
    this.status = false,
    this.message = '-',
    this.data,
    this.totalpage = 1,
    this.totalrecord = 0,
    this.currentpage = 1,
    this.executionTime = 0,
    this.affectedRow = 0,
  });
}
