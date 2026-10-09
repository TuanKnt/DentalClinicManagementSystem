<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- MODAL XÁC NHẬN ĐẶT LỊCH THÀNH CÔNG -->
<div id="successModal" class="modal-overlay">
    <div class="modal-card">
        <div style="width:64px; height:64px; border-radius:50%; background:#ecfdf5; color:#059669; display:flex; align-items:center; justify-content:center; margin:0 auto 16px;">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
        </div>
        <h3 style="font-size:20px; font-weight:800; color:var(--dr-navy); margin:0 0 8px;">Đặt Lịch Hẹn Thành Công!</h3>
        <p style="font-size:13.5px; color:#475569; line-height:1.5; margin-bottom:18px;">
            Thông tin lịch hẹn đã được ghi nhận trên hệ thống phòng khám Dr.Smile. Quầy lễ tân sẽ liên hệ xác nhận trong ít phút.
        </p>
        <div style="background:#f8fafc; border:1px dashed #cbd5e1; border-radius:10px; padding:14px; margin-bottom:20px; text-align:left; font-size:13px;">
            <div style="margin-bottom:6px;">Mã lịch hẹn: <strong id="modalCode" style="color:#0369a1; font-size:14px;">#APT-...</strong></div>
            <div style="margin-bottom:6px;">Bệnh nhân: <strong id="modalName">-</strong></div>
            <div style="margin-bottom:6px;">Thời gian: <strong id="modalTime">-</strong></div>
            <div>Dịch vụ: <span id="modalReason">-</span></div>
        </div>
        <button onclick="closeModal()" class="btn-hero-primary" style="width:100%; justify-content:center; padding:12px;">
            Hoàn Tất & Đóng
        </button>
    </div>
</div>
