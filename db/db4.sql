-- =====================================================
-- DATABASE SIMPEL HKI DAME - VERSI KP (FOCUSED & ROBUST)
-- =====================================================

SET NAMES utf8mb4;
SET time_zone = '+07:00';

-- 1. Manajemen Pengguna
CREATE TABLE users (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nama_lengkap VARCHAR(255),
    role ENUM('Admin', 'Tata Usaha') NOT NULL
);

-- 2. Data Master: Sektor
CREATE TABLE sektor (
    id_sektor INT AUTO_INCREMENT PRIMARY KEY,
    nama_sektor VARCHAR(100) NOT NULL UNIQUE,
    keterangan TEXT NULL
);

-- 3. Data Master: Keluarga (PENTING!)
CREATE TABLE keluarga (
    id_keluarga INT AUTO_INCREMENT PRIMARY KEY,
    nama_keluarga VARCHAR(160) NOT NULL, -- ex: "Keluarga Bpk. Antonius / Ibu Maria"
    alamat_lengkap TEXT NULL,
    id_sektor INT NULL,
    id_kepala_keluarga INT NULL, -- Foreign key ke jemaat, diisi nanti
    status_keluarga ENUM('Aktif','Pindah','Nonaktif') DEFAULT 'Aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_sektor) REFERENCES sektor(id_sektor) ON DELETE SET NULL
);

-- 4. Data Master: Jemaat (Inti dari sistem)
CREATE TABLE jemaat (
    id_jemaat INT AUTO_INCREMENT PRIMARY KEY,
    nik VARCHAR(50) NULL UNIQUE,
    nama_lengkap VARCHAR(255) NOT NULL,
    jenis_kelamin ENUM('Laki-laki', 'Perempuan') NOT NULL,
    tempat_lahir VARCHAR(100) NULL,
    tanggal_lahir DATE NULL,
    no_telepon VARCHAR(25) NULL,
    id_keluarga INT NULL,
    pekerjaan VARCHAR(100) NULL,
    pendidikan_terakhir VARCHAR(100) NULL,
    hubungan_keluarga ENUM('Kepala Keluarga','Istri','Anak','Lainnya') NULL,
    status_pernikahan ENUM('Belum Menikah', 'Menikah', 'Janda/Duda') DEFAULT 'Belum Menikah',
    status_keanggotaan ENUM('Aktif','Pindah','Meninggal','Nonaktif') DEFAULT 'Aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_keluarga) REFERENCES keluarga(id_keluarga) ON DELETE SET NULL
);

-- Tambahkan FK Kepala Keluarga setelah jemaat dibuat
ALTER TABLE keluarga ADD CONSTRAINT fk_kepala_keluarga 
FOREIGN KEY (id_kepala_keluarga) REFERENCES jemaat(id_jemaat) ON DELETE SET NULL;

-- 5. Transaksi: Riwayat Keanggotaan (Menggabungkan Baptis, Sidi, Pindah, Wafat)
CREATE TABLE riwayat_keanggotaan (
    id_riwayat INT AUTO_INCREMENT PRIMARY KEY,
    id_jemaat INT NOT NULL,
    jenis_event ENUM('Lahir','Baptis','Sidi','Pindah Keluar','Pindah Masuk','Meninggal') NOT NULL,
    tanggal_event DATE NOT NULL,
    keterangan TEXT NULL, -- Untuk mencatat nama pendeta, lokasi, gereja tujuan/asal, dll.
    no_surat VARCHAR(100) NULL,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_jemaat) REFERENCES jemaat(id_jemaat) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id_user) ON DELETE SET NULL
);

-- 6. Transaksi: Pernikahan (Tetap terpisah karena kompleks)
CREATE TABLE pernikahan (
    id_pernikahan INT AUTO_INCREMENT PRIMARY KEY,
    id_jemaat_pria INT NULL,
    nama_pasangan_pria_luar VARCHAR(255) NULL,
    id_jemaat_wanita INT NULL,
    nama_pasangan_wanita_luar VARCHAR(255) NULL,
    tanggal_martumpol DATE NOT NULL,
    tempat_martumpol VARCHAR(255) NULL,
    tanggal_pemberkatan DATE NOT NULL,
    tempat_pemberkatan VARCHAR(255) NULL,
    no_surat_nikah VARCHAR(100) NULL,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_jemaat_pria) REFERENCES jemaat(id_jemaat) ON DELETE SET NULL,
    FOREIGN KEY (id_jemaat_wanita) REFERENCES jemaat(id_jemaat) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id_user) ON DELETE SET NULL
);

-- 7. Keuangan: Kategori
CREATE TABLE kategori_keuangan (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL,
    jenis_kategori ENUM('Pemasukan', 'Pengeluaran') NOT NULL
);

-- 8. Keuangan: Transaksi (Simpel dan Efektif)
CREATE TABLE transaksi_keuangan (
    id_transaksi INT AUTO_INCREMENT PRIMARY KEY,
    id_kategori INT NOT NULL,
    tanggal_transaksi DATE NOT NULL,
    keterangan TEXT NOT NULL,
    jumlah DECIMAL(15, 2) NOT NULL,
    id_keluarga_pemberi INT NULL, -- Opsional, untuk persembahan syukur
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_kategori) REFERENCES kategori_keuangan(id_kategori),
    FOREIGN KEY (id_keluarga_pemberi) REFERENCES keluarga(id_keluarga) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id_user) ON DELETE SET NULL
);

CREATE TABLE master_iuran (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tahun YEAR NOT NULL UNIQUE, -- Satu tahun hanya punya satu patokan
    jumlah_patokan_tahunan DECIMAL(15, 2) NOT NULL,
    keterangan TEXT NULL,
    updated_by INT NULL, -- FK ke users
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (updated_by) REFERENCES users(id_user) ON DELETE SET NULL
);

CREATE TABLE iuran_tahunan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_keluarga INT NOT NULL,
    tahun YEAR NOT NULL,
    jumlah_terbayar DECIMAL(15, 2) NOT NULL DEFAULT 0, -- Total yang sudah dibayar
    tanggal_pembayaran_terakhir DATE NULL, -- Untuk melacak kapan terakhir kali keluarga ini membayar
    keterangan TEXT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (id_keluarga) REFERENCES keluarga(id_keluarga) ON DELETE CASCADE,
    
    -- Satu keluarga hanya punya satu baris data per tahun
    UNIQUE KEY uk_keluarga_tahun (id_keluarga, tahun)
);