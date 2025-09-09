package com.moecode.Ecommerce.controller;

import com.moecode.Ecommerce.model.*;
import com.moecode.Ecommerce.dto.*;
import com.moecode.Ecommerce.service.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService){
        this.orderService = orderService;
    }

    @PostMapping("/orders")
    public ResponseEntity<Order> placeOrder(@AuthenticationPrincipal User user,
                                            @RequestBody OrderRequest request) {
        return new ResponseEntity<>(orderService.placeOrder(user, request.items), HttpStatus.CREATED);
    }

    @GetMapping("/orders/me")
    public ResponseEntity<List<Order>> getMyOrders(@AuthenticationPrincipal User user) {
        return new ResponseEntity<>(orderService.getUserOrders(user), HttpStatus.OK);
    }

    @GetMapping("/admin/orders")
    public ResponseEntity<List<Order>> getAllOrders() {
        return new ResponseEntity<>(orderService.getAllOrders(), HttpStatus.OK);
    }
}
