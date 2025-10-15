package app.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class DBUtil {

    // ========== PHẦN 1: DÀNH CHO JPA (Các file DAO cũ) ==========
    // Tạo EntityManagerFactory, sử dụng tên "Persistence Unit" trong persistence.xml
    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("QuanLyPhongKhamPU");
    // Hàm này dùng cho JPA (các DAO kiểu HoSoKhamDAO, DonThuocDAO,...)
    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    public static EntityManagerFactory getEmFactory() {
        return emf;
    }
    private static final String HOSTNAME = "mysql-1774ed16-nhathuy24092005-8d8f.c.aivencloud.com";
    private static final String PORT = "11575"; // <-- THAY BẰNG PORT CỦA BẠN (ví dụ: "13306")
    private static final String DATABASE_NAME = "webkhambenh";
    private static final String USER = "avnadmin";
    private static final String PASSWORD = "AVNS_GgWOk646RNw6Ae9wP_i"; // <-- THAY BẰNG PASSWORD AIVEN CỦA BẠN
    private static final String URL = "jdbc:mysql://" + HOSTNAME + ":" + PORT + "/" + DATABASE_NAME + "?sslmode=require";
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            // Lỗi này xảy ra nếu bạn chưa thêm file mysql-connector-java.jar vào Libraries
            throw new SQLException("MySQL JDBC Driver not found.", e);
        }
    }

    // Các phương thức tiện ích để đóng kết nối JDBC một cách an toàn
    public static void closeStatement(Statement s) {
        try { if (s != null) s.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    public static void closePreparedStatement(PreparedStatement ps) {
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    public static void closeResultSet(ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    
    public static void closeConnection(Connection c) {
        try { if (c != null) c.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}