package com.niit.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Specialty {
    private Long id;
    private Long categoryId;
    private Long scenicSpotId;
    private String name;
    private String description;
    private BigDecimal price;
    private Integer stock;
    private String mainImage;
    private String images;
    private Integer salesCount;
    private Long favoriteCount;
    private Integer status;
    private Date createdAt;
    private Date updatedAt;

    // 关联字段（非表字段，用于JOIN查询）
    private String categoryName;
}
