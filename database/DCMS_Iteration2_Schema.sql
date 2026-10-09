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
        -- FDI notation is four quadrants, each with teeth 1..8. A plain
        -- BETWEEN 11 AND 48 incorrectly accepts values such as 19 or 29.
        ToothNumber INT NOT NULL CHECK (
            (ToothNumber BETWEEN 11 AND 18) OR
            (ToothNumber BETWEEN 21 AND 28) OR
            (ToothNumber BETWEEN 31 AND 38) OR
            (ToothNumber BETWEEN 41 AND 48)
        ),
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

-- Tighten installations created from an older migration where the check was
-- only BETWEEN 11 AND 48 (which allowed invalid values such as 19).
IF OBJECT_ID('dbo.ToothFindings', 'U') IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_ToothFindings_FDI')
BEGIN
    ALTER TABLE dbo.ToothFindings ADD CONSTRAINT CK_ToothFindings_FDI CHECK (
        (ToothNumber BETWEEN 11 AND 18) OR
        (ToothNumber BETWEEN 21 AND 28) OR
        (ToothNumber BETWEEN 31 AND 38) OR
        (ToothNumber BETWEEN 41 AND 48)
    );
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

-- =========================================================================
-- 6. DENTAL SERVICES CATALOG & PROCEDURE DEFINITIONS (UC40)
-- =========================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DentalServices')
BEGIN
    CREATE TABLE dbo.DentalServices (
        ServiceId INT IDENTITY(1,1) PRIMARY KEY,
        ServiceCode NVARCHAR(50) NOT NULL UNIQUE,
        ServiceName NVARCHAR(255) NOT NULL,
        Category NVARCHAR(100) NOT NULL, -- KhamTongQuat, TramRang, NhoRang, TayTrang, RangSu, Implant, ChinhNha, DieuTriTuy
        Price DECIMAL(18,2) NOT NULL CHECK (Price >= 0),
        Unit NVARCHAR(50) NOT NULL DEFAULT N'Lần',
        Description NVARCHAR(MAX) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        UpdatedAt DATETIME2 NULL
    );

    CREATE NONCLUSTERED INDEX IX_DentalServices_Category ON dbo.DentalServices(Category, IsActive);
END
GO

-- =========================================================================
-- 7. TREATMENT PLANS & MULTI-VISIT ITEMS (UC19, UC20, UC21, UC22, UC23)
-- =========================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TreatmentPlans')
BEGIN
    CREATE TABLE dbo.TreatmentPlans (
        PlanId INT IDENTITY(1,1) PRIMARY KEY,
        PatientId INT NOT NULL,
        DentistId INT NOT NULL,
        Title NVARCHAR(255) NOT NULL,
        Diagnosis NVARCHAR(MAX) NULL,
        Status NVARCHAR(50) NOT NULL DEFAULT 'Draft', -- Draft, Proposed, Accepted, PartiallyAccepted, InProgress, Completed, Declined, Cancelled
        EstimatedCost DECIMAL(18,2) NOT NULL DEFAULT 0,
        TotalDiscount DECIMAL(18,2) NOT NULL DEFAULT 0,
        FinalEstimate DECIMAL(18,2) NOT NULL DEFAULT 0,
        PatientConsentDate DATETIME2 NULL,
        ConsentNotes NVARCHAR(MAX) NULL,
        Notes NVARCHAR(MAX) NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        UpdatedAt DATETIME2 NULL,
        CONSTRAINT FK_TreatmentPlans_Patients FOREIGN KEY (PatientId) REFERENCES dbo.Patients(PatientId),
        CONSTRAINT FK_TreatmentPlans_Dentists FOREIGN KEY (DentistId) REFERENCES dbo.Dentists(DentistId)
    );

    CREATE NONCLUSTERED INDEX IX_TreatmentPlans_Patient ON dbo.TreatmentPlans(PatientId, Status);
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TreatmentPlanItems')
BEGIN
    CREATE TABLE dbo.TreatmentPlanItems (
        ItemId INT IDENTITY(1,1) PRIMARY KEY,
        PlanId INT NOT NULL,
        ServiceId INT NOT NULL,
        ToothNumber INT NULL CHECK (
            ToothNumber IS NULL OR
            (ToothNumber BETWEEN 11 AND 18) OR
            (ToothNumber BETWEEN 21 AND 28) OR
            (ToothNumber BETWEEN 31 AND 38) OR
            (ToothNumber BETWEEN 41 AND 48)
        ),
        Surface NVARCHAR(50) NULL DEFAULT 'WholeTooth',
        Quantity INT NOT NULL DEFAULT 1 CHECK (Quantity > 0),
        UnitPrice DECIMAL(18,2) NOT NULL CHECK (UnitPrice >= 0),
        SubTotal DECIMAL(18,2) NOT NULL CHECK (SubTotal >= 0),
        PriorityOrder INT NOT NULL DEFAULT 1,
        Status NVARCHAR(50) NOT NULL DEFAULT 'Proposed', -- Proposed, Accepted, InProgress, Completed, Deferred, Declined, Cancelled
        Notes NVARCHAR(MAX) NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        CONSTRAINT FK_PlanItems_Plans FOREIGN KEY (PlanId) REFERENCES dbo.TreatmentPlans(PlanId) ON DELETE CASCADE,
        CONSTRAINT FK_PlanItems_Services FOREIGN KEY (ServiceId) REFERENCES dbo.DentalServices(ServiceId)
    );

    CREATE NONCLUSTERED INDEX IX_PlanItems_Plan ON dbo.TreatmentPlanItems(PlanId);
END
GO

-- =========================================================================
-- 8. PROCEDURES PERFORMED & MATERIAL USAGES (UC24, UC25, UC26)
-- =========================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProceduresPerformed')
BEGIN
    CREATE TABLE dbo.ProceduresPerformed (
        ProcedureId INT IDENTITY(1,1) PRIMARY KEY,
        VisitId INT NOT NULL,
        DentistId INT NOT NULL,
        AssistantId INT NULL,
        PlanItemId INT NULL,
        ServiceId INT NOT NULL,
        ToothNumber INT NULL,
        Surface NVARCHAR(50) NULL,
        Quantity INT NOT NULL DEFAULT 1 CHECK (Quantity > 0),
        ActualPrice DECIMAL(18,2) NOT NULL CHECK (ActualPrice >= 0),
        Status NVARCHAR(50) NOT NULL DEFAULT 'Completed', -- InProgress, Completed, Voided
        ClinicalNotes NVARCHAR(MAX) NULL,
        PerformedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        CONSTRAINT FK_Procedures_Visits FOREIGN KEY (VisitId) REFERENCES dbo.Visits(VisitId),
        CONSTRAINT FK_Procedures_Dentists FOREIGN KEY (DentistId) REFERENCES dbo.Dentists(DentistId),
        CONSTRAINT FK_Procedures_PlanItems FOREIGN KEY (PlanItemId) REFERENCES dbo.TreatmentPlanItems(ItemId),
        CONSTRAINT FK_Procedures_Services FOREIGN KEY (ServiceId) REFERENCES dbo.DentalServices(ServiceId)
    );

    CREATE NONCLUSTERED INDEX IX_Procedures_Visit ON dbo.ProceduresPerformed(VisitId);
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'MaterialUsages')
BEGIN
    CREATE TABLE dbo.MaterialUsages (
        UsageId INT IDENTITY(1,1) PRIMARY KEY,
        ProcedureId INT NOT NULL,
        MaterialName NVARCHAR(255) NOT NULL,
        Quantity INT NOT NULL DEFAULT 1 CHECK (Quantity > 0),
        Unit NVARCHAR(50) NOT NULL DEFAULT N'Ống',
        Notes NVARCHAR(255) NULL,
        RecordedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        CONSTRAINT FK_Materials_Procedures FOREIGN KEY (ProcedureId) REFERENCES dbo.ProceduresPerformed(ProcedureId) ON DELETE CASCADE
    );
END
GO

-- =========================================================================
-- 9. MEDICINES & E-PRESCRIPTIONS (UC27, UC28)
-- =========================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Medicines')
BEGIN
    CREATE TABLE dbo.Medicines (
        MedicineId INT IDENTITY(1,1) PRIMARY KEY,
        MedicineCode NVARCHAR(50) NOT NULL UNIQUE,
        MedicineName NVARCHAR(255) NOT NULL,
        ActiveIngredient NVARCHAR(255) NULL,
        DosageForm NVARCHAR(100) NOT NULL DEFAULT N'Viên',
        Unit NVARCHAR(50) NOT NULL DEFAULT N'Viên',
        UnitPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
        UsageInstructions NVARCHAR(500) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Prescriptions')
BEGIN
    CREATE TABLE dbo.Prescriptions (
        PrescriptionId INT IDENTITY(1,1) PRIMARY KEY,
        VisitId INT NOT NULL,
        PatientId INT NOT NULL,
        DentistId INT NOT NULL,
        PrescriptionCode NVARCHAR(50) NOT NULL UNIQUE,
        Diagnosis NVARCHAR(MAX) NULL,
        Advice NVARCHAR(MAX) NULL,
        Status NVARCHAR(50) NOT NULL DEFAULT 'Issued', -- Draft, Issued, Cancelled
        IssuedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        CONSTRAINT FK_Prescriptions_Visits FOREIGN KEY (VisitId) REFERENCES dbo.Visits(VisitId),
        CONSTRAINT FK_Prescriptions_Patients FOREIGN KEY (PatientId) REFERENCES dbo.Patients(PatientId),
        CONSTRAINT FK_Prescriptions_Dentists FOREIGN KEY (DentistId) REFERENCES dbo.Dentists(DentistId)
    );

    CREATE NONCLUSTERED INDEX IX_Prescriptions_Visit ON dbo.Prescriptions(VisitId);
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PrescriptionDetails')
BEGIN
    CREATE TABLE dbo.PrescriptionDetails (
        DetailId INT IDENTITY(1,1) PRIMARY KEY,
        PrescriptionId INT NOT NULL,
        MedicineId INT NOT NULL,
        Quantity INT NOT NULL CHECK (Quantity > 0),
        Dosage NVARCHAR(255) NOT NULL,
        DurationDays INT NOT NULL DEFAULT 5,
        Notes NVARCHAR(255) NULL,
        CONSTRAINT FK_PrescriptionDetails_Prescriptions FOREIGN KEY (PrescriptionId) REFERENCES dbo.Prescriptions(PrescriptionId) ON DELETE CASCADE,
        CONSTRAINT FK_PrescriptionDetails_Medicines FOREIGN KEY (MedicineId) REFERENCES dbo.Medicines(MedicineId)
    );
END
GO

-- =========================================================================
-- 10. SEED DATA FOR DENTAL SERVICES & MEDICINES CATALOG
-- =========================================================================
IF NOT EXISTS (SELECT * FROM dbo.DentalServices WHERE ServiceCode = 'SR-KHAM')
BEGIN
    INSERT INTO dbo.DentalServices (ServiceCode, ServiceName, Category, Price, Unit, Description, IsActive) VALUES
    ('SR-KHAM', N'Khám & Tư vấn nha khoa tổng quát', 'KhamTongQuat', 100000, N'Lần', N'Thăm khám lâm sàng, đọc phim X-quang và tư vấn phác đồ', 1),
    ('SR-CAO', N'Lấy cao răng & Đánh bóng siêu âm', 'KhamTongQuat', 250000, N'Lần', N'Làm sạch vôi răng mảng bám trên và dưới nướu không đau', 1),
    ('SR-TRAM-01', N'Trám răng thẩm mỹ Composite (Xoang I, II)', 'TramRang', 450000, N'Răng', N'Hàn trám thẩm mỹ phục hồi hình thể răng sâu bằng vật liệu 3M', 1),
    ('SR-TRAM-02', N'Trám răng thẩm mỹ xoang phức tạp / Cổ răng', 'TramRang', 600000, N'Răng', N'Phục hồi răng sâu ngà sát tủy, mòn cổ răng', 1),
    ('SR-TUY-01', N'Điều trị tủy vi phẫu răng cửa (1 chân)', 'DieuTriTuy', 1200000, N'Răng', N'Làm sạch và hàn kín hệ thống ống tủy vi phẫu', 1),
    ('SR-TUY-02', N'Điều trị tủy vi phẫu răng cối (Nhiều chân)', 'DieuTriTuy', 2000000, N'Răng', N'Nội nha răng hàm nhiều chân, đo chiều dài ống tủy điện tử', 1),
    ('SR-NHO-01', N'Nhổ răng sữa / Răng lung lay độ 3, 4', 'NhoRang', 150000, N'Răng', N'Nhổ răng nhẹ nhàng, an toàn cho trẻ em và người cao tuổi', 1),
    ('SR-NHO-02', N'Nhổ răng thường người lớn', 'NhoRang', 500000, N'Răng', N'Gây tê tại chỗ, nhổ răng chân thẳng', 1),
    ('SR-NHO-KHON', N'Nhổ răng khôn sóng siêu âm Piezosurgical', 'NhoRang', 2500000, N'Răng', N'Công nghệ sóng siêu âm hạn chế sang chấn, nhanh lành thương', 1),
    ('SR-TAYTRANG', N'Tẩy trắng răng bằng đèn LED Laser', 'TayTrang', 1800000, N'Liệu trình', N'Bật 3-5 tone sau 45 phút, an toàn không ê buốt', 1),
    ('SR-SU-01', N'Bọc răng sứ Katana chính hãng Nhật Bản', 'RangSu', 3500000, N'Răng', N'Răng toàn sứ sinh học tự nhiên, bảo hành chính hãng 5 năm', 1),
    ('SR-SU-02', N'Bọc răng sứ Cercon HT chính hãng Đức', 'RangSu', 5000000, N'Răng', N'Độ chịu lực 1200MPa, bảo hành 10 năm', 1),
    ('SR-VENEER', N'Dán sứ Veneer Emax bảo tồn răng thật', 'RangSu', 6500000, N'Răng', N'Mài siêu mỏng 0.2-0.5mm, thẩm mỹ tự nhiên tối đa', 1),
    ('SR-IMP-01', N'Trồng răng Implant Biotem Hàn Quốc', 'Implant', 14000000, N'Trụ', N'Tích hợp xương nhanh, bao gồm khớp nối Abutment', 1),
    ('SR-IMP-02', N'Trồng răng Implant Straumann Thụy Sĩ', 'Implant', 28000000, N'Trụ', N'Dòng Implant cao cấp số 1 thế giới, bảo hành trọn đời', 1);
END
GO

IF NOT EXISTS (SELECT * FROM dbo.Medicines WHERE MedicineCode = 'MED-AUG625')
BEGIN
    INSERT INTO dbo.Medicines (MedicineCode, MedicineName, ActiveIngredient, DosageForm, Unit, UnitPrice, UsageInstructions, IsActive) VALUES
    ('MED-AUG625', N'Augmentin 625mg', N'Amoxicillin + Clavulanic Acid', N'Viên', N'Viên', 18000, N'Uống 1 viên x 2 lần/ngày sau khi ăn (Sáng - Tối)', 1),
    ('MED-ROVA', N'Rodogyl', N'Spiramycin + Metronidazole', N'Viên', N'Viên', 8500, N'Uống 2 viên x 2 lần/ngày sau bữa ăn', 1),
    ('MED-PARA500', N'Paracetamol 500mg', N'Paracetamol', N'Viên', N'Viên', 3000, N'Uống 1-2 viên khi đau nhức, cách nhau tối thiểu 4-6 giờ', 1),
    ('MED-EFF', N'Efferalgan Codeine 500mg/30mg', N'Paracetamol + Codeine', N'Viên sủi', N'Viên', 12000, N'Hòa tan 1 viên trong 200ml nước, uống khi đau nhiều sau nhổ răng', 1),
    ('MED-ALPHA', N'Alpha Chymotrypsin 4.2mg', N'Chymotrypsin', N'Viên ngậm', N'Viên', 5000, N'Ngậm dưới lưỡi 2 viên x 3 lần/ngày chống phù nề', 1),
    ('MED-CHLOR', N'Nước súc miệng Kin Gingival 0.12%', N'Chlorhexidine Digluconate 0.12%', N'Chai 250ml', N'Chai', 135000, N'Súc miệng 15ml trong 30 giây x 2 lần/ngày sau khi đánh răng', 1);
END
GO

PRINT N'DCMS Database Iteration 2 (Treatment Plans, Procedures & Prescriptions) Schema Migration Completed Successfully!';
GO

