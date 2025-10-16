-- 0) MODE UMUM
SET NAMES utf8mb4;
SET time_zone = '+07:00';

-- 1) Tabel referensi Sektor
CREATE TABLE sektor (
  id            BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nama          VARCHAR(100) NOT NULL,
  deskripsi     VARCHAR(255) NULL,
  UNIQUE KEY uk_sektor_nama (nama)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2) Tabel Keluarga
-- catatan: FK kepala_keluarga_id ditambahkan SESUDAH tabel jemaat ada (ALTER di bawah)
CREATE TABLE keluarga (
  id                   BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nama_keluarga        VARCHAR(160) NOT NULL,        -- ex: "Antonius R. Naibaho / br. Panjaitan"
  alamat               VARCHAR(255) NULL,
  sektor_id            BIGINT UNSIGNED NULL,         -- optional, kalau keluarga diikat ke sektor
  kepala_keluarga_id   BIGINT UNSIGNED NULL,         -- diisi setelah kepala (jemaat) ada
  created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_keluarga_sektor
    FOREIGN KEY (sektor_id) REFERENCES sektor(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- 3) Tabel Jemaat
CREATE TABLE jemaat (
  id                      BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nama_lengkap            VARCHAR(160) NOT NULL,
  marga                   VARCHAR(80)  NULL,               -- opsional
  jenis_kelamin           ENUM('L','P') NOT NULL,
  tempat_lahir            VARCHAR(120) NULL,
  tanggal_lahir           DATE         NULL,
  telepon                 VARCHAR(32)  NULL,
  alamat                  VARCHAR(255) NULL,

  sektor_id               BIGINT UNSIGNED NULL,            -- sektor per-jemaat (opsional)
  keluarga_id             BIGINT UNSIGNED NULL,            -- FK ke keluarga saat ini
  peran_dalam_keluarga    ENUM('kepala','istri','anak','single') NULL,

  asal_masuk              ENUM('lahir','pindahan','internal','konversi') NOT NULL DEFAULT 'internal',
  tanggal_masuk           DATE NULL,

  status_keanggotaan      ENUM('aktif','pindah_keluar','nonaktif','wafat') NOT NULL DEFAULT 'aktif',
  status_updated_at       DATETIME NULL,
  status_updated_by       VARCHAR(100) NULL,

  created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_jemaat_keluarga
    FOREIGN KEY (keluarga_id) REFERENCES keluarga(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_jemaat_sektor
    FOREIGN KEY (sektor_id) REFERENCES sektor(id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  KEY idx_jemaat_nama (nama_lengkap),
  KEY idx_jemaat_status (status_keanggotaan),
  KEY idx_jemaat_keluarga (keluarga_id),
  KEY idx_jemaat_sektor (sektor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4) Lengkapi FK kepala_keluarga_id (setelah jemaat ada)
ALTER TABLE keluarga
  ADD CONSTRAINT fk_keluarga_kepala
  FOREIGN KEY (kepala_keluarga_id) REFERENCES jemaat(id)
  ON UPDATE CASCADE ON DELETE SET NULL;

-- 5) Tabel Pernikahan (martumpol + pemberkatan)
-- menyimpan meta peristiwa nikah (termasuk pasangan non-jemaat via kolom *_nama)
CREATE TABLE pernikahan (
  id                     BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,

  mempelai_suami_id      BIGINT UNSIGNED NULL,
  mempelai_suami_nama    VARCHAR(160) NULL,   -- jika non-jemaat / belum terdaftar
  mempelai_istri_id      BIGINT UNSIGNED NULL,
  mempelai_istri_nama    VARCHAR(160) NULL,

  tanggal_martumpol      DATE NULL,
  tempat_martumpol       VARCHAR(160) NULL,

  tanggal_pemberkatan    DATE NULL,
  tempat_pemberkatan     VARCHAR(160) NULL,

  keterangan             VARCHAR(255) NULL,
  created_at             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_nikah_suami  FOREIGN KEY (mempelai_suami_id) REFERENCES jemaat(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_nikah_istri  FOREIGN KEY (mempelai_istri_id) REFERENCES jemaat(id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  KEY idx_nikah_tanggal (tanggal_pemberkatan, tanggal_martumpol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6) Tabel Riwayat Keanggotaan (event timeline)
-- Catat semua peristiwa: lahir, baptis, sidi, martumpol, nikah, pindah, wafat,
-- diterima_pindahan, menikah_pisah, dll. from/to_keluarga_id sesuai kesepakatan Opsi A.
CREATE TABLE riwayat_keanggotaan (
  id                 BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  jemaat_id          BIGINT UNSIGNED NOT NULL,
  jenis_event        ENUM(
                       'lahir','baptis','sidi',
                       'martumpol','nikah',
                       'pindah','wafat',
                       'diterima_pindahan','menikah_pisah'
                     ) NOT NULL,
  tanggal            DATE NOT NULL,
  lokasi             VARCHAR(160) NULL,
  catatan            VARCHAR(255) NULL,

  from_keluarga_id   BIGINT UNSIGNED NULL,
  to_keluarga_id     BIGINT UNSIGNED NULL,

  dokumen_url        VARCHAR(255) NULL,  -- opsional lampiran
  created_by         VARCHAR(100) NULL,
  created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_evt_jemaat  FOREIGN KEY (jemaat_id)        REFERENCES jemaat(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_evt_fromkel FOREIGN KEY (from_keluarga_id)  REFERENCES keluarga(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_evt_tokel   FOREIGN KEY (to_keluarga_id)    REFERENCES keluarga(id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  KEY idx_evt_jemaat_tgl (jemaat_id, tanggal),
  KEY idx_evt_fromkel (from_keluarga_id, tanggal),
  KEY idx_evt_tokel (to_keluarga_id, tanggal),
  KEY idx_evt_jenis (jenis_event, tanggal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
