package com.kh.everyrecipe.board.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.everyrecipe.board.vo.BoardVo;
import com.kh.everyrecipe.board.vo.HashtagVo;
import com.kh.everyrecipe.board.vo.IngredientVo;
import com.kh.everyrecipe.board.vo.PostVo;

@Repository
public class BoardDao {
	@Autowired
	private SqlSession sqlSession;

	
	//Post
	public int getLastPostId() {
		return sqlSession.selectOne("boardMapper.getLastPostId");
	}
	public int insertPost(BoardVo vo) throws Exception{		
		return sqlSession.insert("boardMapper.insertPost",vo);
	}
	public int insertBasicPost(List<BoardVo> bvoList) {
		return sqlSession.insert("boardMapper.insertBasicPost",bvoList);
	}
	public int delete(int postId ) throws Exception {
		return sqlSession.update("boardMapper.delete",postId);
		
	}
	public PostVo selectOne(int postId) throws Exception {
		return sqlSession.selectOne("boardMapper.selectOne",postId);
	}
	public List<PostVo> selectList() throws Exception {
		return sqlSession.selectList("boardMapper.selectList");
	}
	public List<PostVo> pagingList(Map<String, String> map) {
		return sqlSession.selectList("boardMapper.pagingList",map);
	}
	public int updatePost(BoardVo bvo) {
		return sqlSession.update("boardMapper.updatePost",bvo);
	}
	public int upView(int postId) {
		return sqlSession.update("boardMapper.upView",postId);
	}
	
	
	//Ingredient
	public int insertIngList(List<IngredientVo> ivoList) {
		return sqlSession.insert("boardMapper.insertIngList",ivoList);
	}
	
	public int insertBasicIng(List<IngredientVo> iList) {
		return sqlSession.insert("boardMapper.insertBasicIng",iList);
	}	
	public List<IngredientVo> getIngredients() {
		return sqlSession.selectList("boardMapper.allIngredients");
	}
	public List<String> searchIng(String ing) {
		return sqlSession.selectList("boardMapper.searchIng",ing);
	}
	
	public List<IngredientVo> getIngredients(int postId) {
		return sqlSession.selectList("boardMapper.getIngredients",postId);
	}
	public int deleteIngList(int postId) {
		return sqlSession.delete("boardMapper.deleteIngList",postId);
	}
	
	
	
	//Hashtag
	public int insertHashtagList(List<HashtagVo> hashtagList) {
		return sqlSession.update("boardMapper.insertHashtagList",hashtagList);
	}
	public List<HashtagVo> getHashtags(int postId) {
		return sqlSession.selectList("boardMapper.getHashtags",postId);
	}
	public int deleteHashtagList(int postId) {
		return sqlSession.delete("boardMapper.deleteHashtagList",postId);
	}
	
	
	
	
	

	

	

	
	
}
