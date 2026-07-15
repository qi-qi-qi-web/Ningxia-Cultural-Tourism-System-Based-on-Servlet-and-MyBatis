package com.niit.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TravelGuide {
    private Long id;
    private Long userId;
    private String title;
    private String content;
    private String coverImage;
    private String tags;
    private Integer likeCount;
    private Integer viewCount;
    private Integer commentCount;
    private Long favoriteCount;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    // 关联
    private String userName;
    private String nickname;
    private String avatar;
}
