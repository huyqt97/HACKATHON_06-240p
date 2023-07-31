create database quanlysv2;
use quanlysv2;
create table dmkhoa(
makhoa varchar(20) primary key,
tenkhoa varchar(255)
);
create table dmnganh(
manganh int primary key,
tennganh varchar(255),
makhoa varchar(20),
foreign key(makhoa) references dmkhoa(makhoa)
);
create table dmhocphan(
mahp int auto_increment primary key,
tenhp varchar(255),
sodvht int,
manganh int,
hocky int,
foreign key(manganh) references dmnganh(manganh)
);
create table dmlop(
malop varchar(20) primary key,
tenlop varchar(255),
manganh int,
foreign key(manganh) references dmnganh(manganh),
khoahoc int,
hedt varchar(255),
namnhaphoc int
);
create table sinhvien(
masv int auto_increment primary key,
hoten varchar(255),
malop varchar(20),
foreign key(malop) references dmlop(malop),
gioitinh tinyint(1),
ngaysinh date,
diachi varchar(255)
);
create table diemhp(
masv int,
mahp int,
diemhp float,
primary key(masv,mahp),
foreign key(masv) references sinhvien(masv),
foreign key(mahp) references dmhocphan(mahp)
);

-- I: thêm dữ liệu vào các bảng
insert into dmkhoa(makhoa,tenkhoa) values('CNTT','Công nghệ thông tin'),('KT','Kế toán'),('SP','Sư phạm');
insert into dmnganh(manganh,tennganh,makhoa) values (140902,'Sư phạm toán tin','SP'),('480202','Tin học ứng dụng','CNTT');
insert into dmlop(malop,tenlop,manganh,khoahoc,hedt,namnhaphoc) values('CT11','Cao đẳng tin học',480202,11,'TC',2013),('CT12','Cao đẳng tin học',480202,12,'CĐ',2013),('CT13','Cao đẳng tin học',480202,13,'TC',2014);
insert into dmhocphan(tenhp,sodvht,manganh,hocky)
 values('Toán cao cấp A1',4,480202,1),
 ('Tiếng anh 1',3,480202,1),
 ('Vật lý đại cương',4,480202,1),
 ('Tiếng anh 2',7,480202,1),
 ('Tiếng anh 1',3,480202,2),
 ('Xác xuất thống kê',3,480202,2);
 INSERT INTO sinhvien (MaSV, HoTen, MaLop, GioiTinh, NgaySinh, Diachi) VALUES
(1, 'Phan Thanh', 'CT12', 0, '1999-09-12', 'Tuy Phước'),
(2, 'Nguyên Thị Cẩm', 'CT12', 1, '1994-01-12', 'Quy Nhơn'),
(3, 'Võ Thị Hà', 'CT12', 1, '1995-07-02', 'An Nhơn'),
(4, 'Trần Hoài Nam', 'CT12', 0, '1994-04-05', 'Tây Sơn'),
(5, 'Trần Văn Hoàng', 'CT13', 0, '1995-08-04', 'Vĩnh Thạnh'),
(6, 'Đặng Thị Thảo', 'CT13', 1, '1995-06-12', 'Quy Nhơn'),
(7, 'Lê Thị Sen', 'CT13', 1, '1994-08-12', 'Phủ Mỹ'),
(8, 'Nguyễn Văn Huy', 'CT11', 0, '1995-06-04', 'Tuy Phước'),
(9, 'Trần Thị Hoa', 'CT11', 1, '1994-08-09', 'Hoài Nhơn');
INSERT INTO diemhp (MaSV, MaHP, DiemHp) VALUES
(2, 2, 5.9),
(2, 3, 4.5),
(3, 1, 4.3),
(3, 2, 6.7),
(3, 3, 7.3),
(4, 1, 4),
(4, 2, 5.2),
(4, 3, 3.5),
(5, 1, 9.8),
(5, 2, 7.9),
(5, 3, 7.5),
(6, 1, 6.1),
(6, 2, 5.6),
(6, 3, 4),
(7, 1, 6.2);

-- thực hành tuy vấn
-- 1.	 Cho biết họ tên sinh viên KHÔNG học học phần nào 
select masv, hoten from sinhvien
where masv not in (
select masv from 
diemhp
);

-- 2.	Cho biết họ tên sinh viên CHƯA học học phần nào có mã 
select masv, hoten from sinhvien
where masv not in (
select masv from diemhp where diemhp.mahp = 1
);

-- 3.	Cho biết Tên học phần KHÔNG có sinh viên điểm HP <5
select mahp, tenhp from dmhocphan
where mahp not in (
select mahp from diemhp
);

-- 4.	Cho biết Họ tên sinh viên KHÔNG có học phần điểm HP<5 
select masv, hoten from sinhvien
where masv not in(
select masv from diemhp
where diemhp.diemhp < 5
);

-- 5.	Cho biết Tên lớp có sinh viên tên Hoa 
select distinct tenlop from dmlop
where malop in(
select malop from sinhvien
where hoten like "%hoa%"
);

-- 6.	Cho biết HoTen sinh viên có điểm học phần 1 là <5.
select hoten from sinhvien 
where masv in (
select masv from diemhp 
where mahp = 1 and diemhp < 5
);

-- 7.	Cho biết danh sách các học phần có số đơn vị học trình lớn hơn hoặc
--      bằng số đơn vị học trình của học phần mã 1.
select * from dmhocphan
where sodvht >= (select sodvht from dmhocphan where mahp = 1);

--  8.	Cho biết HoTen sinh viên có DiemHP cao nhất. 
select sinhvien.masv, sinhvien.hoten ,diemhp.mahp,diemhp.diemhp  from sinhvien join diemhp on sinhvien.masv = diemhp.masv
where diemhp.diemhp >= ALL (
select diemhp from diemhp
);

-- 9.	Cho biết MaSV, HoTen sinh viên có điểm học phần mã 1 cao nhất.
select sinhvien.masv,sinhvien.hoten from sinhvien 
join diemhp on sinhvien.masv = diemhp.masv
where diemhp.mahp = 1 and diemhp.diemhp >= ALL (
select diemhp from diemhp
where mahp = 1
);

-- 10.	Cho biết MaSV, MaHP có điểm HP lớn hơn bất kì các điểm HP của sinh viên mã 3
select masv, mahp
from diemhp
where diemhp > ANY (select diemhp from diemhp where masv = 3);

-- 11.	Cho biết MaSV, HoTen sinh viên ít nhất một lần học học phần nào đó. 
select masv, hoten from sinhvien
where EXISTS (select 1 from diemhp where diemhp.masv = sinhvien.masv);

-- 12.	Cho biết MaSV, HoTen sinh viên đã không học học phần nào
select masv,hoten from sinhvien
where not exists (select 1 from diemhp where diemhp.masv = sinhvien.masv);

-- 13.	Cho biết MaSV đã học ít nhất một trong hai học phần có mã 1, 2. 
select masv from diemhp
where mahp = 1
union
select masv from diemhp
where mahp = 2;
-- 14.	Tạo thủ tục có tên KIEM_TRA_LOP cho biết HoTen sinh viên KHÔNG có điểm HP <5 ở lớp có mã chỉ định (tức là tham số truyền vào procedure là mã lớp). Phải kiểm tra MaLop chỉ định có trong danh mục hay không, nếu không thì hiển thị thông báo ‘Lớp này không có trong danh mục’. Khi lớp tồn tại thì đưa ra kết quả.
-- Ví dụ gọi thủ tục: Call KIEM_TRA_LOP(‘CT12’).
DELIMITER //
create procedure KIEM_TRA_LOP(in ma_lop varchar(20))
begin
    declare lop_ton_tai int;

    -- Kiểm tra xem mã lớp có tồn tại trong bảng dmlop hay không
    select count(*) into lop_ton_tai
    from dmlop
    where malop = ma_lop;

    if lop_ton_tai = 0 then
        select 'Lớp này không có trong danh mục' as ket_qua;
    else
        select distinct s.HoTen
        from sinhvien s
		join diemhp d on s.masv = d.masv
        where d.diemhp >= 5 and s.malop = ma_lop;
    end if;
end //

DELIMITER ;
call KIEM_TRA_LOP('CT12');
