CREATE TABLE `users`(
    `id_user` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `nama` VARCHAR(255) NULL,
    `role` ENUM('Admin', 'Tata Usaha') NOT NULL
);
ALTER TABLE
    `users` ADD UNIQUE `users_username_unique`(`username`);
CREATE TABLE `sektor`(
    `id_sektor` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nama_sektor` VARCHAR(100) NOT NULL,
    `keterangan` TEXT NULL
);
ALTER TABLE
    `sektor` ADD UNIQUE `sektor_nama_sektor_unique`(`nama_sektor`);
CREATE TABLE `keluarga`(
    `id_keluarga` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nama_keluarga` VARCHAR(160) NOT NULL,
    `alamat_lengkap` TEXT NULL,
    `id_sektor` INT NULL,
    `id_kepala_keluarga` INT NULL,
    `status_keluarga` ENUM('Aktif', 'Pindah', 'Nonaktif') NULL DEFAULT 'Aktif',
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP(), `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP());
CREATE TABLE `jemaat`(
    `id_jemaat` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nik` VARCHAR(50) NULL,
    `nama_lengkap` VARCHAR(255) NOT NULL,
    `jenis_kelamin` ENUM('Laki-laki', 'Perempuan') NOT NULL,
    `tempat_lahir` VARCHAR(100) NULL,
    `tanggal_lahir` DATE NULL,
    `no_telepon` VARCHAR(25) NULL,
    `id_keluarga` INT NULL,
    `pekerjaan` VARCHAR(100) NULL,
    `pendidikan_terakhir` VARCHAR(100) NULL,
    `hubungan_keluarga` ENUM(
        'Kepala Keluarga',
        'Istri',
        'Anak',
        'Lainnya'
    ) NULL,
    `status_pernikahan` ENUM(
        'Belum Menikah',
        'Menikah',
        'Janda/Duda'
    ) NULL DEFAULT 'Belum Menikah',
    `status_keanggotaan` ENUM(
        'Aktif',
        'Pindah',
        'Meninggal',
        'Nonaktif'
    ) NULL DEFAULT 'Aktif',
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP(), `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP());
ALTER TABLE
    `jemaat` ADD UNIQUE `jemaat_nik_unique`(`nik`);
CREATE TABLE `riwayat_keanggotaan`(
    `id_riwayat` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_jemaat` INT NOT NULL,
    `jenis_event` ENUM(
        'Lahir',
        'Baptis',
        'Sidi',
        'Pindah Keluar',
        'Pindah Masuk',
        'Meninggal'
    ) NOT NULL,
    `tanggal_event` DATE NOT NULL,
    `keterangan` TEXT NULL,
    `no_surat` VARCHAR(100) NULL,
    `created_by` INT NULL,
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP());
CREATE TABLE `pernikahan`(
    `id_pernikahan` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_jemaat_pria` INT NULL,
    `nama_pasangan_pria_luar` VARCHAR(255) NULL,
    `id_jemaat_wanita` INT NULL,
    `nama_pasangan_wanita_luar` VARCHAR(255) NULL,
    `tanggal_martumpol` DATE NOT NULL,
    `tempat_martumpol` VARCHAR(255) NULL,
    `tanggal_pemberkatan` DATE NOT NULL,
    `tempat_pemberkatan` VARCHAR(255) NULL,
    `no_surat_nikah` VARCHAR(100) NULL,
    `created_by` INT NULL,
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP());
CREATE TABLE `kategori_keuangan`(
    `id_kategori` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nama_kategori` VARCHAR(100) NOT NULL,
    `jenis_kategori` ENUM('Pemasukan', 'Pengeluaran') NOT NULL
);
CREATE TABLE `transaksi_keuangan`(
    `id_transaksi` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_kategori` INT NOT NULL,
    `tanggal_transaksi` DATE NOT NULL,
    `keterangan` TEXT NOT NULL,
    `jumlah` DECIMAL(15, 2) NOT NULL,
    `id_keluarga_pemberi` INT NULL,
    `created_by` INT NULL,
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP());
CREATE TABLE `master_iuran`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `tahun` YEAR NOT NULL,
    `jumlah_patokan_tahunan` DECIMAL(15, 2) NOT NULL,
    `keterangan` TEXT NULL,
    `updated_by` INT NULL,
    `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP());
ALTER TABLE
    `master_iuran` ADD UNIQUE `master_iuran_tahun_unique`(`tahun`);
CREATE TABLE `iuran_tahunan`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_keluarga` INT NOT NULL,
    `tahun` YEAR NOT NULL,
    `jumlah_terbayar` DECIMAL(15, 2) NOT NULL,
    `tanggal_pembayaran_terakhir` DATE NULL,
    `keterangan` TEXT NULL,
    `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP());
ALTER TABLE
    `iuran_tahunan` ADD UNIQUE `iuran_tahunan_id_keluarga_tahun_unique`(`id_keluarga`, `tahun`);
ALTER TABLE
    `pernikahan` ADD CONSTRAINT `pernikahan_id_jemaat_wanita_foreign` FOREIGN KEY(`id_jemaat_wanita`) REFERENCES `jemaat`(`id_jemaat`);
ALTER TABLE
    `pernikahan` ADD CONSTRAINT `pernikahan_id_jemaat_pria_foreign` FOREIGN KEY(`id_jemaat_pria`) REFERENCES `jemaat`(`id_jemaat`);
ALTER TABLE
    `riwayat_keanggotaan` ADD CONSTRAINT `riwayat_keanggotaan_created_by_foreign` FOREIGN KEY(`created_by`) REFERENCES `users`(`id_user`);
ALTER TABLE
    `riwayat_keanggotaan` ADD CONSTRAINT `riwayat_keanggotaan_id_jemaat_foreign` FOREIGN KEY(`id_jemaat`) REFERENCES `jemaat`(`id_jemaat`);
ALTER TABLE
    `transaksi_keuangan` ADD CONSTRAINT `transaksi_keuangan_id_keluarga_pemberi_foreign` FOREIGN KEY(`id_keluarga_pemberi`) REFERENCES `keluarga`(`id_keluarga`);
ALTER TABLE
    `keluarga` ADD CONSTRAINT `keluarga_id_kepala_keluarga_foreign` FOREIGN KEY(`id_kepala_keluarga`) REFERENCES `jemaat`(`id_jemaat`);
ALTER TABLE
    `keluarga` ADD CONSTRAINT `keluarga_id_sektor_foreign` FOREIGN KEY(`id_sektor`) REFERENCES `sektor`(`id_sektor`);
ALTER TABLE
    `jemaat` ADD CONSTRAINT `jemaat_id_keluarga_foreign` FOREIGN KEY(`id_keluarga`) REFERENCES `keluarga`(`id_keluarga`);
ALTER TABLE
    `transaksi_keuangan` ADD CONSTRAINT `transaksi_keuangan_id_kategori_foreign` FOREIGN KEY(`id_kategori`) REFERENCES `kategori_keuangan`(`id_kategori`);
ALTER TABLE
    `pernikahan` ADD CONSTRAINT `pernikahan_created_by_foreign` FOREIGN KEY(`created_by`) REFERENCES `users`(`id_user`);
ALTER TABLE
    `master_iuran` ADD CONSTRAINT `master_iuran_updated_by_foreign` FOREIGN KEY(`updated_by`) REFERENCES `users`(`id_user`);
ALTER TABLE
    `transaksi_keuangan` ADD CONSTRAINT `transaksi_keuangan_created_by_foreign` FOREIGN KEY(`created_by`) REFERENCES `users`(`id_user`);
ALTER TABLE
    `iuran_tahunan` ADD CONSTRAINT `iuran_tahunan_id_keluarga_foreign` FOREIGN KEY(`id_keluarga`) REFERENCES `keluarga`(`id_keluarga`);