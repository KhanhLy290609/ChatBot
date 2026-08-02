class CareerModel {
  final String title;
  final String block;
  final String salary;
  final String desc;

  const CareerModel({
    required this.title,
    required this.block,
    required this.salary,
    required this.desc,
  });
}

const List<CareerModel> defaultCareers = [
  CareerModel(
    title: 'Công Nghệ Thông Tin / AI',
    block: 'A00, A01, D07',
    salary: '15 - 35 triệu/tháng',
    desc: 'Lập trình ứng dụng, Trí tuệ nhân tạo, An ninh mạng.',
  ),
  CareerModel(
    title: 'Marketing & Truyền Thông',
    block: 'A01, D01, D07',
    salary: '12 - 28 triệu/tháng',
    desc: 'Sáng tạo nội dung số, Quảng cáo trực tuyến, Truyền thông thương hiệu.',
  ),
  CareerModel(
    title: 'Y Khoa & Dược Học',
    block: 'B00, A00',
    salary: '15 - 40 triệu/tháng',
    desc: 'Chẩn đoán điều trị bệnh, Nghiên cứu dược phẩm.',
  ),
  CareerModel(
    title: 'Thiết Kế Đồ Họa / UI UX',
    block: 'H00, V00, D01',
    salary: '10 - 25 triệu/tháng',
    desc: 'Sáng tạo giao diện web/app, Thiết kế 3D & Truyền thông.',
  ),
];
