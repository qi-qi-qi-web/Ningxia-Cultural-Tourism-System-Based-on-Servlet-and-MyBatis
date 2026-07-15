package com.niit.mapper;

import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface FavoriteMapper {
    List<Map<String, Object>> findByUserId(@Param("userId") Long userId);
    List<Long> findIdsByUserAndType(@Param("userId") Long userId, @Param("targetType") String targetType);
}
