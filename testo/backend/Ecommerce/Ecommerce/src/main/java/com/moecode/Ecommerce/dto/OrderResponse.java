package com.moecode.Ecommerce.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class OrderResponse {
    public Long orderId;
    public List<ItemResponse> items;
    public BigDecimal total;
    public LocalDateTime createdAt;

    public static class ItemResponse {
        public String productName;
        public int quantity;
        public BigDecimal price;
    }
}
