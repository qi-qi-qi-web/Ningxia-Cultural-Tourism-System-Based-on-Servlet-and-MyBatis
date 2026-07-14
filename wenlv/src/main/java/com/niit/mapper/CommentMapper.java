package com.niit.mapper;

import com.niit.pojo.Comment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CommentMapper {
    List<Comment> findByTarget(@Param("targetType") String targetType, @Param("targetId") Long targetId);
    List<Comment> findByUserId(@Param("userId") Long userId);
    List<Comment> findAll();
    int insert(Comment c);
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
    int deleteById(Long id);
    int deleteByUser(@Param("id") Long id, @Param("userId") Long userId);
    int updateContent(@Param("id") Long id, @Param("userId") Long userId, @Param("content") String content);
}
