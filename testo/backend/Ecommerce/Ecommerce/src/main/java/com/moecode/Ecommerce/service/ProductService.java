package com.moecode.Ecommerce.service;

import com.moecode.Ecommerce.model.Product;
import com.moecode.Ecommerce.repository.ProductRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ProductService {

    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository){
        this.productRepository = productRepository;
    }

    public Product addProduct(Product product) {
        return productRepository.save(product);
    }

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public List<Product> getLowStockProducts() {
        return productRepository.findByStockLessThan(5);
    }
}
