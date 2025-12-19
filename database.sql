CREATE DATABASE sirana_db;

-- Connect to database
\c sirana_db;

-- Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('super_admin', 'petugas')),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patients Table
CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    nik VARCHAR(16) UNIQUE NOT NULL,
    jenis_kelamin VARCHAR(10) NOT NULL,
    tempat_lahir VARCHAR(255),
    tanggal_lahir DATE NOT NULL,
    alamat TEXT,
    agama VARCHAR(50),
    pekerjaan VARCHAR(100),
    kelompok_usia VARCHAR(50) NOT NULL,
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Medical Assessments Table
CREATE TABLE medical_assessments (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    tanggal_kunjungan TIMESTAMP NOT NULL,
    jenis_anamnesis VARCHAR(20) CHECK (jenis_anamnesis IN ('auto', 'allo')),
    
    -- Subjektif
    keluhan_utama TEXT,
    riwayat_penyakit_sekarang TEXT,
    riwayat_alergi TEXT,
    riwayat_penyakit_terdahulu TEXT,
    riwayat_penggunaan_obat TEXT,
    
    -- Objektif - GCS
    gcs_eye INTEGER,
    gcs_verbal INTEGER,
    gcs_motorik INTEGER,
    keadaan_umum TEXT,
    
    -- TTV
    tekanan_darah VARCHAR(20),
    suhu DECIMAL(4,1),
    nadi INTEGER,
    respirasi INTEGER,
    berat_badan DECIMAL(5,2),
    tinggi_badan DECIMAL(5,2),
    
    -- Pemeriksaan Fisik
    pemeriksaan_kepala TEXT,
    pemeriksaan_mata TEXT,
    pemeriksaan_mulut TEXT,
    pemeriksaan_leher TEXT,
    pemeriksaan_thorax TEXT,
    pemeriksaan_cor TEXT,
    pemeriksaan_pulmo TEXT,
    pemeriksaan_abdomen TEXT,
    pemeriksaan_ekstremitas TEXT,
    pemeriksaan_anus_genetalia TEXT,
    
    -- Pemeriksaan Penunjang
    pemeriksaan_lab BOOLEAN DEFAULT FALSE,
    pemeriksaan_rontgen BOOLEAN DEFAULT FALSE,
    pemeriksaan_ct_scan BOOLEAN DEFAULT FALSE,
    pemeriksaan_lainnya TEXT,
    
    -- Diagnosa & Penatalaksanaan
    diagnosa_kerja TEXT,
    penatalaksanaan TEXT,
    tindak_lanjut VARCHAR(20) CHECK (tindak_lanjut IN ('pulang', 'rujuk', 'tidak_rujuk')),
    
    -- Komunikasi Informasi Edukasi
    kie_diberikan_kepada VARCHAR(20) CHECK (kie_diberikan_kepada IN ('pasien', 'keluarga')),
    dokter_pemeriksa VARCHAR(255),
    
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Environment Assessment Table
CREATE TABLE environment_assessments (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    akses_air_bersih BOOLEAN,
    sanitasi VARCHAR(20) CHECK (sanitasi IN ('baik', 'buruk')),
    foto_tempat_tinggal TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Needs Identification Table
CREATE TABLE needs_identification (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    obat_obatan TEXT,
    alat_kesehatan TEXT,
    infrastruktur TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_patients_nik ON patients(nik);
CREATE INDEX idx_patients_created_by ON patients(created_by);
CREATE INDEX idx_medical_assessments_patient_id ON medical_assessments(patient_id);
CREATE INDEX idx_medical_assessments_created_by ON medical_assessments(created_by);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, email, password, full_name, role, phone) 
VALUES (
    'admin',
    'admin@sirana.id',
    '$2b$10$rKvWJYfE5h0mXqYqYqYqYO8rKvWJYfE5h0mXqYqYqYqYO8',
    'Super Admin',
    'super_admin',
    '081234567890'
);