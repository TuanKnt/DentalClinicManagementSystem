-- =========================================================================
-- DCMS DATABASE SCHEMA MIGRATION: ITERATION 2 (BF-02)
-- Clinical Intake, Dental Examination, Odontogram & Attachments
-- =========================================================================

USE DCMS_DB;
GO

-- 1. Extend Visits table with Operatory (Dental Chair / Room)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Visits') AND name = 'Operatory')
BEGIN
    ALTER TABLE dbo.Visits ADD Operatory NVARCHAR(50) NULL DEFAULT N'Ghế 1 - P.101';
END
GO

-- 2. Pre-treatment Assessment (Vitals & Medical clearance before dental procedures)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PreTreatmentAssessments')
BEGIN
    CREATE TABLE dbo.PreTreatmentAssessments (
        AssessmentId INT IDENTITY(1,1) PRIMARY KEY,
        VisitId INT NOT NULL,
        PatientId INT NOT NULL,
        BloodPressure NVARCHAR(20) NULL,      -- e.g., '120/80'
        PulseRate INT NULL,                   -- e.g., 75 bpm
        BloodSugar DECIMAL(5,2) NULL,         -- mmol/L
        BleedingRisk NVARCHAR(50) NULL DEFAULT N'Bình thường', -- Thấp, Trung bình, Cao
        AnxietyLevel NVARCHAR(50) NULL DEFAULT N'Thấp',       -- Thấp, Vừa, Rất sợ
        MedicalClearance BIT NOT NULL DEFAULT 1,             -- 1 = Đủ điều kiện, 0 = Chờ ý kiến BS chuyên khoa
        Notes NVARCHAR(MAX) NULL,
        RecordedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        CONSTRAINT FK_Assessments_Visits FOREIGN KEY (VisitId) REFERENCES dbo.Visits(VisitId) ON DELETE CASCADE,
        CONSTRAINT FK_Assessments_Patients FOREIGN KEY (PatientId) REFERENCES dbo.Patients(PatientId)
    );
END
GO

-- 3. Tooth Findings (Longitudinal Odontogram data by Tooth & Surface)
-- FDI Two-Digit Notation: 11-18, 21-28, 31-38, 41-48
-- Surface: 'Occlusal', 'Mesial', 'Distal', 'Buccal', 'Lingual', 'WholeTooth'
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ToothFindings')
BEGIN
    CREATE TABLE dbo.ToothFindings (
        FindingId INT IDENTITY(1,1) PRIMARY KEY,
        PatientId INT NOT NULL,
        VisitId INT NOT NULL,
        ToothNumber INT NOT NULL CHECK (ToothNumber BETWEEN 11 AND 48),
        Surface NVARCHAR(20) NOT NULL DEFAULT 'WholeTooth',
        Condition NVARCHAR(50) NOT NULL, -- 'Caries', 'Missing', 'Filled', 'Crown', 'RootCanal', 'Healthy'
        Notes NVARCHAR(255) NULL,
        RecordedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        CONSTRAINT FK_ToothFindings_Patients FOREIGN KEY (PatientId) REFERENCES dbo.Patients(PatientId),
        CONSTRAINT FK_ToothFindings_Visits FOREIGN KEY (VisitId) REFERENCES dbo.Visits(VisitId)
    );

    CREATE NONCLUSTERED INDEX IX_ToothFindings_Patient ON dbo.ToothFindings(PatientId, ToothNumber);
END
GO

-- 4. Clinical Examinations & Diagnoses (BF-02)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ClinicalExaminations')
BEGIN
    CREATE TABLE dbo.ClinicalExaminations (
        ExaminationId INT IDENTITY(1,1) PRIMARY KEY,
        VisitId INT NOT NULL UNIQUE,
        ChiefComplaint NVARCHAR(MAX) NULL,
        ExtraoralExam NVARCHAR(MAX) NULL,
        IntraoralExam NVARCHAR(MAX) NULL,
        ProvisionalDiagnosis NVARCHAR(MAX) NULL,
        FinalDiagnosis NVARCHAR(MAX) NULL,
        ClinicalNotes NVARCHAR(MAX) NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        UpdatedAt DATETIME2 NULL,
        CONSTRAINT FK_Examinations_Visits FOREIGN KEY (VisitId) REFERENCES dbo.Visits(VisitId) ON DELETE CASCADE
    );
END
GO

-- 5. Dental Images & Attachments
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DentalAttachments')
BEGIN
    CREATE TABLE dbo.DentalAttachments (
        AttachmentId INT IDENTITY(1,1) PRIMARY KEY,
        PatientId INT NOT NULL,
        VisitId INT NULL,
        FileName NVARCHAR(255) NOT NULL,
        FileType NVARCHAR(50) NOT NULL, -- 'X-Ray Panorama', 'Periapical', 'IntraoralPhoto', 'Document'
        FilePath NVARCHAR(500) NOT NULL,
        Notes NVARCHAR(255) NULL,
        UploadedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        CONSTRAINT FK_Attachments_Patients FOREIGN KEY (PatientId) REFERENCES dbo.Patients(PatientId),
        CONSTRAINT FK_Attachments_Visits FOREIGN KEY (VisitId) REFERENCES dbo.Visits(VisitId)
    );

    CREATE NONCLUSTERED INDEX IX_Attachments_Patient ON dbo.DentalAttachments(PatientId);
END
GO

-- Seed sample data for Iteration 2 testing
IF NOT EXISTS (SELECT * FROM dbo.Visits WHERE PatientId = 1)
BEGIN
    INSERT INTO dbo.Visits (PatientId, PrimaryDentistId, AppointmentId, Status, VisitType, Notes, Operatory)
    VALUES (1, 3, NULL, 'InProgress', 'WalkIn', N'Đau nhức vùng răng hàm dưới bên phải', N'Ghế 1 - P.101');
END
GO

DECLARE @SampleVisitId INT;
SELECT TOP 1 @SampleVisitId = VisitId FROM dbo.Visits WHERE PatientId = 1;

IF @SampleVisitId IS NOT NULL AND NOT EXISTS (SELECT * FROM dbo.PreTreatmentAssessments WHERE VisitId = @SampleVisitId)
BEGIN
    INSERT INTO dbo.PreTreatmentAssessments (VisitId, PatientId, BloodPressure, PulseRate, BloodSugar, BleedingRisk, AnxietyLevel, MedicalClearance, Notes)
    VALUES (@SampleVisitId, 1, '125/82', 76, 5.4, N'Thấp', N'Vừa', 1, N'Bệnh nhân có tiền sử cao huyết áp, hiện chỉ số ổn định.');
END
GO

IF @SampleVisitId IS NOT NULL AND NOT EXISTS (SELECT * FROM dbo.ClinicalExaminations WHERE VisitId = @SampleVisitId)
BEGIN
    INSERT INTO dbo.ClinicalExaminations (VisitId, ChiefComplaint, ExtraoralExam, IntraoralExam, ProvisionalDiagnosis, FinalDiagnosis, ClinicalNotes)
    VALUES (@SampleVisitId, 
            N'Đau nhức răng 46 khi nhai thức ăn cứng và uống nước lạnh', 
            N'Khuôn mặt cân đối, không sưng hạch góc hàm.', 
            N'Răng 46 lỗ sâu mặt nhai (Occlusal) ngà sâu, gõ dọc ê nhẹ, tủy còn sống.', 
            N'Sâu ngà sâu răng 46 (K02.1)', 
            N'Sâu răng ngà sâu hồi phục răng 46 (K02.1) — Chỉ định trám răng Composite mặt nhai', 
            N'Bệnh nhân đồng ý phương án trám xoang I răng 46.');
END
GO

IF NOT EXISTS (SELECT * FROM dbo.ToothFindings WHERE PatientId = 1)
BEGIN
    INSERT INTO dbo.ToothFindings (PatientId, VisitId, ToothNumber, Surface, Condition, Notes)
    VALUES 
    (1, @SampleVisitId, 46, 'Occlusal', 'Caries', N'Sâu ngà mặt nhai'),
    (1, @SampleVisitId, 36, 'WholeTooth', 'Filled', N'Đã trám Amalgam cũ ổn định'),
    (1, @SampleVisitId, 18, 'WholeTooth', 'Missing', N'Đã nhổ răng khôn');
END
GO

PRINT N'DCMS Database Iteration 2 (BF-02) Schema Migration Completed Successfully!';
GO
