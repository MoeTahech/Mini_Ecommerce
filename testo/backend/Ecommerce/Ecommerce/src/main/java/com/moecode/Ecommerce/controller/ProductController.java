package com.moecode.Ecommerce.controller;

import com.moecode.Ecommerce.model.Product;
import com.moecode.Ecommerce.service.ProductService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService){
        this.productService = productService;
    }

    // Get all products (User)
    @GetMapping("/products")
    public ResponseEntity<List<Product>> getProducts() {
        return new ResponseEntity<>(productService.getAllProducts(), HttpStatus.OK);
    }

    // Add product (Admin)
    @PostMapping("/products")
    public ResponseEntity<Product> addProduct(@RequestBody Product product) {
        return new ResponseEntity<>(productService.addProduct(product), HttpStatus.CREATED);
    }

    // Get low-stock products (Admin)
    @GetMapping("/admin/low-stock")
    public ResponseEntity<List<Product>> getLowStock() {
        return new ResponseEntity<>(productService.getLowStockProducts(), HttpStatus.OK);
    }
}
