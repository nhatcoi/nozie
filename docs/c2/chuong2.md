# CHƯƠNG 2. THIẾT KẾ ỨNG DỤNG XEM PHIM TRỰC TUYẾN – Nozie

## 2.1. Lý do chọn đề tài

Trong bối cảnh công nghệ số phát triển mạnh mẽ, nhu cầu giải trí trực tuyến ngày càng tăng cao, đặc biệt là việc xem phim và video. Việc phát triển ứng dụng xem phim trực tuyến với công nghệ Flutter mang lại nhiều lợi ích:

- **Xu hướng thị trường:** Nhu cầu xem phim trực tuyến tăng trưởng mạnh, đặc biệt sau đại dịch COVID-19
- **Công nghệ hiện đại:** Flutter cho phép phát triển ứng dụng đa nền tảng với hiệu suất cao và thời gian phát triển ngắn
- **Học tập và ứng dụng:** Dự án tích hợp nhiều công nghệ quan trọng như Firebase, Stripe Payment, State Management, giúp nâng cao kỹ năng lập trình
- **Tính thực tiễn:** Ứng dụng có thể triển khai thực tế và phục vụ nhu cầu người dùng

## 2.2. Đối tượng của ứng dụng

Ứng dụng Nozie được thiết kế dành cho:

- **Người dùng cuối:** Người dùng muốn xem phim, video trực tuyến trên thiết bị di động (iOS, Android)
- **Độ tuổi:** Từ 16 tuổi trở lên
- **Sở thích:** Người yêu thích giải trí, xem phim, series
- **Điều kiện:** Có kết nối internet và thiết bị di động hỗ trợ

## 2.3. Phân tích yêu cầu hệ thống

### 2.3.1. Yêu cầu chức năng

**1. Quản lý người dùng:**
- Đăng ký, đăng nhập (Email/Password, Google Sign-In)
- Quên mật khẩu với OTP verification
- Quản lý hồ sơ người dùng

**2. Quản lý nội dung phim:**
- Hiển thị danh sách phim theo nhiều tiêu chí (mới nhất, phổ biến, theo thể loại)
- Xem chi tiết phim (thông tin, trailer, đánh giá)
- Tìm kiếm phim theo tên, thể loại
- Xem phim với video player tích hợp

**3. Quản lý danh sách:**
- Thêm/xóa phim vào danh sách yêu thích (Wishlist)
- Quản lý danh sách phim đã mua (Purchase)
- Lưu lịch sử xem phim

**4. Hệ thống thanh toán:**
- Mua phim với tích hợp Stripe Payment
- Quản lý giao dịch và lịch sử thanh toán
- Xử lý webhook từ Stripe

**5. Thông báo:**
- Push notifications khi có phim mới
- Thông báo về giao dịch thanh toán
- Quản lý cài đặt thông báo

**6. Đa ngôn ngữ:**
- Hỗ trợ tiếng Việt và tiếng Anh
- Chuyển đổi ngôn ngữ trong ứng dụng

### 2.3.2. Yêu cầu phi chức năng

**1. Hiệu suất:**
- Thời gian tải màn hình < 2 giây
- Video streaming mượt mà, không bị lag
- Hỗ trợ offline viewing cho phim đã tải

**2. Bảo mật:**
- Mã hóa dữ liệu người dùng
- Xác thực người dùng an toàn
- Bảo vệ thông tin thanh toán

**3. Khả năng mở rộng:**
- Kiến trúc hỗ trợ thêm tính năng mới
- Database có thể scale theo nhu cầu

**4. Trải nghiệm người dùng:**
- Giao diện thân thiện, dễ sử dụng
- Thiết kế Material Design
- Responsive trên nhiều kích thước màn hình

## 2.4. Đặc điểm của ứng dụng

### 2.4.1. Xác định các chức năng trong hệ thống

**Các chức năng chính:**

1. **Authentication Module:**
   - Đăng ký tài khoản
   - Đăng nhập (Email/Password, Google)
   - Quên mật khẩu
   - Quản lý session

2. **Home Module:**
   - Hiển thị phim đề xuất
   - Phim mới nhất
   - Phim phổ biến
   - Phim theo thể loại

3. **Discover Module:**
   - Khám phá phim theo thể loại
   - Filter và sort phim
   - Xem chi tiết thể loại

4. **Movie Detail Module:**
   - Thông tin chi tiết phim
   - Trailer
   - Đánh giá và rating
   - Nút mua/xem phim
   - Thêm vào wishlist

5. **Video Player Module:**
   - Phát video với controls
   - Lưu progress xem phim
   - Điều chỉnh chất lượng video
   - Điều chỉnh tốc độ phát

6. **Search Module:**
   - Tìm kiếm phim theo tên
   - Filter kết quả tìm kiếm
   - Search suggestions

7. **Wishlist Module:**
   - Xem danh sách yêu thích
   - Thêm/xóa phim
   - Mua phim từ wishlist

8. **Purchase Module:**
   - Xem danh sách phim đã mua
   - Chi tiết giao dịch
   - Download phim (nếu có)

9. **Profile Module:**
   - Thông tin cá nhân
   - Cài đặt tài khoản
   - Quản lý phương thức thanh toán
   - Cài đặt thông báo
   - Đổi ngôn ngữ

10. **Payment Module:**
    - Tích hợp Stripe Payment
    - Checkout screen
    - Xử lý thanh toán
    - Quản lý giao dịch

### 2.4.2. Biểu đồ các use case

**Các Actor chính:**
- **Người dùng (User):** Người sử dụng ứng dụng
- **Hệ thống (System):** Backend và Firebase services

**Use Cases chính:**

1. **Authentication Use Cases:**
   - Đăng ký tài khoản
   - Đăng nhập
   - Quên mật khẩu
   - Đăng xuất

2. **Content Use Cases:**
   - Xem danh sách phim
   - Xem chi tiết phim
   - Tìm kiếm phim
   - Xem phim

3. **User Management Use Cases:**
   - Thêm vào wishlist
   - Xem wishlist
   - Quản lý hồ sơ
   - Xem lịch sử

4. **Payment Use Cases:**
   - Mua phim
   - Xem giao dịch
   - Quản lý phương thức thanh toán

5. **Notification Use Cases:**
   - Xem thông báo
   - Cài đặt thông báo

*(Lưu ý: Biểu đồ use case chi tiết sẽ được thể hiện trong bản vẽ kỹ thuật)*

### 2.4.3. Luồng hoạt động chính

**1. Luồng khởi động ứng dụng:**
```
Khởi động app → Kiểm tra authentication → 
  Nếu chưa đăng nhập → Welcome/Login Screen
  Nếu đã đăng nhập → Home Screen
```

**2. Luồng xem phim:**
```
Home/Discover → Chọn phim → Movie Detail → 
  Kiểm tra quyền truy cập → 
    Nếu free/đã mua → Video Player
    Nếu chưa mua → Checkout Screen → Payment → Video Player
```

**3. Luồng thanh toán:**
```
Movie Detail → Nút "Mua" → Checkout Screen → 
  Chọn phương thức thanh toán → 
    Stripe Payment Sheet → Xử lý thanh toán → 
      Thành công → Thêm vào Purchase → Video Player
      Thất bại → Thông báo lỗi
```

**4. Luồng quản lý wishlist:**
```
Movie Detail → Nút "Yêu thích" → 
  Thêm vào Firestore → Cập nhật UI
Wishlist Screen → Xem danh sách → 
  Chọn phim → Movie Detail hoặc Mua ngay
```

## 2.5. Kiến trúc hệ thống

### 2.5.1. Kiến trúc tổng thể

Hệ thống sử dụng kiến trúc client-server với các thành phần chính:

```
┌─────────────────────────────────────────┐
│         Flutter Mobile App              │
│  (iOS, Android - Frontend)              │
└──────────────┬──────────────────────────┘
               │
               ├── HTTP/REST API
               │
┌──────────────▼──────────────────────────┐
│    Node.js/Express Backend Server       │
│  (Payment Processing, Webhooks)         │
└──────────────┬──────────────────────────┘
               │
               ├── Admin SDK
               │
┌──────────────▼──────────────────────────┐
│         Firebase Services               │
│  ┌──────────────────────────────────┐  │
│  │  - Authentication                │  │
│  │  - Cloud Firestore (Database)    │  │
│  │  - Firebase Storage (Files)      │  │
│  │  - Cloud Messaging (Notifications)│  │
│  └──────────────────────────────────┘  │
└─────────────────────────────────────────┘
               │
               │
┌──────────────▼──────────────────────────┐
│         Stripe Payment Gateway          │
│  (Payment Processing)                   │
└─────────────────────────────────────────┘
```

### 2.5.2. Kiến trúc Frontend (Flutter)

**Kiến trúc Clean Architecture với Feature-based Organization:**

```
lib/
├── main.dart                 # Entry point
├── app/                      # App configuration
│   └── app.dart             # MaterialApp setup
├── core/                     # Shared resources
│   ├── api_service.dart     # API client
│   ├── models/              # Shared models
│   ├── repositories/        # Data repositories
│   ├── services/            # Business services
│   ├── theme/               # App theme
│   ├── utils/               # Utilities
│   └── widgets/             # Shared widgets
├── features/                 # Feature modules
│   ├── auth/                # Authentication
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── home/                # Home screen
│   ├── movie/               # Movie details & player
│   ├── purchase/            # Purchase & payment
│   ├── wishlist/            # Wishlist
│   └── profile/             # User profile
└── routes/                   # Navigation
    └── app_router.dart      # GoRouter config
```

**State Management:** Sử dụng Riverpod cho quản lý state
- Providers cho data fetching
- StateNotifiers cho complex state
- StreamProviders cho real-time data từ Firestore

### 2.5.3. Kiến trúc Backend (Node.js/Express)

**Backend server đơn giản cho xử lý thanh toán:**

```javascript
server.js
├── Express App Setup
├── Firebase Admin SDK Init
├── Routes:
│   ├── POST /create-payment
│   │   └── Tạo Stripe Payment Intent
│   ├── POST /webhook
│   │   └── Xử lý Stripe Webhooks
│   └── POST /send-otp
│       └── Gửi OTP email
```

**Chức năng:**
- Tạo Payment Intent từ Stripe
- Xử lý webhook để cập nhật transaction status
- Gửi OTP email cho quên mật khẩu

### 2.5.4. Cơ sở dữ liệu (Firebase Firestore)

**Cấu trúc Database:**

```
movies/
  {movieId}/
    - title: string
    - year: number
    - genre: array
    - category: array
    - price: { usd: number }
    - imageUrl: string
    - trailerUrl: string
    - videoUrl: string
    - description: string
    - view: number
    - rating: number
    - tmdb: object

users/
  {userId}/
    - email: string
    - displayName: string
    - stripeCustomerId: string
    - isSubscribed: boolean
    - purchases/
      {movieId}/
        - purchasedAt: timestamp
        - transactionId: string
    - wishlist/
      {movieId}/
        - addedAt: timestamp
    - transactions/
      {transactionId}/
        - movieId: string
        - amount: number
        - status: string
        - createdAt: timestamp
        - paidAt: timestamp
    - watch_history/
      {movieId}/
        - lastWatchedAt: timestamp
```

**Tối ưu hóa:**
- Sử dụng indexes cho queries phức tạp
- Real-time listeners cho dữ liệu cần cập nhật ngay
- Composite indexes cho filter và sort

## 2.6. Sơ đồ luồng dữ liệu

### 2.6.1. Luồng đăng nhập/đăng ký

```
1. User nhập thông tin (email/password hoặc chọn Google)
   ↓
2. App gửi request đến Firebase Auth
   ↓
3. Firebase Auth xác thực
   ↓
4. Nếu thành công:
   - Lưu user token
   - Tạo/get user document trong Firestore
   - Navigate đến Home Screen
   ↓
5. Nếu thất bại:
   - Hiển thị thông báo lỗi
   - Giữ nguyên ở màn hình login
```

**Quên mật khẩu:**
```
1. User nhập email
   ↓
2. Backend gửi OTP qua email
   ↓
3. User nhập OTP
   ↓
4. Backend xác thực OTP
   ↓
5. User nhập mật khẩu mới
   ↓
6. Firebase Auth cập nhật mật khẩu
```

### 2.6.2. Luồng xem phim

```
1. User chọn phim từ Home/Discover
   ↓
2. Navigate đến Movie Detail Screen
   ↓
3. Load chi tiết phim từ Firestore
   ↓
4. User nhấn "Xem phim"
   ↓
5. Kiểm tra quyền truy cập:
   - Nếu free (price = 0) → Cho phép xem
   - Nếu đã mua → Cho phép xem
   - Nếu chưa mua → Navigate đến Checkout
   ↓
6. Mở Video Player Screen
   ↓
7. Load video URL và phát video
   ↓
8. Lưu playback state (progress, quality)
   ↓
9. Cập nhật watch history khi xem
   ↓
10. Increment view count của phim
```

### 2.6.3. Luồng thanh toán

```
1. User nhấn "Mua phim" tại Movie Detail
   ↓
2. Navigate đến Checkout Screen
   ↓
3. App gọi backend API: POST /create-payment
   ↓
4. Backend:
   - Tạo transaction record trong Firestore (status: pending)
   - Tạo Stripe Customer (nếu chưa có)
   - Tạo Stripe Payment Intent
   - Tạo Ephemeral Key
   ↓
5. Backend trả về:
   - clientSecret
   - ephemeralKey
   - customerId
   ↓
6. App hiển thị Stripe Payment Sheet
   ↓
7. User nhập thông tin thẻ và xác nhận
   ↓
8. Stripe xử lý thanh toán
   ↓
9. Stripe gửi webhook đến backend: POST /webhook
   ↓
10. Backend xử lý webhook:
    - Nếu payment_intent.succeeded:
      * Cập nhật transaction status = succeeded
      * Thêm phim vào purchases collection
      * Tạo notification
    - Nếu payment_intent.failed:
      * Cập nhật transaction status = failed
   ↓
11. App reload transaction status
   ↓
12. Nếu thành công:
    - Navigate đến Video Player
    - Hiển thị thông báo thành công
```

---

**Kết luận Chương 2:**

Chương 2 đã trình bày về việc thiết kế ứng dụng xem phim trực tuyến Nozie, bao gồm lý do chọn đề tài, đối tượng sử dụng, phân tích yêu cầu hệ thống (chức năng và phi chức năng), các tính năng chính, biểu đồ use case, luồng hoạt động, kiến trúc hệ thống (Frontend, Backend, Database), và các sơ đồ luồng dữ liệu quan trọng. Những thiết kế này sẽ là cơ sở cho việc triển khai ứng dụng được trình bày trong Chương 3.


