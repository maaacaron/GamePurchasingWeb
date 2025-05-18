package model;

public class CartItem {
    private Game game;
    private int quantity;

    // 기본 생성자
    public CartItem() {}

    // 생성자 (선택)
    public CartItem(Game game, int quantity) {
        this.game = game;
        this.quantity = quantity;
    }

    // Getter
    public Game getGame() {
        return game;
    }

    public int getQuantity() {
        return quantity;
    }

    // Setter
    public void setGame(Game game) {
        this.game = game;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
