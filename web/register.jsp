<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/header.jsp" />

<div class="container my-5">
  <div class="row justify-content-center">
    <div class="col-md-7">
      <div class="card shadow-sm border-0">
        <div class="card-body">
          <h3 class="text-center text-success mb-4">Đăng ký tài khoản (Bệnh nhân)</h3>
          <form action="${pageContext.request.contextPath}/user" method="post">
            <input type="hidden" name="action" value="register"/>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label>Họ</label>
                <input name="firstName" class="form-control" required/>
              </div>
              <div class="col-md-6 mb-3">
                <label>Tên</label>
                <input name="lastName" class="form-control" required/>
              </div>
            </div>

            <div class="mb-3">
              <label>Email</label>
              <input name="email" type="email" class="form-control" required/>
            </div>
            <div class="mb-3">
              <label>Số điện thoại</label>
              <input name="phone" class="form-control"/>
            </div>
            <div class="mb-3">
              <label>Mật khẩu</label>
              <input type="password" name="password" class="form-control" required/>
            </div>

            <c:if test="${not empty regError}">
              <div class="alert alert-danger">${regError}</div>
            </c:if>

            <button class="btn btn-success w-100">Đăng ký</button>
            
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/footer.jsp" />
