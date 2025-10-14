/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package app.database;
import app.business.giaodich.HoaDon;
import java.sql.*;
public class HoaDonDB {

    // Tạo hóa đơn mới
    public static void createInvoice(HoaDon hoaDon) {
        String sql = "INSERT INTO HoaDon (thanhToanId, noiDung, ngayXuat, soTien) VALUES (?, ?, NOW(), ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            
            ps.setInt(1, hoaDon.getThanhToan().getThanhToanId()); // Giả sử đối tượng HoaDon chứa đối tượng ThanhToan
            ps.setString(2, hoaDon.getNoiDung());
            ps.setBigDecimal(3, hoaDon.getSoTien());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closePreparedStatement(ps);
            DBUtil.closeConnection(conn);
        }
    }
}
