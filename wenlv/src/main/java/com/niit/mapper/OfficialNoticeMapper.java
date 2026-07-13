package com.niit.mapper;

import com.niit.pojo.OfficialNotice;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OfficialNoticeMapper {
    List<OfficialNotice> findAll();
    List<OfficialNotice> findPublished();
    OfficialNotice findById(Long id);
    int insert(OfficialNotice notice);
    int update(OfficialNotice notice);
    int deleteById(Long id);
    int shiftIdsDown(@Param("afterId") Long afterId);
    Long findMaxId();
    int togglePublish(@Param("id") Long id, @Param("status") Integer status);
    int toggleTop(@Param("id") Long id, @Param("top") Integer top);
}
