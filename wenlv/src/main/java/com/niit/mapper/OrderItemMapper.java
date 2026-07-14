package com.niit.mapper;

import com.niit.pojo.OrderItem;

import java.util.List;

public interface OrderItemMapper {
    int insert(OrderItem item);
    List<OrderItem> findByOrderId(Long orderId);
}
