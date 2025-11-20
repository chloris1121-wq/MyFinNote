package com.my.finnote.backend.user.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserSignUpRequest {
    private String email;
    private String password;
    private String nickname;
}