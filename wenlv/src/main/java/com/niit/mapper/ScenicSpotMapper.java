package com.niit.mapper;

import com.niit.pojo.ScenicSpot;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ScenicSpotMapper {
    List<ScenicSpot> findAll();
    List<ScenicSpot> findOpen();
    ScenicSpot findById(Long id);
    int insert(ScenicSpot s);
    int update(ScenicSpot s);
    int deleteById(Long id);
    int updateStatus(@Param("id") Long id, @Param("status") String status);
    int shiftIdsDown(@Param("afterId") Long afterId);
    Long findMaxId();
    int incrementViewCount(@Param("id") Long id);
}
