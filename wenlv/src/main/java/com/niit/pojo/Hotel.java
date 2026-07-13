package com.niit.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Hotel {
    private Long id;
    private String name;
    private String description;
    private String address;
    private String province;
    private String city;
    private String district;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private Integer starRating;
    private String contactPhone;
    private String facilities;
    private String coverImage;
    private String images;
    private BigDecimal minPrice;
    private Long favoriteCount;
    private Integer status;
    private Date createdAt;
    private Date updatedAt;
}
