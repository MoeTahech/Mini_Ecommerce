package com.moecode.Ecommerce.repository;

import com.moecode.Ecommerce.model.Order;
import com.moecode.Ecommerce.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByUser(User user);
}
