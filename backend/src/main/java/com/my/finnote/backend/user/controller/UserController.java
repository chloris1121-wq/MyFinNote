package com.my.finnote.backend.user.controller;

import com.my.finnote.backend.user.domain.User;
import com.my.finnote.backend.user.dto.request.UserSignUpRequest;
import com.my.finnote.backend.user.dto.response.UserSignUpResponse;
import com.my.finnote.backend.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping("/signup")
    public ResponseEntity<UserSignUpResponse> signUp(@RequestBody UserSignUpRequest request) {

        // 1. Service Layer 호출 (DB 저장 로직 실행)
        User newUser = userService.signUp(request);

        // 2. Entity를 Response DTO로 변환하여 반환
        UserSignUpResponse response = UserSignUpResponse.from(newUser);

        // 3. 201 Created 응답 반환
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }
}