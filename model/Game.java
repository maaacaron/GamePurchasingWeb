package model;

public class Game {
    private int id;
    private String name;
    private String image;
    private String link;
    private String description;
    private String genre;
    private int price;
    private boolean discount;

    public Game(int id, String name, String image, String link, String description, String genre, int price, boolean discount) {
        this.id = id;
        this.name = name;
        this.image = image;
        this.link = link;
        this.description = description;
        this.genre = genre;
        this.price = price;
        this.discount = discount;
    }

    // Getter 메서드 생략 가능 시 자동 생성
    public int getId() { return id; }
    public String getName() { return name; }
    public String getImage() { return image; }
    public String getLink() { return link; }
    public String getDescription() { return description; }
    public String getGenre() { return genre; }
    public int getPrice() { return price; }
    public boolean isDiscount() { return discount; }
}

