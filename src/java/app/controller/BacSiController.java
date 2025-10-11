package app.controller;

import app.business.nguoidung.BacSi;
import app.business.nguoidung.BacSiDAO;
import app.business.vatchat.Khoa;
import app.business.vatchat.KhoaDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/bacsi")
public class BacSiController extends HttpServlet {

    private final BacSiDAO bacSiDAO = new BacSiDAO();
    private final KhoaDAO khoaDAO = new KhoaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new" -> showNewForm(request, response);
            case "edit" -> showEditForm(request, response);
            case "delete" -> deleteBacSi(request, response);
            default -> listBacSi(request, response);
        }
    }

    private void listBacSi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<BacSi> list = bacSiDAO.findAll();
        request.setAttribute("listBacSi", list);
        RequestDispatcher dispatcher = request.getRequestDispatcher("bacsi-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BacSi bacSi = new BacSi();
        List<Khoa> listKhoa = khoaDAO.findAll();

        request.setAttribute("bacSi", bacSi);
        request.setAttribute("listKhoa", listKhoa);

        RequestDispatcher dispatcher = request.getRequestDispatcher("bacsi-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.valueOf(request.getParameter("id"));
        BacSi bacSi = bacSiDAO.findById(id);
        List<Khoa> listKhoa = khoaDAO.findAll();

        request.setAttribute("bacSi", bacSi);
        request.setAttribute("listKhoa", listKhoa);

        RequestDispatcher dispatcher = request.getRequestDispatcher("bacsi-form.jsp");
        dispatcher.forward(request, response);
    }

    private void deleteBacSi(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.valueOf(request.getParameter("id"));
        bacSiDAO.delete(id);
        response.sendRedirect("bacsi?action=list");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");
    String idStr = request.getParameter("id");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String gender = request.getParameter("gender");
    String phoneNumber = request.getParameter("phoneNumber");
    String address = request.getParameter("address");
    String birthdayStr = request.getParameter("birthday");

    String chuyenNganh = request.getParameter("chuyenNganh");
    String bangCapStr = request.getParameter("bangCap");
    String kinhNghiemStr = request.getParameter("kinhNghiem");
    //String soBenhNhanNgayStr = request.getParameter("soBenhNhanNgay");
    String khoaIdStr = request.getParameter("khoaId");

    BacSi bacSi;
    if (idStr != null && !idStr.isEmpty()) {
        bacSi = bacSiDAO.findById(Long.valueOf(idStr));
        if (bacSi == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
    } else {
        bacSi = new BacSi();
    }

    // Kiểm tra dữ liệu bắt buộc
    if (email == null || email.isEmpty()) {
        request.setAttribute("error", "Email không được để trống");
        RequestDispatcher dispatcher = request.getRequestDispatcher("bacsi-form.jsp");
        dispatcher.forward(request, response);
        return;
    }

    bacSi.setEmail(email);
    bacSi.setFirstName(firstName);
    bacSi.setLastName(lastName);
    bacSi.setGender(gender);
    bacSi.setPhoneNumber(phoneNumber);
    bacSi.setAddress(address);

    if (birthdayStr != null && !birthdayStr.isEmpty()) {
        bacSi.setBirthday(LocalDate.parse(birthdayStr));
    }

    if (password != null && !password.isEmpty()) {
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
        bacSi.setPasswordHash(hashed);
    } else if (bacSi.getId() != null) {
        BacSi oldBacSi = bacSiDAO.findById(bacSi.getId());
        if (oldBacSi != null) {
            bacSi.setPasswordHash(oldBacSi.getPasswordHash());
        }
    } else {
        request.setAttribute("error", "Mật khẩu là bắt buộc.");
        RequestDispatcher dispatcher = request.getRequestDispatcher("bacsi-form.jsp");
        dispatcher.forward(request, response);
        return;
    }

    bacSi.setChuyenNganh(chuyenNganh);
    bacSi.setBangCap(parseInteger(bangCapStr));
    bacSi.setKinhNghiem(parseInteger(kinhNghiemStr));
    //bacSi.setSoBenhNhanNgay(parseInteger(soBenhNhanNgayStr));

    if (khoaIdStr != null && !khoaIdStr.isEmpty()) {
        Long khoaId = Long.valueOf(khoaIdStr);
        Khoa khoa = khoaDAO.findById(khoaId);
        bacSi.setKhoa(khoa);
    }

    bacSiDAO.saveOrUpdate(bacSi);
    response.sendRedirect("bacsi?action=list");
}


    private Integer parseInteger(String str) {
        try {
            return (str != null && !str.isEmpty()) ? Integer.valueOf(str) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
