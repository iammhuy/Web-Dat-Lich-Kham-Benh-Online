package app.business.giaodich;

import app.business.nguoidung.User;
import java.io.Serializable;
import java.time.LocalDateTime;
import javax.persistence.*;

@Entity
@Table(name = "ChatMessage")
public class ChatMessage implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "messageId")
    private Long messageId;

    @ManyToOne
    @JoinColumn(name = "senderId", nullable = false)
    private User sender;

    @ManyToOne
    @JoinColumn(name = "receiverId", nullable = false)
    private User receiver;

    @Column(name = "message", nullable = false, columnDefinition = "TEXT")
    private String message;

    @Column(name = "sentTime", nullable = false)
    private LocalDateTime sentTime;

    @Column(name = "isRead", nullable = false)
    private boolean isRead = false;

    // Constructors
    public ChatMessage() {
        this.sentTime = LocalDateTime.now();
    }

    public ChatMessage(User sender, User receiver, String message) {
        this();
        this.sender = sender;
        this.receiver = receiver;
        this.message = message;
    }

    // Getters and Setters
    public Long getMessageId() {
        return messageId;
    }

    public void setMessageId(Long messageId) {
        this.messageId = messageId;
    }

    public User getSender() {
        return sender;
    }

    public void setSender(User sender) {
        this.sender = sender;
    }

    public User getReceiver() {
        return receiver;
    }

    public void setReceiver(User receiver) {
        this.receiver = receiver;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getSentTime() {
        return sentTime;
    }

    public void setSentTime(LocalDateTime sentTime) {
        this.sentTime = sentTime;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }

    @Override
    public String toString() {
        return "ChatMessage{" +
                "messageId=" + messageId +
                ", senderId=" + (sender != null ? sender.getUserId() : null) +
                ", receiverId=" + (receiver != null ? receiver.getUserId() : null) +
                ", message='" + message + '\'' +
                ", sentTime=" + sentTime +
                ", isRead=" + isRead +
                '}';
    }
}