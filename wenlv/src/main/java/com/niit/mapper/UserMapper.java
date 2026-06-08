package com.niit.mapper;

import com.niit.pojo.User;

public interface UserMapper {
    User findByPhoneOrEmail(String phoneOrEmail);

    User findByEmail(String email);

    User findByPhone(String phone);

    int insertUser(User user);
}