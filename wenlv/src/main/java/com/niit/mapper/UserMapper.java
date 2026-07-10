package com.niit.mapper;

import com.niit.pojo.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {

    List<User> findAll();

    User findById(Long id);

    User findByPhoneOrEmail(String phoneOrEmail);

    User findByUsername(String username);

    User findByEmail(String email);

    User findByPhone(String phone);

    int insertUser(User user);

    int deleteById(Long id);

    int shiftIdsDown(@Param("afterId") Long afterId);

    Long findMaxId();

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    int updateProfile(@Param("id") Long id,
                      @Param("nickname") String nickname,
                      @Param("phone") String phone,
                      @Param("email") String email);

    int updatePassword(@Param("id") Long id, @Param("passwordHash") String passwordHash);

    int updateAvatar(@Param("id") Long id, @Param("avatar") String avatar);
}
