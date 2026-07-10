package com.niit.mapper;

import com.niit.pojo.Specialty;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SpecialtyMapper {
    List<Specialty> findAll();
    List<Specialty> findAllWithCategory();
    Specialty findById(Long id);
    int insert(Specialty s);
    int update(Specialty s);
    int deleteById(Long id);
    int shiftIdsDown(@Param("afterId") Long afterId);
    Long findMaxId();
    int toggleStatus(@Param("id") Long id, @Param("status") Integer status);
}
