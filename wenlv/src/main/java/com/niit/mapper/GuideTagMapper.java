package com.niit.mapper;

import com.niit.pojo.GuideTag;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface GuideTagMapper {
    List<GuideTag> findAll();
    List<GuideTag> findByCategory(@Param("category") String category);
    List<GuideTag> findByGuideId(@Param("guideId") Long guideId);
    int insert(GuideTag tag);
    int update(GuideTag tag);
    int deleteById(Long id);
    int deleteByGuideId(@Param("guideId") Long guideId);
    Long findMaxId();
    int shiftIdsDown(@Param("afterId") Long afterId);
}
