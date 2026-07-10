package com.niit.mapper;

import com.niit.pojo.NewsDynamic;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface NewsDynamicMapper {
    List<NewsDynamic> findAll();
    NewsDynamic findById(Long id);
    int insert(NewsDynamic news);
    int update(NewsDynamic news);
    int deleteById(Long id);
    int togglePublish(@Param("id") Long id, @Param("status") Integer status);
}
