-- Tạo database
CREATE DATABASE QuanLyNhaTroSinhVien;
GO

USE QuanLyNhaTroSinhVien;
GO

-- Bảng quản lý thông tin tòa nhà
CREATE TABLE ToaNha (
    MaToaNha INT IDENTITY(1,1) PRIMARY KEY,
    TenToaNha NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255) NOT NULL,
    SoTang INT NOT NULL DEFAULT 1,
    TongSoPhong INT NOT NULL DEFAULT 0,
    MoTa NVARCHAR(500),
    NgayTao DATETIME NOT NULL DEFAULT GETDATE(),
    TrangThai BIT NOT NULL DEFAULT 1 -- 1: Hoạt động, 0: Ngừng hoạt động
);
GO

-- Bảng loại phòng
CREATE TABLE LoaiPhong (
    MaLoaiPhong INT IDENTITY(1,1) PRIMARY KEY,
    TenLoai NVARCHAR(50) NOT NULL, -- Phòng đơn, đôi, tập thể
    DienTich DECIMAL(10,2) NOT NULL,
    SoNguoiToiDa INT NOT NULL,
    MoTa NVARCHAR(500),
    GiaThue DECIMAL(18,2) NOT NULL
);
GO

-- Bảng phòng trọ
CREATE TABLE Phong (
    MaPhong INT IDENTITY(1,1) PRIMARY KEY,
    MaToaNha INT NOT NULL FOREIGN KEY REFERENCES ToaNha(MaToaNha),
    MaLoaiPhong INT NOT NULL FOREIGN KEY REFERENCES LoaiPhong(MaLoaiPhong),
    TenPhong NVARCHAR(50) NOT NULL, -- P101, P102...
    SoTang INT NOT NULL,
    DienTich DECIMAL(10,2),
    TienCoc DECIMAL(18,2) DEFAULT 0,
    TienThue DECIMAL(18,2) NOT NULL,
    TrangThai NVARCHAR(20) NOT NULL DEFAULT 'Trong', -- Trong, Da thue, Dang sua chua
    MoTa NVARCHAR(500),
    NgayTao DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CHK_TrangThai_Phong CHECK (TrangThai IN ('Trong', 'Da thue', 'Dang sua chua'))
);
GO

-- Bảng tiện ích phòng
CREATE TABLE TienIchPhong (
    MaTienIch INT IDENTITY(1,1) PRIMARY KEY,
    MaPhong INT NOT NULL FOREIGN KEY REFERENCES Phong(MaPhong),
    TenTienIch NVARCHAR(100) NOT NULL, -- Wifi, Máy lạnh, Tủ lạnh...
    MoTa NVARCHAR(500),
    TrangThai BIT NOT NULL DEFAULT 1
);
GO

-- Bảng sinh viên (người thuê)
CREATE TABLE SinhVien (
    MaSinhVien INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    CCCD VARCHAR(20) NOT NULL UNIQUE,
    NgaySinh DATE NOT NULL,
    GioiTinh NVARCHAR(10) NOT NULL,
    SDT VARCHAR(15) NOT NULL,
    Email NVARCHAR(100),
    TruongDaiHoc NVARCHAR(200),
    MaSoSinhVien NVARCHAR(50),
    QueQuan NVARCHAR(200),
    TenNguoiThan NVARCHAR(100),
    SDTNguoiThan VARCHAR(15),
    NgayDangKy DATETIME NOT NULL DEFAULT GETDATE(),
    TrangThai BIT NOT NULL DEFAULT 1 -- 1: Đang hoạt động, 0: Đã nghỉ
);
GO

-- Bảng hợp đồng thuê
CREATE TABLE HopDong (
    MaHopDong INT IDENTITY(1,1) PRIMARY KEY,
    MaPhong INT NOT NULL FOREIGN KEY REFERENCES Phong(MaPhong),
    MaSinhVien INT NOT NULL FOREIGN KEY REFERENCES SinhVien(MaSinhVien),
    SoHopDong NVARCHAR(50) NOT NULL UNIQUE,
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    TienCoc DECIMAL(18,2) NOT NULL,
    TienThueHangThang DECIMAL(18,2) NOT NULL,
    NgayThanhToan INT NOT NULL DEFAULT 1, -- Ngày thanh toán trong tháng
    NoiDungHopDong NVARCHAR(MAX),
    TrangThai NVARCHAR(20) NOT NULL DEFAULT 'Dang hoat dong', -- Dang hoat dong, Da ket thuc, Bi huy
    NgayKy DATETIME NOT NULL DEFAULT GETDATE(),
    NguoiTao NVARCHAR(100) NOT NULL,
    CONSTRAINT CHK_TrangThai_HopDong CHECK (TrangThai IN ('Dang hoat dong', 'Da ket thuc', 'Bi huy'))
);
GO

-- Bảng chi tiết người thuê trong phòng (nếu phòng nhiều người)
CREATE TABLE ChiTietNguoiThue (
    MaChiTiet INT IDENTITY(1,1) PRIMARY KEY,
    MaHopDong INT NOT NULL FOREIGN KEY REFERENCES HopDong(MaHopDong),
    MaSinhVien INT NOT NULL FOREIGN KEY REFERENCES SinhVien(MaSinhVien),
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE,
    VaiTro NVARCHAR(50) NOT NULL DEFAULT 'Nguoi thue' -- Chu hop dong, Nguoi thue
);
GO

-- Bảng dịch vụ
CREATE TABLE DichVu (
    MaDichVu INT IDENTITY(1,1) PRIMARY KEY,
    TenDichVu NVARCHAR(100) NOT NULL, -- Điện, Nước, Internet, Rác...
    DonViTinh NVARCHAR(50) NOT NULL, -- kWh, m3, tháng...
    DonGia DECIMAL(18,2) NOT NULL,
    MoTa NVARCHAR(500),
    TrangThai BIT NOT NULL DEFAULT 1
);
GO

-- Bảng hóa đơn
CREATE TABLE HoaDon (
    MaHoaDon INT IDENTITY(1,1) PRIMARY KEY,
    MaHopDong INT NOT NULL FOREIGN KEY REFERENCES HopDong(MaHopDong),
    SoHoaDon NVARCHAR(50) NOT NULL UNIQUE,
    ThangNam VARCHAR(7) NOT NULL, -- Format: YYYY-MM
    TongTien DECIMAL(18,2) NOT NULL DEFAULT 0,
    TienDaThanhToan DECIMAL(18,2) NOT NULL DEFAULT 0,
    NgayTao DATETIME NOT NULL DEFAULT GETDATE(),
    HanThanhToan DATE NOT NULL,
    NgayThanhToan DATETIME,
    TrangThai NVARCHAR(20) NOT NULL DEFAULT 'Chua thanh toan', -- Chua thanh toan, Da thanh toan, Qua han
    GhiChu NVARCHAR(500),
    NguoiTao NVARCHAR(100) NOT NULL,
    CONSTRAINT CHK_TrangThai_HoaDon CHECK (TrangThai IN ('Chua thanh toan', 'Da thanh toan', 'Qua han'))
);
GO

-- Bảng chi tiết hóa đơn dịch vụ
CREATE TABLE ChiTietHoaDon (
    MaChiTiet INT IDENTITY(1,1) PRIMARY KEY,
    MaHoaDon INT NOT NULL FOREIGN KEY REFERENCES HoaDon(MaHoaDon),
    MaDichVu INT NOT NULL FOREIGN KEY REFERENCES DichVu(MaDichVu),
    ChiSoCu DECIMAL(18,2),
    ChiSoMoi DECIMAL(18,2),
    SoLuong DECIMAL(18,2) NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    ThanhTien DECIMAL(18,2) NOT NULL
);
GO

-- Bảng lịch sử thanh toán
CREATE TABLE LichSuThanhToan (
    MaThanhToan INT IDENTITY(1,1) PRIMARY KEY,
    MaHoaDon INT NOT NULL FOREIGN KEY REFERENCES HoaDon(MaHoaDon),
    SoTien DECIMAL(18,2) NOT NULL,
    NgayThanhToan DATETIME NOT NULL DEFAULT GETDATE(),
    PhuongThuc NVARCHAR(50) NOT NULL, -- Tien mat, Chuyen khoan, The
    NguoiThu NVARCHAR(100) NOT NULL,
    GhiChu NVARCHAR(500)
);
GO

-- Bảng báo cáo sự cố/bảo trì
CREATE TABLE BaoCaoSuCo (
    MaBaoCao INT IDENTITY(1,1) PRIMARY KEY,
    MaPhong INT NOT NULL FOREIGN KEY REFERENCES Phong(MaPhong),
    MaSinhVien INT NOT NULL FOREIGN KEY REFERENCES SinhVien(MaSinhVien),
    TieuDe NVARCHAR(200) NOT NULL,
    MoTa NVARCHAR(1000) NOT NULL,
    LoaiSuCo NVARCHAR(100) NOT NULL, -- Hong do, Ve sinh, An ninh...
    MucDo NVARCHAR(20) NOT NULL DEFAULT 'Trung binh', -- Thap, Trung binh, Cao, Khan cap
    TrangThai NVARCHAR(20) NOT NULL DEFAULT 'Moi tao', -- Moi tao, Dang xu ly, Da xu ly, Da huy
    NgayBaoCao DATETIME NOT NULL DEFAULT GETDATE(),
    NgayXuLy DATETIME,
    NguoiXuLy NVARCHAR(100),
    KetQuaXuLy NVARCHAR(1000)
);
GO

-- Bảng nhân viên/quản lý
CREATE TABLE NhanVien (
    MaNhanVien INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,
    HoTen NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NOT NULL,
    Email NVARCHAR(100),
    VaiTro NVARCHAR(50) NOT NULL DEFAULT 'Nhan vien', -- Admin, Quan ly, Nhan vien
    TrangThai BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Bảng cấu hình hệ thống
CREATE TABLE CauHinh (
    MaCauHinh INT IDENTITY(1,1) PRIMARY KEY,
    TenCauHinh NVARCHAR(100) NOT NULL UNIQUE,
    GiaTri NVARCHAR(500) NOT NULL,
    MoTa NVARCHAR(500),
    NgayCapNhat DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Tạo indexes để tối ưu hiệu năng
CREATE INDEX IX_Phong_MaToaNha ON Phong(MaToaNha);
CREATE INDEX IX_Phong_TrangThai ON Phong(TrangThai);
CREATE INDEX IX_HopDong_MaPhong ON HopDong(MaPhong);
CREATE INDEX IX_HopDong_MaSinhVien ON HopDong(MaSinhVien);
CREATE INDEX IX_HopDong_TrangThai ON HopDong(TrangThai);
CREATE INDEX IX_HoaDon_MaHopDong ON HoaDon(MaHopDong);
CREATE INDEX IX_HoaDon_ThangNam ON HoaDon(ThangNam);
CREATE INDEX IX_HoaDon_TrangThai ON HoaDon(TrangThai);
CREATE INDEX IX_SinhVien_CCCD ON SinhVien(CCCD);
CREATE INDEX IX_SinhVien_SDT ON SinhVien(SDT);
CREATE INDEX IX_BaoCaoSuCo_MaPhong ON BaoCaoSuCo(MaPhong);
CREATE INDEX IX_BaoCaoSuCo_TrangThai ON BaoCaoSuCo(TrangThai);
GO

-- Insert dữ liệu mẫu
INSERT INTO LoaiPhong (TenLoai, DienTich, SoNguoiToiDa, MoTa, GiaThue) VALUES
(N'Phòng đơn', 20, 1, N'Phòng cho 1 người, toilet riêng', 1500000),
(N'Phòng đôi', 30, 2, N'Phòng cho 2 người, toilet riêng', 2500000),
(N'Phòng tập thể', 40, 4, N'Phòng cho 4 người, toilet riêng', 3500000);

INSERT INTO DichVu (TenDichVu, DonViTinh, DonGia, MoTa) VALUES
(N'Điện', 'kWh', 3500, N'Tiền điện theo số công tơ'),
(N'Nước', 'm3', 15000, N'Tiền nước theo đồng hồ'),
(N'Internet', 'tháng', 100000, N'Phí internet hàng tháng'),
(N'Rác', 'tháng', 50000, N'Phí vệ sinh môi trường'),
(N'Bảo vệ', 'tháng', 50000, N'Phí an ninh bảo vệ');

INSERT INTO NhanVien (TenDangNhap, MatKhau, HoTen, SDT, Email, VaiTro) VALUES
('admin', '123456', N'Quản Trị Viên', '0123456789', 'admin@nhatro.com', 'Admin'),
('quanly1', '123456', N'Nguyễn Văn Quản Lý', '0987654321', 'quanly@nhatro.com', 'Quan ly');

INSERT INTO CauHinh (TenCauHinh, GiaTri, MoTa) VALUES
('TIEN_PHAT_QUA_HAN', '0.05', N'Phần trăm phí phạt khi thanh toán quá hạn (5%)'),
('SO_NGAY_QUA_HAN', '7', N'Số ngày sau hạn thanh toán được coi là quá hạn'),
('EMAIL_LIEN_HE', 'support@nhatro.com', N'Email hỗ trợ'),
('SO_DIEN_THOAI', '0123456789', N'Số điện thoại liên hệ');

GO

-- Tạo các stored procedure cơ bản
CREATE PROCEDURE sp_ThongKeDoanhThu
    @ThangNam VARCHAR(7)
AS
BEGIN
    SELECT 
        tn.TenToaNha,
        COUNT(DISTINCT hd.MaPhong) as SoPhongDaThue,
        SUM(hd.TongTien) as TongDoanhThu,
        SUM(hd.TienDaThanhToan) as DaThu,
        SUM(hd.TongTien - hd.TienDaThanhToan) as ChuaThu
    FROM HoaDon hd
    INNER JOIN HopDong hd2 ON hd.MaHopDong = hd2.MaHopDong
    INNER JOIN Phong p ON hd2.MaPhong = p.MaPhong
    INNER JOIN ToaNha tn ON p.MaToaNha = tn.MaToaNha
    WHERE hd.ThangNam = @ThangNam
    GROUP BY tn.MaToaNha, tn.TenToaNha
END
GO

CREATE PROCEDURE sp_GetPhongTrong
    @MaToaNha INT = NULL
AS
BEGIN
    SELECT 
        p.MaPhong,
        tn.TenToaNha,
        p.TenPhong,
        lp.TenLoai,
        p.DienTich,
        p.TienThue,
        p.MoTa
    FROM Phong p
    INNER JOIN ToaNha tn ON p.MaToaNha = tn.MaToaNha
    INNER JOIN LoaiPhong lp ON p.MaLoaiPhong = lp.MaLoaiPhong
    WHERE p.TrangThai = 'Trong'
    AND (@MaToaNha IS NULL OR p.MaToaNha = @MaToaNha)
    ORDER BY tn.TenToaNha, p.TenPhong
END
GO