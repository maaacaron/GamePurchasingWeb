package model;

public class Game {
    private int id;
    private String name;
    private String image;
    private String genre;
    private int price;
    private boolean discount;

    public Game(int id, String name, String image, String genre, int price, boolean discount) {
        this.id = id;
        this.name = name;
        this.image = image != null ? image : "";
        this.genre = genre != null ? genre : "";
        this.price = price;
        this.discount = discount;
    }

    public int getId() { return id;}

    public String getName() { return name;}

    public String getImage() { return image;}

    public String getGenre() { return genre;}

    public int getPrice() { return price;}

    public boolean isDiscount() { return discount;}
}
