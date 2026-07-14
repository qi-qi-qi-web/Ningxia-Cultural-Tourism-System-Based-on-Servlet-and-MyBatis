package com.niit.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Comment {
    private Long id;
    private Long userId;
    private String targetType;
    private Long targetId;
    private String content;
    private Integer status;
    private Date createdAt;
    // 关联
    private String userName;
    private String avatar;
    private String targetName;
}
