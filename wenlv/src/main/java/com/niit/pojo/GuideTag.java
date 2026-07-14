package com.niit.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class GuideTag {
    private Long id;
    private Long guideId;
    private String name;
    private String category;
    private Integer sortOrder;
}
