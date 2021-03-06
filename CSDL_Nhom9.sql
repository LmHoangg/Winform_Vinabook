USE master
GO
-- Xóa csdl QLBanSach nếu đã có csdl này
IF  EXISTS (SELECT name 
			FROM sys.databases 
			WHERE name = 'QLBanSach')
	DROP DATABASE QLBanSach
GO
-- Tạo csdl QLBanSach
CREATE DATABASE QLBanSach
GO
--Kết nối với CSDL QLBanSach
USE QLBanSach
GO
--Tạo bảng LOAISACH
CREATE TABLE LOAISACH
(
	MaLoai int identity(1,1) PRIMARY KEY,
	TenLoai nvarchar(20) NOT NULL
)

GO

-- Tạo bảng SACH
CREATE TABLE SACH
(
	MaSach int identity(1,1) PRIMARY KEY,
	TenSach nvarchar(50) not null,
	MaLoai int not null,
	TacGia nvarchar(30) not null,
	NhaXuatBan nvarchar(50) not null,
	DonGiaBan money not null,
	DonGiaNhap money not null,

	CONSTRAINT fk_MaLoai FOREIGN KEY (MaLoai) REFERENCES LOAISACH(MaLoai)
)
GO

--Tạo bảng TAIKHOAN
create TABLE TAIKHOAN
(
	MaTK int identity(1,1) PRIMARY KEY,
	TenDangNhap varchar(20) NOT NULL,
	MatKhau varchar(20) NOT NULL,
	HoTen nvarchar(30) NOT NULL,
	LoaiTK bit NOT NULL
)
GO

-- Tạo bảng KHACHHANG
CREATE TABLE KHACHHANG
(
	MaKH int identity(1,1) PRIMARY KEY,
	TenKH nvarchar(50) NOT NULL,
	SoDT varchar(12) NOT NULL,
	DiaChi nvarchar(100) NOT NULL
)

-- Tạo bảng HOADON
GO
CREATE TABLE HOADON
(
	MaHD int identity(1,1) PRIMARY KEY,
	NgayLap date default GETDATE(),
	MaKH int NOT NULL,
	MaTK int NOT NULL,

	CONSTRAINT fk_HOADON_KHACHHANG FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
	CONSTRAINT fk_HOADON_TAIKHOAN FOREIGN KEY (MaTK) REFERENCES TAIKHOAN(MaTK),
)
GO

--Tạo bảng CTHOADON
CREATE TABLE CTHOADON
(
	MaHD int,
	MaSach int,
	SoLuong int NOT NULL,
	ThanhTien Money NOT NULL,
	PRIMARY KEY(MaHD, MaSach),	
	CONSTRAINT FK_CTHOADON_HOADON FOREIGN KEY(MaHD) REFERENCES HOADON(MaHD) ON DELETE CASCADE,	
	CONSTRAINT FK_CTHOADON_SACH FOREIGN KEY(MaSach) REFERENCES SACH(MaSach)
)
GO


-- Tạo bảng NHACC
CREATE TABLE NHACC
(
	MaNhaCc int identity(1,1) PRIMARY KEY,
	TenNhaCc nvarchar(100) NOT NULL,
	DiaChi nvarchar(200) NOT NULL,
	DienThoai varchar(20) NOT NULL
)
GO

-- Tạo bảng DONDH
CREATE TABLE DONDH
(
	MaDonDH int identity(1,1) PRIMARY KEY,
	NgayDh datetime,
	MaNhaCc int,
	TrangThai nvarchar(200) NOT NULL,
	CONSTRAINT FK_NHACC_DONDH FOREIGN KEY(MaNhaCc) REFERENCES NHACC(MaNhaCc),
)
GO

-- Tạo bảng CTDONDH
CREATE TABLE CTDONDH
(
	MaDonDH int,
	MaSach int,
	SlDat int NOT NULL,
	ThanhTien money NOT NULL,
	PRIMARY KEY (MaDonDH,MaSach),
	CONSTRAINT FK_CTDONDH_DONDH FOREIGN KEY(MaDonDH) REFERENCES DONDH(MaDonDH) ON DELETE CASCADE,
	CONSTRAINT FK_CTDONDH_SACH FOREIGN KEY(MaSach) REFERENCES SACH(MaSach),
)
GO

-- Tạo bảng PNHAP
CREATE TABLE PNHAP(
	MaPN int identity(1,1) PRIMARY KEY,
	NgayNhap datetime NOT NULL,
	MaDonDH int,
	CONSTRAINT FK_PNHAP_DONDH FOREIGN KEY(MaDonDH) REFERENCES DONDH(MaDonDH),
)
GO

-- Tạo bảng CTPNHAP
CREATE TABLE CTPNHAP
(
	MaPN int,
	MaSach int,
	SlNhap int NOT NULL,
	DgNhap Money NOT NULL,
	PRIMARY KEY(MaPN, MaSach),
	CONSTRAINT FK_CTPNHAP_PNHAP FOREIGN KEY(MaPN) REFERENCES PNHAP(MaPN) ON DELETE CASCADE,
	CONSTRAINT FK_CTPNHAP_SACH FOREIGN KEY(MaSach) REFERENCES SACH(MaSach),
)
GO

--them tai khoan
INSERT INTO TAIKHOAN
VALUES('son','123456',N'Nguyễn Đình Sơn',1)
INSERT INTO TAIKHOAN
VALUES('dat','123456',N'Nguyễn Tiến Đạt',0)
INSERT INTO TAIKHOAN
VALUES('phuc','123456',N'Phạm Hồng Phúc',0)
INSERT INTO TAIKHOAN
VALUES('lam','123456',N'Đặng Hoàng Lâm',0)
INSERT INTO TAIKHOAN
VALUES('loc','123456',N'Nguyễn Viêt Lộc',0)

Go

--them loai sach
INSERT INTO LOAISACH
VALUES(N'Văn học')
INSERT INTO LOAISACH
VALUES(N'Khoa học kỹ thuật')
INSERT INTO LOAISACH
VALUES(N'Sách giáo khoa')
INSERT INTO LOAISACH
VALUES(N'Truyện tranh')
INSERT INTO LOAISACH
VALUES(N'Pháp luật')

go

-- them sach
INSERT INTO SACH
VALUES(N'Bí mật của bóng tối',1,N'Đinh Thành Trung',N'NXB Trẻ',65000,60000)
INSERT INTO SACH
VALUES(N'Kỹ thuật sửa chữa ô tô',2,N'Đức Huy',N'NXB Bách Khoa Hà Nội',210000,200000)
INSERT INTO SACH
VALUES(N'Tiếng Việt 1',3,N'NXB Giáo Dục',N'NXB Giáo Dục',45000,35000)
INSERT INTO SACH
VALUES(N'Truyện Doraemon',4,N'Fujiko.F.Fujio',N'NXB Kim Đồng',160000,150000)
INSERT INTO SACH
VALUES(N'Sổ tay pháp luật lao động',5,N'Nguyễn Hữu Phước',N'NXB Tổng hợp TP.HCM',270000,255000)

Go

--them nha cung cap
INSERT INTO NHACC
VALUES(N'Công Ty Cổ Phần Sách Mcbooks',N'Lô 34E, Khu Đấu Giá 3ha, P.Phúc Diễm, Q.Bắc Từ Liêm, Hà Nội','0986066630')
INSERT INTO NHACC
VALUES(N'Công Ty Cổ Phần Sách Giáo Dục Tại Thành Phố Hà Nội',N'289A Khuất Duy Tiến, P.Trung Hòa, Q.Cầu Giấy, Hà Nội','(024) 62534308')
INSERT INTO NHACC
VALUES(N'Công Ty Cổ Phần Học Liệu Sư Phạm',N'Tập Thể Đại Học Sư Phạm Hà Nội, Tổ 28, Dịch Vọng, Cầu Giấy, Hà Nội','(024) 39947446')
INSERT INTO NHACC
VALUES(N'Công Ty Cổ Phần Truyền Thông Và Xuất Bản Amak',N'Tầng 2, Số 46 Tân ấp, P.Phúc Xá, Q.Ba Đình, Hà Nội','(024) 62559966')
INSERT INTO NHACC
VALUES(N'Nam Hoàng - Công Ty TNHH Nam Hoàng',N'Số 38, Ngõ 49 Huỳnh Thúc Kháng, Hà Nội','(024) 37760956')

--Them don dat hang
INSERT INTO DONDH
VALUES('2021/08/08',1,N'Chưa nhập')
GO
INSERT INTO DONDH
VALUES('2021/07/08',2,N'Nhập thiếu')
GO
INSERT INTO DONDH
VALUES('2021/07/18',3,N'Nhập thiếu')
GO
INSERT INTO DONDH
VALUES('2021/08/11',4,N'Chưa nhập')
GO
INSERT INTO DONDH
VALUES('2021/08/11',5,N'Chưa nhập')
GO

--Them chi tiet don dat hang
INSERT INTO CTDONDH
VALUES(1,1,20,1200000)
GO
INSERT INTO CTDONDH
VALUES(1,2,30,6000000)
GO
INSERT INTO CTDONDH
VALUES(1,3,10,350000)
GO
--
INSERT INTO CTDONDH
VALUES(2,2,30,6000000)
GO
INSERT INTO CTDONDH
VALUES(2,1,10,600000)
GO
INSERT INTO CTDONDH
VALUES(2,3,20,700000)
GO
--
INSERT INTO CTDONDH
VALUES(3,1,20,1200000)
GO
INSERT INTO CTDONDH
VALUES(3,2,10,2000000)
GO
INSERT INTO CTDONDH
VALUES(3,3,20,700000)
GO
--
INSERT INTO CTDONDH
VALUES(4,1,20,1200000)
GO
INSERT INTO CTDONDH
VALUES(4,2,30,6000000)
GO
INSERT INTO CTDONDH
VALUES(4,3,10,350000)
GO
--
INSERT INTO CTDONDH
VALUES(5,1,20,1200000)
GO
INSERT INTO CTDONDH
VALUES(5,2,30,6000000)
GO
INSERT INTO CTDONDH
VALUES(5,3,10,350000)
GO

--Them phieu nhap thieu
INSERT INTO PNHAP
VALUES('2021/08/16','2')
GO
INSERT INTO CTPNHAP -- con thieu
VALUES('1','2',20,200000)
GO
INSERT INTO CTPNHAP -- con thieu
VALUES('1','1',5,60000)
GO
INSERT INTO CTPNHAP -- con thieu
VALUES('1','3',5,35000)
GO
--
INSERT INTO PNHAP
VALUES('2021/08/16','3')
GO
INSERT INTO CTPNHAP --nhap du
VALUES('2','1',20,60000)
GO
INSERT INTO CTPNHAP --con thieu
VALUES('2','2',5,200000)
GO
INSERT INTO CTPNHAP -- con thieu
VALUES('2','3',15,35000)
GO

--them KhachHang
INSERT INTO KHACHHANG
VALUES(N'Nguyễn Thị Ngọc Anh','0732999888',N'Bắc Từ Liêm, Hà Nội')
GO
INSERT INTO KHACHHANG
VALUES(N'Phạm Văn Hùng','0342999120',N'Thanh Xuân, Hà Nội')
GO
INSERT INTO KHACHHANG
VALUES(N'Bùi Ngọc Lan','0989727627',N'Cầu Giấy, Hà Nội')
GO
INSERT INTO KHACHHANG
VALUES(N'Nguyễn Xuân Phúc','0982822912',N'Văn Giang, Hưng Yên')
GO
INSERT INTO KHACHHANG
VALUES(N'Hồ Cẩm Đào','0381512060',N'Nam Định')
GO

--them hoadon
INSERT INTO HOADON
VALUES('2021/06/16',1,1)
GO
INSERT INTO HOADON
VALUES('2021/06/17',2,1)
GO
INSERT INTO HOADON
VALUES('2021/06/18',3,2)
GO
INSERT INTO HOADON
VALUES('2021/06/19',4,2)
GO
INSERT INTO HOADON
VALUES('2021/06/20',5,2)
GO

--them cthoadon
INSERT INTO CTHOADON
VALUES(1,1,10,650000)
GO
INSERT INTO CTHOADON
VALUES(1,2,20,4200000)
GO
INSERT INTO CTHOADON
VALUES(1,3,10,450000)
GO
--
INSERT INTO CTHOADON
VALUES(2,1,10,650000)
GO
INSERT INTO CTHOADON
VALUES(2,2,20,4200000)
GO
INSERT INTO CTHOADON
VALUES(2,3,10,450000)
GO
--
INSERT INTO CTHOADON
VALUES(3,1,10,650000)
GO
INSERT INTO CTHOADON
VALUES(3,2,20,4200000)
GO
INSERT INTO CTHOADON
VALUES(3,3,10,450000)
GO
--
INSERT INTO CTHOADON
VALUES(4,1,10,650000)
GO
INSERT INTO CTHOADON
VALUES(4,2,20,4200000)
GO
INSERT INTO CTHOADON
VALUES(4,3,10,450000)
GO
--
INSERT INTO CTHOADON
VALUES(5,1,10,650000)
GO
INSERT INTO CTHOADON
VALUES(5,2,20,4200000)
GO
INSERT INTO CTHOADON
VALUES(5,3,10,450000)
GO
