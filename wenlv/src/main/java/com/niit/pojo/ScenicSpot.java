package com.niit.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScenicSpot {
    private Long id;
    private String name;
    private String description;
    private String address;
    private String province;
    private String city;
    private String district;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private String openingHours;
    private String contactPhone;
    private String coverImage;
    private String images;
    private BigDecimal minPrice;
    private Long viewCount;
    private Long favoriteCount;
    private String status;
    private Date createdAt;
    private Date updatedAt;
}
