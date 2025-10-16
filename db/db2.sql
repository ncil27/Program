CREATE TABLE tbl_sektor (
    id_sektor INT AUTO_INCREMENT PRIMARY KEY,
    nama_sektor VARCHAR(100) NOT NULL,
    keterangan TEXT
);
CREATE TABLE tbl_jemaat (
    id_jemaat INT AUTO_INCREMENT PRIMARY KEY,
    no_induk_jemaat VARCHAR(50) UNIQUE,
    nama_lengkap VARCHAR(255) NOT NULL,
    tempat_lahir VARCHAR(100),
    tanggal_lahir DATE,
    jenis_kelamin ENUM('Laki-laki', 'Perempuan'),
    alamat_lengkap TEXT,
    no_telepon VARCHAR(20),
    tanggal_baptis DATE,
    tanggal_sidi DATE,
    status_pernikahan ENUM('Belum Menikah', 'Menikah', 'Janda/Duda'),
    id_sektor INT,  -- Foreign Key ke tbl_sektor
    status_jemaat ENUM('Aktif', 'Pindah', 'Meninggal') DEFAULT 'Aktif',
    tanggal_bergabung DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_sektor) REFERENCES tbl_sektor(id_sektor)
);
CREATE TABLE tbl_pernikahan (
    id_pernikahan INT AUTO_INCREMENT PRIMARY KEY,
    id_jemaat_pria INT NULL,       -- Bisa NULL jika mempelai pria bukan jemaat HKI Dame
    id_jemaat_wanita INT NULL,     -- Bisa NULL jika mempelai wanita bukan jemaat HKI Dame
    nama_pasangan_luar VARCHAR(255) NULL, -- Untuk mencatat nama pasangan dari luar gereja
    gereja_pasangan_luar VARCHAR(255) NULL, -- Opsional: nama gereja asal pasangan luar
    tanggal_pemberkatan DATE NOT NULL,
    tempat_pemberkatan VARCHAR(255),
    dicatat_oleh VARCHAR(100), -- Nama Pendeta/Petugas
    FOREIGN KEY (id_jemaat_pria) REFERENCES tbl_jemaat(id_jemaat),
    FOREIGN KEY (id_jemaat_wanita) REFERENCES tbl_jemaat(id_jemaat)
);
CREATE TABLE tbl_kategori_keuangan (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL,
    jenis_kategori ENUM('Pemasukan', 'Pengeluaran') NOT NULL -- Membedakan antara income dan expense
);
CREATE TABLE tbl_transaksi_keuangan (
    id_transaksi INT AUTO_INCREMENT PRIMARY KEY,
    id_kategori INT NOT NULL,
    tanggal_transaksi DATE NOT NULL,
    keterangan TEXT NOT NULL,
    jumlah DECIMAL(15, 2) NOT NULL, -- Menggunakan DECIMAL untuk presisi keuangan
    tipe_transaksi ENUM('Pemasukan', 'Pengeluaran') NOT NULL, -- Redundan tapi mempermudah query
    dicatat_oleh INT, -- Foreign Key ke tabel user/admin
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_kategori) REFERENCES tbl_kategori_keuangan(id_kategori)
    -- FOREIGN KEY (dicatat_oleh) REFERENCES tbl_users(id_user) -- Jika ada tabel user
);
CREATE TABLE tbl_users (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- Selalu simpan password yang sudah di-hash!
    nama_lengkap VARCHAR(255),
    role ENUM('Admin', 'Tata Usaha') NOT NULL
);