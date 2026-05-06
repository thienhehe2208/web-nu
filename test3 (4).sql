-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 06, 2026 at 11:04 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test3`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `size` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`) VALUES
(1, 'giày cao gót', 'Giày cao gót là loại giày nữ có phần gót được thiết kế cao hơn so với phần mũi giày, giúp nâng cao chiều cao và tạo dáng người thon gọn, thướt tha hơn.\r\nVới thiết kế đặc trưng là gót nhọn (stiletto), gót vuông, gót dày (block heel) hoặc gót kitten heel, giày cao gót không chỉ là một món đồ thời trang mà còn là biểu tượng của sự quyến rũ, sang trọng và nữ tính. Phần đế thường mỏng, ôm sát bàn chân, giúp người mang trông cao ráo và chân dài hơn.'),
(2, 'giày sandal', 'Giày sandal là loại giày mở mũi và hở gót, thiết kế với nhiều quai mỏng ôm nhẹ quanh bàn chân, giúp chân thoáng khí và dễ chịu.\r\nVới kiểu dáng đơn giản, nhẹ nhàng, giày sandal mang lại cảm giác thoải mái, trẻ trung và phù hợp cho nhiều hoàn cảnh khác nhau, từ đi chơi, dạo phố đến các buổi gặp gỡ thông thường.'),
(3, 'giày búp bê', 'Giày búp bê là loại giày nữ có thiết kế tròn mũi, phẳng hoặc gót thấp, ôm nhẹ bàn chân với kiểu dáng thanh lịch và dễ thương.\r\nGiày búp bê mang lại cảm giác nhẹ nhàng, thoải mái và nữ tính, rất phù hợp để đi hàng ngày hoặc kết hợp với nhiều trang phục.'),
(4, 'dép tông', 'Dép tông là loại dép đơn giản, thoáng mát với thiết kế quai giữa kẽ ngón chân, dễ dàng mang vào và tháo ra.\r\nDép tông mang lại cảm giác nhẹ nhàng, thoải mái, phù hợp cho đi trong nhà, dạo phố hè hoặc các hoạt động thường ngày'),
(5, 'giày sneakers', 'Giày sneakers là loại giày thể thao phổ biến, có thiết kế năng động với đế dày và phần thân giày ôm vừa vặn bàn chân.\r\nGiày sneakers mang lại cảm giác thoải mái, linh hoạt và dễ phối đồ, phù hợp cho cả đi học, đi làm hàng ngày lẫn các hoạt động thể thao nhẹ.');

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_phone` varchar(15) NOT NULL,
  `customer_address` text NOT NULL,
  `total_money` decimal(12,0) NOT NULL,
  `status` varchar(50) DEFAULT 'Chờ xử lý',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `price` decimal(12,0) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `size` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `sku` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `price` decimal(12,0) NOT NULL,
  `discount_price` decimal(12,0) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_new` tinyint(1) DEFAULT 0,
  `is_bestseller` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `sku`, `name`, `price`, `discount_price`, `image`, `description`, `is_new`, `is_bestseller`) VALUES
(1, 1, 'SP001', 'Giày Cao Gót Slingback Mũi Vuông', 599000, 500000, 'https://static.juno.vn/cmsimage/public/kem_cg05168_7_20260428134403.jpeg', 'Giày Cao Gót Slingback Mũi Vuông thanh lịch, tinh tế\r\n\r\nThiết kế mũi vuông hiện đại, tôn dáng bàn chân.\r\n\r\nPhần quai hậu slingback ôm gọn, kết hợp khóa kim loại nhỏ tạo điểm nhấn tinh tế.\r\n\r\nGót vuông cao vừa phải giúp di chuyển ổn định, phù hợp mang cả ngày dài.\r\n\r\nSản phẩm có 3 màu kem, đen, vàng đồng, dễ dàng phối cùng nhiều phong cách khác nhau.', 0, 1),
(2, 1, 'SP002', 'Giày Cao Gót Mũi Vuông Quai Mary Jane', 600000, NULL, 'https://static.juno.vn/cmsimage/public/hong_cg05165_4_20260420165018.jpeg', 'Giày Cao Gót Mũi Vuông Quai Mary Jane nữ tính và thanh lịch\r\n\r\nThiết kế mũi vuông hiện đại, kết hợp quai cài Mary Jane giúp ôm chân chắc chắn.\r\n\r\nBề mặt vải da lộn mềm mại, điểm xuyết họa tiết nhỏ tinh tế tạo nét duyên dáng.\r\n\r\nGót vuông vừa phải mang lại cảm giác êm ái và dễ di chuyển cả ngày.\r\n\r\nSản phẩm có 3 màu kem, đen, hồng, dễ dàng phối cùng nhiều outfit khác nhau.', 1, 0),
(3, 1, 'SP003', 'Giày Cao Gót Mũi Nhọn', 500000, 450000, 'https://static.juno.vn/cmsimage/public/kem_cg07176_2_20260420163130.jpeg', 'Giày Cao Gót Mũi Nhọn mang phong cách thanh lịch và hiện đại.\r\n\r\nThiết kế mũi nhọn tôn dáng, phối quai slingback ôm gót giúp cố định chắc chắn.\r\n\r\nPhần gót cao thanh mảnh tạo hiệu ứng đôi chân thon dài, nữ tính.\r\n\r\nBề mặt da bóng nhẹ mang lại cảm giác sang trọng và dễ vệ sinh.\r\n\r\nSản phẩm có 3 màu kem, đen, trắng, dễ dàng kết hợp với nhiều trang phục khác nhau.', 0, 1),
(4, 1, 'SP004', 'Giày Cao Gót Slingback Phối Chất Liệu Đan', 600000, NULL, 'https://static.juno.vn/cmsimage/public/kem_cg07164_7_20250718173609.jpeg', 'Giày Cao Gót Slingback Phối Chất Liệu Đan sang trọng, nữ tính\r\n\r\nĐặc điểm là chất liệu da đan nổi mang lại nét riêng nổi bật khi diện\r\n\r\nThiết kế đơn giản mũi nhọn, quai hậu tiện dụng\r\n\r\nChất liệu da tổng hợp cao cấp, dễ bảo quản, bền đẹp\r\n\r\nGiày có 3 màu dễ phối đồ. Phù hợp để đi làm, dạo phố, đi tiệc\r\n\r\n', 0, 1),
(5, 1, 'SP005', 'Giày Cao Gót Khoét Hậu', 499000, NULL, 'https://static.juno.vn/cmsimage/public/vang-dong_cg07175_15_20260323165425.jpeg', 'Giày Cao Gót Khoét Hậu Mũi Nhọn thanh lịch, tôn lên vẻ nữ tính và sang trọng\r\n\r\nGót nhọn cao 7cm giúp dáng chân thon gọn, bước đi thanh thoát.\r\n\r\nQuai hậu ôm chân chắc chắn, tạo cảm giác ổn định khi di chuyển.\r\n\r\nChất liệu da tổng hợp cao cấp, bền đẹp và dễ vệ sinh.\r\n\r\nSản phẩm có 3 màu trắng, đen, vàng đồng, phù hợp đi làm, dạo phố hoặc dự tiệc. ', 0, 1),
(6, 1, 'SP006', 'Giày Cao Gót Mules Phối Hai Quai Trang Trí', 300000, 250000, 'https://static.juno.vn/cmsimage/public/vang-dong_cg07174_15_20260317153435.jpeg', 'Giày Cao Gót Mules Phối Hai Quai Trang Trí thanh lịch, hiện đại\r\n\r\nThiết kế mũi nhọn tinh tế kết hợp phần khoét eo mềm mại thanh thoát và tôn dáng bàn chân.\r\n\r\nGót cao khoảng 7cm với đế lót êm ái và lớp chống trơn trượt, giúp bạn di chuyển tự tin\r\n\r\nChất liệu da tổng hợp cao cấp bền đẹp, thích hợp cho nhiều dịp như đi làm, dự tiệc hoặc dạo phố.\r\n\r\n', 0, 0),
(7, 1, 'SP007', 'Giày Cao Gót Pump Slingback Phối Khoá', 599000, NULL, 'https://static.juno.vn/cmsimage/public/den_cg09177_11_20260209165517.jpeg', 'Giày Cao Gót Pump Slingback Phối Khoá sang trọng, nữ tính\r\n\r\nThiết kế đơn giản mũi nhọn, phối khoá kim loại nổi bật, quai hậu cách điệu tạo điểm nhấn\r\n\r\nGót nhọn thanh cao 9cm, có phần lót chống trơn trượt giúp bạn dễ dàng  di chuyển\r\n\r\nChất liệu da tổng hợp cao cấp, dễ bảo quản, bền đẹp\r\n\r\nGiày có 2 màu dễ phối đồ. Phù hợp để đi làm, dạo phố, đi tiệc', 1, 0),
(8, 1, 'SP008', 'Giày Cao Gót Cổ Tim', 700000, 569000, 'https://static.juno.vn/cmsimage/public/trang-kem_cg09176_2_20260209161730.jpeg', 'Giày Cao Gót Cổ Tim thanh lịch, nữ tính\r\n\r\nForm giày cơ bản mũi nhọn cách điệu cổ tim mang lại nét riêng cực kì nổi bật\r\n\r\nGiày gót nhọn cao 9cm với phần đế chống trượt tăng độ an toàn cho người sử dụng\r\n\r\nChất liệu da tổng hợp cao cấp, đẹp\r\n\r\nSản phẩm có 2 phối màu hiện đại Kem, Đen, Trắng cho nàng thêm sự lựa chọn', 0, 0),
(9, 1, 'SP009', 'Giày Cao Gót Mũi Vuông Phối Nơ', 800000, NULL, 'https://static.juno.vn/cmsimage/public/nau_cg05164_14_20260203150659.jpeg', 'Giày Cao Gót Mũi Vuông Phối Nơ nữ tính, thanh lịch\r\n\r\nGiày thiết kế mũi vuông,  phối nơ đơn giản nhưng cực kì nổi bật\r\n\r\nGót cao 5cm kèm miếng đệm chống trơn trượt cho bạn dễ dàng di chuyển\r\n\r\nCó 3 màu sắc cơ bản dễ dàng phối đồ cho bạn lựa chọn\r\n\r\nChất liệu da cao cấp tổng hợp. Giày phù hợp đi mọi dịp, như đi làm, dạo phố', 1, 0),
(10, 1, 'SP010', 'Giày Cao Gót Giày Cao Gót Khoét Eo', 499000, NULL, 'https://static.juno.vn/cmsimage/public/do_cg07173_17_20260119165907.jpeg', 'Giày Cao Gót Giày Cao Gót Khoét Eo nữ tính, thanh lịch\r\n\r\nGiày thiết kế mũi nhọn, phối đính đá vừa nổi bật vừa thời trang thanh lịch\r\n\r\nGót cao 7cm kèm miếng đệm chống trơn trượt cho bạn dễ dàng di chuyển\r\n\r\nCó 3 màu sắc cơ bản dễ dàng phối đồ cho bạn lựa chọn\r\n\r\nChất liệu da cao cấp tổng hợp. Giày phù hợp đi mọi dịp, như đi làm, dạo phố', 1, 0),
(11, 2, 'SP011', 'Giày Cao Gót Pump Gót Cao Cổ Chữ V', 390000, NULL, 'https://static.juno.vn/cmsimage/public/hong_cg07172_8_20260119164236.jpeg', 'Giày Cao Gót Pump Gót Cao Cổ Chữ V thời trang, thanh lịch\r\n\r\nForm giày cơ bản mũi nhọn gót trụ mang lại nét nữ tính và tự tin khi diện\r\n\r\nGiày gót trụ cao 7cm với phần đế chống trượt tăng độ an toàn cho người sử dụng\r\n\r\nChất liệu da tổng hợp cao cấp, đẹp\r\n\r\nSản phẩm có 3 phối màu hiện đại Kem, Đen, Trắng cho nàng thêm sự lựa chọn', 0, 1),
(12, 1, 'SP012', 'Giày Cao Gót Pump Thiết Kế Cut Out', 500000, NULL, 'https://static.juno.vn/cmsimage/public/do_cg09174_23_20260115150028.jpeg', 'Giày Cao Gót Pump Thiết Kế Cut Out sang trọng, nữ tính\r\n\r\nThiết kế đơn giản mũi nhọn, quai hậu cách điệu tạo điểm nhấn\r\n\r\nGót nhọn thanh cao 9cm, có phần lót chống trơn trượt giúp bạn dễ dàng  di chuyển\r\n\r\nChất liệu da tổng hợp cao cấp, dễ bảo quản, bền đẹp\r\n\r\nGiày có 3 màu dễ phối đồ. Phù hợp để đi làm, dạo phố, đi tiệc\r\n\r\n', 1, 0),
(13, 2, 'SP013', 'Giày Sandal Gót Vuông Quai Chéo', 230000, NULL, 'https://static.juno.vn/cmsimage/public/trang-kem_sd05131_7_20260416155222.jpeg', 'Giày Sandal Gót Vuông Quai Chéo mang vẻ đẹp tối giản, tinh tế.\r\n\r\nThiết kế quai mảnh đan chéo thanh thoát, tôn lên nét nữ tính nhẹ nhàng.\r\n\r\nPhần quai hậu ôm chân kết hợp khóa cài chắc chắn, giúp di chuyển linh hoạt.\r\n\r\nGót vuông vừa phải tạo độ cao vừa đủ, êm ái cho cả ngày dài.\r\n\r\nSản phẩm có 3 màu kem, đen, trắng kem, dễ dàng phối với nhiều trang phục.', 0, 0),
(14, 2, 'SP014', 'Giày Sandal Đế Bệt Phối Quai Vân Đan', 599000, NULL, 'https://static.juno.vn/cmsimage/public/kem-dam_sd01142_11_20260330155411.jpeg', 'Giày Sandal Đế Bệt Phối Quai Vân Đan trẻ trung, năng động\r\n\r\nThiết kế đế bệt cùng quai vân đan tinh tế, mang lại vẻ ngoài nhẹ nhàng và hiện đại.\r\n\r\nQuai ôm chân chắc chắn, tạo cảm giác thoải mái khi di chuyển hằng ngày.\r\n\r\nChất liệu da tổng hợp bền đẹp, dễ vệ sinh và giữ form tốt.\r\n\r\nSản phẩm có 3 màu kem, đen, kem đậm, dễ phối đồ cho nhiều dịp khác nhau.', 0, 1),
(15, 2, 'SP015', 'Giày Sandal Phối Quai Tự Do', 600000, NULL, 'https://static.juno.vn/cmsimage/public/nau_sd07109_7_20260323160531.jpeg', 'Giày Sandal Phối Quai Tự Do Sành Điệu\r\n\r\nThiết kế quai mảnh đan chéo tạo cảm giác nhẹ nhàng và thoáng chân\r\n\r\nForm mũi vuông hiện đại kết hợp gót cao 7cm, tôn dáng thanh thoát\r\n\r\nQuai hậu có khóa điều chỉnh giúp ôm chân chắc chắn khi di chuyển\r\n\r\nSản phẩm có 3 màu kem, đen, nâu, dễ phối cùng nhiều phong cách khác nhau', 1, 0),
(16, 2, 'SP016', 'Giày Sandal Phối Quai Đan', 399000, NULL, 'https://static.juno.vn/cmsimage/public/kem-nhat_sd03091_7_20260317154701.jpeg', 'Giày Sandal Phối Quai Đan năng động và thời trang\r\n\r\nThiết kế quai phối chất liệu dệt và da trơn, mang phong cách thanh lịch.\r\n\r\nQuai hậu có khóa điều chỉnh giúp ôm chân và dễ dàng mang vào.\r\n\r\nChất liệu da tổng hợp bền đẹp, dễ vệ sinh và giữ form tốt.\r\n\r\nSản phẩm có 03 màu Nâu, Đen, Kem nhạt phù hợp đi làm, đi học hoặc dạo phố.', 0, 1),
(17, 2, 'SP017', 'Giày Sandal Có Đúp Quai Rút', 699000, NULL, 'https://static.juno.vn/cmsimage/public/kem-nhat_sd09144_11_20260203145925.jpeg', 'Giày Sandal Có Đúp Quai Rút thời trang, sành điệu\r\n\r\nGiày mũi vuông, quai đan cách điệu mảnh tạo nét nữ tính nhẹ nhàng tạo điểm nhấn nổi bật\r\n\r\nGót trụ cao 9cm có kèm rãnh chống trượt, giúp bạn tôn được lên nét nữ tính khi diện\r\n\r\nChất liệu da tổng hợp cao cấp, phù hợp mang nhiều dịp: dạo phố, dự tiệc', 0, 0),
(18, 2, 'SP018', 'Giày Sandal Cao Gót Phối Hai Quai Đá Trang Trí', 799000, NULL, 'https://static.juno.vn/cmsimage/public/nau_sd11028_15_20251215145419.jpeg', 'Giày Sandal Cao Gót Phối Hai Quai Đá Trang Trí sành điệu\r\n\r\nQua ngang mảnh phối đá nổi bật, gót trụ cao mang lại nét hiện đại, thời trang\r\n\r\nChất liệu da tổng hợp bền đẹp, dễ vệ sinh\r\n\r\nĐế bằng cao 11cm thanh lịch, dễ dàng di chuyển\r\n\r\nCó 3 màu cơ bản cho bạn dễ dàng lựa chọn và phối đồ', 0, 0),
(19, 3, 'SP019', 'Giày Búp Bê Slingback Cơ Bản', 390000, NULL, 'https://static.juno.vn/cmsimage/public/kem_bb03148_3_20260421161514.jpeg', 'Giày Búp Bê Slingback Cơ Bản nữ tính, xinh xắn\r\n\r\nThiết kế mũi vuông, slingback  cách điệu mang lại nét uyển chuyển trên từng bước đi\r\n\r\nChất liệu da tổng hợp bền đẹp, dễ vệ sinh\r\n\r\nLót giày êm ái, dưới đế có rãnh chống trượt cho bước chân thoải mái, tự tin\r\n\r\nGiày có 3 màu cho bạn thoải mái lựa chọn', 1, 0),
(20, 3, 'SP020', 'Giày Búp Bê Mũi Tròn', 599000, NULL, 'https://static.juno.vn/cmsimage/public/hong_bb03146_5_20260416095821.jpeg', 'Giày Búp Bê Mũi Tròn mang phong cách nhẹ nhàng, nữ tính.\r\n\r\nThiết kế mũi tròn phối quai ngang tinh tế.\r\n\r\nQuai có khóa điều chỉnh giúp ôm chân chắc chắn và dễ mang\r\n\r\nForm ôm chân, đế thấp giúp di chuyển thoải mái.\r\n\r\nCó 3 màu hồng, đen, kem nhạt dễ phối đồ.', 0, 1),
(21, 3, 'SP021', 'Giày Búp Bê Phối Chất Liệu Vân', 499000, 400000, 'https://static.juno.vn/cmsimage/public/hong_bb01148_23_20260323152855.jpeg', 'Giày Búp Bê Phối Chất Liệu Vân kết hợp quai ngang thanh lịch, nữ tính\r\n\r\nBề mặt phối chất liệu vân nhẹ tạo điểm nhấn hiện đại và sang trọng\r\n\r\nQuai có khóa điều chỉnh giúp ôm chân chắc chắn và dễ mang\r\n\r\n', 0, 1),
(22, 3, 'SP022', 'Giày Búp Bê Phối Nơ Bọc Toecap', 399000, NULL, 'https://static.juno.vn/cmsimage/public/nau_bb01147_17_20260210164525.jpeg', 'Giày Búp Bê Phối Nơ Bọc Toecap nữ tính, phù hợp mọi dịp\r\n\r\nThiết kế mũi vuông, phối nơ tạo nét uyển chuyển trên từng bước đi\r\n\r\nChất liệu da tổng hợp bền đẹp, dễ vệ sinh\r\n\r\n', 0, 1),
(23, 3, 'SP023', 'Giày Búp Bê Phối Nơ Trang Trí', 299000, NULL, 'https://static.juno.vn/cmsimage/public/nau_bb03145_11_20260209163808.jpeg', 'Giày Búp Bê Phối Nơ Trang Trí nữ tính, phù hợp mọi dịp\r\n\r\nThiết kế mũi vuông, slingback mang lại nét uyển chuyển trên từng bước đi\r\n\r\nChất liệu da tổng hợp bền đẹp, dễ vệ sinh\r\n\r\nLót giày êm ái, dưới đế có rãnh chống trượt cho bước chân thoải mái, tự tin\r\n\r\nGiày có 3 màu cho bạn thoải mái lựa chọn', 1, 0),
(24, 4, 'SP024', 'Dép Sandal Quai Ngang Lót Mút Mềm', 199000, NULL, 'https://static.juno.vn/cmsimage/public/xanh_de007_5_20250617100427.jpeg', '', 0, 0),
(25, 4, 'SP025', 'Dép Kẹp DK115', 599000, 290000, 'https://static.juno.vn/cmsimage/public/hong_dk115_5_20250806170156.jpeg', 'Dép Kẹp DK115 với màu sắc cùng hoạ tiết trẻ trung, xinh xắn\r\n\r\nPhù hợp đi chơi biển, dạo phố, mang thường ngày\r\n\r\nChất liệu mousse xốp cao cấp dễ vệ sinh, thoải mái khi mang\r\n\r\n', 0, 1),
(26, 4, 'SP026', 'Dép Kẹp DK116', 499000, NULL, 'https://static.juno.vn/cmsimage/public/xanh_dk116_5_20250806170412.jpeg', 'Dép Kẹp DK116 với màu sắc cùng hoạ tiết trẻ trung, xinh xắn\r\n\r\nPhù hợp đi chơi biển, dạo phố, mang thường ngày\r\n\r\nChất liệu mousse xốp cao cấp dễ vệ sinh, thoải mái khi mang', 1, 0),
(27, 5, 'SP027', 'Adidas Stan Smith Fairway', 799000, NULL, 'https://saigonsneaker.com/wp-content/uploads/2020/01/IMG_2218-2.jpg', 'Fullbox Stan Smith. 2 ver Trắng Gót Xanh/ Full White. Thiết kế basic trend dài dài. Phù hợp: nam nữ, đi học, đi làm, hoạt động thể thao. Size: 36-44. Chất liệu: Da. Giao hàng toàn quốc. Bảo hành 3 tháng. Đổi trả dễ dàng. Streetwear, trẻ trung năng động.', 0, 0),
(28, 5, 'SP028', 'Nike Air Force 1 White Low', 999000, NULL, 'https://saigonsneaker.com/wp-content/uploads/2018/11/IMG_1022.jpg', 'Chất liệu da tổng hợp bền bỉ. Tất cả chi tiết được thiết kế độc đáo với màu trắng nguyên khối bao quanh toàn bộ thân giày. Xu hướng mang giày trắng của giới trẻ giúp cho Air Force 1 thuộc top sản phẩm được yêu thích và bán chạy nhất trong những năm gần đây.', 0, 1),
(29, 5, 'SP029', 'Adidas Alphabounce Beyond Cloud White', 888666, 100000, 'https://saigonsneaker.com/wp-content/uploads/2020/01/IMG_1058-1.jpg', 'Fullbox A.l.p.h.a.bounce Beyond Cloud White. 2 ver Trắng / Đen. Phù hợp: nam nữ, đi học, đi làm, tập gym. Size: 36-44. Êm chân, thoáng khí. Giao hàng toàn quốc. Bảo hành 3 tháng. Đổi trả dễ dàng. Streetwear, trẻ trung năng động.', 0, 1),
(30, 5, 'SP030', 'New Balance 574 Grey Blue', 599000, NULL, 'https://saigonsneaker.com/wp-content/uploads/2020/01/IMG_5495-1.jpg', 'Một trong những mẫu New Balance 574 Classic được nhiều người yêu giày săn đón trong thời gian vừa qua. Đôi New Balance 574 Classic Grey Blue sở hữu nhiều ưu điểm nổi bật mà không phải bất kỳ dòng giày nào cũng có.', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `product_sizes`
--

CREATE TABLE `product_sizes` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `size` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_sizes`
--

INSERT INTO `product_sizes` (`id`, `product_id`, `size`) VALUES
(1, 1, '35'),
(2, 1, '36'),
(3, 1, '37'),
(4, 1, '38'),
(5, 1, '39'),
(6, 1, '40'),
(7, 2, '35'),
(8, 2, '36'),
(9, 2, '37'),
(10, 2, '38'),
(11, 2, '39'),
(12, 2, '40'),
(13, 3, '35'),
(14, 3, '36'),
(15, 3, '37'),
(16, 3, '38'),
(17, 3, '39'),
(18, 3, '40'),
(19, 4, '35'),
(20, 4, '36'),
(21, 4, '37'),
(22, 4, '38'),
(23, 4, '39'),
(24, 4, '40'),
(25, 5, '35'),
(26, 5, '36'),
(27, 5, '37'),
(28, 5, '38'),
(29, 5, '39'),
(30, 5, '40'),
(31, 6, '35'),
(32, 6, '36'),
(33, 6, '37'),
(34, 6, '38'),
(35, 6, '39'),
(36, 6, '40'),
(37, 7, '35'),
(38, 7, '36'),
(39, 7, '37'),
(40, 7, '38'),
(41, 7, '39'),
(42, 7, '40'),
(43, 8, '35'),
(44, 8, '36'),
(45, 8, '37'),
(46, 8, '38'),
(47, 8, '39'),
(48, 8, '40'),
(49, 9, '35'),
(50, 9, '36'),
(51, 9, '37'),
(52, 9, '38'),
(53, 9, '39'),
(54, 9, '40'),
(55, 10, '35'),
(56, 10, '36'),
(57, 10, '37'),
(58, 10, '38'),
(59, 10, '39'),
(60, 10, '40'),
(61, 12, '35'),
(62, 12, '36'),
(63, 12, '37'),
(64, 12, '38'),
(65, 12, '39'),
(66, 12, '40'),
(67, 11, '35'),
(68, 11, '36'),
(69, 11, '37'),
(70, 11, '38'),
(71, 11, '39'),
(72, 11, '40'),
(73, 13, '35'),
(74, 13, '36'),
(75, 13, '37'),
(76, 13, '38'),
(77, 13, '39'),
(78, 13, '40'),
(79, 14, '35'),
(80, 14, '36'),
(81, 14, '37'),
(82, 14, '38'),
(83, 14, '39'),
(84, 14, '40'),
(85, 15, '35'),
(86, 15, '36'),
(87, 15, '37'),
(88, 15, '38'),
(89, 15, '39'),
(90, 15, '40'),
(91, 16, '35'),
(92, 16, '36'),
(93, 16, '37'),
(94, 16, '38'),
(95, 16, '39'),
(96, 16, '40'),
(97, 17, '35'),
(98, 17, '36'),
(99, 17, '37'),
(100, 17, '38'),
(101, 17, '39'),
(102, 17, '40'),
(103, 18, '35'),
(104, 18, '36'),
(105, 18, '37'),
(106, 18, '38'),
(107, 18, '39'),
(108, 18, '40'),
(109, 19, '35'),
(110, 19, '36'),
(111, 19, '37'),
(112, 19, '38'),
(113, 19, '39'),
(114, 19, '40'),
(115, 20, '35'),
(116, 20, '36'),
(117, 20, '37'),
(118, 20, '38'),
(119, 20, '39'),
(120, 20, '40'),
(121, 21, '35'),
(122, 21, '36'),
(123, 21, '37'),
(124, 21, '38'),
(125, 21, '39'),
(126, 21, '40'),
(127, 22, '35'),
(128, 22, '36'),
(129, 22, '37'),
(130, 22, '38'),
(131, 22, '39'),
(132, 22, '40'),
(133, 23, '35'),
(134, 23, '36'),
(135, 23, '37'),
(136, 23, '38'),
(137, 23, '39'),
(138, 23, '40'),
(139, 24, '35'),
(140, 24, '36'),
(141, 24, '37'),
(142, 24, '38'),
(143, 24, '39'),
(144, 24, '40'),
(145, 25, '35'),
(146, 25, '36'),
(147, 25, '37'),
(148, 25, '38'),
(149, 25, '39'),
(150, 25, '40'),
(151, 26, '35'),
(152, 26, '36'),
(153, 26, '37'),
(154, 26, '38'),
(155, 26, '39'),
(156, 26, '40'),
(157, 27, '35'),
(158, 27, '36'),
(159, 27, '37'),
(160, 27, '38'),
(161, 27, '39'),
(162, 27, '40'),
(163, 28, '35'),
(164, 28, '36'),
(165, 28, '37'),
(166, 28, '38'),
(167, 28, '39'),
(168, 28, '40'),
(169, 29, '35'),
(170, 29, '36'),
(171, 29, '37'),
(172, 29, '38'),
(173, 29, '39'),
(174, 29, '40'),
(175, 30, '35'),
(176, 30, '36'),
(177, 30, '37'),
(178, 30, '38'),
(179, 30, '39'),
(180, 30, '40');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `account_name`, `username`, `email`, `phone`, `address`, `password`, `created_at`) VALUES
(1, 'Nguyễn Thị An', 'nguyenan', 'an@gmail.com', '0901234567', '12 Lê Lợi, Q1, TP.HCM', 'e10adc3949ba59abbe56e057f20f883e', '2026-04-29 16:09:37'),
(2, 'Trần Thị Bình', 'tranbinhh', 'binh@gmail.com', '0912345678', '45 Nguyễn Huệ, Q1, TP.HCM', 'e10adc3949ba59abbe56e057f20f883e', '2026-04-29 16:09:37'),
(3, 'Lê Thị Cúc', 'lecucc', 'cuc@gmail.com', '0923456789', '78 Hai Bà Trưng, Q3, TP.HCM', 'e10adc3949ba59abbe56e057f20f883e', '2026-04-29 16:09:37'),
(4, 'Phạm Thị Dung', 'phamdung', 'dung@gmail.com', '0934567890', '90 Đinh Tiên Hoàng, Q1, TP.HCM', 'e10adc3949ba59abbe56e057f20f883e', '2026-04-29 16:09:37'),
(5, 'Hoàng Thị Em', 'hoangemm', 'em@gmail.com', '0945678901', '23 Võ Thị Sáu, Q3, TP.HCM', 'e10adc3949ba59abbe56e057f20f883e', '2026-04-29 16:09:37');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cart_id` (`cart_id`,`product_id`,`size`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `product_sizes`
--
ALTER TABLE `product_sizes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `product_sizes`
--
ALTER TABLE `product_sizes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=181;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `product_sizes`
--
ALTER TABLE `product_sizes`
  ADD CONSTRAINT `product_sizes_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
