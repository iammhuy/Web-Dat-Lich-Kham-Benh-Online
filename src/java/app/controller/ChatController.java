package app.controller;

import app.business.giaodich.ChatMessage;
import app.business.nguoidung.User;
import app.database.ChatMessageDB;
import app.database.UserDB;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ChatController", urlPatterns = {"/chat"})
public class ChatController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                showChatList(request, response, currentUser);
                break;
            case "conversation":
                showConversation(request, response, currentUser);
                break;
            case "api":
                handleApiRequest(request, response, currentUser);
                break;
            default:
                showChatList(request, response, currentUser);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");
        
        switch (action) {
            case "sendMessage":
                sendMessage(request, response, currentUser);
                break;
            case "markAsRead":
                markAsRead(request, response, currentUser);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void showChatList(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        List<User> contacts = ChatMessageDB.getChatContacts(currentUser.getUserId());
        List<User> allUsers = UserDB.selectAllUsers();
        
        request.setAttribute("contacts", contacts);
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("/chat/chat-list.jsp").forward(request, response);
    }

    private void showConversation(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String otherUserIdStr = request.getParameter("userId");
        if (otherUserIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/chat");
            return;
        }

        try {
            Long otherUserId = Long.parseLong(otherUserIdStr);
            User otherUser = UserDB.selectUser(otherUserId);
            
            if (otherUser == null) {
                response.sendRedirect(request.getContextPath() + "/chat");
                return;
            }

            List<ChatMessage> messages = ChatMessageDB.getConversation(
                currentUser.getUserId(), otherUserId);
            
            // Đánh dấu tin nhắn đã đọc
            ChatMessageDB.markMessagesAsRead(otherUserId, currentUser.getUserId());

            request.setAttribute("messages", messages);
            request.setAttribute("otherUser", otherUser);
            request.setAttribute("currentUser", currentUser);
            
            request.getRequestDispatcher("/chat/conversation.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/chat");
        }
    }

    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String apiAction = request.getParameter("apiAction");
        
        switch (apiAction) {
            case "getNewMessages":
                getNewMessages(request, response, currentUser);
                break;
            case "getUnreadCount":
                getUnreadCount(request, response, currentUser);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void getNewMessages(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        
        String otherUserIdStr = request.getParameter("userId");
        String lastMessageIdStr = request.getParameter("lastMessageId");
        
        if (otherUserIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            Long otherUserId = Long.parseLong(otherUserIdStr);
            Long lastMessageId = lastMessageIdStr != null ? Long.parseLong(lastMessageIdStr) : 0L;
            
            List<ChatMessage> newMessages = ChatMessageDB.getNewMessages(
                currentUser.getUserId(), otherUserId, lastMessageId);
            
            // Tạo JSON response đơn giản
            StringBuilder json = new StringBuilder();
            json.append("[");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            
            for (int i = 0; i < newMessages.size(); i++) {
                ChatMessage msg = newMessages.get(i);
                json.append("{");
                json.append("\"messageId\":").append(msg.getMessageId()).append(",");
                json.append("\"senderId\":").append(msg.getSender().getUserId()).append(",");
                json.append("\"senderName\":\"").append(escapeJson(msg.getSender().getFirstName() + " " + msg.getSender().getLastName())).append("\",");
                json.append("\"message\":\"").append(escapeJson(msg.getMessage())).append("\",");
                json.append("\"sentTime\":\"").append(msg.getSentTime().format(formatter)).append("\",");
                json.append("\"isRead\":").append(msg.isRead());
                json.append("}");
                if (i < newMessages.size() - 1) json.append(",");
            }
            json.append("]");
            
            response.getWriter().write(json.toString());
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void sendMessage(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        
        String receiverIdStr = request.getParameter("receiverId");
        String messageText = request.getParameter("message");
        
        if (receiverIdStr == null || messageText == null || messageText.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            Long receiverId = Long.parseLong(receiverIdStr);
            User receiver = UserDB.selectUser(receiverId);
            
            if (receiver == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            ChatMessage message = new ChatMessage(currentUser, receiver, messageText.trim());
            ChatMessageDB.sendMessage(message);
            
            // Redirect về conversation
            response.sendRedirect(request.getContextPath() + "/chat?action=conversation&userId=" + receiverId);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void markAsRead(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        
        String senderIdStr = request.getParameter("senderId");
        
        if (senderIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            Long senderId = Long.parseLong(senderIdStr);
            ChatMessageDB.markMessagesAsRead(senderId, currentUser.getUserId());
            
            response.getWriter().write("{\"success\":true}");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void getUnreadCount(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        
        int unreadCount = ChatMessageDB.getUnreadMessageCount(currentUser.getUserId());
        response.getWriter().write("{\"unreadCount\":" + unreadCount + "}");
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}