package com.niit.mapper;

import com.niit.pojo.Hotel;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface HotelMapper {
    List<Hotel> findAll();
    List<Hotel> findOpen();
    Hotel findById(Long id);
    int insert(Hotel h);
    int update(Hotel h);
    int deleteById(Long id);
    int toggleStatus(@Param("id") Long id, @Param("status") Integer status);
    int shiftIdsDown(@Param("afterId") Long afterId);
    Long findMaxId();
}
