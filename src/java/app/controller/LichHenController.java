package app.controller;
import app.business.giaodich.LichHen;
import app.business.nguoidung.BacSi;
import app.business.nguoidung.BenhNhan;
import app.business.vatchat.Khoa;
import app.database.BacSiDAO;
import app.database.KhoaDAO;
import app.database.LichHenDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LichHenController")
public class LichHenController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null || "prepareAdd".equals(action) || "form".equals(action)) {
        prepareAdd(req, res);
        } else if ("list".equals(action)) {
         hienThiDanhSach(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if ("add".equals(action)) {
            themLich(req, res);
        }
    }

    private void prepareAdd(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        List<Khoa> listKhoa = KhoaDAO.findAll();
        req.setAttribute("listKhoa", listKhoa);
        
        List<BacSi> listBacSi = BacSiDAO.findAll();
        req.setAttribute("listBacSi", listBacSi);

        req.getRequestDispatcher("/benhnhan/datlich.jsp").forward(req, res);
    }

    private void themLich(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        BenhNhan benhNhan;
        if (session == null || session.getAttribute("user") == null) {
            // Dòng này chỉ để test, trong thực tế bạn sẽ chuyển hướng về trang login
            benhNhan = new BenhNhan();
            // SỬA LỖI: Thêm 'L' để chỉ định đây là giá trị kiểu long
            benhNhan.setId(1L); // ID giả định
        } else {
            benhNhan = (BenhNhan) session.getAttribute("user");
        }

        try {
            Long bacSiId = Long.valueOf(req.getParameter("bacSiId"));
            String ngayHenStr = req.getParameter("ngayHen");
            String lyDoKham = req.getParameter("lyDoKham");

            BacSi bacSi = BacSiDAO.findById(bacSiId);
            if (bacSi == null) {
                req.setAttribute("error", "Bác sĩ không hợp lệ.");
                prepareAdd(req, res);
                return;
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date ngayHen = sdf.parse(ngayHenStr);

            LichHen lh = new LichHen();
            lh.setBenhNhan(benhNhan);
            lh.setBacSi(bacSi);
            lh.setNgayHen(ngayHen);
            lh.setLyDoKham(lyDoKham);
            // Bây giờ dòng này đã hợp lệ
            lh.setChiPhi(BigDecimal.valueOf(bacSi.getChiPhiKham())); 
            lh.setTrangThai("Chờ xác nhận");

            LichHenDAO.insert(lh);
            
            req.getSession().setAttribute("lichHenVuaDat", lh);
            // Sửa lại đường dẫn cho đúng, ví dụ: /benhnhan/xacnhan.jsp
            res.sendRedirect(req.getContextPath() + "/benhnhan/xacnhan.jsp");

        } catch (NumberFormatException | ParseException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi thêm lịch: Vui lòng kiểm tra lại thông tin.");
            prepareAdd(req, res);
        }
    }
    private void hienThiDanhSach(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {
    HttpSession session = req.getSession(false);
    BenhNhan user = (BenhNhan) session.getAttribute("user");

    if (user == null) {
        res.sendRedirect(req.getContextPath() + "/login.jsp");
        return;
    }

    List<LichHen> lichChuaXN = LichHenDAO.findByBenhNhanAndTrangThai(user.getId(), "Chờ xác nhận");
    List<LichHen> lichDaXN = LichHenDAO.findByBenhNhanAndTrangThai(user.getId(), "Đã xác nhận");

    req.setAttribute("lichChuaXN", lichChuaXN);
    req.setAttribute("lichDaXN", lichDaXN);

    req.getRequestDispatcher("/benhnhan/lichhen.jsp").forward(req, res);
}

}

