package com.moecode.Ecommerce.service;

import com.moecode.Ecommerce.dto.OrderRequest;
import com.moecode.Ecommerce.model.*;
import com.moecode.Ecommerce.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;

    public OrderService(OrderRepository orderRepository, ProductRepository productRepository) {
        this.orderRepository = orderRepository;
        this.productRepository = productRepository;
    }

    @Transactional
    public Order placeOrder(User user, List<OrderRequest.Item> itemsRequest) {
        List<OrderItem> orderItems = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;

        for (OrderRequest.Item reqItem : itemsRequest) {
            Product product = productRepository.findById(reqItem.productId)
                    .orElseThrow(() -> new RuntimeException("Product not found"));

            if (product.getStock() < reqItem.quantity) {
                throw new RuntimeException("Insufficient stock for product: " + product.getName());
            }

            // Decrement stock
            product.setStock(product.getStock() - reqItem.quantity);
            productRepository.save(product);

            OrderItem orderItem = new OrderItem();
            orderItem.setProduct(product);
            orderItem.setQuantity(reqItem.quantity);
            orderItem.setPriceAtPurchase(product.getPrice());
            orderItems.add(orderItem);

            total = total.add(product.getPrice().multiply(BigDecimal.valueOf(reqItem.quantity)));
        }

        Order order = new Order();
        order.setUser(user);
        order.setItems(orderItems);
        order.setTotal(total);
        order.setCreatedAt(LocalDateTime.now());

        orderItems.forEach(oi -> oi.setOrder(order));

        return orderRepository.save(order);
    }

    public List<Order> getUserOrders(User user) {
        return orderRepository.findByUser(user);
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }
}
