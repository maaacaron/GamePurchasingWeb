package model;

import java.sql.Timestamp;

public class Post {
    private int id;
    private String title;
    private String author;
    private Timestamp createdAt;

    // 기본 생성자
    public Post() {}

    // Getter
    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getAuthor() {
        return author;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    // Setter
    public void setId(int id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
