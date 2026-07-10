package com.niit.mapper;

import com.niit.pojo.OrderMain;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderMapper {
    List<OrderMain> findAll();
    OrderMain findById(Long id);
    int updateStatus(@Param("id") Long id, @Param("status") String status);
    int shipOrder(@Param("id") Long id);
    int completeOrder(@Param("id") Long id);
}
