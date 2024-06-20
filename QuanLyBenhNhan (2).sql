create database QuanLyBenhNhan_Xuong_Team;
go

use QuanLyBenhNhan_Xuong_Team;
go

create table BenhNhan (
	MaBN int identity(1, 1) primary key,
	HoTen nvarchar(30) not null,
	DiaChi nvarchar(100),
	MaBH varchar(15)
);
go

create table BaoHiemYTe (
	MaBH varchar(15) primary key,
	NgayBatDau date,
	NgayKetThuc date,
);
go

create table BenhAn (
	MaBenhAn int identity(1, 1) primary key,
	ChuanDoan nvarchar(100),
	TrieuChung nvarchar(100) not null,
	PhuongPhapDieuTri nvarchar(100) not null,
	NgayNhapVien datetime default getdate(),
	NgayXuatVien datetime,
	KetQua nvarchar(100) not null,
	MaBN int,
	check (NgayXuatVien >= NgayNhapVien)
);
go

create table PhieuKhamBenh (
	MaBenhAn int primary key,
	TrieuChung nvarchar(100) not null,
	NgayKham date not null,
);
go

create table Khoa (
	MaKhoa int identity(1, 1) primary key,
	TenKhoa nvarchar(30) not null
);
go

create table BacSi (
	MaBS int identity(1, 1) primary key,
	HoTenBS nvarchar(30) not null,
	DiaChi nvarchar(100) not null,
	SoDienthoai varchar(15) not null,
	ChuyenMon nvarchar(30) not null,
	ChucVu nvarchar(30) not null,
	MaKhoa int,
);
go

create table ChiTietPK (
	MaBenhAn int,
	MaBS int,
	ChuanDoan nvarchar(100),
	primary key (MaBenhAn, MaBS)
);
go

create table DichVu (
	MaDV int identity(1, 1) primary key,
	TenDichVu nvarchar(30) not null,
	Gia money not null,
	check (Gia >= 0)
);
go

create table ChiTietDichVu (
	MaBenhAn int,
	MaBS int,
	MaDV int,
	KetQuaDV nvarchar(100) not null,
	KetLuan nvarchar(100) not null,
	PhuongPhapDieuTri nvarchar(100) not null,
	primary key (MaBenhAn, MaBS, MaDV)
);
go

create table Thuoc (
	MaThuoc int identity(1, 1) primary key,
	TenThuoc nvarchar(50) not null,
	Gia money not null,
	SoLuongTon int not null default 0,
	GhiChu nvarchar(100),
	DonViTinh nvarchar(10) not null,
	check (Gia >= 0 and SoLuongTon >= 0)
);
go

create table ChiTietToaThuoc (
	MaThuoc int,
	MaBS int,
	MaBenhAn int,
	MaDV int,
	SoLuong int not null,
	SoLanSD int not null,
	LieuLuong nvarchar(50) not null,
	NgayTK datetime default getdate(),
	primary key (MaThuoc, MaBS, MaBenhAn, MaDV),
	check (SoLuong > 0 and SoLanSD >= 0)
);
go

create table TienTamUng (
	MaTamUng int identity(1, 1) primary key,
	TienTamUng money not null,
	MaBenhAn int,
	check (TienTamUng > 0)
);
go

create table HoaDon (
	MaHoaDon int identity(1, 1) primary key,
	PhiPhatSinh money default 0,
	ThanhTien money not null,
	MaThuoc int,
	MaBenhAn int,
	MaDV int,
	MaBS int,
	MaTamUng int
);
go

alter table BenhNhan
add constraint fk_bn_bh
	foreign key (MaBH)
	references BaoHiemYTe(MaBH);
go

alter table BenhAn
add constraint fk_ba_bn
	foreign key (MaBN)
	references BenhNhan(MaBN);
go

alter table PhieuKhamBenh
add constraint fk_kb_ba
	foreign key (MaBenhAn)
	references BenhAn(MaBenhAn);
go

alter table ChiTietPK
add 
	constraint fk_ctpk_bs
	foreign key (MaBS)
	references BacSi(MaBS),

	constraint fk_ctpk_ba
	foreign key (MaBenhAn)
	references PhieuKhamBenh(MaBenhAn);
go

alter table BacSi
add constraint fk_bs_k
	foreign key (MaKhoa)
	references Khoa(MaKhoa);
go

alter table ChiTietDichVu
add 
	constraint fk_ctdv_dv
	foreign key (MaDV)
	references DichVu(MaDV),

	constraint fk_ctdv_ba
	foreign key (MaBenhAn, MaBS)
	references ChiTietPK(MaBenhAn, MaBS);
go

alter table ChiTietToaThuoc
add 
	constraint fk_tt_t
	foreign key (MaThuoc)
	references Thuoc(MaThuoc),

	constraint fk_tt_pkq
	foreign key (MaBenhAn, MaBS, MaDV)
	references ChiTietDichVu(MaBenhAn, MaBS, MaDV);
go

alter table HoaDon
add
	constraint fk_hd_tu
	foreign key (MaTamUng)
	references TienTamUng(MaTamUng),

	constraint fk_hd_t
	foreign key (MaThuoc, MaBS, MaBenhAn, MaDV)
	references ChiTietToaThuoc(MaThuoc, MaBS, MaBenhAn, MaDV);
go

alter table TienTamUng
add constraint fk_tu_ba
	foreign key (MaBenhAn)
	references BenhAn(MaBenhAn);
go

------------------------------------------------------------------------------------------------

-- Thêm dữ liệu vào bảng BaoHiemYTe
INSERT INTO BaoHiemYTe (MaBH, NgayBatDau, NgayKetThuc)
VALUES 
('BH67892', '2022-06-01', '2023-05-31'),
('BH67893', '2023-03-15', '2024-03-14'),
('BH67894', '2022-01-01', '2023-12-31')
go

-- Cập nhật dữ liệu trong bảng BaoHiemYTe
UPDATE BaoHiemYTe
SET NgayBatDau = '2023-01-01', NgayKetThuc = '2024-12-31'
WHERE MaBH = 'BH12345';
go

UPDATE BaoHiemYTe
SET NgayBatDau = '2022-06-01', NgayKetThuc = '2023-05-31'
WHERE MaBH = 'BH67890';
go

UPDATE BaoHiemYTe
SET NgayBatDau = '2023-03-15', NgayKetThuc = '2024-03-14'
WHERE MaBH = 'BH24680';
go

UPDATE BaoHiemYTe
SET NgayBatDau = '2022-01-01', NgayKetThuc = '2023-12-31'
WHERE MaBH = 'BH13579';
go

UPDATE BaoHiemYTe
SET NgayBatDau = '2024-02-01', NgayKetThuc = '2025-01-31'
WHERE MaBH = 'BH86420';
go

-- Thêm dữ liệu vào bảng BenhNhan
INSERT INTO BenhNhan (HoTen, DiaChi, MaBH)
VALUES 
(N'Nguyễn Dương Thiên Lý', N'123 Đường ABC, Quận XYZ, TP. HCM', 'BH67892'),
(N'Võ Thanh Tùng', N'456 Đường DEF, Quận UVW, Hà Nội', NULL),
(N'Phạm Thị Hằng', N'789 Đường GHI, Quận KLM, Đà Nẵng', 'BH67893'),
(N'Lê Văn Danh', N'101 Đường JKL, Quận NOP, Hải Phòng', 'BH67894')
go

-- Thêm dữ liệu vào bảng BenhAn
INSERT INTO BenhAn (ChuanDoan, TrieuChung, PhuongPhapDieuTri, NgayNhapVien, NgayXuatVien, KetQua, MaBN)
VALUES 
(N'Viêm họng', N'Đau họng, sổ mũi', N'Uống thuốc, rửa họng', '2024-03-20', '2024-03-25', N'Hồi phục', (SELECT TOP 1 MaBN FROM BenhNhan WHERE HoTen = N'Nguyễn Dương Thiên Lý')),
(N'Sốt phát ban', N'Sốt cao, phát ban nổi', N'Nghỉ ngơi, uống thuốc hạ sốt', '2024-03-21', NULL, N'Đang điều trị', (SELECT TOP 1 MaBN FROM BenhNhan WHERE HoTen = N'Võ Thanh Tùng')),
(N'Đau bụng dưới', N'Đau ở vùng bụng dưới', N'Kiểm tra lâm sàng, siêu âm', '2024-03-23', NULL, N'Cần theo dõi', (SELECT TOP 1 MaBN FROM BenhNhan WHERE HoTen = N'Phạm Thị Hằng')),
(N'Viêm đường hô hấp', N'Ho, đau ngực, khó thở', N'Kháng sinh, hít khí', '2024-03-22', '2024-03-27', N'Hồi phục', (SELECT TOP 1 MaBN FROM BenhNhan WHERE HoTen = N'Lê Văn Danh'))
go
INSERT INTO BenhAn (ChuanDoan, TrieuChung, PhuongPhapDieuTri, NgayNhapVien, NgayXuatVien, KetQua, MaBN)
VALUES 
(N'Đau răng', N'Đau răng, sưng nướu', N'Khám răng, nhổ răng', '2024-03-26', '2024-03-28', N'Đang điều trị', 2),
(N'Đau răng', N'Đau răng, sưng nướu', N'Khám răng, nhổ răng', '2024-03-25', NULL, N'Đang điều trị', 3),
(N'Đau răng', N'Đau răng, sưng nướu', N'Khám răng, nhổ răng', '2024-03-24', '2024-03-26', N'Hồi phục', 4),
(N'Đau dạ dày', N'Đau ở vùng dạ dày', N'Kiểm tra lâm sàng, siêu âm', '2024-03-25', '2024-03-29', N'Cần theo dõi', 1),
(N'Đau dạ dày', N'Đau ở vùng dạ dày', N'Kiểm tra lâm sàng, siêu âm', '2024-03-23', NULL, N'Đang điều trị', 2),
(N'Đau dạ dày', N'Đau ở vùng dạ dày', N'Kiểm tra lâm sàng, siêu âm', '2024-03-27', NULL, N'Đang điều trị', 3),
(N'Ho do cảm lạnh', N'Ho, sổ mũi, đau họng', N'Uống thuốc giảm ho, hít khí', '2024-03-24', '2024-03-28', N'Hồi phục', 4),
(N'Viêm khớp', N'Đau khớp, sưng khớp', N'Kiểm tra máu, chụp X-quang', '2024-03-25', '2024-03-30', N'Cần theo dõi', 1),
(N'Đau khớp', N'Đau ở các khớp nhỏ', N'Nghỉ ngơi, đắp thuốc giảm đau', '2024-03-26', NULL, N'Đang điều trị', 2),
(N'Viêm tai giữa', N'Đau tai, sốt nhẹ', N'Uống thuốc kháng viêm, nhỏ tai', '2024-03-27', '2024-03-29', N'Hồi phục', 3);


-- Thêm dữ liệu vào bảng Khoa
INSERT INTO Khoa (TenKhoa)
VALUES 
(N'Nội khoa'),
(N'Ngoại khoa'),
(N'Sản khoa'),
(N'Răng hàm mặt'),
(N'Da liễu');
go

-- Thêm dữ liệu vào bảng BacSi
INSERT INTO BacSi (HoTenBS, DiaChi, SoDienthoai, ChuyenMon, ChucVu, MaKhoa)
VALUES 
(N'Nguyễn Thị Lan', N'789 Đường GHI, Quận KLM, Đà Nẵng', '0901234567', N'Nội khoa', N'Bác sĩ chính', 1),
(N'Trần Văn Đức', N'456 Đường DEF, Quận UVW, Hà Nội', '0987654321', N'Ngoại khoa', N'Bác sĩ chính', 2),
(N'Lê Minh Tuấn', N'123 Đường ABC, Quận XYZ, TP. HCM', '0123456789', N'Sản khoa', N'Bác sĩ cấp dưới', 3),
(N'Hoàng Anh Tuấn', N'101 Đường JKL, Quận NOP, Hải Phòng', '0321654987', N'Răng hàm mặt', N'Bác sĩ cấp trên', 4),
(N'Phạm Thị Hương', N'111 Đường MNO, Quận PQR, Cần Thơ', '0369841257', N'Da liễu', N'Bác sĩ cấp dưới', 5);
go

-- Thêm dữ liệu vào bảng DichVu
INSERT INTO DichVu (TenDichVu, Gia)
VALUES
(N'Siêu âm', 500000),
(N'Xét nghiệm máu', 200000),
(N'Chụp X-quang phổi', 300000),
(N'Đo đường huyết', 150000),
(N'Nội soi', 400000);
go

-- Thêm dữ liệu vào bảng Thuoc
INSERT INTO Thuoc (TenThuoc, Gia, SoLuongTon, GhiChu, DonViTinh)
VALUES
('Paracetamol', 5000, 100, N'Thuốc hạ sốt', N'Viên'),
('Amoxicillin', 8000, 50, N'Thuốc kháng sinh', N'Viên'),
('Omeprazole', 10000, 80, N'Thuốc điều trị đau dạ dày', N'Viên'),
('Aspirin', 3000, 120, N'Thuốc giảm dau', N'Viên'),
('Loratadine', 7000, 60, N'Thuốc chống dị ứng', N'Viên');
go

-- Thêm dữ liệu vào bảng PhieuKhamBenh
INSERT INTO PhieuKhamBenh (MaBenhAn, TrieuChung, NgayKham)
SELECT MaBenhAn, TrieuChung, NgayKham
FROM (VALUES 
(1, N'Đau họng, sổ mũi', '2024-03-18'),
(2, N'Sốt cao', '2024-03-21'),
(3, N'Đau ở vùng bụng dưới', '2024-03-23'),
(4, N'Đau bụng, ói', '2024-03-23')
) AS PK (MaBenhAn, TrieuChung, NgayKham)
WHERE MaBenhAn IN (SELECT MaBenhAn FROM BenhAn);
go


-- Thêm dữ liệu vào bảng ChiTietPK
INSERT INTO ChiTietPK (MaBenhAn, MaBS, ChuanDoan)
VALUES 
(1, 2, N'Viêm họng cấp'),
(2, 4, N'Mọc răng khôn'),
(3, 1, N'Viêm ruột thừa'),
(4, 3, N'Mang thai')
go

-- Thêm dữ liệu vào bảng ChiTietDichVu
INSERT INTO ChiTietDichVu (MaBenhAn, MaBS, MaDV, KetQuaDV, KetLuan, PhuongPhapDieuTri)
VALUES
(1, 2, 3, N'Phổi bình thường', N'Ho bình thường', N'Dùng thuốc tây'),
(2, 4, 4, N'Huyết áp cao', N'Chờ huyết áp giảm mới nhổ răng', N'Dùng thuốc giảm huyết áp'),
(4, 3, 1, N'Xuất hiện phôi thai', N'Sinh con gái', N'Dùng thuốc giảm đau'),
(4, 3, 2, N'Nhóm máu 0', N'Thiếu máu', N'Truyền máu');
go

-- Thêm dữ liệu vào bảng TienTamUng
INSERT INTO TienTamUng (TienTamUng, MaBenhAn)
VALUES 
(2000000, 1),
(1500000, 2),
(3000000, 3),
(2500000, 4);
go


-- Thêm dữ liệu vào bảng ChiTietToaThuoc
INSERT INTO ChiTietToaThuoc (MaThuoc, MaBS, MaBenhAn, MaDV, SoLuong, SoLanSD, LieuLuong, NgayTK)
VALUES 
(1, 2, 1, 3, 20, 3, N'1 viên mỗi lần, 3 lần/ngày', '2024-03-20'),
(2, 4, 2, 4, 30, 2, N'1 viên mỗi lần, 2 lần/ngày', '2024-03-21'),
(3, 3, 4, 1, 10, 1, N'1 viên/ngày', '2024-03-22'),
(4, 3, 4, 2, 15, 2, N'1 viên mỗi lần, 2 lần/ngày', '2024-03-23');
go

-- Thêm dữ liệu vào bảng HoaDon
INSERT INTO HoaDon (PhiPhatSinh, ThanhTien, MaThuoc, MaBenhAn, MaDV, MaBS, MaTamUng)
VALUES 
(50000, 150000, 1, 1, 3, 2, 1),
(70000, 200000, 2, 2, 4, 4, 2),
(60000, 180000, 3, 4, 1, 3, 3),
(80000, 250000, 4, 4, 2, 3, 4);
go




--truy vấn thông tin của bác sĩ
select * from BacSi

--truy vấn thông tin bảo hiểm
select * from BaoHiemYTe

--truy vấn thông tin bệnh án
select * from BenhAn

--truy vấn thông tin bệnh nhân
select * from BenhNhan

--truy vấn thông tin Chi tiết dịch vụ
select * from ChiTietDichVu

--truy vấn thông tin chi tiết phiếu khám
select * from ChiTietPK

--truy vấn thông tin chi tiết toa thuốc
select * from ChiTietToaThuoc

--truy vấn thông tin dịch vụ
select * from DichVu

--truy vấn thông tin hóa đơn
select * from HoaDon

--truy vấn thông tin khoa
select * from Khoa

--truy vấn thông tin phiếu khám bệnh
select * from PhieuKhamBenh

--truy vấn thông tin tiền tạm ứng
select * from TienTamUng

--truy vấn thông tin thuốc
select * from Thuoc

go
-- truy vấn có tháng bệnh nhân nhập viên nhiều nhất
SELECT MONTH(NgayNhapVien) AS Thang, COUNT(*) AS SoLuongBenhNhan
FROM BenhAn
WHERE NgayNhapVien IS NOT NULL
GROUP BY MONTH(NgayNhapVien)
ORDER BY SoLuongBenhNhan DESC
GO
--Trigger cho table PhieuKhamBenh
create trigger trigger_NgayKham
on PhieuKhamBenh
for insert , update
as
	begin
	select NgayKham from PhieuKhamBenh where NgayKham=getdate()
		begin
			print N'Ngày khám không phải ngày hôm nay'				
			rollback transaction			
		end
	end
go


--Trigger cho table Thuoc
create or alter trigger trigger_SoLuongThuoc
on Thuoc
for insert , update
as
	begin
	if(select SoLuongTon from inserted) < 0
		begin
			print N'Số lượng tồn phải lớn hơn 0'				
			rollback transaction			
		end
	end
go

create trigger trigger_Gia_Thuoc
on Thuoc
for insert , update
as
	begin
	if(select Gia from inserted) < 0
		begin
			print N'Giá thuốc phải lớn hơn 0'				
			rollback transaction			
		end
	end
go
-- proc
-- top 3 căn bệnh bị nhiều nhất
CREATE PROCEDURE Top3CacBenhNhieuNhat
AS
BEGIN
    SELECT TOP 3 ChuanDoan AS Benh, COUNT(*) AS SoLuong
    FROM BenhAn
    GROUP BY ChuanDoan
    ORDER BY COUNT(*) DESC;
END;
go
exec Top3CacBenhNhieuNhat
go
-- lay thong tin benh nhan
CREATE or ALTER PROCEDURE LayThongTinBenhNhan
    @tenbenhnhan nvarchar(50) 
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM BenhNhan
    WHERE HoTen = @tenbenhnhan; 
END;
GO

-- Gọi stored procedure và truyền giá trị vào
EXEC LayThongTinBenhNhan N'Nguyễn Dương Thiên Lý'; 
