create database qlbn_xuong
go
use qlbn_xuong
go

create table BenhNhan (
	MaBN int identity (1,1) primary key,
	HotenBN nvarchar(30) not null,
	DiaChi nvarchar (100) not null,
);

create table BHYT(
	MaBH  varchar(15) primary key,
	NgayBatDau datetime not null,
	NgayKetThuc datetime not null,
	MaBN int not null,
);

create table BenhAn(
	MaBA int identity (1,1) primary key,
	NgayLap datetime not null,
	KetQua nvarchar (20) not null,
	MaBN int not null
);

create table PhieuKhamBenh (
	MaBN int not null,
	TrieuChung nvarchar (20) not null,
	NgayKham datetime not null
);

create table Khoa(
	MaKhoa int identity (1,1) primary key,
	TenKhoa nvarchar (20) not null
);
create table BacSy(
	MaBS int identity (1,1) primary key,
	HoTenBS nvarchar (30) not null,
	DiaChi nvarchar (30) not null,
	SDT varchar(10) not null,
	ChuyenMon nvarchar (20) not null,
	ChucVu nvarchar (20) not null,
	MaKhoa int
);
create table CT_PhieuKham (
	MaBN int not null,
	MaBS int not null,
	ChuanDoan nvarchar(20) not null
);

create table DichVu(
	MaDV int identity (1,1) primary key,
	TenDichVu nvarchar  (30) not null,
	GiaDichVu money not null,
);

create table Thuoc (
	MaThuoc int identity (1,1) primary key,
	TenThuoc nvarchar (30) not null,
	GiaThuoc money not null,
	SoluongTon int not null,
	GhiChu nvarchar (30) not null,
	DonViTinh nvarchar (10) not null,
);

create table CT_DichVu(
	MaBN int not null,
	MaDV int not null,
	MaBS int not null,
	KetQuaDichVu nvarchar (20),
	KetLuan nvarchar (10),
	PhuongPhap nvarchar (20) not null
);

create table TienTamUng(
	MaTamUng int identity (1,1) primary key,
	TienTamUng money not null,
	MaBN int not null
);

create table HoaDon(
	MaHD int identity (1,1) primary key,
	PhiPhatSinh money not null,
	MaThuoc int not null,
	MaBN int not null,
	MaDV int not null,
	MaBS int not null,
	MaTamUng int not null
);

create table CT_ToaThuoc(
	MaThuoc int not null,
	MaBS int not null,
	MaBN int not null,
	MaDV int not null, 
	SoLuong int not null,
	SoLanSD int not null,
	LieuLuong nvarchar (15) not null,
	NgayTaiKham datetime not null
);

alter table 
add
	constraint fk_ma_l
	foreign key (MaLoaiMon)
	references LoaiMon(MaLoaiMon)
;
go