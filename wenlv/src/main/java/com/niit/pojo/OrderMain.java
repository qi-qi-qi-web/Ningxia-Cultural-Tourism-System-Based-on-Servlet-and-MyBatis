package com.niit.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderMain {
    private Long id;
    private String orderNo;
    private Long userId;
    private BigDecimal totalAmount;
    private BigDecimal discountAmount;
    private BigDecimal payAmount;
    private String pickupMethod;
    private String deliveryName;
    private String deliveryPhone;
    private String deliveryAddress;
    private String status;
    private String paymentMethod;
    private Date paidAt;
    private Date shippedAt;
    private Date completedAt;
    private String remark;
    private Date createdAt;
    private Date updatedAt;

    // 关联
    private String userName;
}
