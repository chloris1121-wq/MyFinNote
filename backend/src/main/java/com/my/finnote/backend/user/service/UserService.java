package com.my.finnote.backend.user.service;

import com.my.finnote.backend.user.domain.User;
import com.my.finnote.backend.user.dto.request.UserSignUpRequest;
import com.my.finnote.backend.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public User signUp(UserSignUpRequest request) {

        String rawPassword = request.getPassword();
        String encodedPassword = passwordEncoder.encode(rawPassword);

        User newUser = new User(
                request.getEmail(),
                passwordHash,
                request.getNickname()
        );

        // DB에 저장하고, 저장된 User 객체를 반환합니다.
        return userRepository.save(newUser);
    }
}