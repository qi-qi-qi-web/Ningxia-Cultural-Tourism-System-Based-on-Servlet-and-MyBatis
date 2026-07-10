package com.niit.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NewsDynamic {
    private Long id;
    private String title;
    private String content;
    private String coverImage;
    private String source;
    private String authorName;
    private Integer viewCount;
    private Integer isPublished;
    private Date publishedAt;
    private Long createdBy;
    private Date createdAt;
    private Date updatedAt;
}
