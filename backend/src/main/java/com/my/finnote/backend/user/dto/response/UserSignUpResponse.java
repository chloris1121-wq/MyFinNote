package com.my.finnote.backend.user.dto.response;

import com.my.finnote.backend.user.domain.User;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserSignUpResponse {
    private final Long userId;
    private final String email;
    private final String nickname;

    // User 엔티티를 Response DTO로 변환하는 메서드
    public static UserSignUpResponse from(User user) {
        return UserSignUpResponse.builder()
                .userId(user.getUserId())
                .email(user.getEmail())
                .nickname(user.getNickname())
                .build();
    }
}