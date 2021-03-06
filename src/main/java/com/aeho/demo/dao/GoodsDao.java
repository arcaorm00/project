package com.aeho.demo.dao;

import java.util.List;

import com.aeho.demo.domain.Criteria2;
import com.aeho.demo.vo.GoodsVo;

public interface GoodsDao {

	List<GoodsVo> listGoods(int gc_code, String keyword);
	
	GoodsVo getGoods(GoodsVo gv);
	
	int insertGoods(GoodsVo gv);
	
	int updateGoods(GoodsVo gv);
	
	int deleteGoods(GoodsVo gv);
	
	int updateCnt(int g_no, String cntKeyword);

	List<GoodsVo> paging(Criteria2 cri);

	int getTotalCount(Criteria2 cri);
	
	List<GoodsVo> getReportGoods(Criteria2 cri);
	
	List<GoodsVo> getMypageGoods(String m_id);
	
	List<GoodsVo> mainNewGoods();
	
	GoodsVo goodsAlarm(int g_no);
	
	int updateGoodsWhereID(String m_id);
}
