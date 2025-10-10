package app.controller;

import app.business.nguoidung.BenhNhan;
import app.business.nguoidung.User;
import app.database.UserDB;
import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "UserController", urlPatterns = {"/user"})
public class UserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        if ("logout".equals(action)) {
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        if ("home".equals(action)) {
        if (session == null || session.getAttribute("user") == null) {
            // Chưa đăng nhập → về login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object u = session.getAttribute("user");
        // Kiểm tra loại user để điều hướng tương ứng
        if (u instanceof app.business.nguoidung.QuanTriVien) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
        } else if (u instanceof app.business.nguoidung.BacSi) {
            response.sendRedirect(request.getContextPath() + "/bacsi/index.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/benhnhan/index.jsp");
        }
        return;
    }

        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("register".equals(action)) {
            handleRegister(request, response);
        } else if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("editprofile".equals(action)) {
            handleEditProfile(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String email = request.getParameter("email").trim();
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");

        if (email == null || email.isEmpty() || password == null || password.length() < 6) {
            request.setAttribute("regError", "Email và mật khẩu (>=6 ký tự) là bắt buộc.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (UserDB.selectUserByEmail(email) != null) {
            request.setAttribute("regError", "Email đã được sử dụng.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));

        BenhNhan bn = new BenhNhan();
        bn.setEmail(email);
        bn.setPasswordHash(hashed);
        bn.setFirstName(firstName);
        bn.setLastName(lastName);
        bn.setPhoneNumber(phone);

        UserDB.insert(bn);
        response.sendRedirect(request.getContextPath() + "/login.jsp?registered=1");
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String email = request.getParameter("email").trim();
        String password = request.getParameter("password");

        User u = UserDB.authenticate(email, password);
        if (u == null) {
            request.setAttribute("loginError", "Số điện thoại/email hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", u);
        session.setMaxInactiveInterval(24 * 60 * 60);

        if (u instanceof app.business.nguoidung.QuanTriVien) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
        } else if (u instanceof app.business.nguoidung.BacSi) {
            response.sendRedirect(request.getContextPath() + "/bacsi/index.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/benhnhan/index.jsp");
        }
    }

    private void handleEditProfile(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        user.setFirstName(request.getParameter("firstName"));
        user.setLastName(request.getParameter("lastName"));
        user.setGender(request.getParameter("gender"));
        user.setPhoneNumber(request.getParameter("phoneNumber"));
        user.setAddress(request.getParameter("address"));

        String birthdayStr = request.getParameter("birthday");
        if (birthdayStr != null && !birthdayStr.isEmpty()) {
            user.setBirthday(LocalDate.parse(birthdayStr));
        }

        UserDB.update(user);
        session.setAttribute("user", user);
        request.setAttribute("successMsg", "Cập nhật thông tin thành công!");
        request.getRequestDispatcher("/benhnhan/index.jsp").forward(request, response);
    }
}
