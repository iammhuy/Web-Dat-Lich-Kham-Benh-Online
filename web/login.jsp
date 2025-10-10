<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/header.jsp" />

<div class="container my-5">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card shadow-sm border-0">
        <div class="card-body">
          <h3 class="text-center text-primary mb-4">Đăng nhập</h3>
          <form action="${pageContext.request.contextPath}/user" method="post">
            <input type="hidden" name="action" value="login"/>
            <div class="mb-3">
              <label class="form-label">Email</label>
              <input type="text" name="email" class="form-control" required/>
            </div>
            <div class="mb-3">
              <label class="form-label">Mật khẩu</label>
              <input type="password" name="password" class="form-control" required/>
            </div>
            <c:if test="${not empty loginError}">
              <div class="alert alert-danger">${loginError}</div>
            </c:if>
            <button class="btn btn-primary w-100">Đăng nhập</button>
            <p class="text-center mt-3">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register.jsp">Đăng ký ngay</a></p>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/footer.jsp" />
