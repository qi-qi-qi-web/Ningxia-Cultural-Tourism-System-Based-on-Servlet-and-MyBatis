package com.niit.mapper;

import com.niit.pojo.OrderMain;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderMapper {
    List<OrderMain> findAll();
    OrderMain findById(Long id);
    int insert(OrderMain order);
    List<OrderMain> findByUserId(Long userId);
    int hasUnpaidOrder(Long userId);
    int updateStatus(@Param("id") Long id, @Param("status") String status);
    int payOrder(@Param("id") Long id);
    int cancelByUser(@Param("id") Long id);
    int shipOrder(@Param("id") Long id);
    int confirmReceipt(@Param("id") Long id);
    int completeOrder(@Param("id") Long id);
    int requestReturn(@Param("id") Long id, @Param("reason") String reason);
    int confirmRefund(@Param("id") Long id);
}
