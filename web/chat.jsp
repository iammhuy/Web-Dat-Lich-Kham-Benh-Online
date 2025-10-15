<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@page
import="app.business.nguoidung.User"%> <% User currentUser = (User)
session.getAttribute("user"); if (currentUser == null) {
response.sendRedirect(request.getContextPath() + "/login.jsp"); return; } %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chat - Hệ thống đặt lịch khám bệnh</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
      rel="stylesheet"
    />
    <style>
      .chat-container {
        height: calc(100vh - 150px);
        max-width: 1200px;
        margin: 20px auto;
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        position: relative;
      }

      .chat-sidebar {
        background: #f8f9fa;
        border-right: 1px solid #dee2e6;
        height: 100%;
      }

      .sidebar-header {
        background: linear-gradient(135deg, #007bff, #0056b3);
        color: white;
        padding: 20px;
        text-align: center;
      }

      .contact-list {
        height: calc(100% - 80px);
        overflow-y: auto;
        padding: 10px 0;
      }

      .contact-item {
        padding: 15px 20px;
        border-bottom: 1px solid #e9ecef;
        cursor: pointer;
        transition: all 0.2s;
      }

      .contact-item:hover,
      .contact-item.active {
        background: #e3f2fd;
        border-left: 4px solid #007bff;
      }

      .contact-avatar {
        width: 45px;
        height: 45px;
        min-width: 45px;
        min-height: 45px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: white;
        margin-right: 12px;
        flex-shrink: 0;
        box-sizing: border-box;
      }

      .chat-main {
        height: 100%;
        display: flex;
        flex-direction: column;
        overflow: hidden;
        position: relative;
        width: 100%;
      }

      .chat-header {
        background: white;
        border-bottom: 1px solid #dee2e6;
        padding: 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
      }

      .chat-messages {
        flex: 1;
        overflow-y: auto;
        overflow-x: hidden;
        padding: 20px;
        background: #f8f9fa;
        max-height: calc(100vh - 312px);
        scroll-behavior: smooth;
      }

      .message {
        display: flex;
        margin-bottom: 15px;
        animation: fadeIn 0.3s ease;
        width: 100%;
        box-sizing: border-box;
        align-items: flex-start;
        flex-wrap: nowrap;
      }

      /* Tin nhắn của mình (sent) - hiển thị bên TRÁI */
      .message.sent {
        justify-content: flex-start !important;
      }

      /* Tin nhắn của người khác (received) - hiển thị bên PHẢI */
      .message.received {
        justify-content: flex-end !important;
      }

      .message-content {
        max-width: 70%;
        min-width: 80px;
        padding: 10px 15px;
        border-radius: 15px;
        word-wrap: break-word;
        word-break: break-word;
        overflow-wrap: break-word;
        hyphens: auto;
        white-space: pre-wrap;
        box-sizing: border-box;
      }

      /* Style cho tin nhắn của mình (bên trái) */
      .message.sent .message-content {
        background: #007bff !important;
        color: white !important;
        margin-left: 10px !important;
        margin-right: 0 !important;
      }

      /* Style cho tin nhắn người khác (bên phải) */
      .message.received .message-content {
        background: white !important;
        border: 1px solid #dee2e6 !important;
        margin-right: 10px !important;
        margin-left: 0 !important;
      }

      .message-time {
        font-size: 11px;
        opacity: 0.7;
        margin-top: 5px;
        display: block;
      }

      /* Xử lý links và text dài */
      .message-content a {
        color: inherit;
        text-decoration: underline;
        word-break: break-all;
      }

      .message-content code {
        background: rgba(0, 0, 0, 0.1);
        padding: 2px 4px;
        border-radius: 3px;
        font-family: monospace;
        word-break: break-all;
      }

      /* Xử lý cho tin nhắn chỉ có emoji */
      .message-content.emoji-only {
        font-size: 2em;
        padding: 5px 10px;
      }

      .chat-input {
        background: white;
        border-top: 1px solid #dee2e6;
        padding: 20px;
      }

      .input-group {
        border-radius: 25px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      .form-control {
        border: none;
        padding: 12px 20px;
      }

      .form-control:focus {
        box-shadow: none;
        outline: none;
      }

      .btn-send {
        background: #007bff;
        border: none;
        color: white;
        padding: 12px 20px;
      }

      .btn-send:hover {
        background: #0056b3;
      }

      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateY(10px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .loading {
        text-align: center;
        color: #6c757d;
        padding: 20px;
      }

      .no-messages {
        text-align: center;
        color: #6c757d;
        padding: 40px;
      }

      /* Responsive cho tin nhắn dài trên mobile */
      @media (max-width: 768px) {
        .message-content {
          max-width: 85%;
        }

        .chat-messages {
          padding: 15px;
        }

        .contact-avatar {
          width: 35px;
          height: 35px;
          min-width: 35px;
          min-height: 35px;
          margin-right: 8px;
        }
      }

      /* Ngăn chặn horizontal scroll */
      .row {
        margin: 0 !important;
      }

      .col-md-4,
      .col-md-8 {
        padding: 0 !important;
      }

      /* Đảm bảo không có overflow ngang */
      * {
        box-sizing: border-box;
      }

      .message-content * {
        max-width: 100% !important;
        word-wrap: break-word !important;
      }

      /* Fix cho long URLs hoặc text không có space */
      .message-content {
        overflow-wrap: anywhere !important;
        word-break: break-word !important;
        hyphens: auto !important;
      }
    </style>
  </head>
  <body>
    <jsp:include page="layout/header.jsp" />

    <div class="chat-container">
      <div class="row g-0 h-100">
        <!-- Sidebar -->
        <div class="col-md-4 chat-sidebar">
          <div class="sidebar-header">
            <h5><i class="fa-solid fa-comments me-2"></i>Chat</h5>
            <small
              ><%=currentUser.getFirstName()%>
              <%=currentUser.getLastName()%></small
            >
          </div>

          <div class="contact-list" id="contactList">
            <div class="loading">
              <i class="fa-solid fa-spinner fa-spin me-2"></i>Đang tải danh
              sách...
            </div>
          </div>
        </div>

        <!-- Chat Area -->
        <div class="col-md-8">
          <div class="chat-main">
            <!-- Header -->
            <div class="chat-header">
              <div class="d-flex align-items-center">
                <div
                  class="contact-avatar"
                  style="background: #007bff"
                  id="currentAvatar"
                >
                  <i class="fa-solid fa-user"></i>
                </div>
                <div class="ms-3">
                  <h6 class="mb-0" id="currentName">Chọn người để chat</h6>
                  <small class="text-muted" id="currentStatus">Offline</small>
                </div>
              </div>
              <div>
                <button class="btn btn-outline-primary btn-sm">
                  <i class="fa-solid fa-phone"></i>
                </button>
              </div>
            </div>

            <!-- Messages -->
            <div class="chat-messages" id="chatMessages">
              <div class="no-messages">
                <i class="fa-solid fa-comments fa-3x mb-3 text-muted"></i>
                <h5>Chào mừng đến với Chat</h5>
                <% if (currentUser instanceof app.business.nguoidung.BenhNhan) {
                %>
                <p>Chọn bác sĩ từ danh sách bên trái để tư vấn sức khỏe</p>
                <% } else if (currentUser instanceof
                app.business.nguoidung.BacSi) { %>
                <p>Chọn bệnh nhân từ danh sách bên trái để hỗ trợ tư vấn</p>
                <% } else { %>
                <p>
                  Chọn một người từ danh sách bên trái để bắt đầu trò chuyện
                </p>
                <% } %>
              </div>
            </div>

            <!-- Input -->
            <div class="chat-input">
              <div class="input-group">
                <input
                  type="text"
                  class="form-control"
                  placeholder="Nhập tin nhắn..."
                  id="messageInput"
                  disabled
                />
                <button
                  class="btn btn-send"
                  onclick="sendMessage()"
                  id="sendBtn"
                  disabled
                >
                  <i class="fa-solid fa-paper-plane"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <jsp:include page="layout/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
      // Global variables
      let currentChatUserId = null;
      let allUsers = [];
      let messages = {};
      let currentUser = {
        id: "<%=currentUser.getUserId()%>",
        name: "<%=currentUser.getFirstName()%> <%=currentUser.getLastName()%>",
        firstName: "<%=currentUser.getFirstName()%>",
      };

      // Initialize when page loads
      document.addEventListener("DOMContentLoaded", function () {
        loadUsers();

        // Enter key to send message
        document
          .getElementById("messageInput")
          .addEventListener("keypress", function (e) {
            if (e.key === "Enter" && !this.disabled) {
              sendMessage();
            }
          });

        // Check for new messages every 3 seconds
        setInterval(checkNewMessages, 3000);
      });

      // Load all users
      function loadUsers() {
        console.log("Starting to load users...");
        fetch("api/chat-api.jsp?action=getUsers")
          .then((response) => {
            console.log("Response status:", response.status);
            console.log("Response ok:", response.ok);
            if (!response.ok) {
              return response.text().then((text) => {
                console.error("Error response:", text);
                throw new Error(
                  "Network response was not ok: " + response.status
                );
              });
            }
            return response.json();
          })
          .then((users) => {
            console.log("Users loaded:", users);
            allUsers = users;
            displayUsers();
          })
          .catch((error) => {
            console.error("Error loading users:", error);
            showError("Không thể tải danh sách người dùng: " + error.message);
            // Fallback to empty list
            allUsers = [];
            displayUsers();
          });
      }

      // Display users in sidebar
      function displayUsers() {
        const contactList = document.getElementById("contactList");
        contactList.innerHTML = "";

        allUsers.forEach((user, index) => {
          const contactDiv = document.createElement("div");
          contactDiv.className = "contact-item";
          contactDiv.onclick = () => selectUser(user);

          let statusHtml = "";
          let roleText = "";

          // Hiển thị vai trò
          if (user.type === "doctor") {
            roleText = "Bác sĩ";
          } else if (user.type === "patient") {
            roleText = "Bệnh nhân";
          } else if (user.type === "admin") {
            roleText = "Quản trị viên";
          } else {
            roleText = "Người dùng";
          }

          if (user.status === "online") {
            statusHtml =
              '<i class="fa-solid fa-circle text-success" style="font-size: 8px;"></i> Online • ' +
              roleText;
          } else {
            statusHtml = "Offline • " + roleText;
          }

          contactDiv.innerHTML =
            '<div class="d-flex align-items-center">' +
            '<div class="contact-avatar" style="background: ' +
            user.bgColor +
            '">' +
            user.avatar +
            "</div>" +
            '<div class="flex-grow-1">' +
            '<h6 class="mb-0">' +
            user.name +
            "</h6>" +
            '<small class="text-muted">' +
            statusHtml +
            "</small>" +
            "</div>" +
            "</div>";

          contactList.appendChild(contactDiv);
        });
      }

      // Select user to chat with
      function selectUser(user) {
        // Update active contact
        document.querySelectorAll(".contact-item").forEach((item) => {
          item.classList.remove("active");
        });
        event.currentTarget.classList.add("active");

        currentChatUserId = user.id;

        // Update header
        document.getElementById("currentName").textContent = user.name;

        // Hiển thị vai trò trong header
        let roleText = "";
        if (user.type === "doctor") {
          roleText = "Bác sĩ";
        } else if (user.type === "patient") {
          roleText = "Bệnh nhân";
        } else if (user.type === "admin") {
          roleText = "Quản trị viên";
        } else {
          roleText = "Người dùng";
        }

        const statusText = user.status === "online" ? "Online" : "Offline";
        document.getElementById("currentStatus").textContent =
          statusText + " • " + roleText;
        document.getElementById("currentAvatar").innerHTML = user.avatar;
        document.getElementById("currentAvatar").style.background =
          user.bgColor;

        // Enable input
        document.getElementById("messageInput").disabled = false;
        document.getElementById("sendBtn").disabled = false;

        // Load messages for this user
        loadMessages(user.id);
      }

      // Load messages for selected user
      function loadMessages(userId) {
        const chatMessages = document.getElementById("chatMessages");

        // Clear chat area and show loading
        chatMessages.innerHTML =
          '<div class="loading"><i class="fa-solid fa-spinner fa-spin me-2"></i>Đang tải tin nhắn...</div>';

        // Load messages from database
        fetch("api/chat-api.jsp?action=getConversation&userId=" + userId)
          .then((response) => {
            if (!response.ok) {
              throw new Error("Network response was not ok");
            }
            return response.json();
          })
          .then((messageList) => {
            // Store messages for this user
            messages[userId] = messageList;

            // Clear chat area
            chatMessages.innerHTML = "";

            if (messageList.length === 0) {
              chatMessages.innerHTML =
                '<div class="no-messages">' +
                '<i class="fa-solid fa-comment-dots fa-2x mb-3 text-muted"></i>' +
                "<p>Chưa có tin nhắn nào. Hãy bắt đầu cuộc trò chuyện!</p>" +
                "</div>";
              return;
            }

            // Display messages
            messageList.forEach((message) => {
              displayMessage(message);
            });

            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
          })
          .catch((error) => {
            console.error("Error loading messages:", error);
            chatMessages.innerHTML =
              '<div class="no-messages">' +
              '<i class="fa-solid fa-exclamation-triangle fa-2x mb-3 text-danger"></i>' +
              "<p>Không thể tải tin nhắn. Vui lòng thử lại!</p>" +
              "</div>";
          });
      }

      // Display a single message
      function displayMessage(message) {
        const chatMessages = document.getElementById("chatMessages");
        const messageDiv = document.createElement("div");
        messageDiv.className = `message ${message.type}`;

        if (message.type === "sent") {
          messageDiv.innerHTML =
            '<div class="message-content">' +
            message.content +
            '<span class="message-time">' +
            message.time +
            "</span>" +
            "</div>" +
            '<div class="contact-avatar" style="background: #28a745; width: 35px; height: 35px; font-size: 14px;">' +
            currentUser.firstName.charAt(0) +
            "</div>";
        } else {
          const user = allUsers.find((u) => u.id === currentChatUserId);
          messageDiv.innerHTML =
            '<div class="contact-avatar" style="background: ' +
            user.bgColor +
            '; width: 35px; height: 35px; font-size: 14px;">' +
            user.avatar +
            "</div>" +
            '<div class="message-content">' +
            message.content +
            '<span class="message-time">' +
            message.time +
            "</span>" +
            "</div>";
        }

        chatMessages.appendChild(messageDiv);
      }

      // Send message
      function sendMessage() {
        const messageInput = document.getElementById("messageInput");
        const content = messageInput.value.trim();

        if (!content || !currentChatUserId) return;

        // Disable input while sending
        messageInput.disabled = true;
        document.getElementById("sendBtn").disabled = true;

        // Send message to server
        const formData = new URLSearchParams();
        formData.append("action", "sendMessage");
        formData.append("receiverId", currentChatUserId);
        formData.append("message", content);

        fetch("api/chat-api.jsp", {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          },
          body: formData,
        })
          .then((response) => {
            console.log("Send message response status:", response.status);
            if (!response.ok) {
              return response.text().then((text) => {
                console.error("Send message error response:", text);
                throw new Error(
                  "Network response was not ok: " +
                    response.status +
                    " - " +
                    text
                );
              });
            }
            return response.json();
          })
          .then((data) => {
            if (data.success) {
              // Add message to local array
              if (!messages[currentChatUserId]) {
                messages[currentChatUserId] = [];
              }
              messages[currentChatUserId].push(data.message);

              // Display message
              displayMessage(data.message);

              // Clear input
              messageInput.value = "";

              // Scroll to bottom
              const chatMessages = document.getElementById("chatMessages");
              chatMessages.scrollTop = chatMessages.scrollHeight;

              showSuccess("Tin nhắn đã được gửi");
            } else {
              throw new Error(data.error || "Unknown error");
            }
          })
          .catch((error) => {
            console.error("Error sending message:", error);
            showError("Không thể gửi tin nhắn: " + error.message);
          })
          .finally(() => {
            // Re-enable input
            messageInput.disabled = false;
            document.getElementById("sendBtn").disabled = false;
            messageInput.focus();
          });
      }

      // Check for new messages periodically
      function checkNewMessages() {
        if (!currentChatUserId || !messages[currentChatUserId]) {
          return;
        }

        const lastMessage =
          messages[currentChatUserId].length > 0
            ? messages[currentChatUserId][
                messages[currentChatUserId].length - 1
              ]
            : null;
        const lastMessageId = lastMessage ? lastMessage.id : 0;

        fetch(
          "api/chat-api.jsp?action=getNewMessages&userId=" +
            currentChatUserId +
            "&lastMessageId=" +
            lastMessageId
        )
          .then((response) => {
            if (!response.ok) {
              throw new Error("Network response was not ok");
            }
            return response.json();
          })
          .then((newMessages) => {
            if (newMessages.length > 0) {
              // Add new messages to array
              newMessages.forEach((message) => {
                messages[currentChatUserId].push(message);
                displayMessage(message);
              });

              // Scroll to bottom
              const chatMessages = document.getElementById("chatMessages");
              chatMessages.scrollTop = chatMessages.scrollHeight;
            }
          })
          .catch((error) => {
            console.error("Error checking new messages:", error);
          });
      }

      // Utility functions
      function showError(message) {
        // Tạo toast notification cho lỗi
        const toast = document.createElement("div");
        toast.className = "position-fixed top-0 end-0 p-3";
        toast.style.zIndex = "1050";
        toast.innerHTML =
          '<div class="toast show" role="alert">' +
          '<div class="toast-header bg-danger text-white">' +
          '<i class="fa-solid fa-exclamation-triangle me-2"></i>' +
          '<strong class="me-auto">Lỗi</strong>' +
          '<button type="button" class="btn-close btn-close-white" onclick="this.closest(\'.position-fixed\').remove()"></button>' +
          "</div>" +
          '<div class="toast-body">' +
          message +
          "</div>" +
          "</div>";
        document.body.appendChild(toast);

        // Auto remove after 5 seconds
        setTimeout(() => {
          if (toast.parentNode) {
            toast.remove();
          }
        }, 5000);
      }

      function showSuccess(message) {
        // Tạo toast notification cho thành công
        const toast = document.createElement("div");
        toast.className = "position-fixed top-0 end-0 p-3";
        toast.style.zIndex = "1050";
        toast.innerHTML =
          '<div class="toast show" role="alert">' +
          '<div class="toast-header bg-success text-white">' +
          '<i class="fa-solid fa-check-circle me-2"></i>' +
          '<strong class="me-auto">Thành công</strong>' +
          '<button type="button" class="btn-close btn-close-white" onclick="this.closest(\'.position-fixed\').remove()"></button>' +
          "</div>" +
          '<div class="toast-body">' +
          message +
          "</div>" +
          "</div>";
        document.body.appendChild(toast);

        // Auto remove after 3 seconds
        setTimeout(() => {
          if (toast.parentNode) {
            toast.remove();
          }
        }, 3000);
      }
    </script>
  </body>
</html>
