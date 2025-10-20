-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


CREATE SCHEMA IF NOT EXISTS `hki_kp_2372060` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `hki_kp_2372060` ;

CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`cache` (
  `key` VARCHAR(255) NOT NULL,
  `value` MEDIUMTEXT NOT NULL,
  `expiration` INT NOT NULL,
  PRIMARY KEY (`key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`cache_locks` (
  `key` VARCHAR(255) NOT NULL,
  `owner` VARCHAR(255) NOT NULL,
  `expiration` INT NOT NULL,
  PRIMARY KEY (`key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`failed_jobs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` VARCHAR(255) NOT NULL,
  `connection` TEXT NOT NULL,
  `queue` TEXT NOT NULL,
  `payload` LONGTEXT NOT NULL,
  `exception` LONGTEXT NOT NULL,
  `failed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `failed_jobs_uuid_unique` (`uuid` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


--------- ERD YANG AKU BUTUHIN ---------

CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`jemaat` (
  `id_jemaat` INT NOT NULL AUTO_INCREMENT,
  `nik` VARCHAR(50) NULL DEFAULT NULL,
  `nama_lengkap` VARCHAR(255) NOT NULL,
  `jenis_kelamin` ENUM('Laki-laki', 'Perempuan') NOT NULL,
  `tempat_lahir` VARCHAR(100) NULL DEFAULT NULL,
  `tanggal_lahir` DATE NULL DEFAULT NULL,
  `no_telepon` VARCHAR(25) NULL DEFAULT NULL,
  `id_keluarga` INT NULL DEFAULT NULL,
  `pekerjaan` VARCHAR(100) NULL DEFAULT NULL,
  `pendidikan_terakhir` VARCHAR(100) NULL DEFAULT NULL,
  `hubungan_keluarga` ENUM('Kepala Keluarga', 'Istri', 'Anak') NOT NULL,
  `status_pernikahan` ENUM('Belum Menikah', 'Menikah', 'Janda/Duda') NULL DEFAULT NULL,
  `status_keanggotaan` ENUM('Aktif', 'Pindah', 'Meninggal', 'Nonaktif') NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_jemaat`),
  UNIQUE INDEX `jemaat_nik_unique` (`nik` ASC) VISIBLE,
  INDEX `jemaat_id_keluarga_foreign` (`id_keluarga` ASC) VISIBLE,
  CONSTRAINT `jemaat_id_keluarga_foreign`
    FOREIGN KEY (`id_keluarga`)
    REFERENCES `hki_kp_2372060`.`keluarga` (`id_keluarga`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`sektor` (
  `id_sektor` INT NOT NULL AUTO_INCREMENT,
  `nama_sektor` VARCHAR(100) NOT NULL,
  `keterangan` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id_sektor`),
  UNIQUE INDEX `sektor_nama_sektor_unique` (`nama_sektor` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`keluarga` (
  `id_keluarga` INT NOT NULL AUTO_INCREMENT,
  `nama_keluarga` VARCHAR(160) NOT NULL,
  `alamat_lengkap` TEXT NULL DEFAULT NULL,
  `id_sektor` INT NULL DEFAULT NULL,
  `id_kepala_keluarga` INT NULL DEFAULT NULL,
  `status_keluarga` ENUM('Aktif', 'Pindah', 'Nonaktif') NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_keluarga`),
  INDEX `keluarga_id_sektor_foreign` (`id_sektor` ASC) VISIBLE,
  INDEX `keluarga_id_kepala_keluarga_foreign` (`id_kepala_keluarga` ASC) VISIBLE,
  CONSTRAINT `keluarga_id_kepala_keluarga_foreign`
    FOREIGN KEY (`id_kepala_keluarga`)
    REFERENCES `hki_kp_2372060`.`jemaat` (`id_jemaat`),
  CONSTRAINT `keluarga_id_sektor_foreign`
    FOREIGN KEY (`id_sektor`)
    REFERENCES `hki_kp_2372060`.`sektor` (`id_sektor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`iuran_tahunan` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_keluarga` INT NOT NULL,
  `tahun` YEAR NOT NULL,
  `jumlah_terbayar` DECIMAL(15,2) NOT NULL,
  `tanggal_pembayaran_terakhir` DATE NULL DEFAULT NULL,
  `keterangan` TEXT NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `iuran_tahunan_id_keluarga_tahun_unique` (`id_keluarga` ASC, `tahun` ASC) VISIBLE,
  CONSTRAINT `iuran_tahunan_id_keluarga_foreign`
    FOREIGN KEY (`id_keluarga`)
    REFERENCES `hki_kp_2372060`.`keluarga` (`id_keluarga`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`job_batches` (
  `id` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `total_jobs` INT NOT NULL,
  `pending_jobs` INT NOT NULL,
  `failed_jobs` INT NOT NULL,
  `failed_job_ids` LONGTEXT NOT NULL,
  `options` MEDIUMTEXT NULL DEFAULT NULL,
  `cancelled_at` INT NULL DEFAULT NULL,
  `created_at` INT NOT NULL,
  `finished_at` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`jobs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` VARCHAR(255) NOT NULL,
  `payload` LONGTEXT NOT NULL,
  `attempts` TINYINT UNSIGNED NOT NULL,
  `reserved_at` INT UNSIGNED NULL DEFAULT NULL,
  `available_at` INT UNSIGNED NOT NULL,
  `created_at` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `jobs_queue_index` (`queue` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`kategori_keuangan` (
  `id_kategori` INT NOT NULL AUTO_INCREMENT,
  `nama_kategori` VARCHAR(100) NOT NULL,
  `jenis_kategori` ENUM('Pemasukan', 'Pengeluaran') NOT NULL,
  PRIMARY KEY (`id_kategori`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama_lengkap` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `role` ENUM('Admin', 'Tata Usaha') NOT NULL DEFAULT 'Tata Usaha',
  `email` VARCHAR(255) NOT NULL,
  `email_verified_at` TIMESTAMP NULL DEFAULT NULL,
  `password` VARCHAR(255) NOT NULL,
  `remember_token` VARCHAR(100) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `users_username_unique` (`username` ASC) VISIBLE,
  UNIQUE INDEX `users_email_unique` (`email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`master_iuran` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tahun` YEAR NOT NULL,
  `jumlah_patokan_tahunan` DECIMAL(15,2) NOT NULL,
  `keterangan` TEXT NULL DEFAULT NULL,
  `updated_by` INT NULL DEFAULT NULL,
  `created_by` BIGINT UNSIGNED NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `master_iuran_tahun_unique` (`tahun` ASC) VISIBLE,
  INDEX `master_iuran_created_by_foreign` (`created_by` ASC) VISIBLE,
  CONSTRAINT `master_iuran_created_by_foreign`
    FOREIGN KEY (`created_by`)
    REFERENCES `hki_kp_2372060`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`migrations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` VARCHAR(255) NOT NULL,
  `batch` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`password_reset_tokens` (
  `email` VARCHAR(255) NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`email`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`pernikahan` (
  `id_pernikahan` INT NOT NULL AUTO_INCREMENT,
  `id_jemaat_pria` INT NULL DEFAULT NULL,
  `nama_pasangan_pria_luar` VARCHAR(255) NULL DEFAULT NULL,
  `id_jemaat_wanita` INT NULL DEFAULT NULL,
  `nama_pasangan_wanita_luar` VARCHAR(255) NULL DEFAULT NULL,
  `tanggal_martumpol` DATE NOT NULL,
  `tempat_martumpol` VARCHAR(255) NULL DEFAULT NULL,
  `tanggal_pemberkatan` DATE NOT NULL,
  `tempat_pemberkatan` VARCHAR(255) NULL DEFAULT NULL,
  `no_surat_nikah` VARCHAR(100) NULL DEFAULT NULL,
  `created_by` BIGINT UNSIGNED NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pernikahan`),
  INDEX `pernikahan_id_jemaat_pria_foreign` (`id_jemaat_pria` ASC) VISIBLE,
  INDEX `pernikahan_id_jemaat_wanita_foreign` (`id_jemaat_wanita` ASC) VISIBLE,
  INDEX `pernikahan_created_by_foreign` (`created_by` ASC) VISIBLE,
  CONSTRAINT `pernikahan_created_by_foreign`
    FOREIGN KEY (`created_by`)
    REFERENCES `hki_kp_2372060`.`users` (`id`),
  CONSTRAINT `pernikahan_id_jemaat_pria_foreign`
    FOREIGN KEY (`id_jemaat_pria`)
    REFERENCES `hki_kp_2372060`.`jemaat` (`id_jemaat`),
  CONSTRAINT `pernikahan_id_jemaat_wanita_foreign`
    FOREIGN KEY (`id_jemaat_wanita`)
    REFERENCES `hki_kp_2372060`.`jemaat` (`id_jemaat`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`riwayat_keanggotaan` (
  `id_riwayat` INT NOT NULL AUTO_INCREMENT,
  `id_jemaat` INT NOT NULL,
  `jenis_event` ENUM('Lahir', 'Baptis', 'Sidi', 'Pindah Keluar', 'Pindah Masuk', 'Meninggal') NOT NULL,
  `tanggal_event` DATE NOT NULL,
  `keterangan` TEXT NULL DEFAULT NULL,
  `no_surat` VARCHAR(100) NULL DEFAULT NULL,
  `created_by` BIGINT UNSIGNED NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_riwayat`),
  INDEX `riwayat_keanggotaan_id_jemaat_foreign` (`id_jemaat` ASC) VISIBLE,
  INDEX `riwayat_keanggotaan_created_by_foreign` (`created_by` ASC) VISIBLE,
  CONSTRAINT `riwayat_keanggotaan_created_by_foreign`
    FOREIGN KEY (`created_by`)
    REFERENCES `hki_kp_2372060`.`users` (`id`),
  CONSTRAINT `riwayat_keanggotaan_id_jemaat_foreign`
    FOREIGN KEY (`id_jemaat`)
    REFERENCES `hki_kp_2372060`.`jemaat` (`id_jemaat`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`sessions` (
  `id` VARCHAR(255) NOT NULL,
  `user_id` BIGINT UNSIGNED NULL DEFAULT NULL,
  `ip_address` VARCHAR(45) NULL DEFAULT NULL,
  `user_agent` TEXT NULL DEFAULT NULL,
  `payload` LONGTEXT NOT NULL,
  `last_activity` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `sessions_user_id_index` (`user_id` ASC) VISIBLE,
  INDEX `sessions_last_activity_index` (`last_activity` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`transaksi_keuangan` (
  `id_transaksi` INT NOT NULL AUTO_INCREMENT,
  `id_kategori` INT NOT NULL,
  `tanggal_transaksi` DATE NOT NULL,
  `keterangan` TEXT NOT NULL,
  `jumlah` DECIMAL(15,2) NOT NULL,
  `id_keluarga_pemberi` INT NULL DEFAULT NULL,
  `created_by` BIGINT UNSIGNED NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_transaksi`),
  INDEX `transaksi_keuangan_id_kategori_foreign` (`id_kategori` ASC) VISIBLE,
  INDEX `transaksi_keuangan_id_keluarga_pemberi_foreign` (`id_keluarga_pemberi` ASC) VISIBLE,
  INDEX `transaksi_keuangan_created_by_foreign` (`created_by` ASC) VISIBLE,
  CONSTRAINT `transaksi_keuangan_created_by_foreign`
    FOREIGN KEY (`created_by`)
    REFERENCES `hki_kp_2372060`.`users` (`id`),
  CONSTRAINT `transaksi_keuangan_id_kategori_foreign`
    FOREIGN KEY (`id_kategori`)
    REFERENCES `hki_kp_2372060`.`kategori_keuangan` (`id_kategori`),
  CONSTRAINT `transaksi_keuangan_id_keluarga_pemberi_foreign`
    FOREIGN KEY (`id_keluarga_pemberi`)
    REFERENCES `hki_kp_2372060`.`keluarga` (`id_keluarga`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
