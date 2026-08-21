import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const DentalApp());
}

class DentalApp extends StatelessWidget {
  const DentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'حجز عيادة الأسنان',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A), // أزرق ليلي طبي
        cardColor: const Color(0xFF1E293B),
        primaryColor: const Color(0xFF0EA5E9), // أزرق سماوي
      ),
      home: const DentalBookingScreen(),
    );
  }
}

class DentalBookingScreen extends StatefulWidget {
  const DentalBookingScreen({super.key});

  @override
  State<DentalBookingScreen> createState() => _DentalBookingScreenState();
}

class _DentalBookingScreenState extends State<DentalBookingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedTime;
  String? _selectedService = 'فحص واستشارة'; // الخدمة الافتراضية

  final List<String> _services = [
    'فحص واستشارة',
    'تنظيف وتلميع الأسنان',
    'حشوة أسنان',
    'قلع سن',
    'تبييض الأسنان',
    'تقويم الأسنان',
  ];

  final List<String> _timeSlots = [
    'مساءً 04:00',
    'مساءً 05:00',
    'مساءً 06:00',
    'مساءً 07:00',
    'مساءً 08:00',
    'مساءً 09:00',
  ];

  Future<void> _sendToWhatsApp() async {
    final String name = _nameController.text.trim();
    final String phone = _phoneController.text.trim();
    const String whatsappNumber = "9647854777816";

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال الاسم ورقم الهاتف')),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار وقت الحجز')),
      );
      return;
    }

    final String message = Uri.encodeComponent(
      "حجز موعد عيادة أسنان 🦷\n\n"
      "👤 الاسم: $name\n"
      "📞 الهاتف: $phone\n"
      "🩺 الخدمة المطلوبة: $_selectedService\n"
      "⏰ الوقت المختار: $_selectedTime",
    );

    final Uri url = Uri.parse("https://wa.me/$whatsappNumber?text=$message");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح تطبيق الواتساب')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // الهيدر والأيقونات الطبية
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services_outlined, color: Color(0xFF0EA5E9), size: 36),
                  SizedBox(width: 15),
                  Icon(Icons.clean_hands_outlined, color: Color(0xFF0EA5E9), size: 36),
                  SizedBox(width: 15),
                  Icon(Icons.health_and_safety_outlined, color: Color(0xFF0EA5E9), size: 36),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'مركز العناية بالأسنان',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // الاسم
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'اسم المريض الكامل',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF0EA5E9)),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF0EA5E9)),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // الهاتف
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF0EA5E9)),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF0EA5E9)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // اختيار نوع العلاج/الخدمة
              const Text(
                'نوع الحجز / الخدمة',
                style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedService,
                    dropdownColor: const Color(0xFF1E293B),
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0EA5E9)),
                    items: _services.map((String service) {
                      return DropdownMenuItem<String>(
                        value: service,
                        child: Text(service),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedService = newValue;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // أوقات الحجز المسائية (العيادات غالباً تعمل مساءً)
              const Text(
                'اختر وقت المراجعة',
                style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _timeSlots.length,
                itemBuilder: (context, index) {
                  final time = _timeSlots[index];
                  final isSelected = _selectedTime == time;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF0EA5E9) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF0EA5E9) : const Color(0xFF334155),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // زر الإرسال
              ElevatedButton.icon(
                onPressed: _sendToWhatsApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'حجز الموعد عبر الواتساب',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
