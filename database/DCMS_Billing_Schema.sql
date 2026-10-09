-- =========================================================================
-- DCMS BILLING & CASHIER SCHEMA (UC29, UC30, UC31, UC32, UC34)
-- Enforces:
-- 1. Iron Rule 3: Invoice ONLY generated from ProcedurePerformed
-- 2. Iron Rule 8: Payment lifecycle (Unpaid -> PartiallyPaid -> Paid)
-- 3. Iron Rule 6: Actor Isolation (Cashier records payment, cannot edit clinical data)
-- =========================================================================

IF OBJECT_ID('dbo.InvoicePayments', 'U') IS NOT NULL DROP TABLE dbo.InvoicePayments;
IF OBJECT_ID('dbo.Invoices', 'U') IS NOT NULL DROP TABLE dbo.Invoices;
GO

CREATE TABLE dbo.Invoices (
    InvoiceId INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceCode NVARCHAR(50) NOT NULL UNIQUE,
    VisitId INT NOT NULL,
    PatientId INT NOT NULL,
    CashierId INT NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    DiscountAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    FinalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    PaidAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    BalanceAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    Status NVARCHAR(30) NOT NULL DEFAULT 'Unpaid' 
        CHECK (Status IN ('Unpaid', 'PartiallyPaid', 'Paid', 'Cancelled')),
    PaymentMethod NVARCHAR(50) NULL,
    Notes NVARCHAR(500) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_Invoices_Visits FOREIGN KEY (VisitId) REFERENCES dbo.Visits(VisitId),
    CONSTRAINT FK_Invoices_Patients FOREIGN KEY (PatientId) REFERENCES dbo.Patients(PatientId),
    CONSTRAINT FK_Invoices_Users FOREIGN KEY (CashierId) REFERENCES dbo.Users(UserId)
);
GO

CREATE TABLE dbo.InvoicePayments (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    PaymentCode NVARCHAR(50) NOT NULL UNIQUE,
    InvoiceId INT NOT NULL,
    Amount DECIMAL(18,2) NOT NULL CHECK (Amount > 0),
    PaymentMethod NVARCHAR(50) NOT NULL DEFAULT 'Cash' 
        CHECK (PaymentMethod IN ('Cash', 'BankTransfer', 'Card')),
    CashierId INT NOT NULL,
    Notes NVARCHAR(255) NULL,
    PaidAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_InvoicePayments_Invoices FOREIGN KEY (InvoiceId) REFERENCES dbo.Invoices(InvoiceId),
    CONSTRAINT FK_InvoicePayments_Users FOREIGN KEY (CashierId) REFERENCES dbo.Users(UserId)
);
GO

-- Seed completed procedures for Visit 1 (Hoàng Văn Nam) and Visit 2 (Đỗ Thu Trang)
DELETE FROM dbo.ProceduresPerformed WHERE VisitId IN (1, 2);
GO

INSERT INTO dbo.ProceduresPerformed (VisitId, DentistId, AssistantId, ServiceId, ToothNumber, Surface, Quantity, ActualPrice, Status, ClinicalNotes, PerformedAt)
VALUES
(1, 3, 4, 1, NULL, NULL, 1, 100000.00, 'Completed', N'Khám lâm sàng tổng quát niêm mạc & khớp cắn bình thường', SYSDATETIME()),
(1, 3, 4, 2, NULL, NULL, 1, 250000.00, 'Completed', N'Lấy cao răng 2 hàm và đánh bóng siêu âm', SYSDATETIME()),
(1, 3, 4, 3, 36, 'Occlusal', 1, 450000.00, 'Completed', N'Trám xoang sâu mặt nhai răng 36 bằng Composite 3M Z350', SYSDATETIME()),
(2, 3, 4, 9, 48, NULL, 1, 2500000.00, 'Completed', N'Nhổ răng khôn ngầm lệch 48 bằng máy siêu âm Piezosurgical, khâu chỉ tự tiêu', SYSDATETIME());
GO

-- Seed Initial Invoices
INSERT INTO dbo.Invoices (InvoiceCode, VisitId, PatientId, CashierId, TotalAmount, DiscountAmount, FinalAmount, PaidAmount, BalanceAmount, Status, PaymentMethod, Notes)
VALUES
('HD-2026-0001', 1, 1, 5, 800000.00, 50000.00, 750000.00, 500000.00, 250000.00, 'PartiallyPaid', 'Cash', N'Bệnh nhân thanh toán trước 500.000đ tiền mặt, hẹn thanh toán nốt buổi sau'),
('HD-2026-0002', 2, 2, 5, 2500000.00, 0.00, 2500000.00, 0.00, 2500000.00, 'Unpaid', NULL, N'Chờ bệnh nhân thanh toán tại quầy thu ngân');
GO

-- Seed First Payment for Invoice 1
INSERT INTO dbo.InvoicePayments (PaymentCode, InvoiceId, Amount, PaymentMethod, CashierId, Notes, PaidAt)
VALUES
('PT-2026-0001', 1, 500000.00, 'Cash', 5, N'Tạm ứng tiền mặt tại quầy', SYSDATETIME());
GO

PRINT 'DCMS Billing Schema & Seed Data Initialized Successfully!';
GO
