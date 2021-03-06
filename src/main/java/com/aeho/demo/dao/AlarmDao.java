package com.aeho.demo.dao;

import java.util.List;

import com.aeho.demo.vo.AlarmVo;

public interface AlarmDao {

	int insertBoardAlarm(AlarmVo alarmVo);
	
	int insertGoodsAlarm(AlarmVo alarmVo);
	
	List<AlarmVo> listAlarm(String m_id);
	
	int updateCheck(int a_no);
	
	int deleteBoardAlarm(int b_no);
	
	int deleteGoodsAlarm(int g_no);
	
	int updateAlarmWhereID(String m_id);
}
