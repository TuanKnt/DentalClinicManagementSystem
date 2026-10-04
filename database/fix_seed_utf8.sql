-- Drop old corrupted constraint
DECLARE @ConstraintName NVARCHAR(200);
SELECT @ConstraintName = name FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('dbo.Patients') AND definition LIKE '%Gender%';
IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE dbo.Patients DROP CONSTRAINT ' + @ConstraintName);
END
GO

-- Recreate proper Unicode check constraint
ALTER TABLE dbo.Patients ADD CONSTRAINT CK_Patients_Gender CHECK (Gender IN (N'Nam', N'Nữ', N'Khác'));
GO

-- Update sample patients
UPDATE dbo.Patients 
SET FullName = N'Hoàng Văn Nam',
    Gender = N'Nam',
    Address = N'Cầu Giấy, Hà Nội',
    MedicalAlerts = N'Tiền sử cao huyết áp',
    Allergies = N'Dị ứng Penicillin'
WHERE Phone = '0988111222';

UPDATE dbo.Patients 
SET FullName = N'Đỗ Thu Trang',
    Gender = N'Nữ',
    Address = N'Nam Từ Liêm, Hà Nội'
WHERE Phone = '0977333444';

SELECT PatientId, FullName, Gender, MedicalAlerts, Allergies, Address FROM dbo.Patients;
GO
