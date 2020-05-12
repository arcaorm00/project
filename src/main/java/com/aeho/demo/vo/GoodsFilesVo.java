package com.aeho.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
 
public class GoodsFilesVo {
	private String uuid;
	private String uploadpath;
	private String filename;
	private int g_no;
}
