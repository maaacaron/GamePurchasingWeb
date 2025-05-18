package model;

public class User {
    private int id;
    private String userId;
    private String PassWord;
    private String name;
    private String email;
    private boolean isAdmin;

    public User() {}

    public User(int id, String userId, String PassWord, String name, String email, boolean isAdmin) {
        this.id = id;
        this.userId = userId;
        this.PassWord = PassWord;
        this.name = name;
        this.email = email;
        this.isAdmin = isAdmin;
    }

    // Getter
    public int getId() {
        return id;
    }

    public String getUserId() {
        return userId;
    }

    public String getPassword() {
        return PassWord;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    // Setter
    public void setId(int id) {
        this.id = id;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setPassword(String PassWord) {
        this.PassWord = PassWord;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setAdmin(boolean isAdmin) {
        this.isAdmin = isAdmin;
    }
}
