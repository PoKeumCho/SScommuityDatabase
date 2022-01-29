# 테이블 제거

USE ssdb;

DROP TABLE IF EXISTS `tmpuser`;							-- 임시 회원 테이블
DROP TABLE IF EXISTS `user`;							-- 회원 테이블
DROP TABLE IF EXISTS `withdrawal`;						-- 탈퇴한 회원 테이블

# `user` 테이블을 먼저 제거해야한다.
DROP TABLE IF EXISTS `accountimg`;						-- 회원 프로필 이미지 테이블

DROP TABLE IF EXISTS `generalimg`;						-- 게시판 이미지 테이블
DROP TABLE IF EXISTS `generalcomments`;					-- 게시판 댓글과 대댓글 테이블

# `generalimg` 테이블을 먼저 제거해야한다.
# `generalcomments` 테이블을 먼저 제거해야한다.
DROP TABLE IF EXISTS `general`;							-- 게시판 테이블

# `general` 테이블을 먼저 제거해야한다.
# `generalcomments` 테이블을 먼저 제거해야한다.
DROP TABLE IF EXISTS `generalcategory`;					-- 게시판 카테고리 테이블

DROP TABLE IF EXISTS `generalcategorybookmark`;			-- 게시판 카테고리 'bookmark' 룩업(lookup) 테이블
DROP TABLE IF EXISTS `generalcategoryexpel`;			-- 게시판 카테고리 'expel' 룩업(lookup) 테이블

-- 게시판 '좋아요'/ssexpel 룩업(lookup) 테이블
DROP TABLE IF EXISTS `generallikes`;
DROP TABLE IF EXISTS `generaldislikes`;
DROP TABLE IF EXISTS `generalexpel`;

-- 게시판 댓글과 대댓글 '좋아요'/ssexpel 룩업(lookup) 테이블
DROP TABLE IF EXISTS `generalcommentslikes`;
DROP TABLE IF EXISTS `generalcommentsdislikes`;  
DROP TABLE IF EXISTS `generalcommentsexpel`;

-- 시간표 관련 테이블
DROP TABLE IF EXISTS `userscheduletbl`;
DROP TABLE IF EXISTS `schedulelookuptbl`;

-- 채팅 관련 테이블
DROP TABLE IF EXISTS `chat`;
DROP TABLE IF EXISTS `chattext`;
DROP TABLE IF EXISTS `chatfile`;
DROP TABLE IF EXISTS `chatblock`;


-- 중고거래 관련 테이블

DROP TABLE IF EXISTS `trade`;

# `trade` 테이블을 먼저 제거해야한다.
DROP TABLE IF EXISTS `tradecategory`;

DROP TABLE IF EXISTS `tradeimg`;
DROP TABLE IF EXISTS `tradeexpel`;