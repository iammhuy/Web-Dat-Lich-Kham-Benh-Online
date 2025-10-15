<%@page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="app.business.nguoidung.User"%>
<%@page import="app.business.nguoidung.BacSi"%>
<%@page import="app.business.nguoidung.BenhNhan"%>
<%@page import="app.business.nguoidung.QuanTriVien"%>
<%@page import="app.business.giaodich.ChatMessage"%>
<%@page import="app.database.UserDB"%>
<%@page import="app.database.ChatMessageDB"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%
    // Thiết lập encoding cho request và response
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");
    response.setCharacterEncoding("UTF-8");
    
    // Kiểm tra user đăng nhập
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.setStatus(401);
        out.print("{\"error\": \"Unauthorized\"}");
        return;
    }
    
    String action = request.getParameter("action");
    if (action == null) {
        response.setStatus(400);
        out.print("{\"error\": \"Missing action parameter\"}");
        return;
    }
    
    try {
        if ("getUsers".equals(action)) {
            // Lấy danh sách tất cả users (trừ current user)
            List<User> allUsers = UserDB.selectAllUsers();
            
            // Debug: log số lượng users và current user info
            System.out.println("=== GET USERS DEBUG (Role-based filtering) ===");
            System.out.println("Total users found: " + (allUsers != null ? allUsers.size() : "null"));
            System.out.println("Current user: " + currentUser.getFirstName() + " " + currentUser.getLastName() + " (ID=" + currentUser.getUserId() + ", Class=" + currentUser.getClass().getSimpleName() + ")");
            
            String filterRule = "";
            if (currentUser instanceof BenhNhan) {
                filterRule = "BenhNhan -> chỉ hiển thị BacSi";
            } else if (currentUser instanceof BacSi) {
                filterRule = "BacSi -> chỉ hiển thị BenhNhan";
            } else if (currentUser instanceof QuanTriVien) {
                filterRule = "QuanTriVien -> hiển thị tất cả";
            }
            System.out.println("Filter rule: " + filterRule);
            
            // Sử dụng Set để tránh duplicate users
            java.util.Set<Long> addedUserIds = new java.util.HashSet<>();
            
            StringBuilder usersJson = new StringBuilder();
            usersJson.append("[");
            
            boolean first = true;
            int addedCount = 0;
            int skippedCount = 0;
            if (allUsers != null) {
                for (User user : allUsers) {
                    // Debug: Log user details
                    String userName = user.getFirstName() + " " + user.getLastName();
                    System.out.println("DEBUG - Processing user: " + userName + " (ID=" + user.getUserId() + ", Class=" + user.getClass().getSimpleName() + ")");
                    
                    // Skip nếu là current user
                    if (user.getUserId() != null && currentUser.getUserId() != null && 
                        user.getUserId().equals(currentUser.getUserId())) {
                        System.out.println("DEBUG - SKIPPING current user: " + userName + " (ID=" + user.getUserId() + ")");
                        skippedCount++;
                        continue;
                    }
                    
                    // Skip nếu đã thêm user này rồi (tránh duplicate)
                    if (addedUserIds.contains(user.getUserId())) {
                        System.out.println("DEBUG - SKIPPING duplicate user: " + userName + " (ID=" + user.getUserId() + ")");
                        skippedCount++;
                        continue;
                    }
                    
                    // Lọc theo quy tắc: Bệnh nhân chỉ chat với Bác sĩ
                    boolean shouldInclude = false;
                    if (currentUser instanceof BenhNhan) {
                        // Nếu current user là bệnh nhân, chỉ hiển thị bác sĩ
                        if (user instanceof BacSi) {
                            shouldInclude = true;
                        }
                    } else if (currentUser instanceof BacSi) {
                        // Nếu current user là bác sĩ, chỉ hiển thị bệnh nhân
                        if (user instanceof BenhNhan) {
                            shouldInclude = true;
                        }
                    } else if (currentUser instanceof QuanTriVien) {
                        // Admin có thể chat với tất cả (giữ nguyên để admin quản lý)
                        shouldInclude = true;
                    }
                    
                    if (!shouldInclude) {
                        System.out.println("DEBUG - SKIPPING user (role restriction): " + userName + " (ID=" + user.getUserId() + ", Class=" + user.getClass().getSimpleName() + ")");
                        skippedCount++;
                        continue;
                    }
                    
                    // Thêm vào Set để track
                    addedUserIds.add(user.getUserId());
                    
                    System.out.println("DEBUG - ADDING user to list: " + userName + " (ID=" + user.getUserId() + ")");
                    
                    if (!first) usersJson.append(",");
                    first = false;
                    addedCount++;
                    
                    // Xác định user type dựa trên class
                    String userType = "user";
                    if (user instanceof BacSi) {
                        userType = "doctor";
                    } else if (user instanceof BenhNhan) {
                        userType = "patient";
                    } else if (user instanceof QuanTriVien) {
                        userType = "admin";
                    }
                    
                    // Kiểm tra null cho firstName
                    String firstName = user.getFirstName() != null ? user.getFirstName() : "";
                    String lastName = user.getLastName() != null ? user.getLastName() : "";
                    String fullName = (firstName + " " + lastName).trim();
                    if (fullName.isEmpty()) {
                        fullName = user.getEmail(); // Fallback to email
                    }
                    
                    usersJson.append("{");
                    usersJson.append("\"id\":").append(user.getUserId()).append(",");
                    usersJson.append("\"name\":\"").append(escapeJson(fullName)).append("\",");
                    usersJson.append("\"type\":\"").append(userType).append("\",");
                    usersJson.append("\"status\":\"online\",");
                    usersJson.append("\"avatar\":\"").append(firstName.isEmpty() ? "U" : firstName.substring(0, 1).toUpperCase()).append("\",");
                    
                    // Màu avatar dựa trên user type
                    String bgColor = "#007bff";
                    if ("doctor".equals(userType)) {
                        bgColor = "#28a745";
                    } else if ("admin".equals(userType)) {
                        bgColor = "#dc3545";
                    } else if ("patient".equals(userType)) {
                        bgColor = "#ffc107";
                    }
                    usersJson.append("\"bgColor\":\"").append(bgColor).append("\"");
                    usersJson.append("}");
                }
            }
            usersJson.append("]");
            
            System.out.println("Final result: Added " + addedCount + " users, Skipped " + skippedCount + " users (current user + duplicates)");
            System.out.println("Added user IDs: " + addedUserIds.toString());
            System.out.println("JSON Response: " + usersJson.toString());
            System.out.println("=== END GET USERS DEBUG ===");
            
            out.print(usersJson.toString());
            
        } else if ("getConversation".equals(action)) {
            String otherUserIdStr = request.getParameter("userId");
            if (otherUserIdStr == null) {
                response.setStatus(400);
                out.print("{\"error\": \"Missing userId parameter\"}");
                return;
            }
            
            Long otherUserId = Long.parseLong(otherUserIdStr);
            List<ChatMessage> messages = ChatMessageDB.getConversation(currentUser.getUserId(), otherUserId);
            
            StringBuilder messagesJson = new StringBuilder();
            messagesJson.append("[");
            
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
            for (int i = 0; i < messages.size(); i++) {
                ChatMessage msg = messages.get(i);
                
                if (i > 0) messagesJson.append(",");
                
                messagesJson.append("{");
                messagesJson.append("\"id\":").append(msg.getMessageId()).append(",");
                messagesJson.append("\"content\":\"").append(escapeJson(msg.getMessage())).append("\",");
                
                // Xác định type: sent (nếu current user gửi) hoặc received
                String type = msg.getSender().getUserId().equals(currentUser.getUserId()) ? "sent" : "received";
                messagesJson.append("\"type\":\"").append(type).append("\",");
                
                messagesJson.append("\"time\":\"").append(msg.getSentTime().format(timeFormatter)).append("\",");
                messagesJson.append("\"timestamp\":\"").append(msg.getSentTime().toString()).append("\"");
                messagesJson.append("}");
            }
            messagesJson.append("]");
            out.print(messagesJson.toString());
            
        } else if ("sendMessage".equals(action)) {
            String receiverIdStr = request.getParameter("receiverId");
            String messageText = request.getParameter("message");
            
            if (receiverIdStr == null || messageText == null || messageText.trim().isEmpty()) {
                response.setStatus(400);
                out.print("{\"error\": \"Missing parameters\"}");
                return;
            }
            
            Long receiverId = Long.parseLong(receiverIdStr);
            User receiver = UserDB.selectUser(receiverId);
            
            if (receiver == null) {
                response.setStatus(400);
                out.print("{\"error\": \"Receiver not found\"}");
                return;
            }
            
            try {
                // Tạo tin nhắn mới
                ChatMessage newMessage = new ChatMessage(currentUser, receiver, messageText.trim());
                System.out.println("Created message: " + newMessage.getMessage());
                
                // Lưu tin nhắn vào database
                ChatMessageDB.sendMessage(newMessage);
                System.out.println("Message saved with ID: " + newMessage.getMessageId());
                
                // Trả về thông tin tin nhắn vừa gửi
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
                StringBuilder result = new StringBuilder();
                result.append("{");
                result.append("\"success\":true,");
                result.append("\"message\":{");
                result.append("\"id\":").append(newMessage.getMessageId()).append(",");
                result.append("\"content\":\"").append(escapeJson(newMessage.getMessage())).append("\",");
                result.append("\"type\":\"sent\",");
                result.append("\"time\":\"").append(newMessage.getSentTime().format(formatter)).append("\",");
                result.append("\"timestamp\":\"").append(newMessage.getSentTime().toString()).append("\"");
                result.append("}");
                result.append("}");
                
                out.print(result.toString());
                
            } catch (Exception e) {
                System.err.println("Error sending message: " + e.getMessage());
                e.printStackTrace();
                response.setStatus(500);
                out.print("{\"error\": \"Failed to send message: " + escapeJson(e.getMessage()) + "\"}");
                return;
            }
            
        } else if ("getNewMessages".equals(action)) {
            String userIdStr = request.getParameter("userId");
            String lastMessageIdStr = request.getParameter("lastMessageId");
            
            if (userIdStr == null) {
                response.setStatus(400);
                out.print("{\"error\": \"Missing userId parameter\"}");
                return;
            }
            
            Long userId = Long.parseLong(userIdStr);
            Long lastMessageId = lastMessageIdStr != null ? Long.parseLong(lastMessageIdStr) : 0L;
            
            List<ChatMessage> newMessages = ChatMessageDB.getNewMessages(currentUser.getUserId(), userId, lastMessageId);
            
            StringBuilder newMessagesJson = new StringBuilder();
            newMessagesJson.append("[");
            
            DateTimeFormatter newTimeFormatter = DateTimeFormatter.ofPattern("HH:mm");
            for (int i = 0; i < newMessages.size(); i++) {
                ChatMessage msg = newMessages.get(i);
                
                if (i > 0) newMessagesJson.append(",");
                
                newMessagesJson.append("{");
                newMessagesJson.append("\"id\":").append(msg.getMessageId()).append(",");
                newMessagesJson.append("\"content\":\"").append(escapeJson(msg.getMessage())).append("\",");
                
                String msgType = msg.getSender().getUserId().equals(currentUser.getUserId()) ? "sent" : "received";
                newMessagesJson.append("\"type\":\"").append(msgType).append("\",");
                
                newMessagesJson.append("\"time\":\"").append(msg.getSentTime().format(newTimeFormatter)).append("\",");
                newMessagesJson.append("\"timestamp\":\"").append(msg.getSentTime().toString()).append("\"");
                newMessagesJson.append("}");
            }
            newMessagesJson.append("]");
            out.print(newMessagesJson.toString());
            
        } else {
            response.setStatus(400);
            out.print("{\"error\": \"Invalid action\"}");
        }
        
    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"error\": \"" + escapeJson(e.getMessage()) + "\"}");
        e.printStackTrace();
    }
%>

<%!
    // Utility method để escape JSON strings và hỗ trợ tiếng Việt
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
%>