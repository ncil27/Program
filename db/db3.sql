-- =====================================================
-- DATABASE SIMPEL HKI DAME - COMPREHENSIVE VERSION
-- Sistem Informasi Pengelolaan Jemaat & Keuangan Gereja
-- =====================================================

SET NAMES utf8mb4;
SET time_zone = '+07:00';
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- SECTION 1: USER MANAGEMENT & AUTHENTICATION
-- =====================================================

-- Tabel untuk user/admin yang mengakses sistem
CREATE TABLE users (
  id                BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  username          VARCHAR(50) NOT NULL,
  email             VARCHAR(100) NOT NULL,
  password_hash     VARCHAR(255) NOT NULL,
  nama_lengkap      VARCHAR(160) NOT NULL,
  role              ENUM('superadmin','admin','tata_usaha','bendahara','viewer') NOT NULL DEFAULT 'viewer',
  is_active         BOOLEAN NOT NULL DEFAULT TRUE,
  last_login_at     DATETIME NULL,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_users_username (username),
  UNIQUE KEY uk_users_email (email),
  KEY idx_users_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Log aktivitas user (audit trail)
CREATE TABLE user_activity_logs (
  id                BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  user_id           BIGINT UNSIGNED NOT NULL,
  action            VARCHAR(100) NOT NULL,  -- 'login', 'create_jemaat', 'update_keuangan', dll
  table_affected    VARCHAR(50) NULL,
  record_id         BIGINT UNSIGNED NULL,
  old_value         TEXT NULL,              -- JSON format
  new_value         TEXT NULL,              -- JSON format
  ip_address        VARCHAR(45) NULL,
  user_agent        VARCHAR(255) NULL,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pengeluaran_diajukan FOREIGN KEY (diajukan_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_pengeluaran_disetujui FOREIGN KEY (disetujui_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_pengeluaran_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_pengeluaran_tanggal (tanggal_pengeluaran),
  KEY idx_pengeluaran_kategori (kategori_keuangan_id),
  KEY idx_pengeluaran_jenis (jenis_pengeluaran),
  KEY idx_pengeluaran_status (status_approval)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 2: DATA MASTER - SEKTOR & WILAYAH
-- =====================================================

-- Tabel Sektor/Wilayah Pelayanan
CREATE TABLE sektor (
  id                BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  kode_sektor       VARCHAR(20) NOT NULL,   -- ex: 'S1', 'S2A', 'WIL-UTARA'
  nama_sektor       VARCHAR(100) NOT NULL,
  deskripsi         TEXT NULL,
  alamat_sektor     VARCHAR(255) NULL,      -- pusat koordinasi sektor
  ketua_sektor_id   BIGINT UNSIGNED NULL,   -- FK ke jemaat (diisi nanti)
  is_active         BOOLEAN NOT NULL DEFAULT TRUE,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_sektor_kode (kode_sektor),
  KEY idx_sektor_nama (nama_sektor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 3: DATA MASTER - KELUARGA
-- =====================================================

CREATE TABLE keluarga (
  id                    BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  no_registrasi         VARCHAR(50) NULL,           -- nomor registrasi keluarga
  nama_keluarga         VARCHAR(160) NOT NULL,      -- "Keluarga Bpk. Antonius / Ibu Maria"
  alamat_lengkap        TEXT NULL,
  rt_rw                 VARCHAR(20) NULL,           -- "RT 05 / RW 02"
  kelurahan             VARCHAR(100) NULL,
  kecamatan             VARCHAR(100) NULL,
  kota                  VARCHAR(100) NULL,
  provinsi              VARCHAR(100) NULL,
  kode_pos              VARCHAR(10) NULL,
  
  sektor_id             BIGINT UNSIGNED NULL,
  kepala_keluarga_id    BIGINT UNSIGNED NULL,       -- FK ke jemaat (diisi nanti)
  
  telepon_rumah         VARCHAR(32) NULL,
  catatan               TEXT NULL,
  status_keluarga       ENUM('aktif','pindah','nonaktif') NOT NULL DEFAULT 'aktif',
  
  created_by            BIGINT UNSIGNED NULL,
  updated_by            BIGINT UNSIGNED NULL,
  created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_keluarga_sektor FOREIGN KEY (sektor_id) 
    REFERENCES sektor(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_keluarga_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_keluarga_updated_by FOREIGN KEY (updated_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_keluarga_no_reg (no_registrasi),
  KEY idx_keluarga_nama (nama_keluarga),
  KEY idx_keluarga_sektor (sektor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 4: DATA MASTER - JEMAAT
-- =====================================================

CREATE TABLE jemaat (
  id                      BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  no_induk                VARCHAR(50) NULL,               -- nomor induk jemaat
  
  -- Data Pribadi
  nama_lengkap            VARCHAR(160) NOT NULL,
  nama_panggilan          VARCHAR(80) NULL,
  marga                   VARCHAR(80) NULL,
  jenis_kelamin           ENUM('L','P') NOT NULL,
  tempat_lahir            VARCHAR(120) NULL,
  tanggal_lahir           DATE NULL,
  nik                     VARCHAR(20) NULL,               -- NIK KTP
  
  -- Kontak
  telepon                 VARCHAR(32) NULL,
  email                   VARCHAR(100) NULL,
  alamat_lengkap          TEXT NULL,                      -- alamat personal (bisa beda dari keluarga)
  
  -- Pendidikan & Pekerjaan
  pendidikan_terakhir     VARCHAR(50) NULL,               -- 'SD','SMP','SMA','D3','S1','S2','S3'
  pekerjaan               VARCHAR(100) NULL,
  nama_perusahaan         VARCHAR(160) NULL,
  
  -- Relasi Keluarga
  keluarga_id             BIGINT UNSIGNED NULL,
  hubungan_keluarga       ENUM('kepala','istri','anak','menantu','cucu','orangtua','lainnya') NULL,
  status_perkawinan       ENUM('belum_menikah','menikah','duda','janda') NOT NULL DEFAULT 'belum_menikah',
  
  -- Keanggotaan Gereja
  sektor_id               BIGINT UNSIGNED NULL,
  asal_masuk              ENUM('lahir','pindahan_masuk','konversi','pernikahan') NOT NULL DEFAULT 'lahir',
  tanggal_masuk           DATE NULL,
  gereja_asal             VARCHAR(160) NULL,              -- jika pindahan
  alamat_gereja_asal      TEXT NULL,
  
  status_keanggotaan      ENUM('aktif','pindah_keluar','nonaktif','meninggal') NOT NULL DEFAULT 'aktif',
  tanggal_nonaktif        DATE NULL,
  alasan_nonaktif         TEXT NULL,
  
  -- Status Sakramen
  is_baptis               BOOLEAN NOT NULL DEFAULT FALSE,
  tanggal_baptis          DATE NULL,
  is_sidi                 BOOLEAN NOT NULL DEFAULT FALSE,
  tanggal_sidi            DATE NULL,
  
  -- Pelayanan
  jabatan_gereja          VARCHAR(100) NULL,              -- 'Majelis', 'Pendeta', 'Pengajar SM', dll
  bidang_pelayanan        VARCHAR(100) NULL,
  
  -- Foto & Dokumen
  foto_url                VARCHAR(255) NULL,
  dokumen_ktp_url         VARCHAR(255) NULL,
  dokumen_kk_url          VARCHAR(255) NULL,
  
  -- Catatan
  catatan_khusus          TEXT NULL,                      -- alergi, kondisi kesehatan, dll
  
  -- Audit
  created_by              BIGINT UNSIGNED NULL,
  updated_by              BIGINT UNSIGNED NULL,
  created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_jemaat_keluarga FOREIGN KEY (keluarga_id) 
    REFERENCES keluarga(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_jemaat_sektor FOREIGN KEY (sektor_id) 
    REFERENCES sektor(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_jemaat_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_jemaat_updated_by FOREIGN KEY (updated_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  UNIQUE KEY uk_jemaat_no_induk (no_induk),
  UNIQUE KEY uk_jemaat_nik (nik),
  KEY idx_jemaat_nama (nama_lengkap),
  KEY idx_jemaat_status (status_keanggotaan),
  KEY idx_jemaat_baptis (is_baptis, tanggal_baptis),
  KEY idx_jemaat_sidi (is_sidi, tanggal_sidi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Lengkapi FK kepala_keluarga dan ketua_sektor
ALTER TABLE keluarga
  ADD CONSTRAINT fk_keluarga_kepala FOREIGN KEY (kepala_keluarga_id) 
  REFERENCES jemaat(id) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE sektor
  ADD CONSTRAINT fk_sektor_ketua FOREIGN KEY (ketua_sektor_id) 
  REFERENCES jemaat(id) ON UPDATE CASCADE ON DELETE SET NULL;

-- =====================================================
-- SECTION 5: TRANSAKSI - BAPTIS
-- =====================================================

CREATE TABLE baptis (
  id                    BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  jemaat_id             BIGINT UNSIGNED NOT NULL,
  
  tanggal_baptis        DATE NOT NULL,
  tempat_baptis         VARCHAR(160) NULL,              -- nama gereja
  pendeta_pembaptis     VARCHAR(160) NOT NULL,
  
  jenis_baptis          ENUM('anak','dewasa') NOT NULL,
  
  -- Data Orang Tua (untuk baptis anak)
  nama_ayah             VARCHAR(160) NULL,
  nama_ibu              VARCHAR(160) NULL,
  
  -- Data Saksi (untuk baptis dewasa)
  nama_saksi_1          VARCHAR(160) NULL,
  nama_saksi_2          VARCHAR(160) NULL,
  
  no_surat_baptis       VARCHAR(100) NULL,
  dokumen_surat_url     VARCHAR(255) NULL,
  
  keterangan            TEXT NULL,
  
  created_by            BIGINT UNSIGNED NULL,
  created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_baptis_jemaat FOREIGN KEY (jemaat_id) 
    REFERENCES jemaat(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_baptis_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_baptis_tanggal (tanggal_baptis),
  KEY idx_baptis_jenis (jenis_baptis)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 6: TRANSAKSI - SIDI (KONFIRMASI)
-- =====================================================

CREATE TABLE sidi (
  id                    BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  jemaat_id             BIGINT UNSIGNED NOT NULL,
  
  tanggal_sidi          DATE NOT NULL,
  tempat_sidi           VARCHAR(160) NULL,
  pendeta_teguh_sidi    VARCHAR(160) NOT NULL,
  
  no_surat_sidi         VARCHAR(100) NULL,
  dokumen_surat_url     VARCHAR(255) NULL,
  
  keterangan            TEXT NULL,
  
  created_by            BIGINT UNSIGNED NULL,
  created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_sidi_jemaat FOREIGN KEY (jemaat_id) 
    REFERENCES jemaat(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_sidi_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_sidi_tanggal (tanggal_sidi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 7: TRANSAKSI - MARTUMPOL & PERNIKAHAN
-- =====================================================

CREATE TABLE pernikahan (
  id                        BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  
  -- Data Mempelai Suami
  mempelai_suami_id         BIGINT UNSIGNED NULL,       -- NULL jika non-jemaat
  mempelai_suami_nama       VARCHAR(160) NOT NULL,      -- wajib diisi (dari jemaat atau input manual)
  mempelai_suami_tempat_lahir VARCHAR(120) NULL,
  mempelai_suami_tgl_lahir  DATE NULL,
  mempelai_suami_alamat     TEXT NULL,
  
  -- Data Mempelai Istri
  mempelai_istri_id         BIGINT UNSIGNED NULL,
  mempelai_istri_nama       VARCHAR(160) NOT NULL,
  mempelai_istri_tempat_lahir VARCHAR(120) NULL,
  mempelai_istri_tgl_lahir  DATE NULL,
  mempelai_istri_alamat     TEXT NULL,
  
  -- Data Martumpol (Lamaran Adat Batak)
  tanggal_martumpol         DATE NULL,
  tempat_martumpol          VARCHAR(160) NULL,
  alamat_martumpol          TEXT NULL,
  
  -- Data Pemberkatan Nikah
  tanggal_pemberkatan       DATE NULL,
  tempat_pemberkatan        VARCHAR(160) NULL,
  pendeta_pemberkatan       VARCHAR(160) NULL,
  
  -- Data Pencatatan Sipil
  tanggal_nikah_sipil       DATE NULL,
  no_akta_nikah             VARCHAR(100) NULL,
  
  -- Keluarga Baru
  keluarga_baru_id          BIGINT UNSIGNED NULL,       -- FK ke keluarga yang terbentuk
  
  -- Saksi
  nama_saksi_1              VARCHAR(160) NULL,
  nama_saksi_2              VARCHAR(160) NULL,
  
  no_surat_nikah            VARCHAR(100) NULL,
  dokumen_surat_url         VARCHAR(255) NULL,
  foto_pernikahan_url       VARCHAR(255) NULL,
  
  keterangan                TEXT NULL,
  
  created_by                BIGINT UNSIGNED NULL,
  created_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_nikah_suami FOREIGN KEY (mempelai_suami_id) 
    REFERENCES jemaat(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_nikah_istri FOREIGN KEY (mempelai_istri_id) 
    REFERENCES jemaat(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_nikah_keluarga_baru FOREIGN KEY (keluarga_baru_id) 
    REFERENCES keluarga(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_nikah_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_nikah_tgl_martumpol (tanggal_martumpol),
  KEY idx_nikah_tgl_pemberkatan (tanggal_pemberkatan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 8: TRANSAKSI - JEMAAT PINDAH
-- =====================================================

CREATE TABLE jemaat_pindah (
  id                        BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  jemaat_id                 BIGINT UNSIGNED NOT NULL,
  
  jenis_perpindahan         ENUM('pindah_keluar','pindah_masuk') NOT NULL,
  tanggal_pindah            DATE NOT NULL,
  
  -- Data Gereja Tujuan/Asal
  nama_gereja               VARCHAR(160) NOT NULL,
  denominasi                VARCHAR(100) NULL,          -- 'HKBP','GKI','GPIB', dll
  alamat_gereja             TEXT NULL,
  kota_gereja               VARCHAR(100) NULL,
  provinsi_gereja           VARCHAR(100) NULL,
  
  -- Data Surat
  no_surat_pindah           VARCHAR(100) NULL,
  dokumen_surat_url         VARCHAR(255) NULL,
  
  alasan_pindah             TEXT NULL,                  -- pekerjaan, kuliah, ikut keluarga, dll
  keterangan                TEXT NULL,
  
  created_by                BIGINT UNSIGNED NULL,
  created_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_pindah_jemaat FOREIGN KEY (jemaat_id) 
    REFERENCES jemaat(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_pindah_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_pindah_jenis (jenis_perpindahan, tanggal_pindah),
  KEY idx_pindah_tanggal (tanggal_pindah)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 9: TRANSAKSI - JEMAAT MENINGGAL
-- =====================================================

CREATE TABLE jemaat_meninggal (
  id                        BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  jemaat_id                 BIGINT UNSIGNED NOT NULL,
  
  tanggal_meninggal         DATE NOT NULL,
  waktu_meninggal           TIME NULL,
  tempat_meninggal          VARCHAR(160) NULL,          -- rumah, RS, dll
  penyebab_kematian         TEXT NULL,
  
  -- Data Pemakaman
  tanggal_pemakaman         DATE NULL,
  tempat_pemakaman          VARCHAR(160) NULL,          -- nama pemakaman
  alamat_pemakaman          TEXT NULL,
  blok_makam                VARCHAR(50) NULL,
  
  pendeta_pemakaman         VARCHAR(160) NULL,
  
  -- Dokumen
  no_surat_kematian         VARCHAR(100) NULL,
  dokumen_surat_url         VARCHAR(255) NULL,
  
  keterangan                TEXT NULL,
  
  created_by                BIGINT UNSIGNED NULL,
  created_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_meninggal_jemaat FOREIGN KEY (jemaat_id) 
    REFERENCES jemaat(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_meninggal_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_meninggal_tanggal (tanggal_meninggal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 10: KEUANGAN - KATEGORI & AKUN
-- =====================================================

-- Master Kategori Transaksi Keuangan
CREATE TABLE kategori_keuangan (
  id                    BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  kode_kategori         VARCHAR(20) NOT NULL,
  nama_kategori         VARCHAR(100) NOT NULL,
  jenis                 ENUM('pemasukan','pengeluaran') NOT NULL,
  deskripsi             TEXT NULL,
  is_active             BOOLEAN NOT NULL DEFAULT TRUE,
  parent_id             BIGINT UNSIGNED NULL,           -- untuk sub-kategori
  
  created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_kategori_parent FOREIGN KEY (parent_id) 
    REFERENCES kategori_keuangan(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  UNIQUE KEY uk_kategori_kode (kode_kategori),
  KEY idx_kategori_jenis (jenis)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Master Akun Bank/Kas
CREATE TABLE akun_bank (
  id                    BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nama_akun             VARCHAR(100) NOT NULL,          -- 'Kas Utama', 'BCA - Gereja', dll
  jenis_akun            ENUM('kas','bank','tabungan') NOT NULL,
  
  nama_bank             VARCHAR(100) NULL,              -- 'BCA', 'Mandiri', dll
  no_rekening           VARCHAR(50) NULL,
  atas_nama             VARCHAR(160) NULL,
  
  saldo_awal            DECIMAL(15,2) NOT NULL DEFAULT 0,
  saldo_saat_ini        DECIMAL(15,2) NOT NULL DEFAULT 0,
  tanggal_buka          DATE NULL,
  
  is_active             BOOLEAN NOT NULL DEFAULT TRUE,
  keterangan            TEXT NULL,
  
  created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  KEY idx_akun_jenis (jenis_akun),
  KEY idx_akun_nama (nama_akun)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 11: KEUANGAN - PERSEMBAHAN
-- =====================================================

-- Header Persembahan per Ibadah/Event
CREATE TABLE persembahan_header (
  id                        BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  
  tanggal_ibadah            DATE NOT NULL,
  jenis_ibadah              VARCHAR(100) NOT NULL,      -- 'Minggu Pagi', 'Minggu Sore', 'Kamis', 'Natal', dll
  waktu_ibadah              TIME NULL,
  
  jumlah_jemaat_hadir       INT NULL,                   -- jumlah yang hadir
  
  total_persembahan_rutin   DECIMAL(15,2) NOT NULL DEFAULT 0,
  total_syukur_umum         DECIMAL(15,2) NOT NULL DEFAULT 0,
  total_syukur_khusus       DECIMAL(15,2) NOT NULL DEFAULT 0,
  total_lainnya             DECIMAL(15,2) NOT NULL DEFAULT 0,
  grand_total               DECIMAL(15,2) NOT NULL DEFAULT 0,
  
  pencatat                  VARCHAR(160) NULL,          -- nama pencatat
  penghitung_1              VARCHAR(160) NULL,
  penghitung_2              VARCHAR(160) NULL,
  
  keterangan                TEXT NULL,
  status                    ENUM('draft','final','disetujui') NOT NULL DEFAULT 'draft',
  
  created_by                BIGINT UNSIGNED NULL,
  approved_by               BIGINT UNSIGNED NULL,
  approved_at               DATETIME NULL,
  created_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_persembahan_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_persembahan_approved_by FOREIGN KEY (approved_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_persembahan_tanggal (tanggal_ibadah),
  KEY idx_persembahan_jenis (jenis_ibadah, tanggal_ibadah)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Detail Persembahan (breakdown per jenis)
CREATE TABLE persembahan_detail (
  id                        BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  persembahan_header_id     BIGINT UNSIGNED NOT NULL,
  
  jenis_persembahan         ENUM('rutin','syukur_umum','syukur_khusus','lainnya') NOT NULL,
  kategori_keuangan_id      BIGINT UNSIGNED NULL,       -- FK ke kategori
  
  deskripsi                 VARCHAR(255) NULL,          -- keterangan detail
  jemaat_id                 BIGINT UNSIGNED NULL,       -- jika diketahui siapa yang memberi
  nama_pemberi              VARCHAR(160) NULL,          -- jika jemaat_id NULL
  
  jumlah                    DECIMAL(15,2) NOT NULL,
  
  created_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_detail_header FOREIGN KEY (persembahan_header_id) 
    REFERENCES persembahan_header(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_detail_kategori FOREIGN KEY (kategori_keuangan_id) 
    REFERENCES kategori_keuangan(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_detail_jemaat FOREIGN KEY (jemaat_id) 
    REFERENCES jemaat(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_detail_header (persembahan_header_id),
  KEY idx_detail_jenis (jenis_persembahan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 12: KEUANGAN - PENGELUARAN
-- =====================================================

CREATE TABLE pengeluaran (
  id                        BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  
  tanggal_pengeluaran       DATE NOT NULL,
  no_bukti                  VARCHAR(100) NULL,          -- nomor kwitansi/nota
  
  kategori_keuangan_id      BIGINT UNSIGNED NOT NULL,
  jenis_pengeluaran         ENUM('rutin','non_rutin') NOT NULL,
  
  deskripsi                 TEXT NOT NULL,
  penerima                  VARCHAR(160) NULL,          -- nama yang menerima uang
  
  jumlah                    DECIMAL(15,2) NOT NULL,
  akun_bank_id              BIGINT UNSIGNED NULL,       -- akun yang digunakan
  
  -- Approval
  status_approval           ENUM('draft','diajukan','disetujui','ditolak') NOT NULL DEFAULT 'draft',
  diajukan_by               BIGINT UNSIGNED NULL,
  disetujui_by              BIGINT UNSIGNED NULL,
  tanggal_approval          DATETIME NULL,
  catatan_approval          TEXT NULL,
  
  -- Dokumen
  dokumen_bukti_url         VARCHAR(255) NULL,
  
  keterangan                TEXT NULL,
  
  created_by                BIGINT UNSIGNED NULL,
  created_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_pengeluaran_kategori FOREIGN KEY (kategori_keuangan_id) 
    REFERENCES kategori_keuangan(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pengeluaran_akun FOREIGN KEY (akun_bank_id) 
    REFERENCES akun_bank(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_pengeluaran_diajukan FOREIGN KEY (diajukan_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_pengeluaran_disetujui FOREIGN KEY (disetujui_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_pengeluaran_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_pengeluaran_tanggal (tanggal_pengeluaran),
  KEY idx_pengeluaran_jenis (jenis_pengeluaran),
  KEY idx_pengeluaran_status (status_approval),
  KEY idx_pengeluaran_kategori (kategori_keuangan_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 13: KEUANGAN - JURNAL UMUM
-- =====================================================

-- Jurnal untuk tracking semua transaksi keuangan
CREATE TABLE jurnal_keuangan (
  id                        BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  
  tanggal_transaksi         DATE NOT NULL,
  no_jurnal                 VARCHAR(100) NULL,          -- auto-generated
  
  jenis_transaksi           ENUM('persembahan','pengeluaran','transfer','penyesuaian') NOT NULL,
  referensi_table           VARCHAR(50) NULL,           -- 'persembahan_header', 'pengeluaran', dll
  referensi_id              BIGINT UNSIGNED NULL,
  
  akun_bank_id              BIGINT UNSIGNED NULL,
  kategori_keuangan_id      BIGINT UNSIGNED NULL,
  
  debit                     DECIMAL(15,2) NOT NULL DEFAULT 0,
  kredit                    DECIMAL(15,2) NOT NULL DEFAULT 0,
  saldo_akhir               DECIMAL(15,2) NOT NULL DEFAULT 0,
  
  deskripsi                 TEXT NULL,
  
  created_by                BIGINT UNSIGNED NULL,
  created_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_jurnal_akun FOREIGN KEY (akun_bank_id) 
    REFERENCES akun_bank(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_jurnal_kategori FOREIGN KEY (kategori_keuangan_id) 
    REFERENCES kategori_keuangan(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_jurnal_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_jurnal_tanggal (tanggal_transaksi),
  KEY idx_jurnal_jenis (jenis_transaksi),
  KEY idx_jurnal_akun (akun_bank_id, tanggal_transaksi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 14: LAPORAN & REKAPITULASI
-- =====================================================

-- Rekapitulasi Keuangan per Periode
CREATE TABLE rekapitulasi_keuangan (
  id                        BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  
  periode_bulan             TINYINT NOT NULL,           -- 1-12
  periode_tahun             YEAR NOT NULL,
  
  total_pemasukan           DECIMAL(15,2) NOT NULL DEFAULT 0,
  total_pengeluaran         DECIMAL(15,2) NOT NULL DEFAULT 0,
  saldo_awal                DECIMAL(15,2) NOT NULL DEFAULT 0,
  saldo_akhir               DECIMAL(15,2) NOT NULL DEFAULT 0,
  
  status                    ENUM('draft','final','approved') NOT NULL DEFAULT 'draft',
  
  created_by                BIGINT UNSIGNED NULL,
  approved_by               BIGINT UNSIGNED NULL,
  approved_at               DATETIME NULL,
  created_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_rekap_created_by FOREIGN KEY (created_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_rekap_approved_by FOREIGN KEY (approved_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  UNIQUE KEY uk_rekap_periode (periode_tahun, periode_bulan),
  KEY idx_rekap_tahun (periode_tahun, periode_bulan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 15: RIWAYAT PERUBAHAN DATA (CHANGELOG)
-- =====================================================

-- Untuk tracking semua perubahan data penting
CREATE TABLE data_changelog (
  id                    BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  
  table_name            VARCHAR(50) NOT NULL,
  record_id             BIGINT UNSIGNED NOT NULL,
  field_name            VARCHAR(50) NOT NULL,
  
  old_value             TEXT NULL,
  new_value             TEXT NULL,
  
  changed_by            BIGINT UNSIGNED NULL,
  changed_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_changelog_user FOREIGN KEY (changed_by) 
    REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
    
  KEY idx_changelog_table (table_name, record_id),
  KEY idx_changelog_date (changed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- SECTION 16: STATISTIK & DASHBOARD
-- =====================================================

-- View untuk statistik jemaat
CREATE VIEW view_statistik_jemaat AS
SELECT 
  s.id AS sektor_id,
  s.nama_sektor,
  COUNT(DISTINCT j.id) AS total_jemaat,
  COUNT(DISTINCT CASE WHEN j.status_keanggotaan = 'aktif' THEN j.id END) AS jemaat_aktif,
  COUNT(DISTINCT CASE WHEN j.jenis_kelamin = 'L' THEN j.id END) AS jemaat_laki,
  COUNT(DISTINCT CASE WHEN j.jenis_kelamin = 'P' THEN j.id END) AS jemaat_perempuan,
  COUNT(DISTINCT CASE WHEN j.is_baptis = TRUE THEN j.id END) AS sudah_baptis,
  COUNT(DISTINCT CASE WHEN j.is_sidi = TRUE THEN j.id END) AS sudah_sidi,
  COUNT(DISTINCT k.id) AS total_keluarga
FROM sektor s
LEFT JOIN jemaat j ON s.id = j.sektor_id
LEFT JOIN keluarga k ON s.id = k.sektor_id
GROUP BY s.id, s.nama_sektor;

-- View untuk ringkasan keuangan bulanan
CREATE VIEW view_ringkasan_keuangan_bulanan AS
SELECT 
  YEAR(tanggal_ibadah) AS tahun,
  MONTH(tanggal_ibadah) AS bulan,
  SUM(grand_total) AS total_persembahan,
  COUNT(*) AS jumlah_ibadah,
  AVG(grand_total) AS rata_rata_per_ibadah
FROM persembahan_header
WHERE status = 'final' OR status = 'disetujui'
GROUP BY YEAR(tanggal_ibadah), MONTH(tanggal_ibadah);

-- =====================================================
-- SECTION 17: DATA AWAL (SEED DATA)
-- =====================================================

-- Insert default user admin
INSERT INTO users (username, email, password_hash, nama_lengkap, role) 
VALUES 
('admin', 'admin@hkidame.org', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrator', 'superadmin'),
('tata_usaha', 'tu@hkidame.org', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tata Usaha', 'tata_usaha'),
('bendahara', 'bendahara@hkidame.org', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Bendahara', 'bendahara');

-- Insert default sektor
INSERT INTO sektor (kode_sektor, nama_sektor, deskripsi) 
VALUES 
('S1', 'Sektor 1', 'Wilayah Jakarta Utara'),
('S2', 'Sektor 2', 'Wilayah Jakarta Selatan'),
('S3', 'Sektor 3', 'Wilayah Jakarta Barat');

-- Insert kategori keuangan default
INSERT INTO kategori_keuangan (kode_kategori, nama_kategori, jenis, deskripsi) 
VALUES 
-- Pemasukan
('PM-001', 'Persembahan Rutin', 'pemasukan', 'Persembahan kolekte ibadah mingguan'),
('PM-002', 'Ucapan Syukur Umum', 'pemasukan', 'Syukur umum dari jemaat'),
('PM-003', 'Ucapan Syukur Khusus', 'pemasukan', 'Syukur atas peristiwa khusus (nikah, baptis, dll)'),
('PM-004', 'Persembahan Natal', 'pemasukan', 'Persembahan khusus Natal'),
('PM-005', 'Persembahan Paskah', 'pemasukan', 'Persembahan khusus Paskah'),

-- Pengeluaran Rutin
('PK-001', 'Gaji Pendeta', 'pengeluaran', 'Gaji bulanan pendeta'),
('PK-002', 'Gaji Pegawai', 'pengeluaran', 'Gaji pegawai gereja (organis, kebersihan, dll)'),
('PK-003', 'Listrik', 'pengeluaran', 'Biaya listrik bulanan'),
('PK-004', 'Air', 'pengeluaran', 'Biaya air bulanan'),
('PK-005', 'Telepon & Internet', 'pengeluaran', 'Biaya komunikasi'),
('PK-006', 'Kebersihan', 'pengeluaran', 'Perlengkapan kebersihan'),
('PK-007', 'ATK', 'pengeluaran', 'Alat tulis kantor'),

-- Pengeluaran Non-Rutin
('PK-101', 'Renovasi Gedung', 'pengeluaran', 'Perbaikan/renovasi gedung gereja'),
('PK-102', 'Peralatan Ibadah', 'pengeluaran', 'Pembelian alat musik, sound system, dll'),
('PK-103', 'Kegiatan Khusus', 'pengeluaran', 'Biaya retreat, seminar, dll'),
('PK-104', 'Pelayanan Sosial', 'pengeluaran', 'Bantuan sosial kepada jemaat'),
('PK-105', 'Beasiswa', 'pengeluaran', 'Bantuan pendidikan');

-- Insert akun bank default
INSERT INTO akun_bank (nama_akun, jenis_akun, saldo_awal, saldo_saat_ini, tanggal_buka) 
VALUES 
('Kas Utama', 'kas', 0, 0, CURDATE()),
('Bank BCA - Gereja HKI DAME', 'bank', 0, 0, CURDATE()),
('Tabungan Pembangunan', 'tabungan', 0, 0, CURDATE());

-- =====================================================
-- INDEXES TAMBAHAN UNTUK PERFORMA
-- =====================================================

ALTER TABLE persembahan_detail ADD INDEX idx_detail_jemaat (jemaat_id);
ALTER TABLE pengeluaran ADD INDEX idx_pengeluaran_penerima (penerima);
ALTER TABLE jemaat ADD INDEX idx_jemaat_email (email);
ALTER TABLE jemaat ADD INDEX idx_jemaat_keluarga_status (keluarga_id, status_keanggotaan);

-- =====================================================
-- TRIGGERS UNTUK AUTOMASI
-- =====================================================

-- Trigger update saldo akun bank saat ada persembahan
DELIMITER //
CREATE TRIGGER after_persembahan_approved
AFTER UPDATE ON persembahan_header
FOR EACH ROW
BEGIN
  IF NEW.status = 'disetujui' AND OLD.status != 'disetujui' THEN
    -- Tambahkan ke kas utama (assuming akun_id = 1)
    UPDATE akun_bank 
    SET saldo_saat_ini = saldo_saat_ini + NEW.grand_total
    WHERE id = 1;
    
    -- Insert ke jurnal
    INSERT INTO jurnal_keuangan (
      tanggal_transaksi, jenis_transaksi, 
      referensi_table, referensi_id,
      akun_bank_id, debit, saldo_akhir, 
      deskripsi, created_by
    ) VALUES (
      NEW.tanggal_ibadah, 'persembahan',
      'persembahan_header', NEW.id,
      1, NEW.grand_total, 
      (SELECT saldo_saat_ini FROM akun_bank WHERE id = 1),
      CONCAT('Persembahan ', NEW.jenis_ibadah, ' - ', DATE_FORMAT(NEW.tanggal_ibadah, '%d/%m/%Y')),
      NEW.approved_by
    );
  END IF;
END//

-- Trigger update saldo akun bank saat ada pengeluaran disetujui
CREATE TRIGGER after_pengeluaran_approved
AFTER UPDATE ON pengeluaran
FOR EACH ROW
BEGIN
  IF NEW.status_approval = 'disetujui' AND OLD.status_approval != 'disetujui' THEN
    -- Kurangi dari akun yang dipilih
    IF NEW.akun_bank_id IS NOT NULL THEN
      UPDATE akun_bank 
      SET saldo_saat_ini = saldo_saat_ini - NEW.jumlah
      WHERE id = NEW.akun_bank_id;
      
      -- Insert ke jurnal
      INSERT INTO jurnal_keuangan (
        tanggal_transaksi, jenis_transaksi,
        referensi_table, referensi_id,
        akun_bank_id, kredit, saldo_akhir,
        deskripsi, created_by
      ) VALUES (
        NEW.tanggal_pengeluaran, 'pengeluaran',
        'pengeluaran', NEW.id,
        NEW.akun_bank_id, NEW.jumlah,
        (SELECT saldo_saat_ini FROM akun_bank WHERE id = NEW.akun_bank_id),
        NEW.deskripsi,
        NEW.disetujui_by
      );
    END IF;
  END IF;
END//

-- Trigger update status jemaat saat baptis
CREATE TRIGGER after_insert_baptis
AFTER INSERT ON baptis
FOR EACH ROW
BEGIN
  UPDATE jemaat 
  SET is_baptis = TRUE, tanggal_baptis = NEW.tanggal_baptis
  WHERE id = NEW.jemaat_id;
END//

-- Trigger update status jemaat saat sidi
CREATE TRIGGER after_insert_sidi
AFTER INSERT ON sidi
FOR EACH ROW
BEGIN
  UPDATE jemaat 
  SET is_sidi = TRUE, tanggal_sidi = NEW.tanggal_sidi
  WHERE id = NEW.jemaat_id;
END//

-- Trigger update status jemaat saat meninggal
CREATE TRIGGER after_insert_meninggal
AFTER INSERT ON jemaat_meninggal
FOR EACH ROW
BEGIN
  UPDATE jemaat 
  SET status_keanggotaan = 'meninggal',
      tanggal_nonaktif = NEW.tanggal_meninggal,
      status_updated_at = NOW()
  WHERE id = NEW.jemaat_id;
END//

-- Trigger update status jemaat saat pindah keluar
CREATE TRIGGER after_insert_pindah_keluar
AFTER INSERT ON jemaat_pindah
FOR EACH ROW
BEGIN
  IF NEW.jenis_perpindahan = 'pindah_keluar' THEN
    UPDATE jemaat 
    SET status_keanggotaan = 'pindah_keluar',
        tanggal_nonaktif = NEW.tanggal_pindah,
        status_updated_at = NOW()
    WHERE id = NEW.jemaat_id;
  END IF;
END//

DELIMITER ;

-- =====================================================
-- STORED PROCEDURES UNTUK FUNGSI KOMPLEKS
-- =====================================================

DELIMITER //

-- Procedure untuk mendapatkan statistik jemaat per sektor
CREATE PROCEDURE sp_get_statistik_sektor(IN p_sektor_id BIGINT UNSIGNED)
BEGIN
  SELECT 
    COUNT(*) AS total_jemaat,
    SUM(CASE WHEN jenis_kelamin = 'L' THEN 1 ELSE 0 END) AS laki_laki,
    SUM(CASE WHEN jenis_kelamin = 'P' THEN 1 ELSE 0 END) AS perempuan,
    SUM(CASE WHEN is_baptis = TRUE THEN 1 ELSE 0 END) AS sudah_baptis,
    SUM(CASE WHEN is_sidi = TRUE THEN 1 ELSE 0 END) AS sudah_sidi,
    SUM(CASE WHEN status_keanggotaan = 'aktif' THEN 1 ELSE 0 END) AS aktif,
    SUM(CASE WHEN YEAR(CURDATE()) - YEAR(tanggal_lahir) < 18 THEN 1 ELSE 0 END) AS anak_anak,
    SUM(CASE WHEN YEAR(CURDATE()) - YEAR(tanggal_lahir) >= 60 THEN 1 ELSE 0 END) AS lansia
  FROM jemaat
  WHERE sektor_id = p_sektor_id OR p_sektor_id IS NULL;
END//

-- Procedure untuk laporan keuangan per periode
CREATE PROCEDURE sp_laporan_keuangan(
  IN p_tahun INT,
  IN p_bulan INT
)
BEGIN
  SELECT 
    'Pemasukan' AS kategori,
    kk.nama_kategori,
    SUM(pd.jumlah) AS total
  FROM persembahan_detail pd
  JOIN persembahan_header ph ON pd.persembahan_header_id = ph.id
  LEFT JOIN kategori_keuangan kk ON pd.kategori_keuangan_id = kk.id
  WHERE YEAR(ph.tanggal_ibadah) = p_tahun 
    AND MONTH(ph.tanggal_ibadah) = p_bulan
    AND ph.status IN ('final', 'disetujui')
  GROUP BY kk.nama_kategori
  
  UNION ALL
  
  SELECT 
    'Pengeluaran' AS kategori,
    kk.nama_kategori,
    SUM(p.jumlah) AS total
  FROM pengeluaran p
  JOIN kategori_keuangan kk ON p.kategori_keuangan_id = kk.id
  WHERE YEAR(p.tanggal_pengeluaran) = p_tahun 
    AND MONTH(p.tanggal_pengeluaran) = p_bulan
    AND p.status_approval = 'disetujui'
  GROUP BY kk.nama_kategori;
END//

DELIMITER ;

-- =====================================================
-- ENABLE FOREIGN KEY CHECKS
-- =====================================================

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- CATATAN PENGGUNAAN:
-- 1. Password default untuk semua user: "password"
--    Hash: $2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi
-- 2. Setelah import, wajib ganti password!
-- 3. Backup database secara berkala
-- 4. Monitor performa query dengan EXPLAIN
-- =====================================================log_user FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  KEY idx_log_user (user_id, created_at),
  KEY idx_log_action (action, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

