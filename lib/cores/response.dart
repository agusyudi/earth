class ResponseResult {
  bool? status = false;
  String? title = 'Terjadi Kesalahan';
  String? message = 'Kesalahan tidak diketahui';
  ResponseResult({this.status, this.title, this.message});
}
