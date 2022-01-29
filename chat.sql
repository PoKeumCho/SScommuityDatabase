WITH `temptbl`
AS
(SELECT C.`no`, C.`senderid`, C.`receiverid`, C.`datetime`, C.`contenttype`, C.`contentno`, C.`readstatus`, T.`text`
	FROM `chat` C
	LEFT JOIN `chattext` T
    ON C.`contentno` = T.`no` 
		AND C.`senderid` = T.`senderid`
        AND C.`receiverid` = T.`receiverid`)
SELECT T.`no`, T.`senderid`, T.`receiverid`, T.`datetime`, T.`contenttype`, T.`readstatus`, T.`text`, F.`path`, F.`width`
	FROM `temptbl` T
	LEFT JOIN `chatfile` F
	ON T.`contentno` = F.`no` 
		AND T.`senderid` = F.`senderid`
        AND T.`receiverid` = F.`receiverid`
	WHERE (T.`senderid`='user1' AND T.`receiverid`='admin')
		OR (T.`senderid`='admin' AND T.`receiverid`='user1');
        
        

# 상대방이 보낸 채팅 중 가장 처음의 '안 읽은 상태'의 채팅 no를 가지고...
UPDATE `chat`
	SET `readstatus` = 'Y'
	WHERE `senderid` = 'admin' AND `receiverid` = 'user1' AND `no` < 72;