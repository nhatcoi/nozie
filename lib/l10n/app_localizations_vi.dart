// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'NoZie';

  @override
  String get forgotPasswordTitle => 'Quên Mật Khẩu 🔑';

  @override
  String get forgotPasswordDes => 'Nhập email của bạn, chúng tôi sẽ gửi mã OTP để xác minh ở bước tiếp theo.';

  @override
  String get forgotPassword => 'Quên Mật Khẩu';

  @override
  String get orContinueWith => 'hoặc tiếp tục với';

  @override
  String get otpTitle => 'OTP tới rồi nè 📩';

  @override
  String get otpDes => 'Chúng tôi đã gửi mã xác thực OTP đến email của bạn. Vui lòng kiểm tra email và nhập mã bên dưới nhé.';

  @override
  String get signIn => 'Đăng Nhập';

  @override
  String get loginTitle => 'Xin chào bạn 👋';

  @override
  String get loginDescription => 'Điền email/tên đăng nhập và mật khẩu để tiếp tục nha ✨';

  @override
  String get login => 'Đăng nhập';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String itemsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mục',
      one: '1 mục',
      zero: 'Không có mục',
    );
    return '$_temp0';
  }

  @override
  String helloUser(String name) {
    return 'Xin chào, $name!';
  }

  @override
  String get skip => 'Bỏ qua';

  @override
  String get continueText => 'Tiếp tục';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get registrationSuccessful => 'Đăng ký thành công!';

  @override
  String stepOf(int current, int total) {
    return 'Bước $current của $total';
  }

  @override
  String contentForStep(int step) {
    return 'Nội dung cho bước $step';
  }

  @override
  String get selectGender => 'Chọn giới tính của bạn';

  @override
  String get selectAge => 'Chọn độ tuổi của bạn';

  @override
  String get selectGenres => 'Chọn thể loại yêu thích';

  @override
  String get profileInfo => 'Thông tin cá nhân';

  @override
  String get accountInfo => 'Thông tin tài khoản';

  @override
  String get male => 'Nam';

  @override
  String get female => 'Nữ';

  @override
  String get other => 'Khác';

  @override
  String get preferNotToSay => 'Không muốn nói';

  @override
  String get chooseYourAge => 'Chọn độ tuổi của bạn';

  @override
  String get selectAgeRange => 'Chọn khoảng tuổi để có nội dung phù hợp hơn';

  @override
  String get age14to17 => '14-17';

  @override
  String get age18to24 => '18-24';

  @override
  String get age25to29 => '25-29';

  @override
  String get age30to34 => '30-34';

  @override
  String get age35to39 => '35-39';

  @override
  String get age40to44 => '40-44';

  @override
  String get age45to49 => '45-49';

  @override
  String get age50plus => '50+';

  @override
  String get whatIsYourGender => 'Giới tính của bạn là gì?';

  @override
  String get selectGenderForBetterContent => 'Chọn giới tính để có nội dung phù hợp hơn';

  @override
  String get iAmMale => 'Tôi là nam';

  @override
  String get iAmFemale => 'Tôi là nữ';

  @override
  String get ratherNotToSay => 'Lẩu gà Bình Thuận';

  @override
  String get chooseMovieGenre => 'Chọn thể loại phim bạn thích';

  @override
  String get selectPreferredGenre => 'Chọn thể loại phim yêu thích để có gợi ý tốt hơn hoặc bạn có thể bỏ qua';

  @override
  String get action => 'Hành động';

  @override
  String get adventure => 'Phiêu lưu';

  @override
  String get animation => 'Hoạt hình';

  @override
  String get comedy => 'Hài';

  @override
  String get crime => 'Tội phạm';

  @override
  String get documentary => 'Tài liệu';

  @override
  String get drama => 'Kịch tính';

  @override
  String get family => 'Gia đình';

  @override
  String get fantasy => 'Viễn tưởng';

  @override
  String get horror => 'Kinh dị';

  @override
  String get mystery => 'Bí ẩn';

  @override
  String get romance => 'Lãng mạn';

  @override
  String get sciFi => 'Khoa học viễn tưởng';

  @override
  String get thriller => 'Giật gân';

  @override
  String get war => 'Chiến tranh';

  @override
  String get western => 'Viễn Tây';

  @override
  String get completeYourProfile => 'Hoàn thành hồ sơ';

  @override
  String get profilePrivacyNote => 'Đừng lo lắng, chỉ bạn mới có thể xem dữ liệu cá nhân của mình. Không ai khác có thể xem được.';

  @override
  String get addPhoto => 'Thêm ảnh';

  @override
  String get tapToAddProfilePicture => 'Nhấn để thêm ảnh đại diện';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get enterYourFullName => 'Nguyễn Văn A';

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String get enterYourPhoneNumber => '(+1) 987-654-321';

  @override
  String get dateOfBirth => 'Ngày sinh';

  @override
  String get dateFormat => 'DD/MM/YYYY';

  @override
  String get country => 'Quốc gia';

  @override
  String get enterYourCountry => 'Quốc gia';

  @override
  String get fullNameRequired => 'Họ và tên là bắt buộc';

  @override
  String get fullNameMinLength => 'Họ và tên phải có ít nhất 2 ký tự';

  @override
  String get phoneRequired => 'Số điện thoại là bắt buộc';

  @override
  String get phoneMinLength => 'Số điện thoại phải có ít nhất 10 chữ số';

  @override
  String get dobRequired => 'Ngày sinh là bắt buộc';

  @override
  String get countryRequired => 'Quốc gia là bắt buộc';

  @override
  String get createAnAccount => 'Tạo tài khoản';

  @override
  String get signupDescription => 'Nhập tên đăng nhập, email và mật khẩu. Nếu bạn quên, bạn sẽ phải làm quên mật khẩu.';

  @override
  String get username => 'Tên đăng nhập';

  @override
  String get enterYourUsername => 'username';

  @override
  String get enterYourPassword => '●●●●●●●●●●●●';

  @override
  String get enterYourEmailAddress => 'vnhat@example.com';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get confirmYourPassword => '●●●●●●●●●●●●';

  @override
  String get rememberMe => 'Ghi nhớ tôi';

  @override
  String get usernameRequired => 'Tên đăng nhập là bắt buộc';

  @override
  String get usernameMinLength => 'Tên đăng nhập phải có ít nhất 3 ký tự';

  @override
  String get usernameInvalidChars => 'Tên đăng nhập chỉ có thể chứa chữ cái, số và dấu gạch dưới';

  @override
  String get emailRequired => 'Email là bắt buộc';

  @override
  String get emailInvalid => 'Vui lòng nhập địa chỉ email hợp lệ';

  @override
  String get passwordRequired => 'Mật khẩu là bắt buộc';

  @override
  String get passwordMinLength => 'Mật khẩu phải có ít nhất 8 ký tự';

  @override
  String get passwordComplexity => 'Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường và một số';

  @override
  String get confirmPasswordRequired => 'Vui lòng xác nhận mật khẩu của bạn';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get welcomeToNoZie => 'Chào mừng đến với NoZie 👋';

  @override
  String get welcomeTo => 'Chào mừng đến với ';

  @override
  String get welcomeDescription => 'Người bạn đồng hành phim của bạn. Nhận gợi ý cá nhân hóa, khám phá phim mới và theo dõi danh sách xem của bạn.';

  @override
  String get discoverNewMovies => 'Khám phá phim mới';

  @override
  String get discoverDescription => 'Khám phá hàng nghìn bộ phim từ các thể loại khác nhau. Tìm những viên ngọc ẩn và phim xu hướng phù hợp với sở thích của bạn.';

  @override
  String get trackYourWatchlist => 'Theo dõi danh sách xem';

  @override
  String get trackDescription => 'Lưu phim bạn muốn xem, đánh dấu những gì bạn đã xem và nhận gợi ý dựa trên sở thích của bạn.';

  @override
  String get joinTheCommunity => 'Tham gia cộng đồng';

  @override
  String get joinDescription => 'Kết nối với những người yêu phim khác, chia sẻ đánh giá và khám phá những gì đang xu hướng trong thế giới điện ảnh.';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get iAlreadyHaveAnAccount => 'Tôi đã có tài khoản';
}
