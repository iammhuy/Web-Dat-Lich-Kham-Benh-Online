package app.controller;

import app.business.nguoidung.BacSi;
import app.database.BacSiDAO;
import app.business.vatchat.Khoa;
import app.database.KhoaDAO;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/bacsi")
public class BacSiController extends HttpServlet {

    // XÓA BỎ: Không cần tạo instance cho các lớp DAO có phương thức static.
    // private final BacSiDAO bacSiDAO = new BacSiDAO();
    // private final KhoaDAO khoaDAO = new KhoaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBacSi(request, response);
                break;
            default:
                listBacSi(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        // Gọi phương thức xử lý thêm mới hoặc cập nhật
        saveOrUpdateBacSi(request, response);
    }

    private void listBacSi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // SỬA LỖI: Gọi phương thức static trực tiếp từ class
        List<BacSi> list = BacSiDAO.findAll();
        request.setAttribute("listBacSi", list);
        RequestDispatcher dispatcher = request.getRequestDispatcher("admin/bacsi-list.jsp"); // Cập nhật đường dẫn nếu cần
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BacSi bacSi = new BacSi();
        // SỬA LỖI: Gọi phương thức static trực tiếp từ class
        List<Khoa> listKhoa = KhoaDAO.findAll();

        request.setAttribute("bacSi", bacSi);
        request.setAttribute("listKhoa", listKhoa);

        RequestDispatcher dispatcher = request.getRequestDispatcher("admin/bacsi-form.jsp"); // Cập nhật đường dẫn nếu cần
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // SỬA LỖI: Chuyển đổi ID sang kiểu int
            int id = Integer.parseInt(request.getParameter("id"));
            // SỬA LỖI: Gọi phương thức static và truyền vào int
            BacSi bacSi = BacSiDAO.findById(id);
            List<Khoa> listKhoa = KhoaDAO.findAll();

            request.setAttribute("bacSi", bacSi);
            request.setAttribute("listKhoa", listKhoa);

            RequestDispatcher dispatcher = request.getRequestDispatcher("admin/bacsi-form.jsp"); // Cập nhật đường dẫn nếu cần
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            // Xử lý trường hợp ID không phải là số
            response.sendRedirect("bacsi?action=list&error=invalidId");
        }
    }

    private void deleteBacSi(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            // SỬA LỖI: Chuyển đổi ID sang kiểu int
            int id = Integer.parseInt(request.getParameter("id"));
            
            // SỬA LOGIC: Cần tìm đối tượng trước khi xóa
            BacSi bacSiToDelete = BacSiDAO.findById(id);
            if (bacSiToDelete != null) {
                BacSiDAO.delete(bacSiToDelete);
                response.sendRedirect("bacsi?action=list&success=delete");
            } else {
                response.sendRedirect("bacsi?action=list&error=notFound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("bacsi?action=list&error=invalidId");
        }
    }

    private void saveOrUpdateBacSi(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        // ... Lấy các tham số khác tương tự
        String khoaIdStr = request.getParameter("khoaId");

        BacSi bacSi;
        boolean isNew = (idStr == null || idStr.isEmpty());

        if (isNew) {
            bacSi = new BacSi(); // Tạo mới
        } else {
            // SỬA LỖI: Dùng int cho ID
            int id = Integer.parseInt(idStr);
            bacSi = BacSiDAO.findById(id); // Lấy từ DB để cập nhật
            if (bacSi == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }

        // --- Set các thuộc tính cho đối tượng bacSi ---
        bacSi.setEmail(email);
        // ... Set các thuộc tính khác: firstName, lastName, gender, v.v.
        
        // Xử lý mật khẩu
        if (password != null && !password.isEmpty()) {
            String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
            bacSi.setPasswordHash(hashed);
        } else if (isNew) {
            // Bắt buộc nhập mật khẩu khi tạo mới
            request.setAttribute("error", "Mật khẩu là bắt buộc khi tạo mới.");
            showNewForm(request, response); // Quay lại form
            return;
        }

        // Xử lý Khoa
        try {
            // SỬA LỖI: Dùng int cho khoaId
            int khoaId = Integer.parseInt(khoaIdStr);
            Khoa khoa = KhoaDAO.findById(khoaId);
            bacSi.setKhoa(khoa);
        } catch (NumberFormatException e) {
            // Bỏ qua hoặc xử lý lỗi nếu khoaId không hợp lệ
        }
        
        // ... Set các thuộc tính còn lại: chuyenNganh, bangCap, v.v.

        // SỬA LOGIC: Gọi insert hoặc update tùy trường hợp
        if (isNew) {
            BacSiDAO.insert(bacSi);
        } else {
            BacSiDAO.update(bacSi);
        }
        
        response.sendRedirect("bacsi?action=list&success=save");
    }

    private Integer parseInteger(String str) {
        try {
            return (str != null && !str.isEmpty()) ? Integer.valueOf(str) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}