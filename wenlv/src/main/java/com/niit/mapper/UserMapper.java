package com.niit.mapper;

import com.niit.pojo.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {

    /** 查询所有用户 */
    List<User> findAll();

    /** 按ID查询 */
    User findById(Long id);

    /** 按手机号或邮箱查询（登录用） */
    User findByPhoneOrEmail(String phoneOrEmail);

    /** 按用户名查询 */
    User findByUsername(String username);

    /** 按邮箱查询 */
    User findByEmail(String email);

    /** 按手机号查询 */
    User findByPhone(String phone);

    /** 新增用户 */
    int insertUser(User user);

    /** 删除用户 */
    int deleteById(Long id);

    /** 更新用户状态（0=禁用, 1=正常） */
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    /** 更新个人资料（昵称、手机号、邮箱） */
    int updateProfile(@Param("id") Long id,
                      @Param("nickname") String nickname,
                      @Param("phone") String phone,
                      @Param("email") String email);

    /** 修改密码 */
    int updatePassword(@Param("id") Long id, @Param("passwordHash") String passwordHash);

    /** 更换头像 */
    int updateAvatar(@Param("id") Long id, @Param("avatar") String avatar);
}
