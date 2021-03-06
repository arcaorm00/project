package com.aeho.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.aeho.demo.dao.AlarmDao;
import com.aeho.demo.dao.BoardDao;
import com.aeho.demo.dao.ReplyDao;
import com.aeho.demo.dao.ReportDao;
import com.aeho.demo.domain.CriteriaForReply;
import com.aeho.demo.vo.AlarmVo;
import com.aeho.demo.vo.ReplyVo;

@Service
public class ReplyServiceImple implements ReplyService {

	@Autowired
	private ReplyDao replyDao;
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private ReportDao reportDao;
	@Autowired 
	private AlarmDao alarmDao;
	
	@Override
	public List<ReplyVo> listReply(int b_no) {
		return replyDao.listReply(b_no);
	}

	@Override
	@Transactional(rollbackFor=Exception.class)
	public int insertReply(ReplyVo rv) {
		
		//답글 일때..
		if(rv.getR_ref()!=0) {
			//부모 댓글
			ReplyVo replyVo = replyDao.getReply(rv.getR_ref());
//			System.out.println("replyVo"+replyVo);
//			rv.setR_step(replyVo.getR_step()+1);
//			System.out.println(rv);
			//부모댓글 소환  
//			System.out.println("누른댓글번호가옴!!==>"+rv.getR_no());
			//부모스탭
//			replyVo.getR_step();			
//			replyDao.updateStep(rv);						
			//rv.setR_step(rv.getR_step()+1);
			rv.setR_level(1);
			rv.setR_ref(replyVo.getR_ref());
			
		}
		int re = 0;
		try {
			int result_insert = replyDao.insertReply(rv);
			String cntkeyword = "reply";
			int result_update = boardDao.updateCnt(rv.getB_no(), cntkeyword);
			
			if(result_insert > 0 && result_update > 0) {
				re = 1;
				replyDao.updateCnt(rv.getR_ref());
			}
		}catch (Exception e) {
			System.out.println(e.getMessage());
		}
		
		//진탁) 06-09댓글 알람 등록
		//본인 작성글이면 알람안되게!
		//b_no로 작성자를 찾는거
		String writer = boardDao.boardAlarm(rv.getB_no()).getM_id();
		if(!writer.equals(rv.getM_id())) {
			AlarmVo alarmVo = new AlarmVo();
			//댓글은 1번 좋아요는 2번 싫어요는 3번
			alarmVo.setAc_code(1);
			alarmVo.setB_no(rv.getB_no());
			alarmVo.setClickid(rv.getM_id());
			alarmVo.setM_id(writer);
			int alarmResult = alarmDao.insertBoardAlarm(alarmVo);
		}

		
		return re;
	}

	@Override
	public int deleteReply(ReplyVo rv) {
		int re = 0;
		rv = replyDao.getReply(rv.getR_no());
		if(reportDao.listReport(rv.getR_no(), "reply") != null) {
			reportDao.deleteReport(rv.getR_no(), "reply");
		}
//		System.out.println("넘어온 reply의 r_ref:"+rv.getR_ref());
		if(rv.getR_no() == rv.getR_ref()) {
			System.out.println("답댓글 아닌 경우의 삭제");
			replyDao.updateState(rv.getR_no());
			boardDao.updateCnt(rv.getB_no(), "reply");
			re=1;
		}
		else {
//			ReplyVo p_rv = replyDao.getReply(rv.getR_ref());//부모댓글 가져오기
			//삭제 처리 후에도 쓸 수 있도록, 삭제할 댓글의 부모 번호 미리 저장해두기
			int r_ref = rv.getR_ref();
			try {
				int result_delete = replyDao.deleteReply(rv);
				String cntkeyword = "reply";
				int result_update = boardDao.updateCnt(rv.getB_no(), cntkeyword);

				
				if( result_delete > 0 && result_update > 0 ) {
					re = 1;
					replyDao.updateCnt(r_ref);
				}
			}catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		
		return re;
	}
	
	@Override
	public int deleteBoardReply(int b_no) {
		System.out.println("댓글 삭제가 안되네?");
		return replyDao.deleteBoardReply(b_no);
	}

	@Override
	public ReplyVo getReply(int r_no) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int maxRstep(ReplyVo rv) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateCnt(int r_ref) {
		return replyDao.updateCnt(r_ref);
	}

	@Override
	public int updateState(int r_no) {
		return replyDao.updateState(r_no);
	}

	//관리자 페이지 신고 댓글 목록
	@Override
	public List<ReplyVo> getReportReply(CriteriaForReply cri) {
		return replyDao.getReportReply(cri);
	}

	//관리자 페이지 신고 댓글 수
	@Override
	public int getReportCnt() {
		return replyDao.getReportCnt();
	}
}
