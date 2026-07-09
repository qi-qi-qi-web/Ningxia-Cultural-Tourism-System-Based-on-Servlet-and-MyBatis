package com.niit.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

/**
 * 密码工具类：纯 JDK 实现，无外部依赖
 * 支持两种密码格式：
 *   - SHA-256（以 $SHA$ 开头）
 *   - BCrypt（以 $2a$ / $2b$ / $2y$ 开头，兼容已有数据）
 */
public class PasswordUtil {

    /**
     * 对密码进行 SHA-256 哈希（用于新注册/修改密码时存储）
     */
    public static String hash(String rawPassword) {
        return "$SHA$" + sha256(rawPassword);
    }

    /**
     * 校验明文密码是否匹配存储的哈希
     */
    public static boolean verify(String rawPassword, String storedHash) {
        if (rawPassword == null || storedHash == null) return false;

        // SHA-256 格式
        if (storedHash.startsWith("$SHA$")) {
            return storedHash.equals("$SHA$" + sha256(rawPassword));
        }

        // BCrypt 格式（兼容脚本初始化的 admin 账号）
        if (storedHash.startsWith("$2a$") || storedHash.startsWith("$2b$") || storedHash.startsWith("$2y$")) {
            // 尝试用 jbcrypt（如果有的话），否则跳过 BCrypt 的校验
            try {
                Class<?> bcryptClass = Class.forName("org.mindrot.jbcrypt.BCrypt");
                Object result = bcryptClass.getMethod("checkpw", String.class, String.class)
                        .invoke(null, rawPassword, storedHash);
                return (Boolean) result;
            } catch (Exception e) {
                // 没有 jbcrypt 库，不支持 BCrypt → 返回 false
                return false;
            }
        }

        // 纯 SHA-256（无前缀，兼容旧数据）
        return sha256(rawPassword).equals(storedHash);
    }

    /**
     * SHA-256 哈希
     */
    private static String sha256(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes("UTF-8"));
            return bytesToHex(hash);
        } catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 字节数组转十六进制字符串
     */
    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b & 0xff));
        }
        return sb.toString();
    }
}
