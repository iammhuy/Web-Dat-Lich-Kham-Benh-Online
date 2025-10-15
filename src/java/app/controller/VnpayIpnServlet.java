/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package app.controller;
import app.business.giaodich.HoaDon;
import app.business.giaodich.ThanhToan;
import app.business.giaodich.TrangThai;
import app.database.HoaDonDB;
import app.database.ThanhToanDB;
import com.vnpay.common.Config;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
public class VnpayIpnServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet VnpayIpnServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VnpayIpnServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      try {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }
        
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        
        // Loại bỏ các trường hash ra khỏi map
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // BẮT ĐẦU SỬA TỪ ĐÂY

        // Sắp xếp các trường theo thứ tự ABC
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);

        // Tạo chuỗi hash từ dữ liệu thô (KHÔNG mã hóa URL)
        StringBuilder sb = new StringBuilder();
        for (Iterator<String> itr = fieldNames.iterator(); itr.hasNext();) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                sb.append(fieldName).append('=').append(fieldValue);
                if (itr.hasNext()) {
                    sb.append('&');
                }
            }
        }

        String signValue = Config.hmacSHA512(Config.vnp_HashSecret, sb.toString());
            if (signValue.equals(vnp_SecureHash)) {
                int thanhToanId = Integer.parseInt(request.getParameter("vnp_TxnRef"));
                ThanhToan thanhToan = ThanhToanDB.getById(thanhToanId);
                
                // Kiểm tra xem giao dịch có tồn tại và đang ở trạng thái PENDING không
                if (thanhToan != null && thanhToan.getTrangThai() == TrangThai.Pending) {
                    String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
                    String maGiaoDich = request.getParameter("vnp_TransactionNo"); // Mã giao dịch của VNPAY
                    
                    if ("00".equals(vnp_ResponseCode)) {
                        // Giao dịch thành công
                        ThanhToanDB.updatePaymentStatus(thanhToanId, TrangThai.Success, maGiaoDich);
                        
                        // Tạo hóa đơn
                        HoaDon hoaDon = new HoaDon();
                        hoaDon.setThanhToan(thanhToan);
                        hoaDon.setNoiDung("Thanh toan cho lich hen #" + thanhToan.getLichHenId());
                        hoaDon.setSoTien(thanhToan.getSoTien());
                        HoaDonDB.createInvoice(hoaDon);
                        
                        response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
                    } else {
                        // Giao dịch thất bại
                        ThanhToanDB.updatePaymentStatus(thanhToanId, TrangThai.Failed, maGiaoDich);
                        response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}"); // Vẫn trả về success để VNPAY không gửi lại
                    }
                } else {
                    response.getWriter().write("{\"RspCode\":\"02\",\"Message\":\"Order already confirmed\"}");
                }
            } else {
                response.getWriter().write("{\"RspCode\":\"97\",\"Message\":\"Invalid Checksum\"}");
            }
        } catch (Exception e) {
            response.getWriter().write("{\"RspCode\":\"99\",\"Message\":\"Unknown error\"}");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
