class CareerModel {
  final String title;
  final String titleEn;
  final String block;
  final String salary;
  final String salaryEn;
  final String desc;
  final String descEn;

  const CareerModel({
    required this.title,
    required this.titleEn,
    required this.block,
    required this.salary,
    required this.salaryEn,
    required this.desc,
    required this.descEn,
  });

  String getTitle(String lang) => lang == 'en' ? titleEn : title;
  String getSalary(String lang) => lang == 'en' ? salaryEn : salary;
  String getDesc(String lang) => lang == 'en' ? descEn : desc;
}

const List<CareerModel> defaultCareers = [
  CareerModel(
    title: 'Công Nghệ Thông Tin / AI',
    titleEn: 'Information Technology / AI',
    block: 'A00, A01, D07',
    salary: '15 - 35 triệu/tháng',
    salaryEn: '\$600 - \$1,400 / month',
    desc: 'Lập trình ứng dụng, Trí tuệ nhân tạo, An ninh mạng.',
    descEn: 'Software Engineering, Artificial Intelligence, Cybersecurity.',
  ),
  CareerModel(
    title: 'Marketing & Truyền Thông',
    titleEn: 'Marketing & Communications',
    block: 'A01, D01, D07',
    salary: '12 - 28 triệu/tháng',
    salaryEn: '\$500 - \$1,100 / month',
    desc: 'Sáng tạo nội dung số, Quảng cáo trực tuyến, Truyền thông thương hiệu.',
    descEn: 'Digital Content Creation, Online Advertising, Brand Marketing.',
  ),
  CareerModel(
    title: 'Y Khoa & Dược Học',
    titleEn: 'Medicine & Pharmacy',
    block: 'B00, A00',
    salary: '15 - 40 triệu/tháng',
    salaryEn: '\$600 - \$1,600 / month',
    desc: 'Chẩn đoán điều trị bệnh, Nghiên cứu dược phẩm.',
    descEn: 'Disease Diagnosis & Treatment, Pharmaceutical Research.',
  ),
  CareerModel(
    title: 'Thiết Kế Đồ Họa / UI UX',
    titleEn: 'Graphic Design / UI UX',
    block: 'H00, V00, D01',
    salary: '10 - 25 triệu/tháng',
    salaryEn: '\$400 - \$1,000 / month',
    desc: 'Sáng tạo giao diện web/app, Thiết kế 3D & Truyền thông.',
    descEn: 'Web/App Interface Design, 3D Design & Media.',
  ),
];
