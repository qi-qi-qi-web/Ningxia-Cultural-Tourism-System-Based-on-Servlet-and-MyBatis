package com.niit.mapper;

import com.niit.pojo.TravelGuide;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TravelGuideMapper {
    List<TravelGuide> findAll();
    TravelGuide findById(Long id);
    List<TravelGuide> findPublished();
    List<TravelGuide> findByUserId(Long userId);
    int insert(TravelGuide guide);
    int update(TravelGuide guide);
    int updateStatus(@Param("id") Long id, @Param("status") String status);
    int incrementViewCount(@Param("id") Long id);
    int incrementFavoriteCount(@Param("id") Long id);
    int decrementFavoriteCount(@Param("id") Long id);
    int deleteById(Long id);
    int shiftIdsDown(@Param("afterId") Long afterId);
    Long findMaxId();
    void reorderIds();
}
