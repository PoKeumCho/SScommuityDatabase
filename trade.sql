SELECT *
	FROM `trade`
	WHERE	
		`categoryid` = 1
        AND (`campus` = 'S' OR `campus` = 'B')
        AND ((`title` LIKE '%%') OR (`info` LIKE '%%'))
	ORDER BY `id` DESC;

WITH `temp`(`id`, `userid`, `imgid`)
AS
(
	SELECT `id`, `userid`, `imgid` 
		FROM `trade`
		WHERE `categoryid`=1 
			AND (`campus`='S' OR `campus`='B')
			AND ((`title` LIKE '%%') OR  (`info` LIKE '%%'))
) 
SELECT T.`id`, TI.`path`, TI.`width`
	FROM  `tradeimg` TI
		INNER JOIN `temp` T
		ON  TI.`userid` = T.`userid` AND TI.`id` = T.`imgid`
    ORDER BY `id` DESC;