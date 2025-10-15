package app.database;

import app.business.giaodich.ChatMessage;
import app.business.nguoidung.User;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;
import javax.persistence.TypedQuery;

public class ChatMessageDB {

    // Sử dụng cùng EntityManagerFactory như các class khác
    private static EntityManagerFactory getEmf() {
        return DBUtil.getEmFactory();
    }

    // Gửi tin nhắn mới
    public static void sendMessage(ChatMessage message) {
        EntityManager em = null;
        try {
            em = getEmf().createEntityManager();
            em.getTransaction().begin();
            em.persist(message);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error sending message", e);
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    // Lấy danh sách tin nhắn giữa hai user
    public static List<ChatMessage> getConversation(Long userId1, Long userId2) {
        EntityManager em = null;
        try {
            em = getEmf().createEntityManager();
            String jpql = "SELECT c FROM ChatMessage c " +
                    "WHERE (c.sender.userId = :user1 AND c.receiver.userId = :user2) " +
                    "OR (c.sender.userId = :user2 AND c.receiver.userId = :user1) " +
                    "ORDER BY c.sentTime ASC";

            TypedQuery<ChatMessage> query = em.createQuery(jpql, ChatMessage.class);
            query.setParameter("user1", userId1);
            query.setParameter("user2", userId2);

            return query.getResultList();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    // Lấy tin nhắn mới trong cuộc trò chuyện (sau thời điểm lastMessageId)
    public static List<ChatMessage> getNewMessages(Long userId1, Long userId2, Long lastMessageId) {
        EntityManager em = null;
        try {
            em = getEmf().createEntityManager();
            String jpql = "SELECT c FROM ChatMessage c " +
                    "WHERE ((c.sender.userId = :user1 AND c.receiver.userId = :user2) " +
                    "OR (c.sender.userId = :user2 AND c.receiver.userId = :user1)) " +
                    "AND c.messageId > :lastMessageId " +
                    "ORDER BY c.sentTime ASC";

            TypedQuery<ChatMessage> query = em.createQuery(jpql, ChatMessage.class);
            query.setParameter("user1", userId1);
            query.setParameter("user2", userId2);
            query.setParameter("lastMessageId", lastMessageId != null ? lastMessageId : 0L);

            return query.getResultList();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    // Lấy danh sách những người đã chat với user
    public static List<User> getChatContacts(Long userId) {
        EntityManager em = null;
        try {
            em = getEmf().createEntityManager();
            String jpql = "SELECT DISTINCT u FROM User u WHERE u.userId IN (" +
                    "SELECT c.sender.userId FROM ChatMessage c WHERE c.receiver.userId = :userId " +
                    "UNION " +
                    "SELECT c.receiver.userId FROM ChatMessage c WHERE c.sender.userId = :userId" +
                    ")";

            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("userId", userId);

            return query.getResultList();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    // Đánh dấu tin nhắn đã đọc
    public static void markMessagesAsRead(Long senderId, Long receiverId) {
        EntityManager em = null;
        try {
            em = getEmf().createEntityManager();
            em.getTransaction().begin();

            String jpql = "UPDATE ChatMessage c SET c.isRead = true " +
                    "WHERE c.sender.userId = :senderId AND c.receiver.userId = :receiverId " +
                    "AND c.isRead = false";

            Query query = em.createQuery(jpql);
            query.setParameter("senderId", senderId);
            query.setParameter("receiverId", receiverId);
            query.executeUpdate();

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error marking messages as read", e);
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    // Đếm tin nhắn chưa đọc
    public static int getUnreadMessageCount(Long userId) {
        EntityManager em = null;
        try {
            em = getEmf().createEntityManager();
            String jpql = "SELECT COUNT(c) FROM ChatMessage c " +
                    "WHERE c.receiver.userId = :userId AND c.isRead = false";

            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            query.setParameter("userId", userId);

            Long count = query.getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    // Lấy tin nhắn cuối cùng với một user cụ thể
    public static ChatMessage getLastMessage(Long userId1, Long userId2) {
        EntityManager em = null;
        try {
            em = getEmf().createEntityManager();
            String jpql = "SELECT c FROM ChatMessage c " +
                    "WHERE (c.sender.userId = :user1 AND c.receiver.userId = :user2) " +
                    "OR (c.sender.userId = :user2 AND c.receiver.userId = :user1) " +
                    "ORDER BY c.sentTime DESC";

            TypedQuery<ChatMessage> query = em.createQuery(jpql, ChatMessage.class);
            query.setParameter("user1", userId1);
            query.setParameter("user2", userId2);
            query.setMaxResults(1);

            List<ChatMessage> results = query.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    // Xóa cuộc trò chuyện
    public static void deleteConversation(Long userId1, Long userId2) {
        EntityManager em = null;
        try {
            em = getEmf().createEntityManager();
            em.getTransaction().begin();

            String jpql = "DELETE FROM ChatMessage c " +
                    "WHERE (c.sender.userId = :user1 AND c.receiver.userId = :user2) " +
                    "OR (c.sender.userId = :user2 AND c.receiver.userId = :user1)";

            Query query = em.createQuery(jpql);
            query.setParameter("user1", userId1);
            query.setParameter("user2", userId2);
            query.executeUpdate();

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting conversation", e);
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
}