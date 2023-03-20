package com.kh.everyrecipe.board.service;

import java.util.List;

import com.kh.everyrecipe.board.vo.BoardVo;
import com.kh.everyrecipe.board.vo.HashtagVo;
import com.kh.everyrecipe.board.vo.IngredientVo;
import com.kh.everyrecipe.board.vo.PostVo;




public interface BoardService {
	
	
	

	
	
	//Post
	public int getLastPostId();
	public PostVo selectOne(int postId) throws Exception ;
	public List<PostVo> selectList() throws Exception;
	public int insertPost(BoardVo bvo) throws Exception;
	public int updatePost(BoardVo bvo) throws Exception;
	public int insertBasicPost(List<BoardVo> bvoList) throws Exception;
	public int delete(int postId ) throws Exception;
	
	
	//Ingredient
	public List<IngredientVo> getIngredients() throws Exception;
	public List<IngredientVo> getIngredients(int postId) throws Exception;
	public int insertIngList(List<IngredientVo> ivoList) throws Exception;
	public int deleteIngList(int postId) throws Exception;
	
	
	//Hashtag
	public int insertHashtagList(List<HashtagVo> hashtagList) throws Exception;
	public int deleteHashtagList(int postId) throws Exception;
	public List<HashtagVo> getHashtags(int postId) throws Exception;

	
}