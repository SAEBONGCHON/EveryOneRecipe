--게시글 테이블용 시퀀스
DROP SEQUENCE SEQ_POSTID;
CREATE SEQUENCE SEQ_POSTID;

--댓글 테이블용 시퀀스
DROP SEQUENCE SEQ_CMTID;
CREATE SEQUENCE SEQ_CMTID;

--대댓글 테이블용 시퀀스
DROP SEQUENCE SEQ_RCMTID;
CREATE SEQUENCE SEQ_RCMTID;

--신고 테이블용 시퀀스
DROP SEQUENCE SEQ_REPORTID;
CREATE SEQUENCE SEQ_REPORTID;

--검색DB 테이블용 시퀀스
DROP SEQUENCE SEQ_SEARCHDBID;
CREATE SEQUENCE SEQ_SEARCHDBID;
--select * from SYS.USER_CONSTRAINTs;
--SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'tabnam';
--1-2
    DROP TABLE "INGREDIENT";
    DROP TABLE "HASHTAG";
    DROP TABLE "FOLLOWMAPPING";
--1-2
        DROP TABLE "DIRECTMESSAGE";
    DROP TABLE "CHATTINGROOM";
-- 2-3
            DROP TABLE "REPLYCOMMENT";
        DROP TABLE "TBCOMMENT";
-- 2-3
        DROP TABLE "REPORT";
        DROP TABLE "POSTBOOKMARK";
        DROP TABLE "POSTLIKE";
        DROP TABLE "CLIENTCHK";
        DROP TABLE "MEMBERBLOCK";
-- 2
    DROP TABLE "POST";
    DROP TABLE "SEARCHDB";
    DROP TABLE "SEARCHCLIENTCHK";
    DROP TABLE "HASHCLIENTCHK";
-- 1
DROP TABLE "MEMBERS" cascade constraints;
-- 1
DROP TABLE "SEARCH";
--비속어 테이블
DROP TABLE BADWORDS;

--검색어
CREATE TABLE "SEARCH" (
	"KEWORD"	VARCHAR2(30 CHAR)		NOT NULL,
	"TIMES"	NUMBER	DEFAULT 0	NOT NULL,
    "ISVISIBLE" VARCHAR2(1 char) DEFAULT 'Y' NOT NULL,
    "SEARCHDATE" TIMESTAMP	DEFAULT SYSTIMESTAMP
);
ALTER TABLE "SEARCH" ADD CONSTRAINT "PK_SEARCH" PRIMARY KEY (
	"KEWORD"
);
--검색DB저장용
CREATE TABLE "SEARCHDB" (
	"SEARCHINDEX"	NUMBER		NOT NULL,
	"KEWORD"	VARCHAR2(30 CHAR)		NOT NULL,
	"SEARCHDATE"	DATE	DEFAULT SYSDATE	NOT NULL,
	"SEARCHOPTION"	VARCHAR2(1 char)		NOT NULL
);
ALTER TABLE "SEARCHDB" ADD CONSTRAINT "PK_SEARCHDB" PRIMARY KEY (
	"SEARCHINDEX"
);
COMMENT ON COLUMN "SEARCHDB"."SEARCHDATE" IS '검색한 시간';
COMMENT ON COLUMN "SEARCHDB"."SEARCHOPTION" IS '검색유형(기본값: 없음)/R: 레시피 유형, H: 해시태그 유형';
--멤버테이블
CREATE TABLE "MEMBERS" (
	"USERID"	VARCHAR2(15 char)		NOT NULL,
	"EMAIL"	VARCHAR2(50 char)		NOT NULL,
	"PASSWORD"	VARCHAR2(80 char)		NOT NULL,
	"NICKNAME"	VARCHAR2(50 char)		NULL,
	"PROFILE"	VARCHAR2(200 char)		NULL,
	"PROFILEURL"	VARCHAR2(300 char)		NULL,
	"CREATEAT"	TIMESTAMP	DEFAULT SYSTIMESTAMP	NOT NULL,
	"UPDATEAT"	TIMESTAMP	DEFAULT SYSTIMESTAMP	NOT NULL,
	"STATUS"	NUMBER(1)	DEFAULT 0	NOT NULL,
	"AUTHORITY"	VARCHAR2(30)	DEFAULT 'ROLE_MEMBER'	NOT NULL,
	"ISBLOCKED"	CHAR(1)	DEFAULT 'N'	NOT NULL
);
ALTER TABLE "MEMBERS" ADD CONSTRAINT "PK_MEMBERS" PRIMARY KEY (
	"USERID"
);
COMMENT ON COLUMN "MEMBERS"."NICKNAME" IS '프로필편집에서 수정';
COMMENT ON COLUMN "MEMBERS"."PROFILE" IS '프로필편집에서 수정';
COMMENT ON COLUMN "MEMBERS"."PROFILEURL" IS '프로필편집에서 수정, file system - cloudinary';
COMMENT ON COLUMN "MEMBERS"."STATUS" IS '0 인증x, 1 인증o, 2 탈퇴';
COMMENT ON COLUMN "MEMBERS"."AUTHORITY" IS 'ROLE_MEMBER: 멤버, ROLE_ADMIN:운영자';
COMMENT ON COLUMN "MEMBERS"."ISBLOCKED" IS 'N';


--게시물
CREATE TABLE "POST" (
	"POSTID"	NUMBER		NOT NULL,
	"USERID"	VARCHAR2(15 char)		NOT NULL,
	"NICKNAME"	VARCHAR2(20 char)		NOT NULL,
	"FOODNAME"	VARCHAR2(50 char)		NOT NULL,
	"CONTENT"	VARCHAR2(3000 char)		NOT NULL,
	"CREATEAT"	TIMESTAMP	DEFAULT SYSTIMESTAMP	NOT NULL,
	"UPDATEAT"	TIMESTAMP	DEFAULT SYSTIMESTAMP	NOT NULL,
	"ISDELETED"	VARCHAR2(1 char)	DEFAULT 'N'	NOT NULL,
	"LOOKUP"	NUMBER	DEFAULT 0	NULL,
    "ISBLINDED"	VARCHAR2(1 char)	DEFAULT 'N'	NOT NULL,
    "MAINIMAGE"	VARCHAR2(300 char)	NOT NULL
);
ALTER TABLE "POST" ADD CONSTRAINT "PK_POST" PRIMARY KEY (
	"POSTID"
);
ALTER TABLE "POST" ADD CONSTRAINT "FK_MEMBERS_TO_POST_1" FOREIGN KEY (
	"USERID"
)
REFERENCES "MEMBERS" (
	"USERID"
);

--클라이언트 구분(POST 조회수용)
CREATE TABLE CLIENTCHK(
    POSTID NUMBER NOT NULL,
    BROWSER VARCHAR2(255 char) NOT NULL,
    IP VARCHAR2(50 char) NOT NULL,
    LASTACCESSTIME DATE DEFAULT(SYSDATE) NOT NULL,
    CONSTRAINT FK_POSTID_CLIENTCHK Foreign Key (POSTID) references POST (POSTID),
    CONSTRAINT PK_CLIENTCHK PRIMARY KEY(POSTID, BROWSER, IP)
);
--클라이언트 구분(검색DB용)
CREATE TABLE "SEARCHCLIENTCHK" (
	"KEYWORD"	VARCHAR2(30 CHAR)		NOT NULL,
	"BROWSER"	VARCHAR2(255 CHAR)		NOT NULL,
	"IP"	VARCHAR2(50 CHAR)		NOT NULL,
	"LASTACCESSTIME"	DATE	DEFAULT SYSDATE	NOT NULL
);

COMMENT ON COLUMN "SEARCHCLIENTCHK"."KEYWORD" IS '검색키워드';
COMMENT ON COLUMN "SEARCHCLIENTCHK"."BROWSER" IS '접속브라우저';
COMMENT ON COLUMN "SEARCHCLIENTCHK"."IP" IS '접속IP';
COMMENT ON COLUMN "SEARCHCLIENTCHK"."LASTACCESSTIME" IS '마지막 접속한 시간';

ALTER TABLE "SEARCHCLIENTCHK" ADD CONSTRAINT "PK_SEARCHCLIENTCHK" PRIMARY KEY (
	"KEYWORD",
	"BROWSER",
	"IP"
);

--클라이언트 구분(해시태그 DB 삽입용)
CREATE TABLE "HASHCLIENTCHK" (
	"KEYWORD"	VARCHAR2(30 CHAR)		NOT NULL,
	"BROWSER"	VARCHAR2(255 CHAR)		NOT NULL,
	"IP"	VARCHAR2(50 CHAR)		NOT NULL,
	"LASTACCESSTIME"	DATE	DEFAULT SYSDATE	NOT NULL
);

COMMENT ON COLUMN "HASHCLIENTCHK"."KEYWORD" IS '검색키워드';
COMMENT ON COLUMN "HASHCLIENTCHK"."BROWSER" IS '접속 브라우저';
COMMENT ON COLUMN "HASHCLIENTCHK"."IP" IS '접속IP';
COMMENT ON COLUMN "HASHCLIENTCHK"."LASTACCESSTIME" IS '마지막 접속한 시간';

ALTER TABLE "HASHCLIENTCHK" ADD CONSTRAINT "PK_HASHCLIENTCHK" PRIMARY KEY (
	"KEYWORD",
	"BROWSER",
	"IP"
);

--회원 블록
CREATE TABLE MEMBERBLOCK (
  BLOCKID NUMBER PRIMARY KEY,
  USERID VARCHAR2(20 char) NOT NULL,
  REASON VARCHAR2(200 char),
  STARTTIME TIMESTAMP NOT NULL,
  ENDTIME TIMESTAMP NOT NULL,
  CONSTRAINT member_fk FOREIGN KEY (USERID) REFERENCES members (USERID)
);

--게시물 좋아요
CREATE TABLE "POSTLIKE" (
	"POSTID"	NUMBER		NOT NULL,
	"USERID"	VARCHAR2(15 char)		NOT NULL,
	"ISDELETED"	VARCHAR2(1 char)	DEFAULT 'N'	NOT NULL,
    "ADDDATE" DATE DEFAULT SYSDATE NOT NULL
);
ALTER TABLE "POSTLIKE" ADD CONSTRAINT "FK_POST_TO_POSTLIKE_1" FOREIGN KEY (
	"POSTID"
)
REFERENCES "POST" (
	"POSTID"
);
ALTER TABLE "POSTLIKE" ADD CONSTRAINT "FK_MEMBERS_TO_POSTLIKE_1" FOREIGN KEY (
	"USERID"
)
REFERENCES "MEMBERS" (
	"USERID"
);
ALTER TABLE "POSTLIKE" ADD CONSTRAINT "PK_POSTLIKE" PRIMARY KEY (
	"POSTID",
	"USERID"
);

--게시물 북마크
CREATE TABLE "POSTBOOKMARK" (
	"POSTID"	NUMBER		NOT NULL,
	"USERID"	VARCHAR2(15 char)		NOT NULL,
	"ISDELETED"	VARCHAR2(1 char)	DEFAULT 'N'	NOT NULL,
    "ADDDATE" DATE DEFAULT SYSDATE NOT NULL
);
ALTER TABLE "POSTBOOKMARK" ADD CONSTRAINT "FK_POST_TO_POSTBOOKMARK_1" FOREIGN KEY (
	"POSTID"
)
REFERENCES "POST" (
	"POSTID"
);
ALTER TABLE "POSTBOOKMARK" ADD CONSTRAINT "FK_MEMBERS_TO_POSTBOOKMARK_1" FOREIGN KEY (
	"USERID"
)
REFERENCES "MEMBERS" (
	"USERID"
);
ALTER TABLE "POSTBOOKMARK" ADD CONSTRAINT "PK_POSTBOOKMARK" PRIMARY KEY (
	"POSTID",
	"USERID"
);
--신고
CREATE TABLE "REPORT" (
	"REPORTID"	NUMBER		NOT NULL,
	"USERID"	VARCHAR2(15 char)		NOT NULL,
	"POSTID"	NUMBER		NULL,
	"CMTID"	NUMBER		NULL,
	"REPORTCONTENT"	VARCHAR2(100 char)		NOT NULL,
	"REPORTTYPE"	VARCHAR(1 char)		NOT NULL,
	"REPORTTIME"	TIMESTAMP	DEFAULT SYSTIMESTAMP	NOT NULL
);

ALTER TABLE "REPORT" ADD CONSTRAINT "PK_REPORT" PRIMARY KEY (
	"REPORTID"
);
ALTER TABLE "REPORT" ADD CONSTRAINT "FK_MEMBERS_TO_REPORT_1" FOREIGN KEY (
	"USERID"
)
REFERENCES "MEMBERS" (
	"USERID"
);

ALTER TABLE "REPORT" ADD CONSTRAINT "FK_POST_TO_REPORT_1" FOREIGN KEY (
	"POSTID"
)
REFERENCES "POST" (
	"POSTID"
);

ALTER TABLE "REPORT" ADD CONSTRAINT "FK_TBCOMMENT_TO_REPORT_1" FOREIGN KEY (
	"CMTID"
)
REFERENCES "TBCOMMENT" (
	"CMTID"
);
COMMENT ON COLUMN "REPORT"."REPORTID" IS 'auto_increment';
COMMENT ON COLUMN "REPORT"."USERID" IS '신고한 유저';
COMMENT ON COLUMN "REPORT"."POSTID" IS '신고당한 게시물';
COMMENT ON COLUMN "REPORT"."CMTID" IS '신고당한 댓글';
COMMENT ON COLUMN "REPORT"."REPORTCONTENT" IS '신고들어온 내용';
COMMENT ON COLUMN "REPORT"."REPORTTYPE" IS 'p 게시글, c 댓글';
COMMENT ON COLUMN "REPORT"."REPORTTIME" IS '신고 시간';

--댓글
CREATE TABLE "TBCOMMENT" (
	"CMTID"	NUMBER		NOT NULL,
	"USERID"	VARCHAR2(20 char)		NOT NULL,
	"POSTID"	NUMBER		NOT NULL,
	"CONTENT"	VARCHAR2(200 char)		NOT NULL,
	"UPDATEAT"	TIMESTAMP	DEFAULT SYSTIMESTAMP	NOT NULL,
	"ISDELETED"	VARCHAR2(1 char)	DEFAULT 'N'	NOT NULL,
    "ISBLINDED"	VARCHAR2(1 char)	DEFAULT 'N'	NOT NULL
);
ALTER TABLE "TBCOMMENT" ADD CONSTRAINT "FK_MEMBERS_TO_TBCOMMENT_1" FOREIGN KEY (
	"USERID"
)
REFERENCES "MEMBERS" (
	"USERID"
);
ALTER TABLE "TBCOMMENT" ADD CONSTRAINT "FK_POST_TO_TBCOMMENT_1" FOREIGN KEY (
	"POSTID"
)
REFERENCES "POST" (
	"POSTID"
);
ALTER TABLE "TBCOMMENT" ADD CONSTRAINT "PK_TBCOMMENT" PRIMARY KEY (
	"CMTID"
);
--대댓글
CREATE TABLE "REPLYCOMMENT" (
	"RCMID"	NUMBER		NOT NULL,
	"CMTID"	NUMBER		NOT NULL,
	"USERID"	VARCHAR2(15 char)		NOT NULL,
	"CONTENT"	VARCHAR2(200 char)		NOT NULL,
	"UPDATEAT"	TIMESTAMP	DEFAULT SYSTIMESTAMP	NOT NULL,
	"ISDELETED"	VARCHAR2(1 char)	DEFAULT 'N'	NOT NULL
);
ALTER TABLE "REPLYCOMMENT" ADD CONSTRAINT "FK_TBCOMMENT_TO_REPLYCOMMENT_1" FOREIGN KEY (
	"CMTID"
)
REFERENCES "TBCOMMENT" (
	"CMTID"
);
ALTER TABLE "REPLYCOMMENT" ADD CONSTRAINT "FK_MEMBERS_TO_REPLYCOMMENT_1" FOREIGN KEY (
	"USERID"
)
REFERENCES "MEMBERS" (
	"USERID"
);
ALTER TABLE "REPLYCOMMENT" ADD CONSTRAINT "PK_REPLYCOMMENT" PRIMARY KEY (
	"RCMID",
	"CMTID"
);
--채팅
CREATE TABLE "CHATTINGROOM" (
	"KEY"	NUMBER		NOT NULL,
	"USERID"	VARCHAR(15 char)		NOT NULL,
	"TITLE"	VARCHAR2(100 char)		NULL,
	"ISDELETED"	VARCHAR2(1 char)		NULL

);
ALTER TABLE "CHATTINGROOM" ADD CONSTRAINT "FK_MEMBERS_TO_CHATROOM_1" FOREIGN KEY (
	"USERID"
)
REFERENCES "MEMBERS" (
	"USERID"
);
ALTER TABLE "CHATTINGROOM" ADD CONSTRAINT "PK_CHATTINGROOM" PRIMARY KEY (
	"KEY"
);

--채팅방 입장여부
CREATE TABLE "CHATROOMCHK" (
	"KEY"	NUMBER		NOT NULL,
	"USERID"	VARCHAR2(15 char)		NOT NULL
);

--다이렉트메세지
CREATE TABLE "DIRECTMESSAGE" (
	"KEY"	NUMBER		NOT NULL,
	"USERID"	VARCHAR2(15 char)		NOT NULL,
	"MESSAGE"	VARCHAR2(200 char)		NULL,
	"UPDATEAT"	TIMESTAMP	DEFAULT SYSTIMESTAMP	NULL,
	"ISDELETED"	VARCHAR2(1 char)	DEFAULT 'A'	NULL,
	"MESSAGENO"	NUMBER		NULL
);
ALTER TABLE "DIRECTMESSAGE" ADD CONSTRAINT "FK_CHATROOM_DIRECTM_1" FOREIGN KEY (
	"KEY"
)
REFERENCES "CHATTINGROOM" (
	"KEY"
);

--팔로우매핑
CREATE TABLE "FOLLOWMAPPING" (
	"FWID"	VARCHAR2(15 char)		NOT NULL,
	"USERID"	VARCHAR2(15 char)		NOT NULL,
	"ISDELETED"	VARCHAR2(1 char)	DEFAULT 'N'	NOT NULL
);
ALTER TABLE "FOLLOWMAPPING" ADD CONSTRAINT "FK_MEMBERS_TO_FOLLOWMAPPING_1" FOREIGN KEY (
	"USERID"
)
REFERENCES "MEMBERS" (
	"USERID"
);
ALTER TABLE "FOLLOWMAPPING" ADD CONSTRAINT "PK_FOLLOWMAPPING" PRIMARY KEY (
	"FWID",
	"USERID"
);
--해쉬태그
CREATE TABLE "HASHTAG" (
	"HASHTAG"	VARCHAR2(30 char)		NOT NULL,
	"POSTID"	NUMBER		NOT NULL
);
ALTER TABLE "HASHTAG" ADD CONSTRAINT "FK_POST_TO_HASHTAG_1" FOREIGN KEY (
	"POSTID"
)
REFERENCES "POST" (
	"POSTID"
);
ALTER TABLE "HASHTAG" ADD CONSTRAINT "PK_HASHTAG" PRIMARY KEY (
	"HASHTAG",
	"POSTID"
);
--재료
CREATE TABLE "INGREDIENT" (
    "POSTID"	NUMBER		NOT NULL,
	"INGREDIENT"	VARCHAR2(30 char)		NOT NULL,
	"AMOUNT"	VARCHAR2(30 char)		NOT NULL
);
ALTER TABLE "INGREDIENT" ADD CONSTRAINT "FK_POST_TO_INGREDIENT_1" FOREIGN KEY (
	"POSTID"
)
REFERENCES "POST" (
	"POSTID"
);
ALTER TABLE "INGREDIENT" ADD CONSTRAINT "PK_INGREDIENT" PRIMARY KEY (
	"INGREDIENT",
	"POSTID"
);
create table BADWORDS(
    BADWORD VARCHAR2(255 char) NOT NULL UNIQUE
);
