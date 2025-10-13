/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package app.database;
import app.business.giaodich.ThanhToan;
import app.business.giaodich.TrangThai;
import java.math.BigDecimal;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ThanhToanDB {

    public static int createPendingPayment(ThanhToan thanhToan) {
        String sql = "INSERT INTO ThanhToan (lichHenId, soTien, phuongThuc, trangThai, ngayThanhToan) "
                + "VALUES (?, ?, ?, ?, NOW())";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            ps.setInt(1, thanhToan.getLichHenId());
            ps.setBigDecimal(2, thanhToan.getSoTien());
            ps.setString(3, thanhToan.getPhuongThuc().name());
            ps.setString(4, TrangThai.Pending.name());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closePreparedStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return 0;
    }

    public static void updatePaymentStatus(int thanhToanId, TrangThai trangThai, String maGiaoDichVnpay) {
        String sql = "UPDATE ThanhToan SET trangThai = ?, maGiaoDichVnpay = ?, ngayThanhToan = NOW() WHERE thanhToanId = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, trangThai.name());
            ps.setString(2, maGiaoDichVnpay);
            ps.setInt(3, thanhToanId);
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ThanhToanDB.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            DBUtil.closePreparedStatement(ps);
            DBUtil.closeConnection(conn);
        }
    }

    public static ThanhToan getById(int thanhToanId) {
        String sql = "SELECT * FROM ThanhToan WHERE thanhToanId = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, thanhToanId);
            rs = ps.executeQuery();
            if (rs.next()) {
                ThanhToan thanhToan = new ThanhToan();
                thanhToan.setThanhToanId(rs.getInt("thanhToanId"));
                thanhToan.setLichHenId(rs.getInt("lichHenId"));
                thanhToan.setSoTien(rs.getBigDecimal("soTien"));
                thanhToan.setTrangThai(TrangThai.valueOf(rs.getString("trangThai")));
                return thanhToan;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ThanhToanDB.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closePreparedStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return null;
    }
}

