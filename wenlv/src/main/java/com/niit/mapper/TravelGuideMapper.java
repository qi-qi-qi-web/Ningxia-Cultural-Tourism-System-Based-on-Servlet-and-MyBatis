package com.niit.mapper;

import com.niit.pojo.TravelGuide;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TravelGuideMapper {
    List<TravelGuide> findAll();
    TravelGuide findById(Long id);
    int updateStatus(@Param("id") Long id, @Param("status") String status);
    int deleteById(Long id);
    int shiftIdsDown(@Param("afterId") Long afterId);
    Long findMaxId();
}
