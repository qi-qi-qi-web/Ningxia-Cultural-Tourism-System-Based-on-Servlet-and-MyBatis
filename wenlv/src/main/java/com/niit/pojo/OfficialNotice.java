package com.niit.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OfficialNotice {
    private Long id;
    private String title;
    private String content;
    private Long scenicSpotId;
    private String coverImage;
    private Integer isTop;
    private Integer isPublished;
    private Date publishedAt;
    private Long createdBy;
    private Date createdAt;
    private Date updatedAt;
}
