package app.controller;

import app.business.nguoidung.BacSi;
import app.business.vatchat.Khoa;
import app.business.vatchat.PhongKham;
import app.database.QuanTriVienDB;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/admin")
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String entity = request.getParameter("entity"); // bacsi | khoa | phong
        String action = request.getParameter("action"); // list | form | delete
        if (entity == null) entity = "bacsi";
        if (action == null) action = "list";

        switch (entity) {
            case "bacsi":
                handleBacSiGet(request, response, action);
                break;
            case "khoa":
                handleKhoaGet(request, response, action);
                break;
            case "phong":
                handlePhongGet(request, response, action);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String entity = request.getParameter("entity");
        String action = request.getParameter("action"); // save (thêm hoặc sửa)
        if (entity == null) entity = "bacsi";

        switch (entity) {
            case "bacsi":
                handleBacSiSave(request, response);
                break;
            case "khoa":
                handleKhoaSave(request, response);
                break;
            case "phong":
                handlePhongSave(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
        }
    }

    // ----------------- BÁC SĨ -----------------
    private void handleBacSiGet(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {

        if ("form".equals(action)) {
            String idStr = request.getParameter("id");
            BacSi bacSi = null;
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    Long id = Long.parseLong(idStr);
                    bacSi = QuanTriVienDB.findBacSiById(id);
                } catch (NumberFormatException ex) { /* ignore -> new */ }
            }

            List<Khoa> listKhoa = QuanTriVienDB.listKhoa();
            request.setAttribute("bacSi", bacSi);
            request.setAttribute("listKhoa", listKhoa);
            request.getRequestDispatcher("/admin/bacsi-form.jsp").forward(request, response);
            return;
        }

        if ("delete".equals(action)) {
            long idDel = toLong(request.getParameter("id"));
            BacSi toDel = (idDel == -1) ? null : QuanTriVienDB.findBacSiById(idDel);
            if (toDel != null) QuanTriVienDB.deleteBacSi(toDel);
            response.sendRedirect("admin?entity=bacsi&action=list&success=deleted");
            return;
        }

        List<BacSi> listBacSi = QuanTriVienDB.listBacSi();
        List<Khoa> listKhoa = QuanTriVienDB.listKhoa();
        request.setAttribute("listBacSi", listBacSi);
        request.setAttribute("listKhoa", listKhoa);
        request.getRequestDispatcher("/admin/danh_sach_bac_si.jsp").forward(request, response);
    }

    private void handleBacSiSave(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String idStr = request.getParameter("id");
    boolean isNew = (idStr == null || idStr.isEmpty());
    BacSi b = isNew ? new BacSi() : QuanTriVienDB.findBacSiById(toLong(idStr));

    if (!isNew && b == null) {
        response.sendRedirect("admin?entity=bacsi&action=list&error=notfound");
        return;
    }

    b.setEmail(request.getParameter("email"));
    String password = request.getParameter("password");
    if (isNew && (password == null || password.isEmpty())) {
        response.sendRedirect("admin?entity=bacsi&action=list&error=missingpass");
        return;
    }
    if (password != null && !password.isEmpty()) {
        b.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt(12)));
    }

    b.setFirstName(request.getParameter("firstName"));
    b.setLastName(request.getParameter("lastName"));
    b.setGender(request.getParameter("gender"));
    b.setPhoneNumber(request.getParameter("phoneNumber"));
    b.setAddress(request.getParameter("address"));
    b.setChuyenNganh(request.getParameter("chuyenNganh"));
    b.setBangCap(request.getParameter("bangCap"));

    // parse birthday
    try {
        String birthdayStr = request.getParameter("birthday");
        if (birthdayStr != null && !birthdayStr.isEmpty()) {
            b.setBirthday(LocalDate.parse(birthdayStr));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // parse kinh nghiem
    try {
        String kinh = request.getParameter("kinhNghiem");
        if (kinh != null && !kinh.isEmpty())
            b.setKinhNghiem(Integer.parseInt(kinh));
    } catch (Exception ignored) {}

    // parse chi phi kham
    try {
        String phi = request.getParameter("chiPhiKham");
        if (phi != null && !phi.isEmpty())
            b.setChiPhiKham(Double.parseDouble(phi));
    } catch (Exception ignored) {}

    try {
        int khoaId = Integer.parseInt(request.getParameter("khoaId"));
        Khoa k = QuanTriVienDB.findKhoaById(khoaId);
        b.setKhoa(k);
    } catch (Exception ignored) {}

    if (isNew) QuanTriVienDB.insertBacSi(b);
    else QuanTriVienDB.updateBacSi(b);

    response.sendRedirect("admin?entity=bacsi&action=list&success=save");
}



    // ----------------- KHOA -----------------
    private void handleKhoaGet(HttpServletRequest request, HttpServletResponse response, String action)
        throws ServletException, IOException {

    if ("new".equals(action)) {
        // Hiển thị form thêm mới
        request.getRequestDispatcher("/admin/khoa-form.jsp").forward(request, response);
        return;
    }

    if ("edit".equals(action)) {
        int id = toInt(request.getParameter("id"));
        Khoa khoa = QuanTriVienDB.findKhoaById(id);
        request.setAttribute("khoa", khoa);
        request.getRequestDispatcher("/admin/khoa-form.jsp").forward(request, response);
        return;
    }

    if ("delete".equals(action)) {
        int idDel = toInt(request.getParameter("id"));
        Khoa toDel = QuanTriVienDB.findKhoaById(idDel);
        if (toDel != null) QuanTriVienDB.deleteKhoa(toDel);
        response.sendRedirect("admin?entity=khoa&action=list");
        return;
    }

    // Mặc định hiển thị danh sách
    List<Khoa> listKhoa = QuanTriVienDB.listKhoa();
    request.setAttribute("listKhoa", listKhoa);
    request.getRequestDispatcher("/admin/danh_sach_khoa.jsp").forward(request, response);
}

    private void handleKhoaSave(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        boolean isNew = (idStr == null || idStr.isEmpty());
        Khoa k = isNew ? new Khoa() : QuanTriVienDB.findKhoaById(toInt(idStr));

        if (!isNew && k == null) {
            response.sendRedirect("admin?entity=khoa&action=list&error=notfound");
            return;
        }

        k.setTenKhoa(request.getParameter("tenKhoa"));
        k.setMoTa(request.getParameter("moTa"));

        if (isNew) QuanTriVienDB.insertKhoa(k); else QuanTriVienDB.updateKhoa(k);
        response.sendRedirect("admin?entity=khoa&action=list&success=save");
    }

    // ----------------- PHÒNG KHÁM -----------------
private void handlePhongGet(HttpServletRequest request, HttpServletResponse response, String action)
        throws ServletException, IOException {
    if ("delete".equals(action)) {
        int idDel = toInt(request.getParameter("id"));
        PhongKham toDel = QuanTriVienDB.findPhongById(idDel);
        if (toDel != null) QuanTriVienDB.deletePhong(toDel);
        response.sendRedirect("admin?entity=phong&action=list&success=deleted");
        return;
    }

    if ("new".equals(action)) {
        // Chuẩn bị form thêm mới
        request.setAttribute("phong", new PhongKham());
        request.setAttribute("listKhoa", QuanTriVienDB.listKhoa());
        request.getRequestDispatcher("/admin/phongkham-form.jsp").forward(request, response);
        return;
    }

    if ("edit".equals(action)) {
        int idEdit = toInt(request.getParameter("id"));
        PhongKham p = QuanTriVienDB.findPhongById(idEdit);
        if (p == null) {
            response.sendRedirect("admin?entity=phong&action=list&error=notfound");
            return;
        }
        request.setAttribute("phong", p);
        request.setAttribute("listKhoa", QuanTriVienDB.listKhoa());
        request.getRequestDispatcher("/admin/phongkham-form.jsp").forward(request, response);
        return;
    }

    // Mặc định: liệt kê danh sách phòng
    List<PhongKham> listPhong = QuanTriVienDB.listPhong();
    List<Khoa> listKhoa = QuanTriVienDB.listKhoa();
    request.setAttribute("listPhong", listPhong);
    request.setAttribute("listKhoa", listKhoa);
    request.getRequestDispatcher("/admin/danh_sach_phong.jsp").forward(request, response);
}

    private void handlePhongSave(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        boolean isNew = (idStr == null || idStr.isEmpty());
        PhongKham p = isNew ? new PhongKham() : QuanTriVienDB.findPhongById(toInt(idStr));

        if (!isNew && p == null) {
            response.sendRedirect("admin?entity=phong&action=list&error=notfound");
            return;
        }

        p.setTenPhong(request.getParameter("tenPhong"));
        try {
            int khoaId = Integer.parseInt(request.getParameter("khoaId"));
            Khoa k = QuanTriVienDB.findKhoaById(khoaId);
            p.setKhoa(k);
        } catch (Exception ignored) {}

        if (isNew) QuanTriVienDB.insertPhong(p); else QuanTriVienDB.updatePhong(p);
        response.sendRedirect("admin?entity=phong&action=list&success=save");
    }

    // ----------------- helpers -----------------
    private Long toLong(String s) {
        if (s == null) return -1L;
        try { return Long.parseLong(s); } catch (Exception e) { return -1L; }
    }

    private int toInt(String s) {
        if (s == null) return -1;
        try { return Integer.parseInt(s); } catch (Exception e) { return -1; }
    }
}
