package com.niit.service;

import com.niit.mapper.UserMapper;
import com.niit.pojo.User;
import com.niit.utils.DBUtil;
import com.niit.utils.PasswordUtil;
import org.apache.ibatis.session.SqlSession;

public class UserService {

    public User findById(Long id) {
        try (SqlSession session = DBUtil.getSession()) {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            return userMapper.findById(id);
        }
    }

    public boolean updateProfile(Long id, String nickname, String phone, String email) {
        try (SqlSession session = DBUtil.getSession(false)) {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            int rows = userMapper.updateProfile(id, nickname, phone, email);
            session.commit();
            return rows > 0;
        }
    }

    public boolean changePassword(Long id, String oldPassword, String newPassword) {
        try (SqlSession session = DBUtil.getSession(false)) {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            User user = userMapper.findById(id);

            if (user == null) return false;
            if (!PasswordUtil.verify(oldPassword, user.getPasswordHash())) return false;

            // 用 SHA-256 加密新密码
            String newHash = PasswordUtil.hash(newPassword);
            int rows = userMapper.updatePassword(id, newHash);
            session.commit();
            return rows > 0;
        }
    }

    public boolean updateAvatar(Long id, String avatar) {
        try (SqlSession session = DBUtil.getSession(false)) {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            int rows = userMapper.updateAvatar(id, avatar);
            session.commit();
            return rows > 0;
        }
    }
}
