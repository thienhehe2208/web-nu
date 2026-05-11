package model;

import java.util.List;

public class Product {

    private int id;
    private int categoryId;
    private String sku;
    private String name;
    private double price;
    private Double discountPrice;
    private String image;
    private String description;
    private boolean isNew;
    private boolean isBestseller;
    private int stock;
    private List<String> sizes;

    public Product() {
    }

    public Product(int id, int categoryId, String sku, String name,
            double price, Double discountPrice,
            String image, String description,
            boolean isNew, boolean isBestseller,
            int stock, List<String> sizes) {

        this.id = id;
        this.categoryId = categoryId;
        this.sku = sku;
        this.name = name;
        this.price = price;
        this.discountPrice = discountPrice;
        this.image = image;
        this.description = description;
        this.isNew = isNew;
        this.isBestseller = isBestseller;
        this.stock = stock;
        this.sizes = sizes;
    }

    public int getId() {
        return id;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public String getSku() {
        return sku;
    }

    public String getName() {
        return name;
    }

    public double getPrice() {
        return price;
    }

    public Double getDiscountPrice() {
        return discountPrice;
    }

    public String getImage() {
        return image;
    }

    public String getDescription() {
        return description;
    }

    public boolean isIsNew() {
        return isNew;
    }

    public boolean isIsBestseller() {
        return isBestseller;
    }

    public int getStock() {
        return stock;
    }

    public List<String> getSizes() {
        return sizes;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setDiscountPrice(Double discountPrice) {
        this.discountPrice = discountPrice;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setIsNew(boolean isNew) {
        this.isNew = isNew;
    }

    public void setIsBestseller(boolean isBestseller) {
        this.isBestseller = isBestseller;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public void setSizes(List<String> sizes) {
        this.sizes = sizes;
    }
}