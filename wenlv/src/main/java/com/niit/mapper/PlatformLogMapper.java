package com.niit.mapper;

import com.niit.pojo.PlatformLog;

import java.util.List;

public interface PlatformLogMapper {
    List<PlatformLog> findAll();
    PlatformLog findById(Long id);
}
