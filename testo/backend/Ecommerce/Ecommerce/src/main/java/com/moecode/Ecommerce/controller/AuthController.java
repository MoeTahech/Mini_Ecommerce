package com.moecode.Ecommerce.controller;

import com.moecode.Ecommerce.dto.AuthRequest;
import com.moecode.Ecommerce.dto.AuthResponse;
import com.moecode.Ecommerce.model.User;
import com.moecode.Ecommerce.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @RequestMapping("/")
    public String index(){
        return "index.html";
    }

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<User> register(@RequestBody AuthRequest request) {
        User user = authService.register(request.getEmail(), request.getPassword());
        return ResponseEntity.status(201).body(user);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody AuthRequest request) {
        String token = authService.login(request.getEmail(), request.getPassword());
        return ResponseEntity.ok(new AuthResponse(token));
    }
}
