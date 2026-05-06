/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class ProductSize {
    private int id;
    private int productId;
    private String size;

    public ProductSize() {
    }

    public ProductSize(int id, int productId, String size) {
        this.id = id;
        this.productId = productId;
        this.size = size;
    }

    public int getId() {
        return id;
    }

    public int getProductId() {
        return productId;
    }

    public String getSize() {
        return size;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setSize(String size) {
        this.size = size;
    }
    
}