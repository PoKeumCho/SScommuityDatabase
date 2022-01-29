# 테이블 생성

USE ssdb;

#===================================== 임시 회원 테이블 =====================================#
# 나중에 삭제할 데이터
#============================================
CREATE TABLE `tmpuser`
(	`id`					VARCHAR(16) NOT NULL UNIQUE,		-- 사용자 아이디
	`pw`					CHAR(60) NOT NULL,					-- 사용자 비밀번호 (PASSWORD_BCRYPT hash)
	`name`					VARCHAR(6) NOT NULL,				-- 사용자 이름
    `birthdate`				DATE NOT NULL,						-- 사용자 생년월일
    `nickname`				CHAR(8) NOT NULL,					-- 사용자 닉네임
    `studentid`				CHAR(8) NOT NULL UNIQUE,			-- 사용자 학번
    `email`					VARCHAR(320) NOT NULL PRIMARY KEY,	-- 사용자 이메일 (PK)
    `code`					CHAR(8) NOT NULL					-- 인증 번호
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#===================================== 탈퇴한 회원 테이블 =====================================#
CREATE TABLE `withdrawal`
(
    `userid`				VARCHAR(16) NOT NULL PRIMARY KEY	-- 사용자 아이디 (PK)
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;


#================================ 회원 프로필 이미지 테이블 ================================#
# 회원 테이블과 일대다관계
#============================================
CREATE TABLE `accountimg`
(	`id`			TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,	-- 회원 프로필 이미지 아이디 (PK)
	`filename`		VARCHAR(60)												-- 이미지 파일명
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

INSERT INTO `ssdb`.`accountimg` (`id`, `filename`) VALUES ('1', 'default');
INSERT INTO `ssdb`.`accountimg` (`id`, `filename`) VALUES ('2', 'student');
INSERT INTO `ssdb`.`accountimg` (`id`, `filename`) VALUES ('3', 'rest');
INSERT INTO `ssdb`.`accountimg` (`id`, `filename`) VALUES ('4', 'graduate');
INSERT INTO `ssdb`.`accountimg` (`id`, `filename`) VALUES ('5', 'worker');

#===================================== 회원 테이블 =====================================#
CREATE TABLE `user`
(	`id`					VARCHAR(16) NOT NULL PRIMARY KEY,	-- 사용자 아이디 (PK)
	`pw`					CHAR(60) NOT NULL,					-- 사용자 비밀번호 (PASSWORD_BCRYPT hash)
	`name`					VARCHAR(6) NOT NULL,				-- 사용자 이름
    `birthdate`				DATE NOT NULL,						-- 사용자 생년월일
    `issungshin`			CHAR(1) NOT NULL,					-- 사용자 성신관련 여부 (Y/N)
    `ssexpel`				TINYINT UNSIGNED NOT NULL,			-- 사용자 '성신 expel' 받은 횟수
    `nickname`				CHAR(8) NOT NULL,					-- 사용자 닉네임
    `studentid`				CHAR(8) NOT NULL UNIQUE,			-- 사용자 학번
    `email`					VARCHAR(320) NOT NULL UNIQUE,		-- 사용자 이메일
    `accountimgid`			TINYINT UNSIGNED NOT NULL,			-- 회원 프로필 이미지 아이디 (FK)
    `generalcategorycount`	TINYINT UNSIGNED NULL,				-- 게시판 카테고리 생성 수 (0-255)
    `generalcount`			SMALLINT UNSIGNED NULL,				-- 게시판 글 작성 수 (0-65535)
	FOREIGN KEY (`accountimgid`) REFERENCES `accountimg`(`id`)
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;


#=================================== 게시판 카테고리 테이블 ===================================#
# 게시판 테이블과 일대다관계
#============================================
CREATE TABLE `generalcategory`
(	`id`			INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,		-- 카테고리 아이디 (PK)
	`tmpid`			VARCHAR(20)	NOT NULL UNIQUE,							-- 임시 구별 아이디
	`userid`		VARCHAR(16) NOT NULL,									-- 사용자 아이디 (FK)
	`name`			VARCHAR(16)  NOT NULL UNIQUE,							-- 카테고리 이름 (중복 금지)
    `info`			VARCHAR(320) NOT NULL,									-- 카테고리 설명 글
    `hashtag`		VARCHAR(320) NOT NULL,									-- 카테고리 해시태그 (검색용)
    `expel`			CHAR(1) NOT NULL,										-- 카테고리 방출 기능 (Y/N)
    `users`			INT UNSIGNED NOT NULL									-- 카테고리 이용자 수
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

INSERT INTO `generalcategory`(`tmpid`, `userid`, `name`, `info`, `hashtag`, `expel`, `users`) 
	VALUES ('', 'root', '자유게시판', '', '', 'N', '0');

#=================================== 게시판 카테고리 'bookmark' 룩업(lookup) 테이블 ===================================#
# 회원 테이블과 게시판 카테고리 테이블 간의 다대다관계
#============================================
CREATE TABLE `generalcategorybookmark`
(	`userid`				VARCHAR(16) NOT NULL,			-- 사용자 아이디	
	`generalcategoryid`		INT UNSIGNED NOT NULL,			-- 카테고리 아이디	
    PRIMARY KEY(`userid`, `generalcategoryid`)				-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#=================================== 게시판 카테고리 'expel' 룩업(lookup) 테이블 ===================================#
# 회원 테이블과 게시판 카테고리 테이블 간의 다대다관계
#============================================
CREATE TABLE `generalcategoryexpel`
(	`userid`				VARCHAR(16) NOT NULL,			-- 사용자 아이디	
	`generalcategoryid`		INT UNSIGNED NOT NULL,			-- 카테고리 아이디	
    PRIMARY KEY(`userid`, `generalcategoryid`)				-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#===================================== 게시판 테이블 =====================================#
CREATE TABLE `general`
(	`id`			INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,	-- 게시판 글 아이디 / 순서 (PK)
	`tmpid`			VARCHAR(22)	NOT NULL UNIQUE,						-- 임시 구별 아이디
	`userid`		VARCHAR(16) NOT NULL,								-- 사용자 아이디
    `categoryid`	INT UNSIGNED NOT NULL,								-- 카테고리 아이디 (FK)
	`text`			TEXT NOT NULL,										-- 게시판 글 본문
	`img`			TINYINT NOT NULL,									-- 업로드 이미지 파일 개수	
    `date`			DATETIME NOT NULL,									-- 게시판 글 등록일
    `likes`			INT NOT NULL,										-- '좋아요' 개수
    `comments`		SMALLINT UNSIGNED NOT NULL,							-- 현재 '댓글' 개수
    `groupid`		SMALLINT UNSIGNED NOT NULL,							-- 누적 '댓글' 개수 (generalcomments group)
    FOREIGN KEY (`categoryid`) REFERENCES `generalcategory`(`id`)
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#=================================== 게시판 이미지 테이블 ===================================#
# 게시판 테이블과 일대다관계
#============================================
CREATE TABLE `generalimg`
(	`generalid`		INT UNSIGNED NOT NULL,			-- 게시판 글 아이디 (FK)	
	`path`			VARCHAR(255) NOT NULL,			-- 이미지 파일이 저장된 경로명
    `width`			SMALLINT NOT NULL,				-- 이미지의 width 값
    FOREIGN KEY (`generalid`) REFERENCES `general`(`id`)
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#=================================== 게시판 '좋아요'/ssexpel 룩업(lookup) 테이블 ===================================#
# 회원 테이블과 게시판 테이블 간의 다대다관계
#============================================
CREATE TABLE `generallikes`
(	`userid`		VARCHAR(16) NOT NULL,			-- 사용자 아이디	
	`generalid`		INT UNSIGNED NOT NULL,			-- 게시판 글 아이디	
    PRIMARY KEY(`userid`, `generalid`)				-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

CREATE TABLE `generaldislikes`
(	`userid`		VARCHAR(16) NOT NULL,			-- 사용자 아이디	
	`generalid`		INT UNSIGNED NOT NULL,			-- 게시판 글 아이디	
    PRIMARY KEY(`userid`, `generalid`)				-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

CREATE TABLE `generalexpel`
(	`userid`		VARCHAR(16) NOT NULL,			-- 사용자 아이디	
	`generalid`		INT UNSIGNED NOT NULL,			-- 게시판 글 아이디	
    PRIMARY KEY(`userid`, `generalid`)				-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#================================== 게시판 댓글과 대댓글 테이블 ==================================#
# 게시판 테이블과 일대다관계
# [참고] https://xerar.tistory.com/44
#============================================
CREATE TABLE `generalcomments`
(	`id`			INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,	-- 댓글과 대댓글 아이디 (PK)
	`userid`		VARCHAR(16) NOT NULL,								-- 사용자 아이디
    `text`			TEXT NOT NULL,										-- 댓글과 대댓글 본문
    `date`			DATETIME NOT NULL,									-- 댓글과 대댓글 등록일
    `likes`			INT NOT NULL,										-- '좋아요' 개수
    `class`			TINYINT NOT NULL,									-- 계층
    `group`			SMALLINT UNSIGNED NOT NULL,							-- 댓글 그룹 (0부터 시작)
    `categoryid`	INT UNSIGNED NOT NULL,								-- 카테고리 아이디 (FK)
    `generalid`		INT UNSIGNED NOT NULL,								-- 게시판 글 아이디 (FK)
    FOREIGN KEY (`generalid`) REFERENCES `general`(`id`),
    FOREIGN KEY (`categoryid`) REFERENCES `generalcategory`(`id`)
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#=================================== 게시판 댓글과 대댓글 '좋아요'/ssexpel 룩업(lookup) 테이블 ===================================#
# 회원 테이블과 게시판 댓글과 대댓글 테이블 간의 다대다관계
#============================================
CREATE TABLE `generalcommentslikes`
(	`userid`				VARCHAR(16) NOT NULL,			-- 사용자 아이디	
	`generalcommentsid`		INT UNSIGNED NOT NULL,			-- 게시판 댓글과 대댓글 아이디	
    PRIMARY KEY(`userid`, `generalcommentsid`)				-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

CREATE TABLE `generalcommentsdislikes`
(	`userid`				VARCHAR(16) NOT NULL,			-- 사용자 아이디	
	`generalcommentsid`		INT UNSIGNED NOT NULL,			-- 게시판 댓글과 대댓글 아이디		
    PRIMARY KEY(`userid`, `generalcommentsid`)				-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

CREATE TABLE `generalcommentsexpel`
(	`userid`				VARCHAR(16) NOT NULL,			-- 사용자 아이디	
	`generalcommentsid`		INT UNSIGNED NOT NULL,			-- 게시판 댓글과 대댓글 아이디		
    PRIMARY KEY(`userid`, `generalcommentsid`)				-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;



#================================ 사용자가 직접 추가한 시간표 테이블 ================================#
CREATE TABLE `userscheduletbl`
(	`userid`		VARCHAR(16) NOT NULL,		-- 사용자 아이디	
	`className`		VARCHAR(30) NOT NULL,		-- 과목명
    `classTime`		VARCHAR(30) NOT NULL,		-- 시간
    `classInfo` 	VARCHAR(30) NULL,			-- 추가정보
    PRIMARY KEY (`userid`, `classTime`)
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#=================================== 시간표 룩업(lookup) 테이블 ===================================#
# 회원 테이블과 `scheduletbl` 테이블 간의 다대다관계
#============================================
CREATE TABLE `schedulelookuptbl`
(	`userid`		VARCHAR(16) NOT NULL,		-- 사용자 아이디
	`scheduleno`	SMALLINT NOT NULL,			-- 시간표 고유번호
	PRIMARY KEY (`userid`, `scheduleno`)		-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;



#=================================== 채팅 테이블 ===================================#
CREATE TABLE `chat`
(	`no`			INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,	-- 채팅 기본 키 (PK)
	`senderid`		VARCHAR(16) NOT NULL,								-- 발신자 아이디
	`receiverid`	VARCHAR(16) NOT NULL,								-- 수신자 아이디
    `datetime`		DATETIME NOT NULL,									-- 날짜/시간
    `contenttype`	CHAR(1) NOT NULL,									-- [T]ext / [F]ile			
    `contentno`		INT UNSIGNED NOT NULL,								-- 채팅 content 번호
    `readstatus`	CHAR(1) NOT NULL									-- 읽은 상태 (Y/N) 
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#=================================== 채팅 룩업(lookup) 테이블 ===================================#
CREATE TABLE `chattext`
(	`no`			INT UNSIGNED NOT NULL,			-- 구분 번호
	`senderid`		VARCHAR(16) NOT NULL,			-- 발신자 아이디
	`receiverid`	VARCHAR(16) NOT NULL,			-- 수신자 아이디
    `text`			TEXT NOT NULL,					-- 채팅 글 본문
	PRIMARY KEY (`no`, `senderid`, `receiverid`)	-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

CREATE TABLE `chatfile`
(	`no`			INT UNSIGNED NOT NULL,			-- 구분 번호
	`senderid`		VARCHAR(16) NOT NULL,			-- 발신자 아이디
	`receiverid`	VARCHAR(16) NOT NULL,			-- 수신자 아이디
    `path`			VARCHAR(255) NOT NULL,			-- 이미지 파일이 저장된 경로명
    `width`			SMALLINT NOT NULL,				-- 이미지 파일의 width 값
	PRIMARY KEY (`no`, `senderid`, `receiverid`)	-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;


CREATE TABLE `chatblock`
(	`userid`		VARCHAR(16) NOT NULL,		-- 사용자 아이디
	`blockid`		VARCHAR(16) NOT NULL,		-- 수신 거부 아이디
	PRIMARY KEY (`userid`, `blockid`)			-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;


#=================================== 중고거래 카테고리 테이블 ===================================#
# 중고거래 테이블과 일대다관계
#============================================
CREATE TABLE `tradecategory`
(	`id`			TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,		-- 카테고리 아이디 (PK)
	`category`		VARCHAR(30)
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

INSERT INTO `tradecategory`(`category`) VALUES ('도서/티켓/음반');
INSERT INTO `tradecategory`(`category`) VALUES ('생활/가공식품');
INSERT INTO `tradecategory`(`category`) VALUES ('디지털기기');
INSERT INTO `tradecategory`(`category`) VALUES ('의류');
INSERT INTO `tradecategory`(`category`) VALUES ('악세사리');
INSERT INTO `tradecategory`(`category`) VALUES ('뷰티/미용');
INSERT INTO `tradecategory`(`category`) VALUES ('게임/취미');
INSERT INTO `tradecategory`(`category`) VALUES ('스포츠/레저');
INSERT INTO `tradecategory`(`category`) VALUES ('반려동물용품');
INSERT INTO `tradecategory`(`category`) VALUES ('가구/인테리어');
INSERT INTO `tradecategory`(`category`) VALUES ('식물');
INSERT INTO `tradecategory`(`category`) VALUES ('기타 중고물품');

#===================================== 중고거래 테이블 =====================================#
CREATE TABLE `trade`
(	`id`			INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,	-- 중고거래 글 아이디 / 순서 (PK)
	`userid`		VARCHAR(16) NOT NULL,								-- 사용자 아이디
    `categoryid`	TINYINT UNSIGNED NOT NULL,							-- 카테고리 아이디 (FK)
    `title`			VARCHAR(30) NOT NULL,								-- 중고거래 물품 제목
    `price`			MEDIUMINT NOT NULL,									-- 중고거래 물품 가격
	`info`			TEXT NOT NULL,										-- 중고거래 물품 설명
	`imgid`			INT UNSIGNED NOT NULL,								-- 업로드 이미지 구분 아이디
    `campus`		CHAR(1) NOT NULL,									-- [S] 수정 / [U] 운정 / [B]oth
    `date`			DATETIME NOT NULL,									-- 중고거래 글 등록일
    `expel`			TINYINT UNSIGNED NOT NULL,							-- 신고 수 (부적절한 글)
    FOREIGN KEY (`categoryid`) REFERENCES `tradecategory`(`id`)
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#=================================== 중고거래 이미지 테이블 ===================================#
# 중고거래 테이블과 일대다관계
#============================================
CREATE TABLE `tradeimg`
(	`userid`		VARCHAR(16) NOT NULL,			-- 사용자 아이디
	`id`			INT UNSIGNED NOT NULL,			-- 중고거래 이미지 구분 아이디
    `no`			TINYINT UNSIGNED NOT NULL,		-- 개별 이미지 구분 번호
	`path`			VARCHAR(255) NOT NULL,			-- 이미지 파일이 저장된 경로명
    `width`			SMALLINT NOT NULL,				-- 이미지의 width 값
    PRIMARY KEY (`userid`, `id`, `no`)				-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;

#=================================== 중고거래 'expel' 룩업(lookup) 테이블 ===================================#
# 회원 테이블과 중고거래 테이블 간의 다대다관계
#============================================
CREATE TABLE `tradeexpel`
(	`userid`		VARCHAR(16) NOT NULL,			-- 사용자 아이디	
	`tradeid`		INT UNSIGNED NOT NULL,			-- 카테고리 아이디	
    PRIMARY KEY(`userid`, `tradeid`)				-- 다중 칼럼 기본 키
) DEFAULT CHARACTER SET utf8mb4 ENGINE=InnoDB;