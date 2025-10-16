-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema hki_kp_2372060
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema hki_kp_2372060
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hki_kp_2372060` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `hki_kp_2372060` ;

-- -----------------------------------------------------
-- Table `hki_kp_2372060`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`users` (
  `id_user` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `nama_lengkap` VARCHAR(255) NULL DEFAULT NULL,
  `role` ENUM('Admin', 'Tata Usaha', 'Bendahara') NOT NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE INDEX (`username`));


-- -----------------------------------------------------
-- Table `hki_kp_2372060`.`sektor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`sektor` (
  `id_sektor` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `nama_sektor` VARCHAR(100) NOT NULL,
  `keterangan` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id_sektor`),
  UNIQUE INDEX (`nama_sektor`));


-- -----------------------------------------------------
-- Table `hki_kp_2372060`.`jemaat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`jemaat` (
  `id_jemaat` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `no_induk` VARCHAR(50) NULL DEFAULT NULL,
  `nama_lengkap` VARCHAR(255) NOT NULL,
  `jenis_kelamin` ENUM('Laki-laki', 'Perempuan') NOT NULL,
  `tempat_lahir` VARCHAR(100) NULL DEFAULT NULL,
  `tanggal_lahir` DATE NULL DEFAULT NULL,
  `no_telepon` VARCHAR(25) NULL DEFAULT NULL,
  `id_keluarga` INT NULL DEFAULT NULL,
  `hubungan_keluarga` ENUM('Kepala Keluarga', 'Istri', 'Anak', 'Lainnya') NULL DEFAULT NULL,
  `status_pernikahan` ENUM('Belum Menikah', 'Menikah', 'Janda/Duda') NULL DEFAULT 'Belum Menikah',
  `status_keanggotaan` ENUM('Aktif', 'Pindah', 'Meninggal', 'Nonaktif') NULL DEFAULT 'Aktif',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_jemaat`),
  UNIQUE INDEX (`no_induk`),
  INDEX (`id_keluarga`),
  CONSTRAINT ``
    FOREIGN KEY (`id_keluarga`)
    REFERENCES `hki_kp_2372060`.`keluarga` (`id_keluarga`)
    ON DELETE SET NULL);


-- -----------------------------------------------------
-- Table `hki_kp_2372060`.`keluarga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`keluarga` (
  `id_keluarga` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `nama_keluarga` VARCHAR(160) NOT NULL,
  `alamat_lengkap` TEXT NULL DEFAULT NULL,
  `id_sektor` INT NULL DEFAULT NULL,
  `id_kepala_keluarga` INT NULL DEFAULT NULL,
  `status_keluarga` ENUM('Aktif', 'Pindah', 'Nonaktif') NULL DEFAULT 'Aktif',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_keluarga`),
  INDEX (`id_sektor`),
  INDEX `fk_kepala_keluarga` (`id_kepala_keluarga`),
  CONSTRAINT ``
    FOREIGN KEY (`id_sektor`)
    REFERENCES `hki_kp_2372060`.`sektor` (`id_sektor`)
    ON DELETE SET NULL,
  CONSTRAINT `fk_kepala_keluarga`
    FOREIGN KEY (`id_kepala_keluarga`)
    REFERENCES `hki_kp_2372060`.`jemaat` (`id_jemaat`)
    ON DELETE SET NULL);


-- -----------------------------------------------------
-- Table `hki_kp_2372060`.`riwayat_keanggotaan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`riwayat_keanggotaan` (
  `id_riwayat` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `id_jemaat` INT NOT NULL,
  `jenis_event` ENUM('Lahir', 'Baptis', 'Sidi', 'Pindah Keluar', 'Pindah Masuk', 'Meninggal') NOT NULL,
  `tanggal_event` DATE NOT NULL,
  `keterangan` TEXT NULL DEFAULT NULL,
  `no_surat` VARCHAR(100) NULL DEFAULT NULL,
  `created_by` INT NULL DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_riwayat`),
  INDEX (`id_jemaat`),
  INDEX (`created_by`),
  CONSTRAINT ``
    FOREIGN KEY (`id_jemaat`)
    REFERENCES `hki_kp_2372060`.`jemaat` (`id_jemaat`)
    ON DELETE ADE,
  CONSTRAINT ``
    FOREIGN KEY (`created_by`)
    REFERENCES `hki_kp_2372060`.`users` (`id_user`)
    ON DELETE SET NULL);


-- -----------------------------------------------------
-- Table `hki_kp_2372060`.`pernikahan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`pernikahan` (
  `id_pernikahan` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `id_jemaat_pria` INT NULL DEFAULT NULL,
  `nama_pasangan_pria_luar` VARCHAR(255) NULL DEFAULT NULL,
  `id_jemaat_wanita` INT NULL DEFAULT NULL,
  `nama_pasangan_wanita_luar` VARCHAR(255) NULL DEFAULT NULL,
  `tanggal_pemberkatan` DATE NOT NULL,
  `tempat_pemberkatan` VARCHAR(255) NULL DEFAULT NULL,
  `nama_pendeta` VARCHAR(255) NULL DEFAULT NULL,
  `no_surat_nikah` VARCHAR(100) NULL DEFAULT NULL,
  `created_by` INT NULL DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pernikahan`),
  INDEX (`id_jemaat_pria`),
  INDEX (`id_jemaat_wanita`),
  INDEX (`created_by`),
  CONSTRAINT ``
    FOREIGN KEY (`id_jemaat_pria`)
    REFERENCES `hki_kp_2372060`.`jemaat` (`id_jemaat`)
    ON DELETE SET NULL,
  CONSTRAINT ``
    FOREIGN KEY (`id_jemaat_wanita`)
    REFERENCES `hki_kp_2372060`.`jemaat` (`id_jemaat`)
    ON DELETE SET NULL,
  CONSTRAINT ``
    FOREIGN KEY (`created_by`)
    REFERENCES `hki_kp_2372060`.`users` (`id_user`)
    ON DELETE SET NULL);


-- -----------------------------------------------------
-- Table `hki_kp_2372060`.`kategori_keuangan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`kategori_keuangan` (
  `id_kategori` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `nama_kategori` VARCHAR(100) NOT NULL,
  `jenis_kategori` ENUM('Pemasukan', 'Pengeluaran') NOT NULL,
  PRIMARY KEY (`id_kategori`));


-- -----------------------------------------------------
-- Table `hki_kp_2372060`.`transaksi_keuangan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hki_kp_2372060`.`transaksi_keuangan` (
  `id_transaksi` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `id_kategori` INT NOT NULL,
  `tanggal_transaksi` DATE NOT NULL,
  `keterangan` TEXT NOT NULL,
  `jumlah` DECIMAL(15,2) NOT NULL,
  `id_jemaat_pemberi` INT NULL DEFAULT NULL,
  `id_keluarga_pemberi` INT NULL DEFAULT NULL,
  `created_by` INT NULL DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_transaksi`),
  INDEX (`id_kategori`),
  INDEX (`id_jemaat_pemberi`),
  INDEX (`id_keluarga_pemberi`),
  INDEX (`created_by`),
  CONSTRAINT ``
    FOREIGN KEY (`id_kategori`)
    REFERENCES `hki_kp_2372060`.`kategori_keuangan` (`id_kategori`),
  CONSTRAINT ``
    FOREIGN KEY (`id_jemaat_pemberi`)
    REFERENCES `hki_kp_2372060`.`jemaat` (`id_jemaat`)
    ON DELETE SET NULL,
  CONSTRAINT ``
    FOREIGN KEY (`id_keluarga_pemberi`)
    REFERENCES `hki_kp_2372060`.`keluarga` (`id_keluarga`)
    ON DELETE SET NULL,
  CONSTRAINT ``
    FOREIGN KEY (`created_by`)
    REFERENCES `hki_kp_2372060`.`users` (`id_user`)
    ON DELETE SET NULL);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
