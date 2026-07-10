package com.niit.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PlatformLog {
    private Long id;
    private Long userId;
    private String userName;
    private String logType;
    private String targetType;
    private Long targetId;
    private String targetName;
    private String detail;
    private String ipAddress;
    private String userAgent;
    private Date createdAt;
}
